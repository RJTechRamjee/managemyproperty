using {rj.re.managemyproperty as mngprp} from '../db/schema';

service CatalogService @(path:'CatalogService'){

    entity Addresses  as projection on mngprp.Addresses;

    entity Properties as projection on mngprp.Properties;

    @readonly
    entity Users      as projection on mngprp.Users;

    action ReservepProperty(
        
    ) returns array of  Properties;
}


service AdminService {

    entity Addresses  as projection on mngprp.Addresses;

    entity Properties as projection on mngprp.Properties;

    entity Users      as projection on mngprp.Users;

}
