
using {rj.re.managemyproperty as mngprp} from '../db/schema';

service AdminService @(path: 'AdminService') {

    entity Addresses       as projection on mngprp.Addresses;

    entity Properties1     as projection on mngprp.Properties;

    @odata.draft.enabled
    entity Users           as projection on mngprp.Users {
        *,
        firstName || ' ' || lastName as fullName : String(81) @title: '{i18n>fullName}'
    };

    entity Statuses        as projection on mngprp.Statuses;

    entity Notifications   as projection on mngprp.Notifications;

    entity EmailLogs       as projection on mngprp.EmailLogs;

    entity ContactRequests as projection on mngprp.ContactRequests;

}