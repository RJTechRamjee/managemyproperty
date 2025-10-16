using {rj.re.managemyproperty as mngprp} from '../srv/catalog_service';
namespace rj.re.managemyproperty;

/*
  UI annotations for list (line item) views.
  - Important fields are marked with Importance: #High / #Medium / #Low
  - GUID / managed metadata fields are hidden
  - Associations show useful scalar members (contact person's name, address city/postal)
*/

annotate mngprp.Properties with {
  // hide generated GUID and managed fields (cuid + managed mixin)
  ID @UI.hidden: true;
  createdAt @UI.hidden: true;
  createdBy @UI.hidden: true;
  modifiedAt @UI.hidden: true;
  modifiedBy @UI.hidden: true;

  // Primary list layout for Properties
  @UI.lineItem: [
    { Value: popertyId,                Label: 'Property ID',           Importance: #Low   },
    { Value: title,                    Label: 'Title',                 Importance: #High  },
    { Value: type,                     Label: 'Type',                  Importance: #High  },
    { Value: listingFor,               Label: 'Listing For',           Importance: #High  },
    { Value: purpose,                  Label: 'Purpose',               Importance: #Medium},
    { Value: state,                    Label: 'State',                 Importance: #High  },
    { Value: isVacant,                 Label: 'Vacant',                Importance: #High  },
    { Value: availableFrom,            Label: 'Available From',        Importance: #Medium},
    { Value: noOfRooms,                Label: 'Rooms',                 Importance: #Medium},
    { Value: propertySize,             Label: 'Size',                  Importance: #Medium,
      RecordType: 'Measure' },
    { Value: propertySizeUnit,         Label: 'Unit',                  Importance: #Low   },

    { Value: coldRent,                 Label: 'Cold Rent',             Importance: #High  },
    { Value: warmRent,                 Label: 'Warm Rent',             Importance: #High  },
    { Value: currency,                 Label: 'Currency',              Importance: #High  },

    { Value: address.city,             Label: 'City',                  Importance: #Medium},
    { Value: address.postalCode,       Label: 'Postal Code',           Importance: #Low   },

    // contact person (show helpful name fields instead of GUID)
    { Value: contactPerson.firstName,  Label: 'Contact First Name',    Importance: #Low   },
    { Value: contactPerson.lastName,   Label: 'Contact Last Name',     Importance: #Low   },
    { Value: contactPerson.emailId,    Label: 'Contact E-Mail',        Importance: #Low   },

    // useful features & amenities
    { Value: hasBalcony,               Label: 'Balcony',               Importance: #Low   },
    { Value: hasdGarten,               Label: 'Garden',                Importance: #Low   },
    { Value: hasGarageParking,         Label: 'Garage',                Importance: #Low   },
    { Value: noOfParkingSpace,         Label: 'Parking',               Importance: #Low   },

    { Value: floorNo,                  Label: 'Floor No.',             Importance: #Low   },
    { Value: totalFloors,              Label: 'Total Floors',          Importance: #Low   },
    { Value: yearOfConstruction,       Label: 'Year Built',            Importance: #Low   },
    { Value: hasPassengerLift,         Label: 'Passenger Lift',        Importance: #Low   },
    { Value: arePetsAllowed,           Label: 'Pets Allowed',          Importance: #Low   },

    { Value: heatingType,              Label: 'Heating',               Importance: #Low   },
    { Value: energyEffieicenyClass,    Label: 'Energy Class',          Importance: #Low   },
    { Value: minmumInternetSpeed,      Label: 'Min. Internet',         Importance: #Low   }
  ]
} 

annotate mngprp.Users with {
  // hide generated GUID + managed bookkeeping fields
  ID @UI.hidden: true;
  createdAt @UI.hidden: true;
  createdBy @UI.hidden: true;
  modifiedAt @UI.hidden: true;
  modifiedBy @UI.hidden: true;

  // line items for Users (list view)
  @UI.lineItem: [
    { Value: userId,                   Label: 'User ID',               Importance: #Low   },
    { Value: firstName,                Label: 'First Name',            Importance: #High  },
    { Value: lastName,                 Label: 'Last Name',             Importance: #High  },
    { Value: emailId,                  Label: 'EMail',                Importance: #High  },

    // show the most relevant address information inline (avoid exposing address GUID)
    { Value: address.city,             Label: 'City',                  Importance: #Medium},
    { Value: address.postalCode,       Label: 'Postal Code',           Importance: #Low   },

    // short intro for list preview (detailed intro should remain in object page)
    { Value: ShortIntro,               Label: 'Intro',                 Importance: #Low   }
  ]
}