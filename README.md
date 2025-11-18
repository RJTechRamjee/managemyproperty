# Property Management System

A comprehensive role-based property management system built with SAP Cloud Application Programming (CAP) model, featuring notifications, email communication, and workflow management for real estate operations.

## Overview

This system enables buyers, sellers, property owners, tenants, and real estate agents to interact through a feature-rich platform with automated notifications and communication tracking.

## Key Features

### 🏠 Property Management
- Create, read, update, and delete property listings
- Support for sale, rent, and lease listings
- Comprehensive property details (rooms, size, amenities, location)
- Property status tracking and history
- Nearby amenities management

### 👥 Role-Based Access Control
- **Buyer**: Browse properties, send inquiries, track favorites
- **Seller**: List properties for sale, manage buyer inquiries
- **Owner**: Manage rental properties, handle tenant applications
- **Tenant**: Search rentals, submit applications, request maintenance
- **Agent**: Manage multiple properties, facilitate transactions

### 📬 Contact Request System
- Send and manage property inquiries
- Status tracking (Pending, Responded, Closed)
- Conversation threading with messages
- Automatic notifications to property owners

### 🔔 Notification System
- Real-time in-app notifications
- 6 notification types:
  - Contact request received/response
  - Property status changes
  - New property matches
  - Price changes
  - Viewing scheduled
- Read/unread status tracking
- User notification preferences

### 📧 Email Communication
- Email logging and tracking
- Multiple email types (Welcome, Confirmations, Documents)
- Delivery status tracking
- Complete email history

## Technology Stack

- **Backend**: SAP Cloud Application Programming (CAP) Model
- **Database**: SQLite (development), SAP HANA (production-ready)
- **Frontend**: SAP Fiori Elements (UI5)
- **OData**: V4 Protocol
- **Node.js**: Runtime environment

## Project Structure

```
managemyproperty/
├── app/                        # UI applications
│   ├── appmngpmyproperty/     # Property management UI
│   ├── appmnguserprofiles/    # User profile management UI
│   ├── appmngmyuser/          # User dashboard UI
│   └── appmngcontactreq/      # Contact request UI
├── db/                         # Database schema and data
│   ├── schema.cds             # Core data model
│   ├── data/                  # Initial data (CSV)
│   └── i18n/                  # Internationalization
├── srv/                        # Service definitions
│   ├── catalog_service.cds    # Main catalog service
│   ├── catalog_service.js     # Service implementation
│   └── Admin_Service.cds      # Admin service
├── BUSINESS_REQUIREMENTS.md   # Complete business requirements
├── IMPLEMENTATION_GUIDE.md    # Technical implementation details
├── FEATURE_MATRIX.md          # Role-based access control matrix
├── USAGE_EXAMPLES.md          # API usage examples
└── IMPLEMENTATION_SUMMARY.md  # Implementation summary

```

## Quick Start

### Installation

```bash
# Clone the repository
git clone https://github.com/RJTechRamjee/managemyproperty.git
cd managemyproperty

# Install dependencies
npm install
```

### Running the Application

```bash
# Start the development server
npm start

# Start with specific UI app
npm run watch-appmngpmyproperty
npm run watch-appmnguserprofiles
npm run watch-appmngmyuser
npm run watch-appmngcontactreq
```

The application will be available at:
- Main service: http://localhost:4004
- CatalogService: http://localhost:4004/odata/v4/CatalogService
- AdminService: http://localhost:4004/odata/v4/AdminService

### Development Authentication

In development mode, the application uses mock authentication. When accessing the app, you'll be prompted for credentials:

**Available Test Users:**
- `john.buyer` / `pass` - Buyer role
- `sarah.seller` / `pass` - Seller role
- `michael.agent` / `pass` - Agent role
- `emily.owner` / `pass` - Owner role
- `david.tenant` / `pass` - Tenant role
- `lisa.buyer2` / `pass` - Buyer role

