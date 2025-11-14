const { PropertyManager } = require('../srv/PropertyManager');

describe('PropertyManager', () => {
    let propertyManager;
    let mockSrv;
    let mockEntities;
    
    beforeEach(() => {
        // Mock entities
        mockEntities = {
            Properties: 'Properties',
            ContactRequests: 'ContactRequests',
            Notifications: 'Notifications',
            EmailLogs: 'EmailLogs'
        };
        
        // Mock service
        mockSrv = {
            entities: mockEntities,
            before: jest.fn(),
            after: jest.fn(),
            on: jest.fn()
        };
        
        propertyManager = new PropertyManager(mockSrv);
    });
    
    describe('Constructor', () => {
        test('should initialize with service and entities', () => {
            expect(propertyManager.srv).toBe(mockSrv);
            expect(propertyManager.entities).toBe(mockEntities);
        });
    });
    
    describe('checkAuthentication', () => {
        test('should return user ID for authenticated user', () => {
            const mockRequest = {
                user: { id: 'user-123' },
                reject: jest.fn()
            };
            
            const userId = propertyManager.checkAuthentication(mockRequest);
            
            expect(userId).toBe('user-123');
            expect(mockRequest.reject).not.toHaveBeenCalled();
        });
        
        test('should reject anonymous users', () => {
            const mockRequest = {
                user: { id: 'anonymous' },
                reject: jest.fn()
            };
            
            const userId = propertyManager.checkAuthentication(mockRequest);
            
            expect(userId).toBeNull();
            expect(mockRequest.reject).toHaveBeenCalledWith(401, 'User must be authenticated');
        });
        
        test('should reject users without ID', () => {
            const mockRequest = {
                user: {},
                reject: jest.fn()
            };
            
            const userId = propertyManager.checkAuthentication(mockRequest);
            
            expect(userId).toBeNull();
            expect(mockRequest.reject).toHaveBeenCalled();
        });
        
        test('should accept custom error message', () => {
            const mockRequest = {
                user: { id: 'anonymous' },
                reject: jest.fn()
            };
            
            propertyManager.checkAuthentication(mockRequest, 'Custom error');
            
            expect(mockRequest.reject).toHaveBeenCalledWith(401, 'Custom error');
        });
    });
    
    describe('sanitizeInput', () => {
        test('should remove script tags', () => {
            const input = 'Hello <script>alert("xss")</script> World';
            const result = propertyManager.sanitizeInput(input);
            expect(result).toBe('Hello  World');
        });
        
        test('should trim whitespace', () => {
            const input = '  Hello World  ';
            const result = propertyManager.sanitizeInput(input);
            expect(result).toBe('Hello World');
        });
        
        test('should handle non-string input', () => {
            expect(propertyManager.sanitizeInput(123)).toBe(123);
            expect(propertyManager.sanitizeInput(null)).toBeNull();
            expect(propertyManager.sanitizeInput(undefined)).toBeUndefined();
        });
        
        test('should remove multiple script tags', () => {
            const input = '<script>bad()</script>Good<script>bad2()</script>';
            const result = propertyManager.sanitizeInput(input);
            expect(result).toBe('Good');
        });
    });
    
    describe('validateProperty', () => {
        test('should validate valid property data', () => {
            const validProperty = {
                title: 'Test Property',
                type: 'Apartment',
                listingFor: 'Rent',
                coldRent: 1500,
                warmRent: 1700,
                noOfRooms: 3
            };
            
            expect(() => propertyManager.validateProperty(validProperty)).not.toThrow();
            expect(propertyManager.validateProperty(validProperty)).toBe(true);
        });
        
        test('should throw error for null property data', () => {
            expect(() => propertyManager.validateProperty(null))
                .toThrow('Property data is required');
        });
        
        test('should throw error for missing title', () => {
            const invalidProperty = {
                type: 'Apartment',
                listingFor: 'Rent'
            };
            
            expect(() => propertyManager.validateProperty(invalidProperty))
                .toThrow('title is required');
        });
        
        test('should throw error for missing type', () => {
            const invalidProperty = {
                title: 'Test Property',
                listingFor: 'Rent'
            };
            
            expect(() => propertyManager.validateProperty(invalidProperty))
                .toThrow('type is required');
        });
        
        test('should throw error for missing listingFor', () => {
            const invalidProperty = {
                title: 'Test Property',
                type: 'Apartment'
            };
            
            expect(() => propertyManager.validateProperty(invalidProperty))
                .toThrow('listingFor is required');
        });
        
        test('should throw error for negative cold rent', () => {
            const invalidProperty = {
                title: 'Test Property',
                type: 'Apartment',
                listingFor: 'Rent',
                coldRent: -100
            };
            
            expect(() => propertyManager.validateProperty(invalidProperty))
                .toThrow('Cold rent must be positive');
        });
        
        test('should throw error for zero cold rent', () => {
            const invalidProperty = {
                title: 'Test Property',
                type: 'Apartment',
                listingFor: 'Rent',
                coldRent: 0
            };
            
            expect(() => propertyManager.validateProperty(invalidProperty))
                .toThrow('Cold rent must be positive');
        });
        
        test('should throw error for negative warm rent', () => {
            const invalidProperty = {
                title: 'Test Property',
                type: 'Apartment',
                listingFor: 'Rent',
                warmRent: -100
            };
            
            expect(() => propertyManager.validateProperty(invalidProperty))
                .toThrow('Warm rent must be positive');
        });
        
        test('should throw error for negative number of rooms', () => {
            const invalidProperty = {
                title: 'Test Property',
                type: 'Apartment',
                listingFor: 'Rent',
                noOfRooms: -1
            };
            
            expect(() => propertyManager.validateProperty(invalidProperty))
                .toThrow('Number of rooms cannot be negative');
        });
    });
    
    describe('validateNearbyAmenities', () => {
        test('should validate valid amenities data', () => {
            const validAmenities = [
                { name: 'School', distance: 0.5 },
                { name: 'Park', distance: 0.2 },
                { name: 'Supermarket', distance: 1.0 }
            ];
            
            expect(() => propertyManager.validateNearbyAmenities(validAmenities)).not.toThrow();
            expect(propertyManager.validateNearbyAmenities(validAmenities)).toBe(true);
        });
        
        test('should throw error for non-array input', () => {
            expect(() => propertyManager.validateNearbyAmenities('not an array'))
                .toThrow('Amenities data must be an array');
        });
        
        test('should throw error for null input', () => {
            expect(() => propertyManager.validateNearbyAmenities(null))
                .toThrow('Amenities data must be an array');
        });
        
        test('should throw error for amenity without name', () => {
            const invalidAmenities = [
                { distance: 0.5 }
            ];
            
            expect(() => propertyManager.validateNearbyAmenities(invalidAmenities))
                .toThrow('Each amenity must have a valid name');
        });
        
        test('should throw error for amenity with non-string name', () => {
            const invalidAmenities = [
                { name: 123, distance: 0.5 }
            ];
            
            expect(() => propertyManager.validateNearbyAmenities(invalidAmenities))
                .toThrow('Each amenity must have a valid name');
        });
        
        test('should throw error for amenity with negative distance', () => {
            const invalidAmenities = [
                { name: 'School', distance: -1 }
            ];
            
            expect(() => propertyManager.validateNearbyAmenities(invalidAmenities))
                .toThrow('Amenity distance must be a non-negative number');
        });
        
        test('should throw error for amenity with invalid distance type', () => {
            const invalidAmenities = [
                { name: 'School', distance: 'far' }
            ];
            
            expect(() => propertyManager.validateNearbyAmenities(invalidAmenities))
                .toThrow('Amenity distance must be a non-negative number');
        });
        
        test('should allow amenities without distance', () => {
            const validAmenities = [
                { name: 'School' },
                { name: 'Park' }
            ];
            
            expect(() => propertyManager.validateNearbyAmenities(validAmenities)).not.toThrow();
        });
    });
    
    describe('getDynamicYears', () => {
        test('should return array of 31 years', () => {
            const years = propertyManager.getDynamicYears();
            expect(years).toHaveLength(31);
        });
        
        test('should include current year', () => {
            const currentYear = new Date().getFullYear();
            const years = propertyManager.getDynamicYears();
            const yearStrings = years.map(y => y.year);
            expect(yearStrings).toContain(String(currentYear));
        });
        
        test('should include years from 30 years ago', () => {
            const currentYear = new Date().getFullYear();
            const years = propertyManager.getDynamicYears();
            const yearStrings = years.map(y => y.year);
            expect(yearStrings).toContain(String(currentYear - 30));
        });
        
        test('should have years in ascending order', () => {
            const years = propertyManager.getDynamicYears();
            for (let i = 1; i < years.length; i++) {
                const prevYear = parseInt(years[i - 1].year);
                const currYear = parseInt(years[i].year);
                expect(currYear).toBe(prevYear + 1);
            }
        });
    });
    
    describe('getNextPropertyId', () => {
        test('should return P0001 when no properties exist', async () => {
            // Mock SELECT to return no properties
            global.SELECT = {
                one: {
                    from: jest.fn().mockReturnThis(),
                    orderBy: jest.fn().mockReturnThis(),
                    columns: jest.fn().mockResolvedValue(null)
                }
            };
            
            const nextId = await propertyManager.getNextPropertyId();
            expect(nextId).toBe('P0001');
        });
        
        test('should increment from existing max property ID', async () => {
            // Mock SELECT to return property with ID P0042
            global.SELECT = {
                one: {
                    from: jest.fn().mockReturnThis(),
                    orderBy: jest.fn().mockReturnThis(),
                    columns: jest.fn().mockResolvedValue({ propertyId: 'P0042' })
                }
            };
            
            const nextId = await propertyManager.getNextPropertyId();
            expect(nextId).toBe('P0043');
        });
        
        test('should pad ID with zeros', async () => {
            // Mock SELECT to return property with ID P0009
            global.SELECT = {
                one: {
                    from: jest.fn().mockReturnThis(),
                    orderBy: jest.fn().mockReturnThis(),
                    columns: jest.fn().mockResolvedValue({ propertyId: 'P0009' })
                }
            };
            
            const nextId = await propertyManager.getNextPropertyId();
            expect(nextId).toBe('P0010');
        });
    });
});
