using {rj.re.managemyproperty as mngprp} from '../db/schema';


service CatalogService @(path: 'CatalogService') {

    type ActionParams : {
        newStatusCode : String(10)
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
            popertyId asc
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
        };

    // entity ContactRequests   as projection on mngprp.ContactRequests {
    // requester.ID, requester.firstName, requester.lastName , requester.ShortIntro,
    // requester : redirected to Users,
    // property : redirected to Properties,
    // };
    entity ConactReqMessages                  as projection on mngprp.ConactReqMessages;

    action ReservepProperty(

    ) returns array of Properties;

    entity DynamicYears @cds.persistence.skip as projection on mngprp.DynamicYears;

    entity Statuses                           as projection on mngprp.Statuses;
}
