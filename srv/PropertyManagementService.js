const cds = require('@sap/cds');
const { PropertyManager } = require('./PropertyManager');

class PropertyManagementService extends cds.ApplicationService {
    init() {
        // Initialize PropertyManager with this service
        const propertyManager = new PropertyManager(this);
        
        // Register all event handlers through PropertyManager
        propertyManager.registerHandlers();

        return super.init();
    }
}

module.exports = { PropertyManagementService };
