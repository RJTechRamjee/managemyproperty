using {  cuid, managed } from '@sap/cds/common';
namespace rj.re.manageproperty;

entity Properties : cuid , managed 
{
    popertyId : String(10);
    title : String(100);
    description : String(200);
    type : PropertyType;
    listingFor : PropertyListingFor;
    purpose : PropertyPurpose;
    state : PropertyState;
    isVacant : Boolean;
    availableFrom : Date;
    contactPerson : Association to one Users;
    address : Association to one Addresses;
}

entity Users : cuid, managed
{
    userId : String(10);
    firstName : String(40);
    lastName : String(40);
    emailId : String(50);
    address : Association to one Addresses;
    ShortIntro : String(200);
    DetailedIntro : String(500);
}

entity Addresses : cuid , managed
{
    addressId : String(10) ;
    houseNo : Int16;
    streetName : String(40);
    city : String(40);
    postalCode : String(6);
    ctate : String(40);
    Country : String(20);

}

type PropertyListingFor : Integer enum
{
    Sale = 1;
    Rent = 2;
    Lease = 3;
}

type PropertyPurpose : Integer enum
{
    Living = 1;
    Commercial = 2;
}

type PropertyState : String enum
{
    New;
    Renovated;
    VeryGood = 'Very Good';
    NeedsRenovation = 'Needs renovation';
}

type PropertyType : Integer enum
{
    Apartment = 1;
    House = 2;
}