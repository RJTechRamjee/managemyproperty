const { request } = require("http");
const cds = require('@sap/cds');

// module.exports = cds.service.impl(async function () {

class CatalogService extends cds.ApplicationService {
    init() {

        //Step-1 get the object from OData service

        const { Properties, ContactRequests } = this.entities;
        // console.log(this.entities.ContactRequests); // Debug: check if ContactRequests is listed
        const { uuid } = cds.utils;
        this.before('INSERT', Properties, (request, response) => {
            if (request.data.coldRent == 0.00) {
                request.error(400, 'Cold rent must be a positive value', 'in/coldRent')
            }
            if (request.data.warmRent == 0.00) {
                request.error(400, 'Warm rent must be a positive value', 'in/warmRent')
            }
        })

        this.before('UPDATE', Properties, (request, response) => {
            if (request.data.coldRent == 0.00) {
                request.error(400, 'Cold rent must be a positive value', 'in/coldRent')
            }
            if (request.data.warmRent == 0.00) {
                request.error(400, 'Warm rent must be a positive value', 'in/warmRent')
            }
        })

        this.before('INSERT', ContactRequests, (request, response) => {

            if (!request.data.requestMessage ||
                (typeof request.data.requestMessage === 'string' && request.data.requestMessage.trim() === '')) {
                request.error(400, 'Request message cannot be empty.', 'in/requestMessage')
            }

        })
        this.before('UPDATE', ContactRequests, (request, response) => {

            if (!request.data.requestMessage ||
                (typeof request.data.requestMessage === 'string' && request.data.requestMessage.trim() === '')) {

                request.error(400, 'Request message cannot be empty.', 'in/requestMessage')
            }

        })


        this.on('READ', 'DynamicYears', async () => {
            const currentYear = new Date().getFullYear();
            const years = [];
            for (let i = -3; i <= 3; i++) {
                years.push({ year: String(currentYear + i) });
            }
            return years;
        });


        this.on('SetToStatus', async (request, response) => {
            try {
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
        })

        this.on('SendRequest', async (request, response) => {


            try {

                let id = uuid(); // generates a new UUID
                const property = request.params[0];
                const requestMessage = request.data.requestMessage;

                const newContactReq = {
                    // ID: id,
                    property_ID: property.ID,
                    requester_ID: "4g2b1c0d-9d55-4e77-f999-1e2f3a4b5c56",
                    requestMessage: requestMessage,
                }

                const tx = cds.transaction(request);

                const insertResult = await tx.run(
                    INSERT.into('ContactRequests').entries(newContactReq)
                );
                request.notify(`Contact request for Property ID "${property.ID}" successfully logged.`);
            } catch (error) {
                return "Error: " + error.toString();
            }

        })

        return super.init();

    }
}
module.exports = { CatalogService };
// })