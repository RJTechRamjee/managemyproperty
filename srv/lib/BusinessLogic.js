const cds = require('@sap/cds');
const { SELECT, INSERT } = require("@sap/cds/lib/ql/cds-ql");

/**
 * Shared business logic for property management
 * This module contains reusable functions used across different services
 */
class BusinessLogic {

    constructor(srv) {
        this.srv = srv;
        this.entities = srv.entities;
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
     * Get next property ID
     */
    async getNextPropertyId() {
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
     * Check if user is authenticated
     * @returns {string|null} User ID if authenticated, null otherwise (rejection is sent)
     */
    checkAuthentication(request, message = 'User must be authenticated') {
        const userId = request.user?.id;
        if (!userId || userId === 'anonymous') {
            request.reject(401, message);
            return null;
        }
        return userId;
    }

    /**
     * Check if user owns a property
     * @returns {Promise<object|null>} Property object if authorized, null otherwise (rejection is sent)
     */
    async checkPropertyOwnership(request, propertyId) {
        const userId = this.checkAuthentication(request);
        if (!userId) return null;
        
        const { Properties } = this.entities;
        const tx = cds.tx(request);
        const property = await tx.read(Properties).where({ ID: propertyId });
        
        if (!property || property.length === 0) {
            request.reject(404, 'Property not found');
            return null;
        }
        
        if (property[0].contactPerson_ID !== userId) {
            request.reject(403, 'Only the property owner can perform this action');
            return null;
        }
        
        return property[0];
    }

    /**
     * Sanitize user input to prevent XSS attacks
     */
    sanitizeInput(input) {
        if (typeof input !== 'string') return input;
        // Remove HTML tags and trim whitespace
        return input.trim()
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#x27;')
            .replace(/\//g, '&#x2F;');
    }

    /**
     * Validate property data
     */
    validateProperty(propertyData) {
        if (!propertyData) {
            throw new Error('Property data is required');
        }
        
        // Validate required fields
        const requiredFields = ['title', 'type', 'listingFor'];
        for (const field of requiredFields) {
            if (!propertyData[field]) {
                throw new Error(`${field} is required`);
            }
        }
        
        // Validate numeric fields
        if (propertyData.coldRent !== undefined && propertyData.coldRent <= 0) {
            throw new Error('Cold rent must be positive');
        }
        
        if (propertyData.warmRent !== undefined && propertyData.warmRent <= 0) {
            throw new Error('Warm rent must be positive');
        }
        
        if (propertyData.noOfRooms !== undefined && propertyData.noOfRooms < 0) {
            throw new Error('Number of rooms cannot be negative');
        }
        
        return true;
    }

    /**
     * Validate nearby amenities
     */
    validateNearbyAmenities(amenitiesData) {
        if (!amenitiesData || !Array.isArray(amenitiesData)) {
            throw new Error('Amenities data must be an array');
        }
        
        // Validate each amenity
        for (const amenity of amenitiesData) {
            if (!amenity.name || typeof amenity.name !== 'string') {
                throw new Error('Each amenity must have a valid name');
            }
            
            if (amenity.distance !== undefined && (typeof amenity.distance !== 'number' || amenity.distance < 0)) {
                throw new Error('Amenity distance must be a non-negative number');
            }
        }
        
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
    BusinessLogic
};
