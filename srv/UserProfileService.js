const cds = require('@sap/cds');

class UserProfileService extends cds.ApplicationService {
    init() {
        // No custom handlers needed for this service currently
        return super.init();
    }
}

module.exports = { UserProfileService };
