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

        this.srv.before('UPDATE', Properties, async (request, response) => {
            // Check ownership before allowing update
            const userId = request.user?.id;
            if (!userId || userId === 'anonymous') {
                request.error(401, 'User must be authenticated to update a property.');
                return;
            }

            const tx = cds.tx(request);
            const propertyId = request.data.ID || request.params?.[0]?.ID;
            
            if (propertyId) {
                const property = await tx.read(Properties).where({ ID: propertyId });
                if (property && property.length > 0) {
                    if (property[0].contactPerson_ID !== userId) {
                        request.error(403, 'You are not authorized to update this property. Only the property owner can make changes.');
                        return;
                    }
                }
            }

            if (request.data.coldRent == 0.00) {
                request.error(400, 'Cold rent must be a positive value', 'in/coldRent');
            }
            if (request.data.warmRent == 0.00) {
                request.error(400, 'Warm rent must be a positive value', 'in/warmRent');
            }
        });

        // Contact request validation handlers  
        // Auto-populate requester_ID for all create operations
        this.srv.before('*', 'ContactRequests', (request) => {
            // Automatically set requester_ID from authenticated user if not set
            const requesterId = request.user?.id;
            if (requesterId && requesterId !== 'anonymous' && request.data && !request.data.requester_ID) {
                request.data.requester_ID = requesterId;
            }
        });

        this.srv.before('INSERT', ContactRequests, (request, response) => {
            if (!request.data.requestMessage ||
                (typeof request.data.requestMessage === 'string' && request.data.requestMessage.trim() === '')) {
                request.error(400, 'Request message cannot be empty.', 'in/requestMessage');
            }
            
            // Automatically set requester_ID from authenticated user if not already set
            if (!request.data.requester_ID) {
                const requesterId = request.user?.id;
                if (!requesterId || requesterId === 'anonymous') {
                    request.error(401, 'User must be authenticated to create a contact request.');
                } else {
                    request.data.requester_ID = requesterId;
                }
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

        // Add handlers to populate virtual ownership fields
        this.srv.after('READ', Properties, async (properties, request) => {
            return await this.populatePropertyOwnership(properties, request);
        });

        this.srv.after('READ', ContactRequests, async (contactRequests, request) => {
            return await this.populateContactRequestOwnership(contactRequests, request);
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
            const userId = request.user?.id;

            if (!userId || userId === 'anonymous') {
                return request.error(401, 'User must be authenticated to change property status.');
            }

            const tx = cds.tx(request);

            // Check ownership before allowing status change
            const property = await tx.read(Properties).where(ID);
            if (property && property.length > 0) {
                if (property[0].contactPerson_ID !== userId) {
                    return request.error(403, 'You are not authorized to change this property status. Only the property owner can make changes.');
                }
            } else {
                return request.error(404, 'Property not found.');
            }

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

            const tx = cds.transaction(request);

            // Check if user is trying to send request to their own property
            const propertyData = await tx.read(Properties).where({ ID: property.ID });
            if (propertyData && propertyData.length > 0) {
                if (propertyData[0].contactPerson_ID === requesterId) {
                    return request.error(403, 'You cannot send a contact request to your own property.');
                }
            } else {
                return request.error(404, 'Property not found.');
            }

            const newContactReq = {
                property_ID: property.ID,
                requester_ID: requesterId,
                requestMessage: requestMessage,
                status: 'Pending',
            };

            const insertResult = await tx.run(
                INSERT.into('ContactRequests').entries(newContactReq)
            );

            // Send notification to property owner
            if (propertyData[0].contactPerson_ID) {
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
            const { ContactRequests, Properties } = this.entities;
            const contactRequestId = request.params[0].ID;
            const responseMessage = request.data.responseMessage;
            const userId = request.user?.id;

            if (!userId || userId === 'anonymous') {
                return request.error(401, 'User must be authenticated to respond to a contact request.');
            }

            const tx = cds.transaction(request);

            // Get contact request details
            const contactRequest = await tx.read(ContactRequests).where({ ID: contactRequestId });
            
            if (!contactRequest || contactRequest.length === 0) {
                return request.error(404, 'Contact request not found.');
            }

            // Check if user owns the property
            const property = await tx.read(Properties).where({ ID: contactRequest[0].property_ID });
            if (property && property.length > 0) {
                if (property[0].contactPerson_ID !== userId) {
                    return request.error(403, 'You are not authorized to respond to this contact request. Only the property owner can respond.');
                }
            } else {
                return request.error(404, 'Property not found.');
            }

            // Update contact request status
            await tx.update(ContactRequests).set({ status: 'Responded' }).where({ ID: contactRequestId });

            // Create notification for requester
            await this.createNotification(tx, {
                recipientId: contactRequest[0].requester_ID,
                notificationType: 'Contact Request Response',
                title: 'Response to Your Contact Request',
                message: `You have received a response to your contact request: ${responseMessage}`,
                relatedEntity: 'ContactRequests',
                relatedEntityId: contactRequestId
            });

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
            const { ContactRequests, Properties } = this.entities;
            const contactRequestId = request.params[0].ID;
            const userId = request.user?.id;

            if (!userId || userId === 'anonymous') {
                return request.error(401, 'User must be authenticated to close a contact request.');
            }

            const tx = cds.transaction(request);

            // Get contact request details
            const contactRequest = await tx.read(ContactRequests).where({ ID: contactRequestId });
            
            if (!contactRequest || contactRequest.length === 0) {
                return request.error(404, 'Contact request not found.');
            }

            // Check if user owns the property
            const property = await tx.read(Properties).where({ ID: contactRequest[0].property_ID });
            if (property && property.length > 0) {
                if (property[0].contactPerson_ID !== userId) {
                    return request.error(403, 'You are not authorized to close this contact request. Only the property owner can close it.');
                }
            } else {
                return request.error(404, 'Property not found.');
            }

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

    /**
     * Populate isOwner field for Properties to control action visibility
     */
    async populatePropertyOwnership(properties, request) {
        const userId = request.user?.id;
        
        if (!properties) return properties;
        
        const propertiesArray = Array.isArray(properties) ? properties : [properties];
        const { Properties } = this.entities;
        
        // Check if contactPerson_ID is missing in any property and fetch if needed
        const propertiesNeedingOwnerInfo = propertiesArray.filter(
            property => property && property.ID && property.contactPerson_ID === undefined
        );
        
        if (propertiesNeedingOwnerInfo.length > 0) {
            // Fetch contactPerson_ID for properties that don't have it
            const tx = cds.tx(request);
            const propertyIds = propertiesNeedingOwnerInfo.map(p => p.ID);
            const ownerInfo = await tx.read(Properties)
                .where({ ID: { in: propertyIds } })
                .columns('ID', 'contactPerson_ID');
            
            // Create a map of property ID to owner ID
            const ownerMap = new Map();
            ownerInfo.forEach(prop => {
                ownerMap.set(prop.ID, prop.contactPerson_ID);
            });
            
            // Update the properties with the fetched owner information
            propertiesNeedingOwnerInfo.forEach(property => {
                property.contactPerson_ID = ownerMap.get(property.ID);
            });
        }
        
        // Now populate isOwner for all properties
        propertiesArray.forEach(property => {
            if (property && property.contactPerson_ID) {
                property.isOwner = (userId === property.contactPerson_ID);
            } else {
                property.isOwner = false;
            }
        });
        
        return properties;
    }

    /**
     * Populate isPropertyOwner field for ContactRequests to control action visibility
     */
    async populateContactRequestOwnership(contactRequests, request) {
        const userId = request.user?.id;
        
        if (!contactRequests) return contactRequests;
        
        const contactRequestsArray = Array.isArray(contactRequests) ? contactRequests : [contactRequests];
        const { Properties } = this.entities;
        
        // Get all property IDs from contact requests
        const propertyIds = contactRequestsArray
            .filter(cr => cr && cr.property_ID)
            .map(cr => cr.property_ID);
        
        if (propertyIds.length === 0) {
            contactRequestsArray.forEach(cr => {
                if (cr) cr.isPropertyOwner = false;
            });
            return contactRequests;
        }
        
        // Fetch property owners for all properties in one query
        const tx = cds.tx(request);
        const properties = await tx.read(Properties)
            .where({ ID: { in: propertyIds } })
            .columns('ID', 'contactPerson_ID');
        
        // Create a map of property ID to owner ID
        const propertyOwnerMap = new Map();
        properties.forEach(prop => {
            propertyOwnerMap.set(prop.ID, prop.contactPerson_ID);
        });
        
        // Set isPropertyOwner flag for each contact request
        contactRequestsArray.forEach(cr => {
            if (cr && cr.property_ID) {
                const ownerId = propertyOwnerMap.get(cr.property_ID);
                cr.isPropertyOwner = (userId === ownerId);
            } else {
                cr.isPropertyOwner = false;
            }
        });
        
        return contactRequests;
    }

}

module.exports = {
    PropertyManager
};