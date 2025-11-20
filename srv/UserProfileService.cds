using {rj.re.managemyproperty as mngprp} from '../db/schema';

service UserProfileService @(path: 'UserProfileService') {

    entity Addresses       as projection on mngprp.Addresses;

    entity Users           as projection on mngprp.Users {
        *,
        firstName || ' ' || lastName as fullName : String(81) @title: '{i18n>fullName}'
    };

    entity Statuses        as projection on mngprp.Statuses;

    entity Notifications   as projection on mngprp.Notifications;

    entity ContactRequests as projection on mngprp.ContactRequests;

}

annotate UserProfileService  with @(requires: 'authenticated-user');
