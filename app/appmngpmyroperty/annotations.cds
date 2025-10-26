using CatalogService as service from '../../srv/catalog_service';
annotate service.Properties with @(

    UI.SelectionFields :[
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
        
    
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'popertyId',
                Value : popertyId,
            },
            {
                $Type : 'UI.DataField',
                Label : 'title',
                Value : title,
            },
            {
                $Type : 'UI.DataField',
                Label : 'description',
                Value : description,
            },
            {
                $Type : 'UI.DataField',
                Label : 'type',
                Value : type,
            },
            {
                $Type : 'UI.DataField',
                Label : 'listingFor',
                Value : listingFor,
            },
            {
                $Type : 'UI.DataField',
                Label : 'purpose',
                Value : purpose,
            },
            {
                $Type : 'UI.DataField',
                Label : 'state',
                Value : state,
            },
            {
                $Type : 'UI.DataField',
                Label : 'isVacant',
                Value : isVacant,
            },
            {
                $Type : 'UI.DataField',
                Label : 'availableFrom',
                Value : availableFrom,
            },
            {
                $Type : 'UI.DataField',
                Label : 'noOfRooms',
                Value : noOfRooms,
            },
            {
                $Type : 'UI.DataField',
                Label : 'propertySize',
                Value : propertySize,
            },
            {
                $Type : 'UI.DataField',
                Label : 'propertySizeUnit',
                Value : propertySizeUnit,
            },
            {
                $Type : 'UI.DataField',
                Label : 'coldRent',
                Value : coldRent,
            },
            {
                $Type : 'UI.DataField',
                Label : 'warmRent',
                Value : warmRent,
            },
            {
                $Type : 'UI.DataField',
                Label : 'currency_code',
                Value : currency_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'hasBalcony',
                Value : hasBalcony,
            },
            {
                $Type : 'UI.DataField',
                Label : 'hasdGarten',
                Value : hasdGarten,
            },
            {
                $Type : 'UI.DataField',
                Label : 'noOfParkingSpace',
                Value : noOfParkingSpace,
            },
            {
                $Type : 'UI.DataField',
                Label : 'hasGarageParking',
                Value : hasGarageParking,
            },
            {
                $Type : 'UI.DataField',
                Label : 'floorNo',
                Value : floorNo,
            },
            {
                $Type : 'UI.DataField',
                Label : 'totalFloors',
                Value : totalFloors,
            },
            {
                $Type : 'UI.DataField',
                Label : 'yearOfConstruction',
                Value : yearOfConstruction,
            },
            {
                $Type : 'UI.DataField',
                Label : 'hasPassengerLift',
                Value : hasPassengerLift,
            },
            {
                $Type : 'UI.DataField',
                Label : 'arePetsAllowed',
                Value : arePetsAllowed,
            },
            {
                $Type : 'UI.DataField',
                Label : 'heatingType',
                Value : heatingType,
            },
            {
                $Type : 'UI.DataField',
                Label : 'energyEffieicenyClass',
                Value : energyEffieicenyClass,
            },
            {
                $Type : 'UI.DataField',
                Label : 'minmumInternetSpeed',
                Value : minmumInternetSpeed,
            },
            {
                $Type : 'UI.DataField',
                Label : 'listingStatus',
                Value : listingStatus,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'popertyId',
            Value : popertyId,
        },
        {
            $Type : 'UI.DataField',
            Label : 'title',
            Value : title,
        },
        {
            $Type : 'UI.DataField',
            Label : 'description',
            Value : description,
        },
        {
            $Type : 'UI.DataField',
            Label : 'type',
            Value : type,
        },
        {
            $Type : 'UI.DataField',
            Label : 'listingFor',
            Value : listingFor,
        },
    ],
);

annotate service.Properties with {
    contactPerson @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Users',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : contactPerson_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'userId',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'firstName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'lastName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'emailId',
            },
        ],
    }
};

annotate service.Properties with {
    address @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Addresses',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : address_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'addressId',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'houseNo',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'streetName',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'city',
            },
        ],
    }
};

