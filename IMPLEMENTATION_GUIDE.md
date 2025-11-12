# Property Management System - Implementation Guide

## Overview
This guide explains the technical implementation of the role-based property management system with notification and email features.

## Database Schema Changes

### User Role Management

#### UserRole Enumeration
```cds
type UserRole : String(20) enum {
  Buyer;
  Seller;
  Owner;
  Tenant;
  Agent;
}
```

**Usage**: Defines the five main user roles in the system.

#### Enhanced Users Entity
The `Users` entity has been extended with the following fields:

- `role` (UserRole): The primary role of the user
- `phoneNumber` (String): Contact phone number
- `isActive` (Boolean): Whether the user account is active
- `emailNotifications` (Boolean): User preference for email notifications
- `appNotifications` (Boolean): User preference for in-app notifications

### Notification System

#### NotificationType Enumeration
```cds
type NotificationType : String(30) enum {
  ContactRequestReceived;
  ContactRequestResponse;
  PropertyStatusChanged;
  NewPropertyMatch;
  PropertyPriceChanged;
  ViewingScheduled;
}
```

#### Notifications Entity
Stores all in-app notifications sent to users:

- `recipient` (Association to Users): Who receives the notification
- `notificationType` (NotificationType): Type of notification
- `title` (String): Short notification title
- `message` (String): Detailed notification message
- `isRead` (Boolean): Whether notification has been read
- `relatedEntity` (String): Entity type the notification relates to
- `relatedEntityId` (String): ID of the related entity

### Email System

#### EmailType Enumeration
```cds
type EmailType : String(30) enum {
  WelcomeEmail;
  ContactRequestConfirm;
  ContactRequestResponse;
  PropertyViewingConfirm;
  DocumentSharing;
}
```

#### EmailLogs Entity
Tracks all emails sent through the system:

- `recipient` (Association to Users): Email recipient
- `sender` (Association to Users): Email sender
- `emailType` (EmailType): Type of email
- `subject` (String): Email subject line
- `body` (String): Email body content
- `sentAt` (DateTime): When the email was sent
- `deliveryStatus` (String): Delivery status (Sent, Delivered, Failed)
- `relatedEntity` (String): Related entity type
- `relatedEntityId` (String): Related entity ID

### Contact Request Enhancements

#### RequestStatus Enumeration
```cds
type RequestStatus : String(20) enum {
  Pending;
  Responded;
  Closed;
}
```

#### Enhanced ContactRequests Entity
Added fields:
- `status` (RequestStatus): Current status of the request
- `emailSent` (Boolean): Whether email notification was sent
- `notificationSent` (Boolean): Whether in-app notification was sent

## Service Layer Implementation

### New Service Endpoints

#### 1. Contact Request Actions

**RespondToRequest**
- Bound action on ContactRequests entity
- Updates request status to 'Responded'
- Sends notification to requester
- Parameters: `responseMessage` (String)

```javascript
// Usage in bound action
ContactRequests/{ID}/RespondToRequest
Body: { "responseMessage": "Thank you for your interest..." }
```

**CloseRequest**
- Bound action on ContactRequests entity
- Updates request status to 'Closed'
- Parameters: None

#### 2. Notification Management

**SendNotification**
- Unbound action to send notifications
- Parameters:
  - `recipientId` (String): User ID of recipient
  - `title` (String): Notification title
  - `message` (String): Notification message

```javascript
// Usage
POST /CatalogService/SendNotification
Body: {
  "params": {
    "recipientId": "user-uuid",
    "title": "New Property Available",
    "message": "A new property matching your criteria is now available."
  }
}
```

#### 3. Email Management

**SendEmail**
- Unbound action to send emails
- Parameters:
  - `recipientId` (String): User ID of recipient
  - `subject` (String): Email subject
  - `body` (String): Email body

```javascript
// Usage
POST /CatalogService/SendEmail
Body: {
  "params": {
    "recipientId": "user-uuid",
    "subject": "Property Viewing Confirmation",
    "body": "Your viewing has been scheduled for..."
  }
}
```

### Automated Notifications

The system automatically creates notifications in the following scenarios:

1. **New Contact Request**: When a user sends a contact request for a property, the property owner receives a notification
2. **Contact Request Response**: When an owner responds to a request, the requester receives a notification

## Role-Based Access Control Implementation

### Function Restrictions

The system implements role-based restrictions through service layer validation:

#### Property Management
- **Create/Edit Properties**: Only allowed for Seller, Owner, or Agent roles
- **View Properties**: Allowed for all roles
- **Delete Properties**: Only property owner or assigned agent

#### Contact Requests
- **Send Request**: All roles can send contact requests
- **View Property Requests**: Only property owner/agent can view requests for their properties
- **Respond to Requests**: Only property owner/agent

#### Notifications
- **Send Notifications**: Only Seller, Owner, Agent roles
- **Receive Notifications**: All roles
- **View Notifications**: Users can only view their own notifications

