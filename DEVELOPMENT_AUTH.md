# Development Authentication Guide

## Overview

This application uses mock authentication in development mode to simulate different users with various roles. This allows testing of role-based functionality without setting up a full authentication system.

## Mock Users Configuration

The following test users are configured in `package.json` under `cds.requires.[development].auth`:

| Username | User ID | Role | Real User |
|----------|---------|------|-----------|
| john.buyer | c9537972-9792-4c6e-9091-21ad34305d8a | Buyer | John Smith |
| sarah.seller | 79a042b1-7ffa-48e1-96d8-c522a84e3a03 | Seller | Sarah Johnson |
| michael.agent | d3c31fcf-ecea-4fea-9f67-708d9aa9c96b | Agent | Michael Brown |
| emily.owner | 7fdda6bd-b9b3-44d7-b12c-35a49ec57e7a | Owner | Emily Davis |
| david.tenant | 6a5270cb-8cd3-4726-9066-f6209e3191cd | Tenant | David Wilson |
| lisa.buyer2 | 6ecbc509-9098-45a1-8e03-180f346332c5 | Buyer | Lisa Martinez |

## How to Use

### Starting the Application

```bash
npm start
```

The application will automatically use mock authentication in development mode.

### Authenticating with Mock Users

Mock authentication uses HTTP Basic Authentication. You can authenticate in several ways:

#### 1. Browser Authentication

When you access the application in a browser, you'll be prompted for credentials:
- **Username**: Use any of the usernames above (e.g., `john.buyer`)
- **Password**: Use any password (e.g., `pass` or just press Enter)

The password is not validated in mock mode - only the username matters.

#### 2. Using cURL

```bash
# As John (Buyer)
curl -u john.buyer:pass http://localhost:4004/odata/v4/CatalogService/Properties

# As Sarah (Seller)
curl -u sarah.seller:pass http://localhost:4004/odata/v4/CatalogService/Properties
```

#### 3. Using Postman or Similar Tools

1. Set Authorization Type to "Basic Auth"
2. Username: `john.buyer` (or any other mock user)
3. Password: `pass` (any value)

### Testing Send Request Feature

The "Send Request" action now captures the authenticated user automatically:

```bash
# Send a contact request as John (Buyer)
curl -X POST \
  -u john.buyer:pass \
  -H "Content-Type: application/json" \
  -d '{"requestMessage": "I am interested in this property"}' \
  "http://localhost:4004/odata/v4/CatalogService/Properties(ID=<property-id>,IsActiveEntity=true)/CatalogService.SendRequest"
```

The system will automatically:
- Capture `john.buyer`'s ID (c9537972-9792-4c6e-9091-21ad34305d8a)
- Set it as the `requester_ID` in the ContactRequest
- Create proper audit trails (createdBy, modifiedBy)

### Unauthenticated Requests

Requests without authentication will be rejected:

```bash
# This will fail with 401 Unauthorized
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"requestMessage": "Should fail"}' \
  "http://localhost:4004/odata/v4/CatalogService/Properties(ID=<property-id>,IsActiveEntity=true)/CatalogService.SendRequest"
```

## Adding More Mock Users

To add additional mock users for testing:

1. Open `package.json`
2. Find the `cds.requires.[development].auth.users` section
3. Add a new user entry:

```json
"new.username": {
  "id": "<user-id-from-database>",
  "username": "new.username",
  "roles": ["Role"]
}
```

4. Restart the application

The user ID must match an existing user ID from `db/data/rj.re.managemyproperty-Users.csv`.

## Role-Based Testing Scenarios

### Buyer Scenarios
Use `john.buyer` or `lisa.buyer2` to test:
- Browsing properties
- Sending contact requests
- Viewing own contact requests

### Seller Scenarios
Use `sarah.seller` to test:
- Listing properties
- Managing property status
- Responding to contact requests

### Agent Scenarios
Use `michael.agent` to test:
- Managing multiple properties
- Facilitating transactions
- Handling client requests

### Owner Scenarios
Use `emily.owner` to test:
- Managing rental properties
- Handling tenant applications
- Property maintenance requests

### Tenant Scenarios
Use `david.tenant` to test:
- Searching rentals
- Submitting applications
- Requesting information

## Troubleshooting

### Issue: "Unauthorized" Error

**Solution**: Make sure you're providing authentication credentials with your request.

### Issue: Wrong User ID Captured

**Solution**: Check that the username matches exactly what's configured in `package.json`.

### Issue: Mock Auth Not Working

**Solution**: 
1. Verify you're running in development mode
2. Check the console output for "[cds] [INFO] using auth strategy { kind: 'mocked' }"
3. Restart the server if you made changes to `package.json`

## Production Considerations

**Important**: Mock authentication is ONLY for development. In production:

1. Remove or disable the `[development]` configuration section
2. Implement proper authentication (OAuth2, SAML, etc.)
3. Use real user management systems
4. Implement proper authorization checks

The production authentication should be configured under `cds.requires.auth` without the `[development]` prefix.

## Security Notes

- Mock authentication bypasses all security checks
- Do NOT use mock users in production
- Do NOT commit real credentials to version control
- Mock mode is automatically disabled when `NODE_ENV=production`

## Related Files

- `package.json`: Mock user configuration
- `srv/PropertyManager.js`: Request user capture logic
- `db/data/rj.re.managemyproperty-Users.csv`: User database

## References

- [CAP Authentication Documentation](https://cap.cloud.sap/docs/node.js/authentication)
- [CAP Mock Users](https://cap.cloud.sap/docs/node.js/authentication#mock-users)
