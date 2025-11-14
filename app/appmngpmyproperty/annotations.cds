using CatalogService as service from '../../srv/catalog_service';

annotate service.Properties with @(
    odata.draft.enabled,

    UI.SelectionFields        : [
        listingStatus_code,
        type,
        listingFor,
        purpose,
        state,
        isVacant,
        propertySize,
        coldRent,
        warmRent,
        yearOfConstruction
    ],

    UI.LineItem               : [
        {
            $Type  : 'UI.DataFieldForActionGroup',
            Label  : 'Set to status',
            Actions: [
                {
                    $Type : 'UI.DataFieldForAction',
                    Action: 'CatalogService.ReservepProperty',
                    Label : 'Reserve Property'
                // InvocationGrouping : ,
                // Inline : ,
                // Determining : ,
                // Label : '',
                // Criticality : ,
                // CriticalityRepresentation : ,
                // IconUrl : '',
                },
                {
                    $Type : 'UI.DataFieldForAction',
                    Action: 'CatalogService.SetToStatus',
                    Label : 'Set to Status'
                }
            ]
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Send Request',
            Action: 'CatalogService.SendRequest'
        },
        {
            $Type: 'UI.DataField',
            Value: propertyId,
        },
        {
            $Type: 'UI.DataField',
            Value: title,
        },
        // {
        //     $Type: 'UI.DataField',
        //     Value: description,
        // },
        {
            $Type: 'UI.DataField',
            Value: type,
        },
        {
            $Type: 'UI.DataField',
            Value: listingFor,
        },
        {
            $Type: 'UI.DataField',
            Value: purpose,
        },
        {
            $Type: 'UI.DataField',
            Value: state,
        },
        {
            $Type: 'UI.DataField',
            Value: availableFrom,
        },
        {
            $Type: 'UI.DataField',
            Value: noOfRooms,
        },
        {
            $Type: 'UI.DataField',
            Value: propertySize,
        },
        {
            $Type: 'UI.DataField',
            Value: coldRent,
        },
        {
            $Type: 'UI.DataField',
            Value: warmRent,
        },
        {
            $Type: 'UI.DataField',
            Value: hasBalcony,
        },
        {
            $Type          : 'UI.DataField',
            Value          : yearOfConstruction,
            formatOptions  : {groupingEnabled: false},
            textArrangement: #TextOnly

        },
    ],

    UI.HeaderInfo             : {
        TypeName      : '{i18n>Properties}',
        TypeNamePlural: '{i18n>Properties}',
        Title         : {
            Label: '{i18n>popertyId}',
            Value: propertyId
        },
        Description   : {
            Label: '{i18n>title}',
            Value: title
        }
    },


    UI.Facets                 : [
        {
            $Type : 'UI.CollectionFacet',
            Label : '{i18n>GeneralInfo}',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : '{i18n>GeneralInfo}',
                    Target: '@UI.FieldGroup#GeneralInfo'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : '{i18n>GeneralInfo1}',
                    Target: '@UI.FieldGroup#GeneralInfo1'
                },

            ]
        },
        {
            $Type : 'UI.CollectionFacet',
            Label : '{i18n>FinancialInfo}',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : '{i18n>FinancialInfo}',
                    Target: '@UI.FieldGroup#FinancialInfo'
                }
            ]
        },
        {
            $Type : 'UI.CollectionFacet',
            Label : '{i18n>PropertyFeatures}',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : '{i18n>PropertyFeatures}',
                    Target: '@UI.FieldGroup#PropertyFeatures'
                }
            ]
        },
        {
            $Type : 'UI.CollectionFacet',
            Label : '{i18n>UtilitiesAmenities}',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : '{i18n>UtilitiesAmenities}',
                    Target: '@UI.FieldGroup#UtilitiesAmenities'
                }
            ]
        },
        {
            $Type : 'UI.CollectionFacet',
            Label : '{i18n>LegalCompliance}',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : '{i18n>LegalCompliance}',
                    Target: '@UI.FieldGroup#LegalCompliance'
                }
            ]
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>PropertyDetailsInfo}',
            Target: 'propertyDetails/@UI.FieldGroup#PropertyDetailsGroup'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>NearByAmenities}',
            Target: 'nearByAmenities/@UI.LineItem'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>contactPerson}',
            Target: 'contactPerson/@Communication.Contact'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>ContactRequests}',
            Target: 'contactRequests/@UI.LineItem'
        },
    ],

    UI.Identification         : [
        {
            $Type : 'UI.DataFieldForAction',
            Label : '{i18n>SendRequest}',
            Action: 'service.SendRequest'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Set to Status',
            Action: 'service.SetToStatus'
        }
    ],

    UI.FieldGroup #GeneralInfo: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: listingFor
            },
            {
                $Type: 'UI.DataField',
                Value: type
            },
            {
                $Type: 'UI.DataField',
                Value: purpose
            },
            {
                $Type: 'UI.DataField',
                Value: state
            },
            {
                $Type: 'UI.DataField',
                Value: isVacant
            },
            {
                $Type: 'UI.DataField',
                Value: propertySize
            },
            {
                $Type: 'UI.DataField',
                Value: coldRent
            },
            {
                $Type: 'UI.DataField',
                Value: warmRent
            },
            {
                $Type          : 'UI.DataField',
                Value          : yearOfConstruction,

                formatOptions  : {groupingEnabled: false},
                textArrangement: #TextOnly

            },
            {
                $Type: 'UI.DataField',
                Value: heatingType
            },
            {
                $Type                : 'UI.DataFieldForAnnotation',
                Label                : '{i18n>listingStatus}',
                Target               : '@UI.DataPoint#ListingStatus',
                ![@UI.Importance]    : #High
            }
        ]
    }
);

