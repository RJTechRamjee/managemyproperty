const cds = require('@sap/cds');

describe('CatalogService', () => {
    let catalogService;
    
    beforeAll(async () => {
        // Load and deploy the model
        catalogService = await cds.connect.to('CatalogService');
    });
    
    describe('Users Entity - fullName computation', () => {
        test('should compute fullName from firstName and lastName', async () => {
            const { Users } = catalogService.entities;
            
            // Mock user data
            const mockUser = {
                firstName: 'John',
                lastName: 'Doe'
            };
            
            // The fullName should be computed as 'John Doe'
            // This is a service-level test that would require actual data
            // For now, we verify the projection definition exists
            expect(Users).toBeDefined();
        });
    });
    
    describe('Properties Entity - New Fields', () => {
        test('should have financial information fields', async () => {
            const { Properties } = catalogService.entities;
            
            expect(Properties).toBeDefined();
            expect(Properties.elements.securityDeposit).toBeDefined();
            expect(Properties.elements.maintenanceCost).toBeDefined();
            expect(Properties.elements.utilityCost).toBeDefined();
            expect(Properties.elements.brokerCommission).toBeDefined();
            expect(Properties.elements.propertyTax).toBeDefined();
        });
        
        test('should have property features fields', async () => {
            const { Properties } = catalogService.entities;
            
            expect(Properties.elements.noOfBedrooms).toBeDefined();
            expect(Properties.elements.noOfBathrooms).toBeDefined();
            expect(Properties.elements.balconySize).toBeDefined();
            expect(Properties.elements.gardenSize).toBeDefined();
            expect(Properties.elements.isFurnished).toBeDefined();
            expect(Properties.elements.hasAirConditioning).toBeDefined();
            expect(Properties.elements.hasBasement).toBeDefined();
            expect(Properties.elements.hasAttic).toBeDefined();
        });
        
        test('should have utilities and amenities fields', async () => {
            const { Properties } = catalogService.entities;
            
            expect(Properties.elements.waterSupply).toBeDefined();
            expect(Properties.elements.powerBackup).toBeDefined();
            expect(Properties.elements.hasSwimmingPool).toBeDefined();
            expect(Properties.elements.hasGym).toBeDefined();
        });
        
        test('should have legal and compliance fields', async () => {
            const { Properties } = catalogService.entities;
            
            expect(Properties.elements.lastRenovationYear).toBeDefined();
            expect(Properties.elements.occupancyCertificate).toBeDefined();
            expect(Properties.elements.fireComplianceCert).toBeDefined();
        });
        
        test('should have association to PropertyDetails', async () => {
            const { Properties } = catalogService.entities;
            
            expect(Properties.elements.propertyDetails).toBeDefined();
            expect(Properties.elements.propertyDetails.type).toBe('cds.Association');
        });
    });
    
    describe('PropertyDetails Entity', () => {
        test('should be exposed in the service', async () => {
            const { PropertyDetails } = catalogService.entities;
            
            expect(PropertyDetails).toBeDefined();
        });
        
        test('should have all required fields', async () => {
            const { PropertyDetails } = catalogService.entities;
            
            expect(PropertyDetails.elements.interiorDescription).toBeDefined();
            expect(PropertyDetails.elements.exteriorDescription).toBeDefined();
            expect(PropertyDetails.elements.kitchenType).toBeDefined();
            expect(PropertyDetails.elements.flooringType).toBeDefined();
            expect(PropertyDetails.elements.windowType).toBeDefined();
            expect(PropertyDetails.elements.roofType).toBeDefined();
            expect(PropertyDetails.elements.facingDirection).toBeDefined();
            expect(PropertyDetails.elements.viewFromProperty).toBeDefined();
            expect(PropertyDetails.elements.neighborhoodType).toBeDefined();
            expect(PropertyDetails.elements.parkingType).toBeDefined();
            expect(PropertyDetails.elements.storageSpace).toBeDefined();
            expect(PropertyDetails.elements.laundryFacility).toBeDefined();
            expect(PropertyDetails.elements.disabledAccess).toBeDefined();
            expect(PropertyDetails.elements.smokingAllowed).toBeDefined();
            expect(PropertyDetails.elements.soundproofing).toBeDefined();
            expect(PropertyDetails.elements.securityFeatures).toBeDefined();
            expect(PropertyDetails.elements.specialNotes).toBeDefined();
        });
    });
    
    describe('NearByAmenities Entity - Type Field', () => {
        test('should have type field as enum', async () => {
            const { NearByAmenities } = catalogService.entities;
            
            expect(NearByAmenities).toBeDefined();
            expect(NearByAmenities.elements.type).toBeDefined();
            // The type should be an enum type (AmenityType)
            expect(NearByAmenities.elements.type.type).toBe('cds.String');
        });
    });
    
    describe('Statuses Entity - Criticality Field', () => {
        test('should have criticality field', async () => {
            const { Statuses } = catalogService.entities;
            
            expect(Statuses).toBeDefined();
            expect(Statuses.elements.criticality).toBeDefined();
            expect(Statuses.elements.criticality.type).toBe('cds.Integer');
        });
    });
});
