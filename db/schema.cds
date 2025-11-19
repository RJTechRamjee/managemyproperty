using {
  cuid,
  managed,
  Currency,
  sap.common.CodeList
} from '@sap/cds/common';

namespace rj.re.managemyproperty;

@cds.odata.valuelist
entity Statuses : CodeList {
  key code : String(10) @(title: '{i18n>code}');
  criticality : Integer;
}

entity Properties : cuid, managed {
  propertyId             : String(10)                                   @(title: '{i18n>popertyId}');
  title                 : String(100)                                  @(title: '{i18n>title}');
  description           : String(500)                                  @(title: '{i18n>description}');
  type                  : PropertyType                                 @(title: '{i18n>PropertyType}');
  listingFor            : PropertyListingFor                           @(title: '{i18n>listingFor}');
  purpose               : PropertyPurpose                              @(title: '{i18n>purpose}');
  state                 : PropertyState                                @(title: '{i18n>state}');
  isVacant              : Boolean                                      @(title: '{i18n>isVacant}');
  availableFrom         : Date                                         @(title: '{i18n>availableFrom}');
  noOfRooms             : Integer                                      @(title: '{i18n>noOfRooms}');
  propertySize          : Decimal(5, 2)                                @(title: '{i18n>propertySize}');
  propertySizeUnit      : String(10) default 'sqm'                     @(title: '{i18n>propertySizeUnit}');
  coldRent              : Decimal(6, 2)                                @(title: '{i18n>coldRent}');
  warmRent              : Decimal(6, 2)                                @(title: '{i18n>warmRent}');
  currency              : Currency                                     @(title: '{i18n>currency}');
  hasBalcony            : Boolean                                      @(title: '{i18n>hasBalcony}');
  hasdGarten            : Boolean                                      @(title: '{i18n>hasdGarten}');
  noOfParkingSpace      : Int16                                        @(title: '{i18n>noOfParkingSpace}');
  hasGarageParking      : Boolean                                      @(title: '{i18n>hasGarageParking}');
  floorNo               : Integer                                      @(title: '{i18n>floorNo}');
  totalFloors           : Integer                                      @(title: '{i18n>totalFloors}');
  yearOfConstruction    : String(4)                                    @(title: '{i18n>yearOfConstruction}');
  hasPassengerLift      : Boolean                                      @(title: '{i18n>hasPassengerLift}');
  arePetsAllowed        : Boolean                                      @(title: '{i18n>arePetsAllowed}');
  heatingType           : String(20)                                   @(title: '{i18n>heatingType}');
  energyEffieicenyClass : String(2)                                    @(title: '{i18n>energyEffieicenyClass}');
  minmumInternetSpeed   : String(10)                                   @(title: '{i18n>minmumInternetSpeed}');
  // New Financial Fields
  securityDeposit       : Decimal(6, 2)                                @(title: '{i18n>securityDeposit}');
  maintenanceCost       : Decimal(6, 2)                                @(title: '{i18n>maintenanceCost}');
  utilityCost           : Decimal(6, 2)                                @(title: '{i18n>utilityCost}');
  brokerCommission      : Decimal(5, 2)                                @(title: '{i18n>brokerCommission}');
  propertyTax           : Decimal(6, 2)                                @(title: '{i18n>propertyTax}');
  // New Property Features
  noOfBathrooms         : Integer                                      @(title: '{i18n>noOfBathrooms}');
  noOfBedrooms          : Integer                                      @(title: '{i18n>noOfBedrooms}');
  balconySize           : Decimal(4, 2)                                @(title: '{i18n>balconySize}');
  gardenSize            : Decimal(5, 2)                                @(title: '{i18n>gardenSize}');
  isFurnished           : Boolean                                      @(title: '{i18n>isFurnished}');
  hasAirConditioning    : Boolean                                      @(title: '{i18n>hasAirConditioning}');
  hasBasement           : Boolean                                      @(title: '{i18n>hasBasement}');
  hasAttic              : Boolean                                      @(title: '{i18n>hasAttic}');
  // New Utilities & Amenities
  waterSupply           : WaterSupplyType                              @(title: '{i18n>waterSupply}');
  powerBackup           : Boolean                                      @(title: '{i18n>powerBackup}');
  hasSwimmingPool       : Boolean                                      @(title: '{i18n>hasSwimmingPool}');
  hasGym                : Boolean                                      @(title: '{i18n>hasGym}');
  // New Legal & Compliance
  lastRenovationYear    : String(4)                                    @(title: '{i18n>lastRenovationYear}');
  occupancyCertificate  : Boolean                                      @(title: '{i18n>occupancyCertificate}');
  fireComplianceCert    : Boolean                                      @(title: '{i18n>fireComplianceCert}');
  
  contactPerson         : Association to one Users                     @(title: '{i18n>contactPerson}');
  address               : Association to one Addresses                 @(title: '{i18n>address}');
  listingStatus         : Association to Statuses default 'NEWLISTING' @(title: '{i18n>listingStatus}');
  propertyDetails       : Composition of  one PropertyDetails           @(title: '{i18n>propertyDetails}');
  nearByAmenities       : Composition of many NearByAmenities
                            on nearByAmenities.property = $self        @(title: '{i18n>nearByAmenities}');
  contactRequests       : Association to many ContactRequests
                            on contactRequests.property = $self        @(title: '{i18n>contactRequests}');
}

