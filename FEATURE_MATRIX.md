# Role-Based Access Control Feature Matrix

## Overview
This document provides a comprehensive matrix of features and their accessibility based on user roles in the Property Management System.

## User Roles

| Role | Description | Primary Use Case |
|------|-------------|------------------|
| **Buyer** | User looking to purchase property | Browse properties, send inquiries, track favorites |
| **Seller** | Property owner selling their property | List properties for sale, manage inquiries |
| **Owner** | Property owner renting/leasing property | List rentals, manage tenants, track occupancy |
| **Tenant** | User looking to rent/lease property | Browse rentals, apply for properties, submit requests |
| **Agent** | Real estate professional | Manage multiple properties, facilitate transactions |

## Feature Access Matrix

### Property Management

| Feature | Buyer | Seller | Owner | Tenant | Agent | Notes |
|---------|-------|--------|-------|--------|-------|-------|
| **View Properties** | ✅ | ✅ | ✅ | ✅ | ✅ | All users can view properties |
| **Create Property** | ❌ | ✅ | ✅ | ❌ | ✅ | Only owners/sellers/agents can create |
| **Edit Own Property** | ❌ | ✅ | ✅ | ❌ | ✅ | Limited to own properties |
| **Edit Any Property** | ❌ | ❌ | ❌ | ❌ | ⚠️ | Agents: only assigned properties |
| **Delete Property** | ❌ | ✅ | ✅ | ❌ | ⚠️ | Agents: with approval |
| **Change Property Status** | ❌ | ✅ | ✅ | ❌ | ✅ | Update listing status |
| **View Property Analytics** | ❌ | ✅ | ✅ | ❌ | ✅ | View statistics |
| **Archive Property** | ❌ | ✅ | ✅ | ❌ | ✅ | Soft delete |

### Contact Request Management

| Feature | Buyer | Seller | Owner | Tenant | Agent | Notes |
|---------|-------|--------|-------|--------|-------|-------|
| **Send Contact Request** | ✅ | ✅ | ✅ | ✅ | ✅ | All users can send requests |
| **View Own Requests** | ✅ | ✅ | ✅ | ✅ | ✅ | See requests I sent |
| **View Property Requests** | ❌ | ✅ | ✅ | ❌ | ✅ | See requests for my properties |
| **Respond to Requests** | ❌ | ✅ | ✅ | ❌ | ✅ | Reply to inquiries |
| **Close Requests** | ❌ | ✅ | ✅ | ❌ | ✅ | Mark request as closed |
| **Export Requests** | ❌ | ✅ | ✅ | ❌ | ✅ | Download request data |

### Notification System

| Feature | Buyer | Seller | Owner | Tenant | Agent | Notes |
|---------|-------|--------|-------|--------|-------|-------|
| **Receive Notifications** | ✅ | ✅ | ✅ | ✅ | ✅ | All users receive notifications |
| **View Own Notifications** | ✅ | ✅ | ✅ | ✅ | ✅ | See my notifications |
| **Mark as Read** | ✅ | ✅ | ✅ | ✅ | ✅ | Update notification status |
| **Send to Requesters** | ❌ | ✅ | ✅ | ❌ | ✅ | Notify interested parties |
| **Send to Any User** | ❌ | ❌ | ❌ | ❌ | ✅ | Agents can notify anyone |
| **Configure Preferences** | ✅ | ✅ | ✅ | ✅ | ✅ | Set notification settings |
| **Delete Notifications** | ✅ | ✅ | ✅ | ✅ | ✅ | Remove old notifications |

### Email Communication

| Feature | Buyer | Seller | Owner | Tenant | Agent | Notes |
|---------|-------|--------|-------|--------|-------|-------|
| **Receive Emails** | ✅ | ✅ | ✅ | ✅ | ✅ | All users receive emails |
| **View Email History** | ✅ | ✅ | ✅ | ✅ | ✅ | See sent/received emails |
| **Send to Requesters** | ❌ | ✅ | ✅ | ❌ | ✅ | Email interested parties |
| **Send to Any User** | ❌ | ❌ | ❌ | ❌ | ✅ | Agents have broader access |
| **Attach Documents** | ❌ | ✅ | ✅ | ❌ | ✅ | Share files via email |
| **Use Email Templates** | ❌ | ✅ | ✅ | ❌ | ✅ | Pre-formatted emails |
| **Configure Email Prefs** | ✅ | ✅ | ✅ | ✅ | ✅ | Enable/disable emails |

### User Profile Management

