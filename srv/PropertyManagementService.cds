using {rj.re.managemyproperty as mngprp} from '../db/schema';

service PropertyManagementService @(path: 'PropertyManagementService') {

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
    @odata.draft.enabled
    entity Addresses                          as projection on mngprp.Addresses;

    @cds.odata.valuelist
    @odata.draft.enabled
    entity Properties                         as
        projection on mngprp.Properties {
            *,
            
            contactRequests : redirected to ContactRequests,
            virtual null as isOwner : Boolean
        }
        order by
            propertyId asc
        actions {
            action SetToStatus(newStatusCode: ActionParams:newStatusCode) returns Properties;

            action SendRequest(requestMessage: String(300) @UI.MultiLineText)               returns String;

        };

    @cds.odata.valuelist
    entity NearByAmenities                    as projection on mngprp.NearByAmenities;

    @cds.odata.valuelist
    entity PropertyDetails                    as projection on mngprp.PropertyDetails;

    @cds.odata.valuelist
    entity Users                              as projection on mngprp.Users {
        *,
        firstName || ' ' || lastName as fullName : String(81) @title: '{i18n>fullName}'
    };

    @odata.draft.enabled
    @cds.odata.valuelist
    entity ContactRequests                    as
        projection on mngprp.ContactRequests {
            *,
            requester.firstName,
            requester.lastName,
            requester.ShortIntro,
            virtual null as isPropertyOwner : Boolean
        };

    entity Notifications                      as projection on mngprp.Notifications;

    entity EmailLogs                          as projection on mngprp.EmailLogs;

    action ReservepProperty(

    ) returns array of Properties;

    entity DynamicYears @cds.persistence.skip as projection on mngprp.DynamicYears;

    @odata.draft.enabled
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

annotate PropertyManagementService  with @(requires: 'authenticated-user');
