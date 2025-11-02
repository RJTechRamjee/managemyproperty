using { cuid, managed, Currency, sap.common.CodeList } from '@sap/cds/common';

namespace rj.re.managemyproperty;

@cds.odata.valuelist
entity Statuses : CodeList {
  key code : String(10) @(title: '{i18n>code}');
}

entity Properties : cuid, managed {
  popertyId             : String(10) @(title: '{i18n>popertyId}');
  title                 : String(100) @(title: '{i18n>title}');
  description           : String(500) @(title: '{i18n>description}');
  type                  : PropertyType @(title: '{i18n>PropertyType}');
  listingFor            : PropertyListingFor @(title: '{i18n>listingFor}');
  purpose               : PropertyPurpose @(title: '{i18n>purpose}');
  state                 : PropertyState @(title: '{i18n>state}');
  isVacant              : Boolean @(title: '{i18n>isVacant}');
  availableFrom         : Date @(title: '{i18n>availableFrom}');
  noOfRooms             : Integer @(title: '{i18n>noOfRooms}');
  propertySize          : Decimal(5, 2) @(title: '{i18n>propertySize}');
  propertySizeUnit      : String(10) default 'sqm' @(title: '{i18n>propertySizeUnit}');
  coldRent              : Decimal(6, 2) @(title: '{i18n>coldRent}');
  warmRent              : Decimal(6, 2) @(title: '{i18n>warmRent}');
  currency              : Currency @(title: '{i18n>currency}');
  hasBalcony            : Boolean @(title: '{i18n>hasBalcony}');
  hasdGarten            : Boolean @(title: '{i18n>hasdGarten}');
  noOfParkingSpace      : Int16 @(title: '{i18n>noOfParkingSpace}');
  hasGarageParking      : Boolean @(title: '{i18n>hasGarageParking}');
  floorNo               : Integer @(title: '{i18n>floorNo}');
  totalFloors           : Integer @(title: '{i18n>totalFloors}');
  @Common : { Text }
  yearOfConstruction    : Int16 @(title: '{i18n>yearOfConstruction}');
  hasPassengerLift      : Boolean @(title: '{i18n>hasPassengerLift}');
  arePetsAllowed        : Boolean @(title: '{i18n>arePetsAllowed}');
  heatingType           : String(20) @(title: '{i18n>heatingType}');
  energyEffieicenyClass : String(2) @(title: '{i18n>energyEffieicenyClass}');
  minmumInternetSpeed   : String(10) @(title: '{i18n>minmumInternetSpeed}');
  contactPerson         : Association to one Users @(title: '{i18n>contactPerson}');
  address               : Association to one Addresses @(title: '{i18n>address}');
  listingStatus         : Association to Statuses default 'NEWLISTING' @(title: '{i18n>listingStatus}');
  nearByAmenities       : Composition of many NearByAmenities 
                                        on nearByAmenities.property = $self;
  contactRequests : Association to many ContactRequests on contactRequests.property = $self;                                        
}

entity NearByAmenities : cuid, managed {
  property : Association to one Properties;
  type : String(20);
  name : String(50);
  distance : Int16;
  distanceUnit : String(5) default 'km';
  walkTime : Int16;
  walkTimeUnit : String(5) default 'min'
}

entity Users : cuid, managed {
  userId        : String(10) @(title: '{i18n>userId}');
  firstName     : String(40) @(title: '{i18n>firstName}');
  lastName      : String(40) @(title: '{i18n>lastName}');
  emailId       : String(50) @(title: '{i18n>emailId}');
  address       : Association to one Addresses @(title: '{i18n>address}');
  ShortIntro    : String(200) @(title: '{i18n>ShortIntro}');
  DetailedIntro : String(500) @(title: '{i18n>DetailedIntro}');
}

entity Addresses : cuid, managed {
  addressId  : String(10) @(title: '{i18n>addressId}');
  houseNo    : Int16 @(title: '{i18n>houseNo}');
  streetName : String(40) @(title: '{i18n>streetName}');
  city       : String(40) @(title: '{i18n>city}');
  postalCode : String(6) @(title: '{i18n>postalCode}');
  ctate      : String(40) @(title: '{i18n>ctate}');
  Country    : String(20) @(title: '{i18n>Country}');
}

type PropertyListingFor : String(10) enum {
  Sale  @(title: '{i18n>Sale}');
  Rent  @(title: '{i18n>Rent}');
  Lease @(title: '{i18n>Lease}');
}

type PropertyPurpose : String(20) enum {
  Living @(title: '{i18n>Living}');
  Commercial @(title: '{i18n>Commercial}');
}

type PropertyState : String enum {
  New @(title: '{i18n>New}');
  Renovated @(title: '{i18n>Renovated}');
  VeryGood = 'Very Good' @(title: '{i18n>VeryGood}');
  NeedsRenovation = 'Needs renovation' @(title: '{i18n>NeedsRenovation}');
}

type PropertyType : String(20) enum {
  Apartment  @(title: '{i18n>Apartment}');
  House @(title: '{i18n>House}');
}

entity ContactRequests : cuid , managed {
  property : Association to one Properties;
  requester : Association to one Users;
  requestMessage : String(500);
  messages : Composition of many ConactReqMessages on messages.contactRequest = $self;
}

entity ConactReqMessages : cuid, managed {
  contactRequest : Association to one ContactRequests;
  sender : Association to one Users;
  message : String(300);
}