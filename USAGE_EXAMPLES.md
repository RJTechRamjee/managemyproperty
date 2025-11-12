# Example Usage Guide

## Overview
This guide provides practical examples of how to use the Property Management System's role-based features.

## Table of Contents
1. [Property Listing Flow](#property-listing-flow)
2. [Contact Request Flow](#contact-request-flow)
3. [Notification Examples](#notification-examples)
4. [Email Examples](#email-examples)
5. [API Usage Examples](#api-usage-examples)

## Property Listing Flow

### As a Seller: Create a Property Listing

**Step 1: Create User Profile**
```http
POST /odata/v4/AdminService/Users
Content-Type: application/json

{
  "firstName": "John",
  "lastName": "Doe",
  "emailId": "john.doe@example.com",
  "phoneNumber": "+1234567890",
  "role": "Seller",
  "isActive": true,
  "emailNotifications": true,
  "appNotifications": true
}
```

**Step 2: Create Property Listing**
```http
POST /odata/v4/CatalogService/Properties
Content-Type: application/json

{
  "title": "Beautiful 3 Bedroom Apartment",
  "description": "Spacious apartment with modern amenities",
  "type": "Apartment",
  "listingFor": "Sale",
  "purpose": "Living",
  "state": "Very Good",
  "isVacant": true,
  "availableFrom": "2024-01-01",
  "noOfRooms": 3,
  "propertySize": 120.50,
  "coldRent": 1500.00,
  "warmRent": 1800.00,
  "currency_code": "EUR",
  "hasBalcony": true,
  "contactPerson_ID": "{user-id-from-step1}"
}
```

**Response:**
```json
{
  "propertyId": "P0001",
  "ID": "{generated-uuid}",
  "title": "Beautiful 3 Bedroom Apartment",
  "listingStatus_code": "NEWLISTING",
  ...
}
```

## Contact Request Flow

### As a Buyer: Send Contact Request

**Step 1: Browse Properties**
```http
GET /odata/v4/CatalogService/Properties?$filter=listingFor eq 'Sale' and noOfRooms ge 3
```

**Step 2: Send Contact Request**
```http
POST /odata/v4/CatalogService/Properties({property-id})/SendRequest
Content-Type: application/json

{
  "requestMessage": "I'm interested in viewing this property. Is it still available?"
}
```

**What Happens:**
1. Contact request is created with status "Pending"
2. Notification is automatically sent to property owner
3. Email log is created (if email notifications enabled)
4. Response message confirms request was logged

### As a Seller: Respond to Contact Request

**Step 1: View Contact Requests**
```http
GET /odata/v4/CatalogService/ContactRequests?$expand=property,requester&$filter=property/contactPerson_ID eq '{my-user-id}'
```

**Step 2: Respond to Request**
```http
POST /odata/v4/CatalogService/ContactRequests({request-id})/RespondToRequest
Content-Type: application/json

{
  "responseMessage": "Yes, the property is still available. Would you like to schedule a viewing this weekend?"
}
```

**What Happens:**
1. Contact request status updated to "Responded"
2. Notification sent to requester
3. Response message added to conversation thread

**Step 3: Close Request (when done)**
```http
POST /odata/v4/CatalogService/ContactRequests({request-id})/CloseRequest
```

## Notification Examples

### View My Notifications

**Get All Notifications:**
```http
GET /odata/v4/CatalogService/Notifications?$filter=recipient_ID eq '{my-user-id}'&$orderby=createdAt desc
```

**Response:**
```json
{
  "value": [
    {
      "ID": "{notification-id}",
      "notificationType": "Contact Request Received",
      "title": "New Contact Request",
      "message": "You have received a new contact request for property P0001",
      "isRead": false,
      "createdAt": "2024-11-12T10:30:00Z",
      "relatedEntity": "ContactRequests",
      "relatedEntityId": "{contact-request-id}"
    }
  ]
}
```

### Mark Notification as Read

```http
PATCH /odata/v4/CatalogService/Notifications({notification-id})
Content-Type: application/json

{
  "isRead": true
}
```

### Get Unread Notification Count

```http
GET /odata/v4/CatalogService/Notifications/$count?$filter=recipient_ID eq '{my-user-id}' and isRead eq false
```

## Email Examples

### As an Agent: Send Email to Interested Buyer

```http
POST /odata/v4/CatalogService/SendEmail
Content-Type: application/json

{
  "params": {
    "recipientId": "{buyer-user-id}",
    "subject": "Property Viewing Scheduled - 3 Bedroom Apartment",
    "body": "Dear Buyer,\n\nYour property viewing has been scheduled for:\n\nDate: Saturday, November 16, 2024\nTime: 2:00 PM\nAddress: 123 Main Street, City\n\nPlease bring a valid ID and arrive 5 minutes early.\n\nBest regards,\nYour Real Estate Agent"
  }
}
```

**What Happens:**
1. Email log entry created
2. Email marked as "Sent"
3. Timestamp recorded
4. Email sent to recipient (if email service configured)

### View Email History

**Get All Emails I Sent:**
```http
GET /odata/v4/CatalogService/EmailLogs?$filter=sender_ID eq '{my-user-id}'&$orderby=sentAt desc
```

**Get All Emails I Received:**
```http
GET /odata/v4/CatalogService/EmailLogs?$filter=recipient_ID eq '{my-user-id}'&$orderby=sentAt desc
```

## API Usage Examples

### Property Management

#### Update Property Status
```http
POST /odata/v4/CatalogService/Properties({property-id})/SetToStatus
Content-Type: application/json

{
  "newStatusCode": "UNDERCONTRACT"
}
```

#### Filter Properties by Multiple Criteria
```http
GET /odata/v4/CatalogService/Properties?$filter=
  listingFor eq 'Rent' and 
  noOfRooms ge 2 and 
  coldRent le 1500 and 
  hasBalcony eq true and
  city eq 'Berlin'
&$orderby=coldRent asc
```

### User Management

#### Update User Notification Preferences
```http
PATCH /odata/v4/AdminService/Users({user-id})
Content-Type: application/json

{
  "emailNotifications": false,
  "appNotifications": true
}
```

#### Switch User Role
```http
PATCH /odata/v4/AdminService/Users({user-id})
Content-Type: application/json

{
  "role": "Agent"
}
```

### Advanced Queries

#### Get Properties with Contact Requests
```http
GET /odata/v4/CatalogService/Properties?$expand=contactRequests($expand=requester)&$filter=contactRequests/any()
```

#### Get Contact Requests with Messages
```http
GET /odata/v4/CatalogService/ContactRequests?$expand=property,requester,messages($expand=sender)
```

#### Get Property with All Details
```http
GET /odata/v4/CatalogService/Properties({property-id})?$expand=
  contactPerson,
  address,
  nearByAmenities,
  contactRequests($expand=requester,messages)
```

## Real-World Scenario Examples

### Scenario 1: Complete Property Sale Journey

**Day 1 - Seller Lists Property:**
```http
POST /odata/v4/CatalogService/Properties
{
  "title": "Modern Villa with Pool",
  "type": "House",
  "listingFor": "Sale",
  "coldRent": 450000,
  ...
}
```

**Day 2 - Buyer Shows Interest:**
```http
POST /odata/v4/CatalogService/Properties({property-id})/SendRequest
{
  "requestMessage": "Interested in viewing this villa. Available this weekend?"
}
```
→ Seller receives notification

**Day 3 - Seller Responds:**
```http
POST /odata/v4/CatalogService/ContactRequests({request-id})/RespondToRequest
{
  "responseMessage": "Sunday at 3 PM works. See you then!"
}
```
→ Buyer receives notification

**Day 4 - Agent Sends Viewing Confirmation:**
```http
POST /odata/v4/CatalogService/SendEmail
{
  "params": {
    "recipientId": "{buyer-id}",
    "subject": "Viewing Confirmation",
    "body": "Your viewing is confirmed for Sunday at 3 PM..."
  }
}
```

**Day 10 - Seller Updates Status:**
```http
POST /odata/v4/CatalogService/Properties({property-id})/SetToStatus
{
  "newStatusCode": "SOLD"
}
```

### Scenario 2: Tenant Application Process

**Step 1 - Tenant Searches for Rentals:**
```http
GET /odata/v4/CatalogService/Properties?$filter=
  listingFor eq 'Rent' and 
  purpose eq 'Living' and
  warmRent le 1200 and
  arePetsAllowed eq true
```

**Step 2 - Tenant Applies:**
```http
POST /odata/v4/CatalogService/Properties({property-id})/SendRequest
{
  "requestMessage": "I would like to apply for this apartment. I have excellent references and a stable income."
}
```

**Step 3 - Owner Reviews Application:**
```http
GET /odata/v4/CatalogService/ContactRequests?$expand=requester&$filter=property_ID eq '{property-id}'
```

**Step 4 - Owner Sends Notification:**
```http
POST /odata/v4/CatalogService/SendNotification
{
  "params": {
    "recipientId": "{tenant-id}",
    "title": "Application Approved",
    "message": "Your rental application has been approved! Please check your email for next steps."
  }
}
```

## Testing Tips

### Using Postman or Similar Tools

1. **Set Base URL:** `http://localhost:4004`
2. **Add Authentication:** Basic Auth (if configured) or leave default for mocked auth
3. **Set Headers:**
   ```
   Content-Type: application/json
   Accept: application/json
   ```

### Quick Test Commands (using curl)

**Health Check:**
```bash
curl http://localhost:4004/
```

**Get All Properties:**
```bash
curl http://localhost:4004/odata/v4/CatalogService/Properties
```

**Create User:**
```bash
curl -X POST http://localhost:4004/odata/v4/AdminService/Users \
  -H "Content-Type: application/json" \
  -d '{
    "firstName": "Test",
    "lastName": "User",
    "emailId": "test@example.com",
    "role": "Buyer"
  }'
```

## Troubleshooting Common Issues

### Issue: Cannot Send Contact Request
**Solution:** Ensure the property exists and the requester_ID is valid

### Issue: Notifications Not Appearing
**Solution:** Check that user's `appNotifications` preference is true

### Issue: Email Not Sent
**Solution:** Verify email service is configured and recipient email is valid

### Issue: Cannot Update Property
**Solution:** Verify user owns the property or is assigned agent

## Additional Resources

- [Business Requirements Document](./BUSINESS_REQUIREMENTS.md)
- [Implementation Guide](./IMPLEMENTATION_GUIDE.md)
- [Feature Access Matrix](./FEATURE_MATRIX.md)
- OData V4 Documentation: https://www.odata.org/documentation/