annotate service.NearByAmenities with @(UI.LineItem: [
    {
        $Type: 'UI.DataField',
        Value: type,
    },
    {
        $Type: 'UI.DataField',
        Value: name,
    },
    {
        $Type: 'UI.DataField',
        Value: distance,
    },
    {
        $Type: 'UI.DataField',
        Value: distanceUnit,
    },
    {
        $Type: 'UI.DataField',
        Value: walkTime,
    },
    {
        $Type: 'UI.DataField',
        Value: walkTimeUnit,
    },
]);

annotate service.ContactRequests with @(UI.lineItem: [
    {
        $Type: 'UI.DataField',
        Value: requester_ID
    },
    {
        $Type: 'UI.DataField',
        Value: requester.fullName,
        Label: '{i18n>fullName}'
    },
    {
        $Type: 'UI.DataField',
        Value: requester.shortIntro
    },
]);

annotate service.Properties with {
    yearOfConstruction @Common.ValueList: {
        CollectionPath: 'DynamicYears',
        Parameters    : [{
            $Type            : 'Common.ValueListParameterInOut',
            LocalDataProperty: 'yearOfConstruction',
            ValueListProperty: 'year'
        }]
    };
    listingStatus      @Common.ValueList: {
        CollectionPath: 'Statuses',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: 'listingStatus_code',
                ValueListProperty: 'code'
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'name'
            }
        ]
    };
};

annotate service.ActionParams with {
    newStatusCode @Common.ValueList: {
        CollectionPath: 'Statuses',
        Parameters    : [{
            $Type            : 'Common.ValueListParameterInOut',
            LocalDataProperty: 'newStatusCode',
            ValueListProperty: 'code'
        },
        {
            $Type            : 'Common.ValueListParameterDisplayOnly',
            ValueListProperty: 'name'
        }]
    }
};

// Control action visibility based on property ownership
annotate service.Properties actions {
    // SendRequest should only be visible when user is NOT the property owner
    SendRequest @(
        Core.OperationAvailable: {$edmJson: {$Not: {$Path: 'in/isOwner'}}}
    );
    // SetToStatus should only be visible when user IS the property owner
    SetToStatus @(
        Core.OperationAvailable: {$edmJson: {$Path: 'in/isOwner'}}
    );
};

// Control Edit/Update capability based on property ownership
annotate service.Properties with @(
    Capabilities.UpdateRestrictions: {
        Updatable: {$edmJson: {$Path: 'isOwner'}}
    },
    Capabilities.DeleteRestrictions: {
        Deletable: {$edmJson: {$Path: 'isOwner'}}
    }
);


annotate service.Properties with {
    // Add currency semantic annotations
    coldRent @(
        Measures.ISOCurrency: currency_code,
        Common.Label        : '{i18n>coldRent}'
    );
    warmRent @(
        Measures.ISOCurrency: currency_code,
        Common.Label        : '{i18n>warmRent}'
    );
    securityDeposit @(
        Measures.ISOCurrency: currency_code,
        Common.Label        : '{i18n>securityDeposit}'
    );
    maintenanceCost @(
        Measures.ISOCurrency: currency_code,
        Common.Label        : '{i18n>maintenanceCost}'
    );
    utilityCost @(
        Measures.ISOCurrency: currency_code,
        Common.Label        : '{i18n>utilityCost}'
    );
    propertyTax @(
        Measures.ISOCurrency: currency_code,
        Common.Label        : '{i18n>propertyTax}'
    );

    // Add contact person as contact card
    contactPerson @(
        Common.Label: '{i18n>contactPerson}',
        UI.IsContactCard
    );
};

// Add DataPoint for Listing Status with criticality
annotate service.Properties with @(
    UI.DataPoint #ListingStatus: {
        Value                : listingStatus.name,
        Criticality          : listingStatus.criticality,
        CriticalityRepresentation: #WithIcon
    }
);

// Add criticality field to Statuses
annotate service.Statuses with {
    code        @title: '{i18n>code}';
    name        @title: 'Status';
    criticality @title: 'Criticality';
};

