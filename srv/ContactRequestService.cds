using {rj.re.managemyproperty as mngprp} from '../db/schema';

service ContactRequestService @(path: 'ContactRequestService') {

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
        }
        actions {
            action RespondToRequest(responseMessage: String(300) @UI.MultiLineText)         returns String;
            action CloseRequest()                                          returns String;
        };

// Mark requester_ID as readonly to prevent user modification
annotate ContactRequests with {
    requester @readonly @Core.Computed;
}

    entity ConactReqMessages                  as projection on mngprp.ConactReqMessages;

    entity Notifications                      as projection on mngprp.Notifications;

    entity EmailLogs                          as projection on mngprp.EmailLogs;

    entity Properties                         as projection on mngprp.Properties;

}

annotate ContactRequestService  with @(requires: 'authenticated-user');
