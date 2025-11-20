using ContactRequestService as service from '../../srv/ContactRequestService';

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
            },
            {
                $Type: 'UI.DataField',
                Value: status,
            },
            {
                $Type: 'UI.DataField',
                Value: emailSent,
            },
            {
                $Type: 'UI.DataField',
                Value: notificationSent,
            }
        ],
    },
    UI.Identification            : [
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Respond to Request',
            Action: 'CatalogService.RespondToRequest'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Close Request',
            Action: 'CatalogService.CloseRequest'
        }
    ],
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
            $Type : 'UI.DataFieldForAction',
            Label : 'Respond to Request',
            Action: 'CatalogService.RespondToRequest'
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Close Request',
            Action: 'CatalogService.CloseRequest'
        },
        {
            $Type: 'UI.DataField',
            Value: requester.fullName,
        },
        {
            $Type: 'UI.DataField',
            Value: requester.ShortIntro,
        },
        {
            $Type: 'UI.DataField',
            Value: requestMessage,
        },
        {
            $Type: 'UI.DataField',
            Value: status,
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
    requester @(
        Common.ValueList: {
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
        },
        Core.Computed: true,
        Core.Immutable: true,
        UI.Hidden: true
    )
};

// Control action visibility based on property ownership
annotate service.ContactRequests actions {
    // RespondToRequest should only be visible when user IS the property owner
    RespondToRequest @(
        Core.OperationAvailable: {$edmJson: {$Path: 'in/isPropertyOwner'}}
    );
    // CloseRequest should only be visible when user IS the property owner
    CloseRequest @(
        Core.OperationAvailable: {$edmJson: {$Path: 'in/isPropertyOwner'}}
    );
};

// Control Edit/Update capability for contact requests based on property ownership
annotate service.ContactRequests with @(
    Capabilities.UpdateRestrictions: {
        Updatable: {$edmJson: {$Path: 'isPropertyOwner'}}
    },
    Capabilities.DeleteRestrictions: {
        Deletable: {$edmJson: {$Path: 'isPropertyOwner'}}
    }
);

// Add dropdown annotation for ContactRequests enum field
annotate service.ContactRequests with {
    status @(
        Common.ValueListWithFixedValues: true
    );
};

