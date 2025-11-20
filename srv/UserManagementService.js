const cds = require('@sap/cds');

class UserManagementService extends cds.ApplicationService {
    init() {
        // No custom handlers needed for this service currently
        return super.init();
    }
}

module.exports = { UserManagementService };
