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
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>NearByAmenities}',
            Target: 'nearByAmenities/@UI.LineItem'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>ContactRequests}',
            Target: 'contactRequests/@UI.LineItem#ForProperties'
        },
    ],

    UI.Identification         : [{
        $Type : 'UI.DataFieldForAction',
        Label : '{i18n>SendRequest}',
        Action: 'service.SendRequest'
    }],

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
                $Type: 'UI.DataField',
                Value: listingStatus.code
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

// ContactRequests table shown in Properties object page (read-only association)
// Removed property_ID as it's redundant in this context
annotate service.ContactRequests with @(
    UI.LineItem #ForProperties: [
        {
            $Type: 'UI.DataField',
            Value: requester.firstName,
            Label: '{i18n>firstName}'
        },
        {
            $Type: 'UI.DataField',
            Value: requester.lastName,
            Label: '{i18n>lastName}'
        },
        {
            $Type: 'UI.DataField',
            Value: requestMessage,
            Label: '{i18n>requestMessage}'
        },
        {
            $Type: 'UI.DataField',
            Value: status,
            Label: '{i18n>status}'
        }
    ]
);

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

