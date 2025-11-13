const cds = require('@sap/cds');
const { SELECT, INSERT, UPDATE } = require("@sap/cds/lib/ql/cds-ql");

class PropertyManager {

    constructor(srv) {
        this.srv = srv;
        this.entities = srv.entities;
    }

    /**
     * Register all event handlers for the service
     */
    registerHandlers() {
        const { Properties, ContactRequests, Notifications, EmailLogs, Users } = this.entities;

        // Property validation handlers
        this.srv.before('CREATE', Properties, async (req) => {
            try {
                const nextPropertyId = await this.getNextPropertyId(req.tx);
                req.data.propertyId = nextPropertyId;
            } catch (error) {
                return "Error: " + error.toString();
            }
        });

        this.srv.before('INSERT', Properties, (request, response) => {
            if (!request.data.coldRent || request.data.coldRent == 0.00) {
                request.error(400, 'Cold rent must be a positive value', 'in/coldRent');
            }
            if (request.data.warmRent == 0.00) {
                request.error(400, 'Warm rent must be a positive value', 'in/warmRent');
            }
        });

        this.srv.before('UPDATE', Properties, (request, response) => {
            if (request.data.coldRent == 0.00) {
                request.error(400, 'Cold rent must be a positive value', 'in/coldRent');
            }
            if (request.data.warmRent == 0.00) {
                request.error(400, 'Warm rent must be a positive value', 'in/warmRent');
            }
        });

        // Contact request validation handlers
        this.srv.before('INSERT', ContactRequests, (request, response) => {
            if (!request.data.requestMessage ||
                (typeof request.data.requestMessage === 'string' && request.data.requestMessage.trim() === '')) {
                request.error(400, 'Request message cannot be empty.', 'in/requestMessage');
            }
        });

        this.srv.before('UPDATE', ContactRequests, (request, response) => {
            if (!request.data.requestMessage ||
                (typeof request.data.requestMessage === 'string' && request.data.requestMessage.trim() === '')) {
                request.error(400, 'Request message cannot be empty.', 'in/requestMessage');
            }
        });

        // Dynamic years handler
        this.srv.on('READ', 'DynamicYears', async () => {
            return this.getDynamicYears();
        });

        // Property action handlers
        this.srv.on('SetToStatus', async (request, response) => {
            return await this.setPropertyStatus(request);
        });

        this.srv.on('SendRequest', async (request, response) => {
            return await this.sendContactRequest(request);
        });

        // Contact request action handlers
        this.srv.on('RespondToRequest', async (request) => {
            return await this.respondToRequest(request);
        });

        this.srv.on('CloseRequest', async (request) => {
            return await this.closeRequest(request);
        });

        // Notification and email handlers
        this.srv.on('SendNotification', async (request) => {
            return await this.sendNotification(request);
        });

        this.srv.on('SendEmail', async (request) => {
            return await this.sendEmail(request);
        });

        this.srv.on('getNextPropertyId', async (req) => {
            return await this.getNextPropertyId(req.tx);
        });
    }

    /**
     * Get dynamic years for year selection
     */
    getDynamicYears() {
        const currentYear = new Date().getFullYear();
        const years = [];
        for (let i = -30; i <= 0; i++) {
            years.push({ year: String(currentYear + i) });
        }
        return years;
    }

    /**
     * Set property status
     */
    async setPropertyStatus(request) {
        try {
            const { Properties } = this.entities;
            const ID = request.params[0];
            const { newStatusCode } = request.data;

            const tx = cds.tx(request);

            await tx.update(Properties).with({
                listingStatus_code: newStatusCode
            }).where(ID);

            const response = await tx.read(Properties).where(ID);
            return response;
        } catch (error) {
            return "Error : " + error.toString();
        }
    }

    /**
     * Send contact request for a property
     */
    async sendContactRequest(request) {
        try {
            const { Properties, ContactRequests } = this.entities;
            const { uuid } = cds.utils;

            const property = request.params[0];
            const requestMessage = request.data.requestMessage;

            // Get the logged-in user ID from request context
            const requesterId = request.user?.id;
            
            if (!requesterId || requesterId === 'anonymous') {
                return request.error(401, 'User must be authenticated to send a contact request.');
            }

            const newContactReq = {
                property_ID: property.ID,
                requester_ID: requesterId,
                requestMessage: requestMessage,
                status: 'Pending',
            };

            const tx = cds.transaction(request);

            const insertResult = await tx.run(
                INSERT.into('ContactRequests').entries(newContactReq)
            );

            // Send notification to property owner
            const propertyData = await tx.read(Properties).where({ ID: property.ID });
            if (propertyData && propertyData.length > 0 && propertyData[0].contactPerson_ID) {
                await this.createNotification(tx, {
                    recipientId: propertyData[0].contactPerson_ID,
                    notificationType: 'Contact Request Received',
                    title: 'New Contact Request',
                    message: `You have received a new contact request for property ${property.propertyId || property.ID}`,
                    relatedEntity: 'ContactRequests',
                    relatedEntityId: insertResult
                });
            }

            request.notify(`Contact request for Property ID "${property.ID}" successfully logged.`);
        } catch (error) {
            return "Error: " + error.toString();
        }
    }