| Feature | Buyer | Seller | Owner | Tenant | Agent | Notes |
|---------|-------|--------|-------|--------|-------|-------|
| **View Own Profile** | ✅ | ✅ | ✅ | ✅ | ✅ | See my profile |
| **Edit Own Profile** | ✅ | ✅ | ✅ | ✅ | ✅ | Update my information |
| **View Other Profiles** | ⚠️ | ⚠️ | ⚠️ | ⚠️ | ⚠️ | Limited public info only |
| **Change Role** | ✅ | ✅ | ✅ | ✅ | ✅ | Switch primary role |
| **Delete Account** | ✅ | ✅ | ✅ | ✅ | ✅ | Self-service deletion |

### Search and Filtering

| Feature | Buyer | Seller | Owner | Tenant | Agent | Notes |
|---------|-------|--------|-------|--------|-------|-------|
| **Basic Search** | ✅ | ✅ | ✅ | ✅ | ✅ | Search properties |
| **Advanced Filters** | ✅ | ✅ | ✅ | ✅ | ✅ | Complex search criteria |
| **Save Searches** | ✅ | ❌ | ❌ | ✅ | ✅ | Save search criteria |
| **Get Search Alerts** | ✅ | ❌ | ❌ | ✅ | ✅ | Notify on new matches |
| **View Search Stats** | ❌ | ✅ | ✅ | ❌ | ✅ | Analytics on searches |

### Administrative Functions

| Feature | Buyer | Seller | Owner | Tenant | Agent | Notes |
|---------|-------|--------|-------|--------|-------|-------|
| **Manage Users** | ❌ | ❌ | ❌ | ❌ | ❌ | Admin only |
| **System Settings** | ❌ | ❌ | ❌ | ❌ | ❌ | Admin only |
| **View System Logs** | ❌ | ❌ | ❌ | ❌ | ❌ | Admin only |
| **Generate Reports** | ❌ | ⚠️ | ⚠️ | ❌ | ✅ | Own property reports |

## Legend

| Symbol | Meaning |
|--------|---------|
| ✅ | Full access to feature |
| ❌ | No access to feature |
| ⚠️ | Limited or conditional access |

## Notification Types by Role

### Buyer Receives
- New property matching saved searches
- Response to contact request
- Property status change (for inquired properties)
- Property price change (for favorite properties)

### Seller Receives
- New contact request for property
- Viewing appointment request
- Property listing approved/rejected
- Property performance summary

### Owner Receives
- New rental application
- Tenant maintenance request
- Lease renewal reminder
- Rental payment received

### Tenant Receives
- Rental application status
- Viewing appointment confirmation
- Lease terms notification
- Response to maintenance request

### Agent Receives
- All notifications for managed properties
- New property assignment
- Client action required
- Transaction milestone reached

## Email Types by Role

### All Users Receive
- Welcome email on registration
- Password reset
- Account verification
- Important system announcements

### Sellers/Owners Send
- Contact request response
- Viewing confirmation
- Document sharing (contracts, brochures)
- Property status updates

### Agents Send
- All of above
- Professional market analysis
- Property recommendations
- Transaction updates to multiple parties

## Implementation Status

| Component | Status | Notes |
|-----------|--------|-------|
| User Role Schema | ✅ Complete | Enum types defined |
| Notification System | ✅ Complete | Entity and actions implemented |
| Email System | ✅ Complete | Logging and tracking implemented |
| Contact Request Enhancement | ✅ Complete | Status tracking added |
| Role-Based Authorization | ⚠️ Partial | Logic implemented, needs testing |
| Admin Functions | 📝 Planned | Future enhancement |

## Security Considerations

1. **Data Isolation**: Users can only access data they own or have permission to view
2. **Action Authorization**: All actions validate user role before execution
3. **Property Ownership**: Property modifications require ownership or agent assignment
4. **Email Privacy**: Email addresses not exposed to unauthorized users
5. **Notification Privacy**: Users only see their own notifications
6. **Audit Trail**: All sensitive actions are logged with timestamps

## Next Steps

1. Implement role-based authorization middleware
2. Add unit tests for role validation
3. Create UI components for role-specific features
4. Add admin dashboard for system management
5. Implement agent property assignment workflow
6. Add property ownership transfer functionality

## Related Documents

- [BUSINESS_REQUIREMENTS.md](./BUSINESS_REQUIREMENTS.md) - Complete business requirements
- [IMPLEMENTATION_GUIDE.md](./IMPLEMENTATION_GUIDE.md) - Technical implementation details
- Database schema: `db/schema.cds`
- Service definitions: `srv/catalog_service.cds`
