using {rj.re.managemyproperty as mngprp} from '../db/schema';


service CatalogService @(path: 'CatalogService') {

    type ActionParams : {
        newStatusCode : String(10)
    };

    type NotificationParams : {
        recipientId : String;
        title       : String(100);
        message     : String(500);
    };

    type EmailParams : {
        recipientId : String;
        subject     : String(200);
        body        : String(2000);
    };

    @cds.odata.valuelist
    entity Addresses                          as projection on mngprp.Addresses;

    @cds.odata.valuelist
    entity Properties                         as
        projection on mngprp.Properties {
            *,
            @readonly
            contactRequests : redirected to ContactRequests
        }
        order by
            propertyId asc
        actions {
            action SetToStatus(newStatusCode: ActionParams:newStatusCode) returns Properties;

            action SendRequest(requestMessage: String(300))               returns String;

        };

    @cds.odata.valuelist
    entity NearByAmenities                    as projection on mngprp.NearByAmenities;

    @readonly
    @cds.odata.valuelist
    entity Users                              as projection on mngprp.Users;

    @odata.draft.enabled
    @cds.odata.valuelist
    entity ContactRequests                    as
        projection on mngprp.ContactRequests {
            *,
            requester.firstName,
            requester.lastName,
            requester.ShortIntro
        }
        actions {
            action RespondToRequest(responseMessage: String(300))         returns String;
            action CloseRequest()                                          returns String;
        };

    entity ConactReqMessages                  as projection on mngprp.ConactReqMessages;

    entity Notifications                      as projection on mngprp.Notifications;

    entity EmailLogs                          as projection on mngprp.EmailLogs;

    action ReservepProperty(

    ) returns array of Properties;

    entity DynamicYears @cds.persistence.skip as projection on mngprp.DynamicYears;

    entity Statuses                           as projection on mngprp.Statuses;

    function getNextPropertyId() returns Properties:propertyId;

    // Notification and Email functions
    action   SendNotification(
        params : NotificationParams
    )                         returns String;

    action   SendEmail(
        params : EmailParams
    )                         returns String;
}