    /**
     * Respond to a contact request
     */
    async respondToRequest(request) {
        try {
            const { ContactRequests } = this.entities;
            const contactRequestId = request.params[0].ID;
            const responseMessage = request.data.responseMessage;
            const tx = cds.transaction(request);

            // Update contact request status
            await tx.update(ContactRequests).set({ status: 'Responded' }).where({ ID: contactRequestId });

            // Get contact request details
            const contactRequest = await tx.read(ContactRequests).where({ ID: contactRequestId });

            if (contactRequest && contactRequest.length > 0) {
                // Create notification for requester
                await this.createNotification(tx, {
                    recipientId: contactRequest[0].requester_ID,
                    notificationType: 'Contact Request Response',
                    title: 'Response to Your Contact Request',
                    message: `You have received a response to your contact request: ${responseMessage}`,
                    relatedEntity: 'ContactRequests',
                    relatedEntityId: contactRequestId
                });
            }

            return "Response sent successfully";
        } catch (error) {
            return "Error: " + error.toString();
        }
    }

    /**
     * Close a contact request
     */
    async closeRequest(request) {
        try {
            const { ContactRequests } = this.entities;
            const contactRequestId = request.params[0].ID;
            const tx = cds.transaction(request);

            await tx.update(ContactRequests).set({ status: 'Closed' }).where({ ID: contactRequestId });

            return "Contact request closed successfully";
        } catch (error) {
            return "Error: " + error.toString();
        }
    }

    /**
     * Send notification to a user
     */
    async sendNotification(request) {
        try {
            const params = request.data.params;
            const tx = cds.transaction(request);

            await this.createNotification(tx, {
                recipientId: params.recipientId,
                notificationType: 'New Property Match',
                title: params.title,
                message: params.message,
                relatedEntity: '',
                relatedEntityId: ''
            });

            return "Notification sent successfully";
        } catch (error) {
            return "Error: " + error.toString();
        }
    }

    /**
     * Send email and log it
     */
    async sendEmail(request) {
        try {
            const params = request.data.params;
            const tx = cds.transaction(request);

            await this.createEmailLog(tx, {
                recipientId: params.recipientId,
                senderId: request.user?.id || "system",
                emailType: 'Contact Request Confirm',
                subject: params.subject,
                body: params.body,
                relatedEntity: '',
                relatedEntityId: ''
            });

            return "Email sent successfully";
        } catch (error) {
            return "Error: " + error.toString();
        }
    }

    /**
     * Get next property ID
     */
    async getNextPropertyId(tx) {
        const { Properties } = this.entities;
        const currentMaxProp = await SELECT.one.from(Properties).orderBy('propertyId desc').columns('propertyId');
        let nextPropertyId = 1;

        if (currentMaxProp && currentMaxProp.propertyId) {
            let currentMaxPropIdNum = parseInt(currentMaxProp.propertyId.replace('P', ' '), 10);
            nextPropertyId = currentMaxPropIdNum + 1;
        }

        return `P${String(nextPropertyId).padStart(4, '0')}`;
    }

    /**
     * Create a notification record
     */
    async createNotification(tx, params) {
        const { Notifications } = this.entities;
        const notification = {
            recipient_ID: params.recipientId,
            notificationType: params.notificationType,
            title: params.title,
            message: params.message,
            isRead: false,
            relatedEntity: params.relatedEntity || '',
            relatedEntityId: params.relatedEntityId || ''
        };

        await tx.run(INSERT.into(Notifications).entries(notification));
    }

    /**
     * Create an email log record
     */
    async createEmailLog(tx, params) {
        const { EmailLogs } = this.entities;
        const emailLog = {
            recipient_ID: params.recipientId,
            sender_ID: params.senderId,
            emailType: params.emailType,
            subject: params.subject,
            body: params.body,
            sentAt: new Date().toISOString(),
            deliveryStatus: 'Sent',
            relatedEntity: params.relatedEntity || '',
            relatedEntityId: params.relatedEntityId || ''
        };

        await tx.run(INSERT.into(EmailLogs).entries(emailLog));
    }

    /**
     * Validate property data
     */
    validateProperty(propertyData) {
        // Property validation logic can be added here
        return true;
    }

    /**
     * Validate nearby amenities
     */
    validateNearByAminities(amenitiesData) {
        // Amenities validation logic can be added here
        return true;
    }

}

module.exports = {
    PropertyManager
};