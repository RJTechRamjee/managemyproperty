using UserProfileService as service from '../../srv/UserProfileService';
annotate service.Users with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : userId,
        },
        {
            $Type : 'UI.DataField',
            Value : fullName,
            Label : '{i18n>fullName}'
        },
        {
            $Type : 'UI.DataField',
            Value : emailId,
        },
        {
            $Type : 'UI.DataField',
            Value : ShortIntro,
        },
        {
            $Type : 'UI.DataField',
            Value : role,
        },
    ]
);

// Add dropdown annotation for Users enum field
annotate service.Users with {
    role @(
        Common.ValueListWithFixedValues: true
    );
};

