using {rj.re.managemyproperty as mngprp} from '../db/schema';

service CatalogService {

    entity Addresses  as projection on mngprp.Addresses;

    entity Properties as projection on mngprp.Properties;

    @readonly
    entity Users      as projection on mngprp.Users;

}


service AdminService {

    entity Addresses  as projection on mngprp.Addresses;

    entity Properties as projection on mngprp.Properties;

    entity Users      as projection on mngprp.Users;

}