For detailed authentication information, see [DEVELOPMENT_AUTH.md](./DEVELOPMENT_AUTH.md).

## Documentation

### For Business Users
- 📋 [Business Requirements](./BUSINESS_REQUIREMENTS.md) - Complete feature descriptions and user stories
- 🎯 [Feature Matrix](./FEATURE_MATRIX.md) - What each user role can do

### For Developers
- 🔧 [Implementation Guide](./IMPLEMENTATION_GUIDE.md) - Technical details and architecture
- 📝 [Usage Examples](./USAGE_EXAMPLES.md) - API examples and common scenarios
- 📊 [Implementation Summary](./IMPLEMENTATION_SUMMARY.md) - Overview of what was built
- 🚀 [MTA Developer Guide](./MTA_DEVELOPER_GUIDE.md) - Complete guide for MTA.yaml configuration and deployment

## API Examples

### Create a Property
```http
POST /odata/v4/CatalogService/Properties
Content-Type: application/json

{
  "title": "Modern 3BR Apartment",
  "type": "Apartment",
  "listingFor": "Rent",
  "coldRent": 1500.00,
  "noOfRooms": 3
}
```

### Send Contact Request
```http
POST /odata/v4/CatalogService/Properties({id})/SendRequest
Content-Type: application/json

{
  "requestMessage": "I'm interested in viewing this property."
}
```

### View Notifications
```http
GET /odata/v4/CatalogService/Notifications?$filter=recipient_ID eq '{user-id}'
```

More examples in [USAGE_EXAMPLES.md](./USAGE_EXAMPLES.md)

## Entity Model

### Core Entities
- **Properties**: Property listings with details
- **Users**: System users with roles
- **ContactRequests**: Property inquiries and applications
- **Notifications**: In-app notifications
- **EmailLogs**: Email communication tracking
- **Addresses**: Location information
- **NearByAmenities**: Points of interest near properties

### User Roles
```
Buyer → Browse & Inquire
Seller → List & Sell
Owner → Rent & Manage
Tenant → Search & Apply
Agent → Facilitate & Manage
```

## Key Features by Role

| Feature | Buyer | Seller | Owner | Tenant | Agent |
|---------|-------|--------|-------|--------|-------|
| Browse Properties | ✅ | ✅ | ✅ | ✅ | ✅ |
| Create Properties | ❌ | ✅ | ✅ | ❌ | ✅ |
| Send Contact Requests | ✅ | ✅ | ✅ | ✅ | ✅ |
| Respond to Requests | ❌ | ✅ | ✅ | ❌ | ✅ |
| Send Notifications | ❌ | ✅ | ✅ | ❌ | ✅ |
| Send Emails | ❌ | ✅ | ✅ | ❌ | ✅ |

See complete matrix in [FEATURE_MATRIX.md](./FEATURE_MATRIX.md)

## Development

### Testing
```bash
# Run tests (if configured)
npm test

# Check for security issues
npm audit
```

### Building for Production
```bash
# Build the application
npm run build

# Deploy to SAP BTP
cf push
```

## Configuration

### Environment Variables
- `NODE_ENV`: Development or production environment
- `PORT`: Server port (default: 4004)

### Database
- Development: SQLite (in-memory)
- Production: SAP HANA Cloud

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Roadmap

### Phase 1 (Current) ✅
- Role-based user system
- Property management
- Contact request workflow
- Notification system
- Email logging

### Phase 2 (Planned) 📋
- Authorization enforcement
- Email service integration
- Advanced search filters
- Saved searches with alerts
- Property image gallery

### Phase 3 (Future) 🚀
- Document management
- Payment processing
- Review and rating system
- Mobile application
- AI-powered recommendations

## License

This project is private and proprietary.

## Support

For questions or issues, please open an issue in the GitHub repository.

## Authors

- RJTech Ramjee

## Acknowledgments

- Built with SAP Cloud Application Programming Model
- UI powered by SAP Fiori Elements
- Database support by SAP HANA Cloud