entity PropertyDetails : cuid, managed {
  property              : Association to one Properties                 @(title: '{i18n>property}');
  interiorDescription   : String(1000)                                  @(title: '{i18n>interiorDescription}');
  exteriorDescription   : String(1000)                                  @(title: '{i18n>exteriorDescription}');
  kitchenType           : KitchenType                                   @(title: '{i18n>kitchenType}');
  flooringType          : String(50)                                    @(title: '{i18n>flooringType}');
  windowType            : String(50)                                    @(title: '{i18n>windowType}');
  roofType              : String(50)                                    @(title: '{i18n>roofType}');
  facingDirection       : FacingDirection                               @(title: '{i18n>facingDirection}');
  viewFromProperty      : String(200)                                   @(title: '{i18n>viewFromProperty}');
  neighborhoodType      : NeighborhoodType                              @(title: '{i18n>neighborhoodType}');
  parkingType           : ParkingType                                   @(title: '{i18n>parkingType}');
  storageSpace          : Boolean                                       @(title: '{i18n>storageSpace}');
  laundryFacility       : Boolean                                       @(title: '{i18n>laundryFacility}');
  disabledAccess        : Boolean                                       @(title: '{i18n>disabledAccess}');
  smokingAllowed        : Boolean                                       @(title: '{i18n>smokingAllowed}');
  soundproofing         : SoundproofingLevel                            @(title: '{i18n>soundproofing}');
  securityFeatures      : String(500)                                   @(title: '{i18n>securityFeatures}');
  specialNotes          : String(1000)                                  @(title: '{i18n>specialNotes}');
}

entity NearByAmenities : cuid, managed {
  property     : Association to one Properties                 @(title: '{i18n>property}');
  type         : AmenityType                                   @(title: '{i18n>type}');
  name         : String(50)                                    @(title: '{i18n>name}');
  distance     : Int16                                         @(title: '{i18n>distance}');
  distanceUnit : String(5) default 'km'                        @(title: '{i18n>distanceUnit}');
  walkTime     : Int16                                         @(title: '{i18n>walkTime}');
  walkTimeUnit : String(5) default 'min'                       @(title: '{i18n>walkTimeUnit}')
}

entity Users : cuid, managed {
  userId             : String(10)                   @(title: '{i18n>userId}');
  firstName          : String(40)                   @(title: '{i18n>firstName}');
  lastName           : String(40)                   @(title: '{i18n>lastName}');
  phoneNumber        : String(20)                   @(title: '{i18n>phoneNumber}');
  address            : Association to one Addresses @(title: '{i18n>address}');
  ShortIntro         : String(200)                  @(title: '{i18n>ShortIntro}');
  DetailedIntro      : String(500)                  @(title: '{i18n>DetailedIntro}');
  role               : UserRole                     @(title: '{i18n>role}');
  isActive           : Boolean default true         @(title: '{i18n>isActive}');
  emailNotifications : Boolean default true         @(title: '{i18n>emailNotifications}');
  appNotifications   : Boolean default true         @(title: '{i18n>appNotifications}');
}

