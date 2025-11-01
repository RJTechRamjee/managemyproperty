using {rj.re.managemyproperty as mngprp} from '../db/schema';


service CatalogService @(path: 'CatalogService') {

    @cds.odata.valuelist
    entity Addresses         as projection on mngprp.Addresses;

@cds.odata.valuelist
    entity Properties        as projection on mngprp.Properties
                                order by
                                    popertyId asc
        actions {
            action SetToStatus(newStatusCode: String(10)) returns Properties;

            action SendEmail(UserId: String(10), personalMessage: String(300));
        };
@cds.odata.valuelist
    entity NearByAmenities   as projection on mngprp.NearByAmenities;

    @readonly
     @cds.odata.valuelist
    entity Users             as projection on mngprp.Users;

    @odata.draft.enabled
    @cds.odata.valuelist
    entity ContactRequests   as projection on mngprp.ContactRequests;
    entity ConactReqMessages as projection on mngprp.ConactReqMessages;

    action ReservepProperty(

    ) returns array of Properties;
}


service AdminService @(path: 'AdminService') {

    entity Addresses  as projection on mngprp.Addresses;

    entity Properties as projection on mngprp.Properties;

    @odata.draft.enabled
    entity Users      as projection on mngprp.Users;

    entity Statuses   as projection on mngprp.Statuses;

}
