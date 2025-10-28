using CatalogService as service from '../../srv/catalog_service';

annotate service.Properties with @(

    UI.SelectionFields        : [
        listingStatus,
        type,
        listingFor,
        purpose,
        state,
        isVacant,
        propertySize,
        coldRent,
        warmRent
    ],

    UI.LineItem               : [
        {
            $Type: 'UI.DataField',
            Value: popertyId,
        },
        {
            $Type: 'UI.DataField',
            Value: title,
        },
        {
            $Type: 'UI.DataField',
            Value: description,
        },
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
            $Type: 'UI.DataField',
            Value: yearOfConstruction,
        },
    ],

    UI.HeaderInfo             : {
        TypeName      : 'Property',
        TypeNamePlural: 'Properties',
        Title         : {
            Label: 'Property ID',
            Value: popertyId
        },
        Description   : {
            Label: 'Titie',
            Value: title
        }
    },
 



    UI.Facets                 : [{
        $Type : 'UI.CollectionFacet',
        Label : 'Purchase Order Details',
        Facets: [
            {   
            $Type : 'UI.ReferenceFacet',
            Label : 'General Info',
            Target: '@UI.FieldGroup#GeneralInfo'
        },
          {   
            $Type : 'UI.ReferenceFacet',
            Label : 'General Info',
            Target: '@UI.FieldGroup#GeneralInfo1'
        },
        ]
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
                $Type: 'UI.DataField',
                Value: yearOfConstruction
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

// annotate service.Properties with {
//     contactPerson @Common.ValueList : {
//         $Type : 'Common.ValueListType',
//         CollectionPath : 'Users',
//         Parameters : [
//             {
//                 $Type : 'Common.ValueListParameterInOut',
//                 LocalDataProperty : contactPerson_ID,
//                 ValueListProperty : 'ID',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'userId',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'firstName',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'lastName',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'emailId',
//             },
//         ],
//     }
// };

// annotate service.Properties with {
//     address @Common.ValueList : {
//         $Type : 'Common.ValueListType',
//         CollectionPath : 'Addresses',
//         Parameters : [
//             {
//                 $Type : 'Common.ValueListParameterInOut',
//                 LocalDataProperty : address_ID,
//                 ValueListProperty : 'ID',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'addressId',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'houseNo',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'streetName',
//             },
//             {
//                 $Type : 'Common.ValueListParameterDisplayOnly',
//                 ValueListProperty : 'city',
//             },
//         ],
//     }
// };