entity Addresses : cuid, managed {
  addressId  : String(10) @(title: '{i18n>addressId}');
  houseNo    : Int16      @(title: '{i18n>houseNo}');
  streetName : String(40) @(title: '{i18n>streetName}');
  city       : String(40) @(title: '{i18n>city}');
  postalCode : String(6)  @(title: '{i18n>postalCode}');
  ctate      : String(40) @(title: '{i18n>ctate}');
  Country    : String(20) @(title: '{i18n>Country}');
}

type PropertyListingFor : String(10) enum {
  Sale  @(title: '{i18n>Sale}');
  Rent  @(title: '{i18n>Rent}');
  Lease @(title: '{i18n>Lease}');
}

type PropertyPurpose    : String(20) enum {
  Living     @(title: '{i18n>Living}');
  Commercial @(title: '{i18n>Commercial}');
}

type PropertyState      : String enum {
  New                                  @(title: '{i18n>New}');
  Renovated                            @(title: '{i18n>Renovated}');
  VeryGood = 'Very Good' @(title: '{i18n>VeryGood}');
  NeedsRenovation = 'Needs renovation' @(title: '{i18n>NeedsRenovation}');
}

type PropertyType       : String(20) enum {
  Apartment @(title: '{i18n>Apartment}');
  House     @(title: '{i18n>House}');
}

type UserRole           : String(20) enum {
  Buyer      @(title: '{i18n>Buyer}');
  Seller     @(title: '{i18n>Seller}');
  Owner      @(title: '{i18n>Owner}');
  Tenant     @(title: '{i18n>Tenant}');
  Agent      @(title: '{i18n>Agent}');
}

type NotificationType   : String(30) enum {
  ContactRequestReceived = 'Contact Request Received' @(title: '{i18n>ContactRequestReceived}');
  ContactRequestResponse = 'Contact Request Response' @(title: '{i18n>ContactRequestResponse}');
  PropertyStatusChanged  = 'Property Status Changed'  @(title: '{i18n>PropertyStatusChanged}');
  NewPropertyMatch       = 'New Property Match'       @(title: '{i18n>NewPropertyMatch}');
  PropertyPriceChanged   = 'Property Price Changed'   @(title: '{i18n>PropertyPriceChanged}');
  ViewingScheduled       = 'Viewing Scheduled'        @(title: '{i18n>ViewingScheduled}');
}

type EmailType          : String(30) enum {
  WelcomeEmail           = 'Welcome Email'            @(title: '{i18n>WelcomeEmail}');
  ContactRequestConfirm  = 'Contact Request Confirm'  @(title: '{i18n>ContactRequestConfirm}');
  ContactRequestResponse = 'Contact Request Response' @(title: '{i18n>ContactRequestResponse}');
  PropertyViewingConfirm = 'Property Viewing Confirm' @(title: '{i18n>PropertyViewingConfirm}');
  DocumentSharing        = 'Document Sharing'         @(title: '{i18n>DocumentSharing}');
}

type AmenityType        : String(20) enum {
  School         @(title: '{i18n>School}');
  Hospital       @(title: '{i18n>Hospital}');
  Supermarket    @(title: '{i18n>Supermarket}');
  PublicTransport = 'Public Transport' @(title: '{i18n>PublicTransport}');
  Restaurant     @(title: '{i18n>Restaurant}');
  Park           @(title: '{i18n>Park}');
  Pharmacy       @(title: '{i18n>Pharmacy}');
  Bank           @(title: '{i18n>Bank}');
  PostOffice = 'Post Office' @(title: '{i18n>PostOffice}');
  ShoppingMall = 'Shopping Mall' @(title: '{i18n>ShoppingMall}');
}

type WaterSupplyType    : String(20) enum {
  Municipal      @(title: '{i18n>Municipal}');
  Borewell       @(title: '{i18n>Borewell}');
  Both           @(title: '{i18n>Both}');
}

