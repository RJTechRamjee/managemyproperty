using CatalogService as service from '../../srv/catalog_service';

annotate service.ContactRequests with @(
    UI.FieldGroup #GeneratedGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: property_ID,
            },
            {
                $Type: 'UI.DataField',
                Value: requester_ID,
            },
            {
                $Type: 'UI.DataField',
                Value: requester.firstName,
            },
            {
                $Type: 'UI.DataField',
                Value: requester.lastName,
            },
            {
                $Type: 'UI.DataField',
                Value: requester.ShortIntro,
            },
               {
            $Type: 'UI.DataField',
            Value: requestMessage,
        }
        ],
    },
    UI.Facets                    : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'General',
            Label : '{i18n>GeneralInfo}',
            Target: '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Messages',
            Label : '{i18n>Messages}',
            Target: 'messages/@UI.LineItem',
        },

    ],
    UI.LineItem                  : [
        {
            $Type: 'UI.DataField',
            Value: property_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: requester_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: requester.firstName,
        },
        {
            $Type: 'UI.DataField',
            Value: requester.lastName,
        },
        {
            $Type: 'UI.DataField',
            Value: requester.ShortIntro,
        },
                {
            $Type: 'UI.DataField',
            Value: requestMessage,
        }
    ],
);


annotate service.ConactReqMessages with @(UI.LineItem: [
    {
        $Type: 'UI.DataField',
        Value: sender_ID,
    },
    {
        $Type: 'UI.DataField',
        Value: message,
    },
    {
        $Type: 'UI.DataField',
        Value: modifiedAt,
    }
]);


annotate service.ContactRequests with {
    property @Common.ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Properties',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: property_ID,
                ValueListProperty: 'ID',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'popertyId',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'title',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'description',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'type',
            },
        ],
    }
};

annotate service.ContactRequests with {
    requester @Common.ValueList: {
        $Type         : 'Common.ValueListType',
        CollectionPath: 'Users',
        Parameters    : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: requester_ID,
                ValueListProperty: 'ID',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'userId',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'firstName',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'lastName',
            },
            {
                $Type            : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty: 'emailId',
            },
        ],
    }
};
