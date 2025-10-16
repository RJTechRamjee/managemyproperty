using {  cuid, managed , Currency } from '@sap/cds/common';
namespace rj.re.managemyproperty;

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
    noOfRooms : Integer;
    propertySize : Decimal(5, 2);
    propertySizeUnit : String(10) default 'sqm';
    coldRent : Decimal(4,2);
    warmRent : Decimal(4, 2);
    currency : Currency;
    hasBalcony : Boolean;
    hasdGarten : Boolean;
    noOfParkingSpace : Int16;
    hasGarageParking : Boolean;
    floorNo : Integer;
    totalFloors : Integer;
    @Common : { Text  }
    yearOfConstruction: Int16 ; // dynaminc range
    hasPassengerLift : Boolean;
    arePetsAllowed : Boolean;
    heatingType : String(20) ; // Floor Heating , Central Heating,
    energyEffieicenyClass : String(2); // A+,B,C,D,E,F,G,H
    minmumInternetSpeed: String(10); // 100Mbps , 250Mbps, 1000 Mbps
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