type KitchenType        : String(20) enum {
  Modular        @(title: '{i18n>Modular}');
  SemiModular = 'Semi Modular'    @(title: '{i18n>SemiModular}');
  Traditional    @(title: '{i18n>Traditional}');
}

type FacingDirection    : String(10) enum {
  North          @(title: '{i18n>North}');
  South          @(title: '{i18n>South}');
  East           @(title: '{i18n>East}');
  West           @(title: '{i18n>West}');
  NorthEast = 'North East'      @(title: '{i18n>NorthEast}');
  NorthWest = 'North West'      @(title: '{i18n>NorthWest}');
  SouthEast = 'South East'      @(title: '{i18n>SouthEast}');
  SouthWest = 'South West'      @(title: '{i18n>SouthWest}');
}

type NeighborhoodType   : String(20) enum {
  Residential    @(title: '{i18n>Residential}');
  Commercial     @(title: '{i18n>CommercialNeighborhood}');
  Mixed          @(title: '{i18n>Mixed}');
}

type ParkingType        : String(20) enum {
  Covered        @(title: '{i18n>Covered}');
  Open           @(title: '{i18n>Open}');
  Basement       @(title: '{i18n>BasementParking}');
  Street         @(title: '{i18n>Street}');
}

type SoundproofingLevel : String(10) enum {
  None           @(title: '{i18n>None}');
  Basic          @(title: '{i18n>Basic}');
  Standard       @(title: '{i18n>Standard}');
  Advanced       @(title: '{i18n>Advanced}');
}

entity DynamicYears @cds.persistence.skip {
  key year : String(4) @(title: '{i18n>year}');
}

entity ContactRequests : cuid, managed {
  property        : Association to one Properties                 @(title: '{i18n>property}');
  requester       : Association to one Users                      @(title: '{i18n>requester}');
  requestMessage  : String(500)                                   @(title: '{i18n>requestMessage}');
  status          : RequestStatus default 'Pending'               @(title: '{i18n>status}');
  emailSent       : Boolean default false                         @(title: '{i18n>emailSent}');
  notificationSent: Boolean default false                         @(title: '{i18n>notificationSent}');
  messages        : Composition of many ConactReqMessages
                      on messages.contactRequest = $self          @(title: '{i18n>messages}');
}

type RequestStatus      : String(20) enum {
  Pending    @(title: '{i18n>Pending}');
  Responded  @(title: '{i18n>Responded}');
  Closed     @(title: '{i18n>Closed}');
}

entity ConactReqMessages : cuid, managed {
  contactRequest : Association to one ContactRequests            @(title: '{i18n>contactRequest}');
  sender         : Association to one Users                      @(title: '{i18n>sender}');
  message        : String(300)                                   @(title: '{i18n>message}');
}

entity Notifications : cuid, managed {
  recipient      : Association to one Users                      @(title: '{i18n>recipient}');
  notificationType: NotificationType                             @(title: '{i18n>notificationType}');
  title          : String(100)                                   @(title: '{i18n>notificationTitle}');
  message        : String(500)                                   @(title: '{i18n>notificationMessage}');
  isRead         : Boolean default false                         @(title: '{i18n>isRead}');
  relatedEntity  : String(100)                                   @(title: '{i18n>relatedEntity}');
  relatedEntityId: String(100)                                   @(title: '{i18n>relatedEntityId}');
}

entity EmailLogs : cuid, managed {
  recipient      : Association to one Users                      @(title: '{i18n>emailRecipient}');
  sender         : Association to one Users                      @(title: '{i18n>emailSender}');
  emailType      : EmailType                                     @(title: '{i18n>emailType}');
  subject        : String(200)                                   @(title: '{i18n>emailSubject}');
  body           : String(2000)                                  @(title: '{i18n>emailBody}');
  sentAt         : DateTime                                      @(title: '{i18n>sentAt}');
  deliveryStatus : String(20) default 'Sent'                     @(title: '{i18n>deliveryStatus}');
  relatedEntity  : String(100)                                   @(title: '{i18n>relatedEntity}');
  relatedEntityId: String(100)                                   @(title: '{i18n>relatedEntityId}');
}
