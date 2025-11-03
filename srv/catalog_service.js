const { request } = require("http");
const cds = require('@sap/cds');
module.exports = cds.service.impl(async function () {
    //Step-1 get the object from OData service

    const { Properties, ContactRequests } = cds.entities;
    // console.log(ContactRequests); // Debug: check if ContactRequests is listed
    const { uuid } = cds.utils;
    this.before('INSERT', Properties, (request, response) => {
        if (request.data.coldRent == 0.00 || request.data.warmRent == 0.00) {
            request.error(400, 'Cold rent and Warm rent must be a positive value')
        }
    })

    this.before('UPDATE', Properties, (request, response) => {
        if (request.data.coldRent == 0.00 || request.data.warmRent == 0.00) {
            request.error(400, 'Cold rent and Warm rent must be a positive value')
        }
    })

    this.before('INSERT', ContactRequests, (request, response ) => {

        if (request.data.requestMessage == '') {
            request.error(400, 'Cold rent and Warm rent must be a positive value')
        }

    })

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



})