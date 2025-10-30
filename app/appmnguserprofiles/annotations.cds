using AdminService as service from '../../srv/catalog_service';
annotate service.Users with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : userId,
        },
        {
            $Type : 'UI.DataField',
            Value : firstName,
        },
        {
            $Type : 'UI.DataField',
            Value : lastName,
        },
        {
            $Type : 'UI.DataField',
            Value : emailId,
        },
        {
            $Type : 'UI.DataField',
            Value : ShortIntro,
        },
    ]
);

