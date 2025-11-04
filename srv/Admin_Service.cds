
using {rj.re.managemyproperty as mngprp} from '../db/schema';

service AdminService @(path: 'AdminService') {

    entity Addresses  as projection on mngprp.Addresses;

    entity Properties1 as projection on mngprp.Properties;

    @odata.draft.enabled
    entity Users      as projection on mngprp.Users;

    entity Statuses   as projection on mngprp.Statuses;

}