const { request } = require("http");

const { request } = require("http");

module.exports = cds.service.impl(async function () {
    //Step-1 get the object from OData service

    const { Properties } = this.entities;

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

    this.on('SetToStatus', async (request,response) => {
        try {
            const ID = request.params[0];
            const { newStatusCode } = request.data ;

            const tx = cds.tx(request);

            await tx.update(Properties).with({
                listingStatus_code : newStatusCode
            }).where(ID) ; 
            
            const response = await tx.read(Properties).where(ID);
            return response;
        } catch (error) {
            return "Error : "+ error.toString();
        }
    })

})