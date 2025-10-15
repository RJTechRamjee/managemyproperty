using { rj.re.manageproperty as mngprp } from '../db/schema';

service CatalogService {

    entity Addresses as projection on mngprp.Addresses;

    entity Properties as projection on mngprp.Properties;

    entity Users as projection on mngprp.Users;

}
