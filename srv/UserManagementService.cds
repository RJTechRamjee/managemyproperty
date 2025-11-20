using {rj.re.managemyproperty as mngprp} from '../db/schema';

service UserManagementService @(path: 'UserManagementService') {

    entity Addresses       as projection on mngprp.Addresses;

    @odata.draft.enabled
    entity Users           as projection on mngprp.Users {
        *,
        firstName || ' ' || lastName as fullName : String(81) @title: '{i18n>fullName}'
    };

    entity Statuses        as projection on mngprp.Statuses;

    entity Notifications   as projection on mngprp.Notifications;

    entity EmailLogs       as projection on mngprp.EmailLogs;

}

annotate UserManagementService  with @(requires: 'authenticated-user');