// FieldGroup for Financial Information
annotate service.Properties with @(
    UI.FieldGroup #FinancialInfo: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: coldRent
            },
            {
                $Type: 'UI.DataField',
                Value: warmRent
            },
            {
                $Type: 'UI.DataField',
                Value: currency_code
            },
            {
                $Type: 'UI.DataField',
                Value: securityDeposit
            },
            {
                $Type: 'UI.DataField',
                Value: maintenanceCost
            },
            {
                $Type: 'UI.DataField',
                Value: utilityCost
            },
            {
                $Type: 'UI.DataField',
                Value: brokerCommission
            },
            {
                $Type: 'UI.DataField',
                Value: propertyTax
            }
        ]
    }
);

// FieldGroup for Property Features
annotate service.Properties with @(
    UI.FieldGroup #PropertyFeatures: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: noOfBedrooms
            },
            {
                $Type: 'UI.DataField',
                Value: noOfBathrooms
            },
            {
                $Type: 'UI.DataField',
                Value: noOfRooms
            },
            {
                $Type: 'UI.DataField',
                Value: hasBalcony
            },
            {
                $Type: 'UI.DataField',
                Value: balconySize
            },
            {
                $Type: 'UI.DataField',
                Value: hasdGarten
            },
            {
                $Type: 'UI.DataField',
                Value: gardenSize
            },
            {
                $Type: 'UI.DataField',
                Value: isFurnished
            },
            {
                $Type: 'UI.DataField',
                Value: hasAirConditioning
            },
            {
                $Type: 'UI.DataField',
                Value: hasBasement
            },
            {
                $Type: 'UI.DataField',
                Value: hasAttic
            }
        ]
    }
);

// FieldGroup for Utilities & Amenities
annotate service.Properties with @(
    UI.FieldGroup #UtilitiesAmenities: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: waterSupply
            },
            {
                $Type: 'UI.DataField',
                Value: powerBackup
            },
            {
                $Type: 'UI.DataField',
                Value: hasSwimmingPool
            },
            {
                $Type: 'UI.DataField',
                Value: hasGym
            },
            {
                $Type: 'UI.DataField',
                Value: hasPassengerLift
            },
            {
                $Type: 'UI.DataField',
                Value: noOfParkingSpace
            },
            {
                $Type: 'UI.DataField',
                Value: hasGarageParking
            },
            {
                $Type: 'UI.DataField',
                Value: minmumInternetSpeed
            }
        ]
    }
);

// FieldGroup for Legal & Compliance
annotate service.Properties with @(
    UI.FieldGroup #LegalCompliance: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: yearOfConstruction,
                formatOptions: {groupingEnabled: false},
                textArrangement: #TextOnly
            },
            {
                $Type: 'UI.DataField',
                Value: lastRenovationYear,
                formatOptions: {groupingEnabled: false},
                textArrangement: #TextOnly
            },
            {
                $Type: 'UI.DataField',
                Value: occupancyCertificate
            },
            {
                $Type: 'UI.DataField',
                Value: fireComplianceCert
            },
            {
                $Type: 'UI.DataField',
                Value: energyEffieicenyClass
            },
            {
                $Type: 'UI.DataField',
                Value: arePetsAllowed
            }
        ]
    }
);

// FieldGroup for PropertyDetails
annotate service.PropertyDetails with @(
    UI.FieldGroup #PropertyDetailsGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: interiorDescription
            },
            {
                $Type: 'UI.DataField',
                Value: exteriorDescription
            },
            {
                $Type: 'UI.DataField',
                Value: kitchenType
            },
            {
                $Type: 'UI.DataField',
                Value: flooringType
            },
            {
                $Type: 'UI.DataField',
                Value: windowType
            },
            {
                $Type: 'UI.DataField',
                Value: roofType
            },
            {
                $Type: 'UI.DataField',
                Value: facingDirection
            },
            {
                $Type: 'UI.DataField',
                Value: viewFromProperty
            },
            {
                $Type: 'UI.DataField',
                Value: neighborhoodType
            },
            {
                $Type: 'UI.DataField',
                Value: parkingType
            },
            {
                $Type: 'UI.DataField',
                Value: storageSpace
            },
            {
                $Type: 'UI.DataField',
                Value: laundryFacility
            },
            {
                $Type: 'UI.DataField',
                Value: disabledAccess
            },
            {
                $Type: 'UI.DataField',
                Value: smokingAllowed
            },
            {
                $Type: 'UI.DataField',
                Value: soundproofing
            },
            {
                $Type: 'UI.DataField',
                Value: securityFeatures
            },
            {
                $Type: 'UI.DataField',
                Value: specialNotes
            }
        ]
    }
);

// Update ContactRequests to use fullName and contact card
annotate service.ContactRequests with {
    requester @(
        Common.Label: '{i18n>requester}',
        UI.IsContactCard
    );
};

// Update Users with contact information annotation
annotate service.Users with @(
    Communication.Contact: {
        fn  : fullName,
        tel : [{
            type: #work,
            uri : phoneNumber
        }],
        email: [{
            type   : #work,
            address: emailId
        }]
    }
);