#### Email
- **Send Emails**: Only Seller, Owner, Agent roles to requesters
- **Agents**: Can send emails to all parties for managed properties

### Implementation Pattern

```javascript
// Example authorization check
this.before('CREATE', Properties, async (req) => {
    const userRole = req.user.role;
    
    if (!['Seller', 'Owner', 'Agent'].includes(userRole)) {
        req.error(403, 'Unauthorized: Only Sellers, Owners, and Agents can create properties');
    }
});

// Example property ownership check
this.before('UPDATE', Properties, async (req) => {
    const propertyId = req.data.ID;
    const property = await SELECT.one.from(Properties).where({ ID: propertyId });
    
    if (property.contactPerson_ID !== req.user.id && req.user.role !== 'Agent') {
        req.error(403, 'Unauthorized: You can only edit your own properties');
    }
});
```

## API Examples

### Creating a Notification When Property Status Changes

```javascript
this.after('UPDATE', Properties, async (data, req) => {
    if (data.listingStatus_code !== req.data.listingStatus_code) {
        // Property status changed, notify interested parties
        const requests = await SELECT.from(ContactRequests)
            .where({ property_ID: data.ID });
        
        for (const request of requests) {
            await createNotification(req.tx, {
                recipientId: request.requester_ID,
                notificationType: 'Property Status Changed',
                title: 'Property Status Update',
                message: `Property ${data.propertyId} status changed to ${data.listingStatus_code}`,
                relatedEntity: 'Properties',
                relatedEntityId: data.ID
            });
        }
    }
});
```

### Sending Welcome Email to New User

```javascript
this.after('CREATE', Users, async (data, req) => {
    await createEmailLog(req.tx, {
        recipientId: data.ID,
        senderId: 'system',
        emailType: 'Welcome Email',
        subject: 'Welcome to Property Management System',
        body: `Dear ${data.firstName},\n\nWelcome to our property management system...`,
        relatedEntity: 'Users',
        relatedEntityId: data.ID
    });
});
```

## Testing the Implementation

### Test Scenarios

1. **Buyer sends contact request**
   - Create a contact request for a property
   - Verify notification is created for property owner
   - Check ContactRequest status is 'Pending'

2. **Owner responds to contact request**
   - Call RespondToRequest action
   - Verify status changes to 'Responded'
   - Check notification is created for requester

3. **Agent sends email to buyer**
   - Call SendEmail action as Agent role
   - Verify email log is created
   - Check delivery status

4. **Notification preferences**
   - User disables email notifications
   - Send notification
   - Verify only in-app notification is created

## Data Model Relationships

```
Users
  ├── role (UserRole)
  ├── emailNotifications (Boolean)
  └── appNotifications (Boolean)

Properties
  ├── contactPerson → Users
  └── contactRequests → ContactRequests[]

ContactRequests
  ├── property → Properties
  ├── requester → Users
  ├── status (RequestStatus)
  └── messages → ConactReqMessages[]

Notifications
  ├── recipient → Users
  ├── notificationType (NotificationType)
  └── isRead (Boolean)

EmailLogs
  ├── recipient → Users
  ├── sender → Users
  └── emailType (EmailType)
```

## Future Enhancements

### Planned Features

1. **Real-time notifications**: Implement WebSocket for instant notifications
2. **Email templates**: Create reusable email templates
3. **Notification aggregation**: Group similar notifications
4. **Email scheduling**: Schedule emails to be sent at specific times
5. **Push notifications**: Mobile push notifications
6. **Notification read receipts**: Track when notifications are read
7. **Email open tracking**: Track email opens and clicks

### Advanced Role Features

1. **Multi-role support**: Allow users to have multiple roles
2. **Role hierarchy**: Define role inheritance and permissions
3. **Custom permissions**: Fine-grained permission system
4. **Delegation**: Allow agents to delegate to other agents
5. **Temporary access**: Time-limited access to properties

## Security Considerations

1. **Data Privacy**: Users can only view their own notifications and emails
2. **Access Control**: All actions validate user roles and permissions
3. **Audit Trail**: All created/modified timestamps tracked via `managed` aspect
4. **Email Validation**: Validate email addresses before sending
5. **Rate Limiting**: Implement rate limiting for notification/email sending
6. **Data Encryption**: Sensitive data should be encrypted at rest

## Troubleshooting

### Common Issues

1. **Notifications not appearing**
   - Check user's `appNotifications` preference
   - Verify notification was created in database
   - Check recipient_ID is correct

2. **Emails not sending**
   - Verify email service configuration
   - Check `deliveryStatus` in EmailLogs
   - Ensure recipient has valid email address

3. **Authorization errors**
   - Verify user role is set correctly
   - Check role-based validation logic
   - Ensure user is authenticated

## Conclusion

This implementation provides a comprehensive foundation for a role-based property management system with notification and email capabilities. The system is designed to be extensible and can be enhanced with additional features as needed.
