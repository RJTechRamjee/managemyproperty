# MTA.yaml Developer Guide for CAP CDS Development

## Table of Contents
1. [Introduction](#introduction)
2. [What is MTA?](#what-is-mta)
3. [Basic Structure](#basic-structure)
4. [Understanding Modules](#understanding-modules)
5. [Understanding Resources](#understanding-resources)
6. [Build Parameters](#build-parameters)
7. [Dependencies and Relationships](#dependencies-and-relationships)
8. [Real-World Examples](#real-world-examples)
9. [Best Practices](#best-practices)
10. [Troubleshooting](#troubleshooting)
11. [References](#references)

---

## Introduction

This guide provides a comprehensive, developer-focused overview of creating and configuring `mta.yaml` files for SAP Cloud Application Programming (CAP) Model projects deployed to SAP Business Technology Platform (BTP) Cloud Foundry environment.

The Multi-Target Application (MTA) descriptor file (`mta.yaml`) is the deployment blueprint for your CAP application. It defines all the components (modules) and services (resources) that make up your application, along with their configurations and interdependencies.

**Target Audience**: Developers working with CAP CDS (Core Data Services) who need to deploy applications to SAP BTP Cloud Foundry.

---

## What is MTA?

### Overview
A **Multi-Target Application (MTA)** is a package comprised of multiple software modules that are deployed together on SAP BTP. Each module can be developed in different technologies (Node.js, Java, HTML5, etc.) and can use various services.

### Key Benefits
- **Declarative Configuration**: Define your entire application structure in one file
- **Dependency Management**: Automatically handles dependencies between modules
- **Service Binding**: Simplifies service creation and binding
- **Consistent Deployment**: Ensures all components are deployed in the correct order
- **Environment Agnostic**: Same descriptor works across dev, test, and production

### MTA Components
1. **Modules**: Deployable components (applications, microservices)
2. **Resources**: Services and configurations required by modules
3. **Parameters**: Configuration values
4. **Properties**: Values that can be referenced by other components

---

## Basic Structure

### Schema Version and Metadata

```yaml
_schema-version: 3.3.0
ID: managemyproperty
version: 1.0.0
description: "A simple CAP project."
```

**Explanation**:
- `_schema-version`: Version of the MTA descriptor schema (3.3.0 is current)
- `ID`: Unique identifier for your MTA (should match your project name)
- `version`: Application version (follows semantic versioning)
- `description`: Human-readable description of your application

### Top-Level Parameters

```yaml
parameters:
  enable-parallel-deployments: true
```

**Purpose**: Global parameters that affect the entire deployment
- `enable-parallel-deployments`: Allows multiple deployments simultaneously (faster deployments)

---

## Understanding Modules

Modules are the deployable components of your application. Each module represents a runtime instance in Cloud Foundry.

### Module Anatomy

```yaml
modules:
  - name: module-name              # Unique identifier
    type: nodejs                   # Module type
    path: gen/srv                  # Path to built artifacts
    parameters:                    # Cloud Foundry parameters
      instances: 1
      memory: 256M
      disk-quota: 512M
      buildpack: nodejs_buildpack
    build-parameters:              # Build-time configuration
      builder: npm-ci
    provides:                      # What this module offers
      - name: srv-api
        properties:
          srv-url: ${default-url}
    requires:                      # What this module needs
      - name: managemyproperty-db
      - name: managemyproperty-auth
```

### Common Module Types

#### 1. Node.js Service Module

**Purpose**: Backend CAP service (OData endpoints, business logic)

```yaml
- name: managemyproperty-srv
  type: nodejs
  path: gen/srv                    # Built service artifacts
  parameters:
    instances: 1                   # Number of instances
    buildpack: nodejs_buildpack
  build-parameters:
    builder: npm-ci                # Use npm ci for installation
  provides:
    - name: srv-api                # Exposes service URL
      properties:
        srv-url: ${default-url}    # Cloud Foundry default URL
  requires:
    - name: managemyproperty-auth  # XSUAA service
    - name: managemyproperty-db    # HANA HDI container
```

**Key Points**:
- `path: gen/srv` - Points to generated service code (after `cds build`)
- `builder: npm-ci` - Installs dependencies deterministically
- `${default-url}` - Cloud Foundry placeholder for app URL
- Service exposes an API that other modules can consume

#### 2. Database Deployer Module

**Purpose**: Deploys database artifacts (tables, views, procedures) to HANA

```yaml
- name: managemyproperty-db-deployer
  type: hdb
  path: gen/db                     # Built database artifacts
  parameters:
    buildpack: nodejs_buildpack
  requires:
    - name: managemyproperty-db    # HDI container to deploy to
```

**Key Points**:
- `type: hdb` - Special type for HANA database deployment
- `path: gen/db` - Points to generated database artifacts
- Automatically executes during deployment
- One-time execution per deployment

#### 3. Application Router (Approuter)

**Purpose**: Single entry point, authentication, routing to backend services

```yaml
- name: managemyproperty
  type: approuter.nodejs
  path: app/                       # Contains xs-app.json
  parameters:
    keep-existing-routes: true
    disk-quota: 256M
    memory: 256M
  requires:
    - name: srv-api                # Backend service
      group: destinations
      properties:
        name: srv-api
        url: ~{srv-url}            # Reference to provided URL
        forwardAuthToken: true
    - name: managemyproperty-auth  # XSUAA for authentication
  provides:
    - name: app-api                # Exposes app URL
      properties:
        app-protocol: ${protocol}
        app-uri: ${default-uri}
```

**Key Points**:
- `type: approuter.nodejs` - Special Cloud Foundry buildpack
- `group: destinations` - Creates destination configuration
- `~{srv-url}` - References provided property from srv module
- `forwardAuthToken: true` - Passes JWT token to backend
- Entry point for all user requests

#### 4. UI Module (Fiori Elements)

**Purpose**: Hosts UI5/Fiori applications

```yaml
- name: appmngmyproperty-ui
  type: nodejs
  path: app                        # UI5 applications
  parameters:
    buildpack: nodejs_buildpack
  build-parameters:
    builder: npm-ci
  requires:
    - name: srv-api
      group: destinations
      properties:
        name: srv-api
        strictSSL: true
        forwardAuthToken: true
        url: '~{srv-url}'
    - name: managemyproperty-auth
```

**Key Points**:
- Separate module for UI components
- Connects to backend via destinations
- Can contain multiple UI5 applications

---

## Understanding Resources

Resources represent services and configurations that modules consume. They are created/bound automatically during deployment.

### Resource Anatomy

```yaml
resources:
  - name: resource-name            # Unique identifier
    type: service-type             # Cloud Foundry service type
    parameters:
      service: service-name        # Service from marketplace
      service-plan: plan-name      # Service plan
      path: ./config-file.json     # Configuration file
      config:                      # Inline configuration
        key: value
    requires:                      # Can reference other resources
      - name: another-resource
```

### Common Resource Types

#### 1. XSUAA (Authentication and Authorization)

**Purpose**: User authentication and role-based authorization

```yaml
- name: managemyproperty-auth
  type: org.cloudfoundry.managed-service
  parameters:
    service: xsuaa
    service-plan: application
    path: ./xs-security.json       # Security configuration
    config:
      xsappname: managemyproperty-${org}-${space}
      tenant-mode: dedicated
      oauth2-configuration:
        redirect-uris:
          - https://*~{app-api/app-uri}/**
  requires:
    - name: app-api                # Needs app URL for redirect
```

**Key Points**:
- `service: xsuaa` - SAP's authentication service
- `service-plan: application` - Standard plan for business apps
- `xs-security.json` - Defines scopes, roles, role templates
- `${org}-${space}` - Makes app name unique per space
- `redirect-uris` - OAuth callback URLs (needs app URL)

**xs-security.json Structure**:
```json
{
  "xsappname": "managemyproperty",
  "tenant-mode": "dedicated",
  "scopes": [
    {
      "name": "$XSAPPNAME.Admin",
      "description": "Admin scope"
    }
  ],
  "role-templates": [
    {
      "name": "Admin",
      "description": "Administrator",
      "scope-references": ["$XSAPPNAME.Admin"]
    }
  ]
}
```

#### 2. SAP HANA HDI Container

**Purpose**: Isolated database schema for your application

```yaml
- name: managemyproperty-db
  type: com.sap.xs.hdi-container
  parameters:
    service: hana
    service-plan: hdi-shared       # Shared HANA instance
```

**Key Points**:
- `hdi-shared` - Shared HANA instance (cost-effective)
- `hdi` - Full HANA instance (production)
- Automatically provisions isolated database container
- Supports multi-tenancy

#### 3. Destination Service

**Purpose**: Manages connections to remote systems

```yaml
- name: managemyproperty-destination
  type: org.cloudfoundry.managed-service
  parameters:
    service: destination
    service-plan: lite
    config:
      HTML5Runtime_enabled: true
      init_data:
        instance:
          destinations:
            - Name: srv-api
              URL: ~{srv-api/srv-url}
              Authentication: NoAuthentication
              ProxyType: Internet
          existing_destinations_policy: update
  requires:
    - name: srv-api
```

**Use Cases**:
- Connect to external APIs
- Connect to on-premise systems (via Cloud Connector)
- Reuse destinations across applications

#### 4. HTML5 Application Repository

**Purpose**: Host and serve HTML5/UI5 applications

```yaml
- name: managemyproperty-html5-repo-host
  type: org.cloudfoundry.managed-service
  parameters:
    service: html5-apps-repo
    service-plan: app-host
```

**Key Points**:
- Optimized for serving static content
- Better performance than regular apps
- Version management for UI apps

---

## Build Parameters

Build parameters control how modules are built and prepared for deployment.

### Global Build Parameters

```yaml
build-parameters:
  before-all:
    - builder: custom
      commands:
        - npm ci                    # Install dependencies
        - npx cds build --production  # Build CAP project
```

**Purpose**: Commands executed once before building any module
- `npm ci` - Clean install (faster, deterministic)
- `cds build --production` - Generates `/gen` folder with deployable artifacts

### Module-Specific Build Parameters

```yaml
build-parameters:
  builder: npm-ci                  # Use npm ci instead of npm install
  ignore:                          # Don't include in deployment
    - .gitignore
    - node_modules/
  supported-platforms: []          # Build for all platforms
```

**Common Builders**:
- `npm-ci` - For Node.js modules
- `custom` - For custom build commands
- `maven` - For Java modules
- `grunt` - For UI projects

### Build Optimization Tips

```yaml
build-parameters:
  builder: npm-ci
  ignore:                          # Reduce deployment size
    - node_modules/
    - test/
    - .git/
    - .vscode/
    - "*.md"
  minify: true                     # Minify JavaScript (if supported)
```

---

## Dependencies and Relationships

Understanding `requires`, `provides`, and how to reference values.

### Provides: Exposing Values

```yaml
provides:
  - name: srv-api                  # Identifier for this offer
    properties:
      srv-url: ${default-url}      # Property other modules can use
      srv-protocol: ${protocol}
```

**Use Case**: Module offers its URL/endpoint to other modules

### Requires: Consuming Values

```yaml
requires:
  - name: srv-api                  # Reference to provided name
    group: destinations            # How to consume (destinations)
    properties:
      name: srv-api
      url: ~{srv-url}              # Use provided srv-url
      forwardAuthToken: true
```

**Syntax**:
- `~{property-name}` - Reference provided property
- `~{module-name/property-name}` - Fully qualified reference

### Dependency Patterns

#### 1. Service → Database

```yaml
# Service module
requires:
  - name: managemyproperty-db      # HDI container resource
```

**Explanation**: Service needs database credentials to connect

#### 2. Service → Authentication

```yaml
# Service module
requires:
  - name: managemyproperty-auth    # XSUAA resource
```

**Explanation**: Service validates JWT tokens from users

#### 3. Approuter → Service

```yaml
# Approuter module
requires:
  - name: srv-api                  # Provided by service module
    group: destinations
    properties:
      url: ~{srv-url}
```

**Explanation**: Approuter routes requests to backend service

#### 4. Resource → Module (Reverse Dependency)

```yaml
# XSUAA resource
requires:
  - name: app-api                  # Provided by approuter
```

**Explanation**: XSUAA needs app URL for OAuth redirect URIs

### Dependency Order

MTA deployer automatically determines deployment order based on dependencies:

1. **Resources** are created first
2. **Modules** without dependencies
3. **Modules** with dependencies (after their dependencies)
4. **Database deployers** (after HDI containers)

---

## Real-World Examples

### Example 1: Simple CAP Application

**Scenario**: Basic CAP service with SQLite (no HANA)

```yaml
_schema-version: 3.3.0
ID: simple-cap-app
version: 1.0.0

modules:
  - name: simple-cap-app-srv
    type: nodejs
    path: gen/srv
    parameters:
      memory: 256M
    build-parameters:
      builder: npm-ci
```

**Use Case**: Development/demo applications

### Example 2: CAP with HANA

**Scenario**: Production CAP app with HANA database

```yaml
_schema-version: 3.3.0
ID: cap-with-hana
version: 1.0.0

build-parameters:
  before-all:
    - builder: custom
      commands:
        - npm ci
        - npx cds build --production

modules:
  # Service module
  - name: cap-srv
    type: nodejs
    path: gen/srv
    requires:
      - name: cap-db
      - name: cap-auth

  # Database deployer
  - name: cap-db-deployer
    type: hdb
    path: gen/db
    requires:
      - name: cap-db

resources:
  # HANA HDI Container
  - name: cap-db
    type: com.sap.xs.hdi-container
    parameters:
      service: hana
      service-plan: hdi-shared

  # Authentication
  - name: cap-auth
    type: org.cloudfoundry.managed-service
    parameters:
      service: xsuaa
      service-plan: application
      path: ./xs-security.json
```

### Example 3: Full-Stack CAP Application (Current Project)

**Scenario**: Complete application with UI, service, database, and authentication

```yaml
_schema-version: 3.3.0
ID: managemyproperty
version: 1.0.0
description: "A simple CAP project."

parameters:
  enable-parallel-deployments: true

build-parameters:
  before-all:
    - builder: custom
      commands:
        - npm ci
        - npx cds build --production

modules:
  # UI Module
  - name: appmngmyproperty-ui
    type: nodejs
    path: app
    build-parameters:
      builder: npm-ci
    requires:
      - name: srv-api
        group: destinations
        properties:
          name: srv-api
          strictSSL: true
          forwardAuthToken: true
          url: '~{srv-url}'
      - name: managemyproperty-auth

  # Service Module
  - name: managemyproperty-srv
    type: nodejs
    path: gen/srv
    parameters:
      instances: 1
      buildpack: nodejs_buildpack
    build-parameters:
      builder: npm-ci
    provides:
      - name: srv-api
        properties:
          srv-url: ${default-url}
    requires:
      - name: managemyproperty-auth
      - name: managemyproperty-db

  # Database Deployer
  - name: managemyproperty-db-deployer
    type: hdb
    path: gen/db
    parameters:
      buildpack: nodejs_buildpack
    requires:
      - name: managemyproperty-db

  # Approuter
  - name: managemyproperty
    type: approuter.nodejs
    path: app/
    parameters:
      keep-existing-routes: true
      disk-quota: 256M
      memory: 256M
    requires:
      - name: srv-api
        group: destinations
        properties:
          name: srv-api
          url: ~{srv-url}
          forwardAuthToken: true
      - name: managemyproperty-auth
    provides:
      - name: app-api
        properties:
          app-protocol: ${protocol}
          app-uri: ${default-uri}

resources:
  # XSUAA
  - name: managemyproperty-auth
    type: org.cloudfoundry.managed-service
    parameters:
      service: xsuaa
      service-plan: application
      path: ./xs-security.json
      config:
        xsappname: managemyproperty-${org}-${space}
        tenant-mode: dedicated
        oauth2-configuration:
          redirect-uris:
            - https://*~{app-api/app-uri}/**
    requires:
      - name: app-api

  # HANA HDI
  - name: managemyproperty-db
    type: com.sap.xs.hdi-container
    parameters:
      service: hana
      service-plan: hdi-shared
```

### Example 4: Multi-Tenant Application

**Scenario**: SaaS application supporting multiple tenants

```yaml
resources:
  - name: saas-registry
    type: org.cloudfoundry.managed-service
    parameters:
      service: saas-registry
      service-plan: application
      config:
        appName: my-saas-app
        displayName: "My SaaS Application"
        description: "Multi-tenant SaaS application"
        category: "Business Applications"
        appUrls:
          getDependencies: ~{srv-api/srv-url}/callback/v1.0/dependencies
          onSubscription: ~{srv-api/srv-url}/callback/v1.0/tenants/{tenantId}
    requires:
      - name: srv-api

  - name: my-auth
    parameters:
      config:
        tenant-mode: shared        # Key difference!
        xsappname: my-saas-${org}-${space}
```

### Example 5: External API Integration

**Scenario**: Connect to external REST API

```yaml
resources:
  - name: external-api-dest
    type: org.cloudfoundry.managed-service
    parameters:
      service: destination
      service-plan: lite
      config:
        init_data:
          instance:
            destinations:
              - Name: external-api
                URL: https://api.example.com
                Authentication: OAuth2ClientCredentials
                ProxyType: Internet
                tokenServiceURL: https://auth.example.com/oauth/token
                clientId: my-client-id
                clientSecret: my-client-secret
            existing_destinations_policy: update

modules:
  - name: my-srv
    requires:
      - name: external-api-dest
```

### Example 6: Job Scheduler Integration

**Scenario**: Background jobs and scheduled tasks

```yaml
resources:
  - name: job-scheduler
    type: org.cloudfoundry.managed-service
    parameters:
      service: jobscheduler
      service-plan: standard

modules:
  - name: my-srv
    requires:
      - name: job-scheduler
```

---

## Best Practices

### 1. Naming Conventions

```yaml
# Good: Consistent, descriptive names
ID: my-app
modules:
  - name: my-app-srv          # Pattern: {app}-srv
  - name: my-app-db-deployer  # Pattern: {app}-db-deployer
  - name: my-app-ui           # Pattern: {app}-ui
resources:
  - name: my-app-db           # Pattern: {app}-db
  - name: my-app-auth         # Pattern: {app}-auth
```

### 2. Use Environment Variables

```yaml
# Make xsappname unique per space
config:
  xsappname: ${appname}-${org}-${space}
  
# Or use custom parameters
parameters:
  app-domain: cfapps.us10.hana.ondemand.com

properties:
  url: https://myapp.${app-domain}
```

### 3. Resource Optimization

```yaml
# Service module
parameters:
  memory: 256M              # Start small
  disk-quota: 512M
  instances: 1              # Scale later if needed

# Build optimization
build-parameters:
  ignore:                   # Reduce deployment size
    - node_modules/
    - test/
    - .git/
    - "*.md"
```

### 4. Development vs. Production

```yaml
# Use extension descriptors for different environments
# mta.yaml (base)
parameters:
  memory: 256M

# mtad-dev.yaml (development overrides)
modules:
  - name: my-srv
    parameters:
      memory: 128M          # Less memory in dev

# mtad-prod.yaml (production overrides)
modules:
  - name: my-srv
    parameters:
      memory: 512M          # More memory in prod
      instances: 3          # Scale out
```

### 5. Security Best Practices

```yaml
# ❌ Bad: Hardcoded credentials
config:
  clientId: "my-client-id"
  clientSecret: "my-secret"

# ✅ Good: Use service keys or environment variables
# Set via CF CLI: cf set-env my-app CLIENT_SECRET "secret"
```

### 6. Modular Design

```yaml
# Separate UI modules for better maintainability
- name: app-fiori-ui        # Fiori apps
  path: app/fiori
  
- name: app-react-ui        # React apps
  path: app/react
  
- name: app-angular-ui      # Angular apps
  path: app/angular
```

### 7. Documentation

```yaml
# Add comments to complex configurations
_schema-version: 3.3.0
ID: my-app
description: |
  My Application
  - Customer portal
  - Admin dashboard
  - Background jobs

modules:
  # Customer-facing service
  - name: customer-srv
    # ... configuration
    
  # Internal admin service
  - name: admin-srv
    # ... configuration
```

### 8. Version Management

```yaml
# Semantic versioning
version: 1.2.3              # MAJOR.MINOR.PATCH

# Or use build number from CI/CD
version: ${env.BUILD_VERSION}
```

---

## Troubleshooting

### Common Issues and Solutions

#### 1. Module Build Failures

**Problem**: Module fails to build during deployment

```
Error: Module 'my-srv' build failed
```

**Solutions**:
```yaml
# Check build commands
build-parameters:
  before-all:
    - builder: custom
      commands:
        - npm ci              # Not 'npm install'
        - npx cds build --production

# Verify paths
modules:
  - name: my-srv
    path: gen/srv           # Must exist after build
```

**Debug Steps**:
1. Run build locally: `npm ci && npx cds build --production`
2. Verify `gen/` folder exists
3. Check `gen/srv/package.json` is present

#### 2. Service Binding Failures

**Problem**: Module can't connect to service

```
Error: Service 'my-db' not found
```

**Solutions**:
```yaml
# Check resource name matches
resources:
  - name: my-db             # ← Must match exactly
    
modules:
  - name: my-srv
    requires:
      - name: my-db         # ← Same name
```

#### 3. Circular Dependencies

**Problem**: Deployment hangs or fails

```
Error: Circular dependency detected
```

**Solution**: Review `requires` and `provides`

```yaml
# ❌ Bad: Circular dependency
modules:
  - name: srv-a
    provides: [{ name: srv-a-api }]
    requires: [{ name: srv-b-api }]
    
  - name: srv-b
    provides: [{ name: srv-b-api }]
    requires: [{ name: srv-a-api }]

# ✅ Good: One-way dependency
modules:
  - name: srv-a
    provides: [{ name: srv-a-api }]
    
  - name: srv-b
    requires: [{ name: srv-a-api }]
```

#### 4. Memory/Disk Quota Exceeded

**Problem**: App crashes due to insufficient resources

```
Error: Failed to create container: insufficient memory
```

**Solutions**:
```yaml
parameters:
  memory: 512M              # Increase from 256M
  disk-quota: 1024M         # Increase from 512M

# Monitor with: cf app my-app
# Adjust based on actual usage
```

#### 5. Authentication Issues

**Problem**: Users can't log in

```
Error: Unauthorized (401)
```

**Solutions**:
```yaml
# Check redirect URIs
resources:
  - name: my-auth
    parameters:
      config:
        oauth2-configuration:
          redirect-uris:
            - https://*~{app-api/app-uri}/**  # Must match app URL
            
# Verify app-api is provided
modules:
  - name: my-approuter
    provides:
      - name: app-api       # Required by XSUAA
```

#### 6. Database Deployment Fails

**Problem**: HDI deployer fails

```
Error: Database deployment failed
```

**Solutions**:
```yaml
# Ensure db-deployer depends on HDI container
modules:
  - name: my-db-deployer
    type: hdb
    path: gen/db            # Check this path exists
    requires:
      - name: my-db         # HDI container resource

# Verify db artifacts
# gen/db/ should contain:
# - src/
# - package.json
# - .hdiconfig
```

**Debug Steps**:
1. Check deployer logs: `cf logs my-db-deployer --recent`
2. Verify CDS build: `npx cds build --production`
3. Check database artifacts in `gen/db/`

#### 7. Approuter Configuration Issues

**Problem**: Approuter returns 404 for backend calls

```
Error: 404 Not Found - /srv/odata/v4/CatalogService
```

**Solutions**:
```yaml
# Check xs-app.json in app/ folder
{
  "routes": [
    {
      "source": "^/srv/(.*)$",
      "target": "$1",
      "destination": "srv-api"    # Must match destination name
    }
  ]
}

# Verify destination in mta.yaml
modules:
  - name: my-approuter
    requires:
      - name: srv-api
        group: destinations
        properties:
          name: srv-api       # Must match xs-app.json
          url: ~{srv-url}
```

### Deployment Commands

```bash
# Build MTA
mbt build

# Deploy to Cloud Foundry
cf deploy mta_archives/my-app_1.0.0.mtar

# Deploy with specific extension
cf deploy mta_archives/my-app_1.0.0.mtar -e mtad-prod.yaml

# Check deployment status
cf mta my-app

# View module logs
cf logs my-app-srv --recent

# Undeploy
cf undeploy my-app --delete-services
```

### Validation Tools

```bash
# Install MTA Build Tool
npm install -g mbt

# Validate mta.yaml syntax
mbt validate

# Build and validate
mbt build
```

---

## Advanced Patterns

### 1. Service Mesh with Multiple Services

```yaml
modules:
  # API Gateway
  - name: api-gateway
    type: nodejs
    provides:
      - name: gateway-api
    requires:
      - name: user-srv-api
      - name: product-srv-api
      
  # User Service
  - name: user-srv
    type: nodejs
    provides:
      - name: user-srv-api
    requires:
      - name: user-db
      
  # Product Service
  - name: product-srv
    type: nodejs
    provides:
      - name: product-srv-api
    requires:
      - name: product-db
```

### 2. Blue-Green Deployment Ready

```yaml
parameters:
  enable-parallel-deployments: true

modules:
  - name: my-srv
    parameters:
      keep-existing-routes: true  # Don't remove old routes
      instances: 2                # Multiple instances
```

### 3. Using Extensions for Environments

**Base mta.yaml**:
```yaml
ID: my-app
modules:
  - name: my-srv
    parameters:
      memory: ${default-memory}
```

**dev-extension.mtaext**:
```yaml
_schema-version: 3.3.0
ID: my-app
extends: my-app

parameters:
  default-memory: 128M
```

**prod-extension.mtaext**:
```yaml
_schema-version: 3.3.0
ID: my-app
extends: my-app

parameters:
  default-memory: 512M
  
modules:
  - name: my-srv
    parameters:
      instances: 3
```

### 4. Shared Services Across MTAs

```yaml
# Use existing service instead of creating new one
resources:
  - name: shared-db
    type: org.cloudfoundry.existing-service
    parameters:
      service-name: existing-hdi-container
```

---

## Performance Optimization

### 1. Parallel Deployments

```yaml
parameters:
  enable-parallel-deployments: true  # Deploy independent modules in parallel
```

### 2. Minimize Module Size

```yaml
build-parameters:
  ignore:
    - node_modules/
    - test/
    - .git/
    - .vscode/
    - "*.log"
    - "*.md"
```

### 3. Optimize Memory Usage

```yaml
# Start with minimal memory
parameters:
  memory: 128M

# Scale up based on monitoring
# Use: cf app my-srv (to see actual usage)
```

### 4. Use CDN for Static Assets

```yaml
# Serve UI from HTML5 repo instead of regular app
- name: my-ui
  type: com.sap.application.content
  requires:
    - name: html5-repo-host
      parameters:
        content-target: true
```

---

## Security Checklist

- [ ] Use `xsappname: ${appname}-${org}-${space}` for XSUAA uniqueness
- [ ] Never hardcode credentials in mta.yaml
- [ ] Use HTTPS for all external destinations
- [ ] Set `forwardAuthToken: true` for authenticated destinations
- [ ] Configure proper scopes and role-templates in xs-security.json
- [ ] Use `tenant-mode: dedicated` unless building SaaS
- [ ] Set appropriate redirect URIs in XSUAA config
- [ ] Review service plans (use `lite` for dev, `standard` for prod)
- [ ] Enable audit logging for production
- [ ] Use service keys for sensitive configurations

---

## Migration Guide

### From XSA to Cloud Foundry

**XSA mta.yaml**:
```yaml
modules:
  - name: my-srv
    type: nodejs
    path: srv
    provides:
      - name: my-srv-api
        properties:
          url: ${default-url}
```

**Cloud Foundry mta.yaml**:
```yaml
build-parameters:
  before-all:
    - builder: custom
      commands:
        - npm ci
        - npx cds build --production  # Add build step

modules:
  - name: my-srv
    type: nodejs
    path: gen/srv                     # Changed from 'srv' to 'gen/srv'
    parameters:
      buildpack: nodejs_buildpack     # Specify buildpack
    build-parameters:
      builder: npm-ci                 # Add builder
    provides:
      - name: my-srv-api
        properties:
          url: ${default-url}
```

---

## Cheat Sheet

### Quick Reference

```yaml
# Module Types
nodejs              # Node.js application
hdb                 # HANA database deployer
approuter.nodejs    # Application Router
html5              # HTML5 application
java                # Java application

# Service Types
org.cloudfoundry.managed-service      # Standard CF service
org.cloudfoundry.existing-service     # Use existing service
com.sap.xs.hdi-container             # HANA HDI container

# Common Services
xsuaa               # Authentication
hana                # SAP HANA
destination         # Destination service
html5-apps-repo     # HTML5 repository
jobscheduler        # Job Scheduler
connectivity        # Cloud Connector

# Placeholders
${default-url}      # App URL
${default-uri}      # App URI
${protocol}         # Protocol (https)
${org}              # CF organization
${space}            # CF space
~{property}         # Reference provided property

# Build Parameters
builder: npm-ci                # Node.js builder
builder: maven                 # Maven builder
builder: custom                # Custom commands
ignore: [...]                  # Files to exclude
```

---

## References

### Official Documentation
- [MTA Development and Deployment](https://help.sap.com/docs/btp/sap-business-technology-platform/multitarget-applications-in-cloud-foundry-environment)
- [MTA Module Types](https://help.sap.com/docs/btp/sap-business-technology-platform/modules)
- [MTA Resource Types](https://help.sap.com/docs/btp/sap-business-technology-platform/resources)
- [CAP Documentation](https://cap.cloud.sap/docs/)
- [Cloud Foundry Services](https://help.sap.com/docs/btp/sap-business-technology-platform/consuming-services-in-cloud-foundry-environment)

### Tools
- [Cloud MTA Build Tool (MBT)](https://sap.github.io/cloud-mta-build-tool/)
- [MTA Archive Builder](https://github.com/SAP/cloud-mta-build-tool)
- [Cloud Foundry CLI](https://docs.cloudfoundry.org/cf-cli/)
- [MultiApps CF CLI Plugin](https://github.com/cloudfoundry-incubator/multiapps-cli-plugin)

### SAP BTP Services
- [XSUAA Service](https://help.sap.com/docs/CP_AUTHORIZ_TRUST_MNG/65de2977205c403bbc107264b8eccf4b/6373bb7a96114d619bfdfdc6f505d1b9.html)
- [SAP HANA Cloud](https://help.sap.com/docs/HANA_CLOUD)
- [Destination Service](https://help.sap.com/docs/CP_CONNECTIVITY/cca91383641e40ffbe03bdc78f00f681/7e306250e08340f89d6c103e28840f30.html)
- [HTML5 Application Repository](https://help.sap.com/docs/BTP/65de2977205c403bbc107264b8eccf4b/11d77aa154f64c2e83cc9652a78bb985.html)

### Community Resources
- [SAP Community](https://community.sap.com/)
- [SAP Developer Center](https://developers.sap.com/)
- [CAP Samples on GitHub](https://github.com/SAP-samples?q=cap)

### Troubleshooting
- [Troubleshooting MTA Deployment](https://help.sap.com/docs/btp/sap-business-technology-platform/troubleshooting)
- [Cloud Foundry Troubleshooting](https://docs.cloudfoundry.org/devguide/deploy-apps/troubleshoot-app-health.html)

---

## Appendix: Complete Example

### Project Structure
```
my-cap-project/
├── app/
│   ├── fiori/              # UI5 applications
│   ├── xs-app.json         # Approuter configuration
│   └── package.json
├── db/
│   ├── schema.cds          # Data model
│   └── data/               # Initial data
├── srv/
│   ├── service.cds         # Service definitions
│   └── service.js          # Service implementation
├── mta.yaml                # THIS FILE
├── xs-security.json        # XSUAA configuration
└── package.json            # Root package.json
```

### Complete mta.yaml

```yaml
_schema-version: 3.3.0
ID: my-complete-cap-app
version: 1.0.0
description: "Complete CAP application with all features"

parameters:
  enable-parallel-deployments: true
  deploy_mode: html5-repo

build-parameters:
  before-all:
    - builder: custom
      commands:
        - npm ci
        - npx cds build --production

modules:
  # ===== Approuter Module =====
  - name: my-app-approuter
    type: approuter.nodejs
    path: app/
    parameters:
      keep-existing-routes: true
      disk-quota: 256M
      memory: 256M
    requires:
      - name: my-app-auth
      - name: my-app-destination
      - name: my-app-html5-repo-runtime
      - name: srv-api
        group: destinations
        properties:
          name: srv-api
          url: ~{srv-url}
          forwardAuthToken: true
    provides:
      - name: app-api
        properties:
          app-protocol: ${protocol}
          app-uri: ${default-uri}

  # ===== Service Module =====
  - name: my-app-srv
    type: nodejs
    path: gen/srv
    parameters:
      buildpack: nodejs_buildpack
      memory: 512M
      disk-quota: 1024M
      instances: 2
    build-parameters:
      builder: npm-ci
      ignore:
        - .env
        - node_modules/
    provides:
      - name: srv-api
        properties:
          srv-url: ${default-url}
    requires:
      - name: my-app-auth
      - name: my-app-db
      - name: my-app-destination
      - name: my-app-logs

  # ===== Database Deployer =====
  - name: my-app-db-deployer
    type: hdb
    path: gen/db
    parameters:
      buildpack: nodejs_buildpack
    requires:
      - name: my-app-db

  # ===== UI Deployer =====
  - name: my-app-ui-deployer
    type: com.sap.application.content
    path: .
    requires:
      - name: my-app-html5-repo-host
        parameters:
          content-target: true
    build-parameters:
      build-result: resources
      requires:
        - name: my-app-fiori
          artifacts:
            - fiori.zip
          target-path: resources/

  # ===== Fiori UI =====
  - name: my-app-fiori
    type: html5
    path: app/fiori
    build-parameters:
      builder: custom
      commands:
        - npm ci
        - npm run build
      supported-platforms: []
      build-result: dist

resources:
  # ===== XSUAA =====
  - name: my-app-auth
    type: org.cloudfoundry.managed-service
    parameters:
      service: xsuaa
      service-plan: application
      path: ./xs-security.json
      config:
        xsappname: my-app-${org}-${space}
        tenant-mode: dedicated
        oauth2-configuration:
          redirect-uris:
            - https://*~{app-api/app-uri}/**
    requires:
      - name: app-api

  # ===== HANA HDI Container =====
  - name: my-app-db
    type: com.sap.xs.hdi-container
    parameters:
      service: hana
      service-plan: hdi-shared
    properties:
      hdi-service-name: ${service-name}

  # ===== Destination Service =====
  - name: my-app-destination
    type: org.cloudfoundry.managed-service
    parameters:
      service: destination
      service-plan: lite
      config:
        HTML5Runtime_enabled: true
        init_data:
          instance:
            destinations:
              - Name: srv-api
                URL: ~{srv-api/srv-url}
                Authentication: NoAuthentication
                ProxyType: Internet
              - Name: external-api
                URL: https://api.example.com
                Authentication: BasicAuthentication
                ProxyType: Internet
                User: ${external-api-user}
                Password: ${external-api-password}
            existing_destinations_policy: update
    requires:
      - name: srv-api

  # ===== HTML5 App Repo Host =====
  - name: my-app-html5-repo-host
    type: org.cloudfoundry.managed-service
    parameters:
      service: html5-apps-repo
      service-plan: app-host

  # ===== HTML5 App Repo Runtime =====
  - name: my-app-html5-repo-runtime
    type: org.cloudfoundry.managed-service
    parameters:
      service: html5-apps-repo
      service-plan: app-runtime

  # ===== Application Logging =====
  - name: my-app-logs
    type: org.cloudfoundry.managed-service
    parameters:
      service: application-logs
      service-plan: lite
```

---

## Quick Start Checklist

- [ ] Copy existing mta.yaml as template
- [ ] Update `ID` and `description`
- [ ] Configure build commands in `build-parameters.before-all`
- [ ] Define service module (nodejs, path: gen/srv)
- [ ] Define database deployer (hdb, path: gen/db)
- [ ] Add XSUAA resource with xs-security.json
- [ ] Add HDI container resource
- [ ] Configure dependencies (requires/provides)
- [ ] Test build: `mbt build`
- [ ] Deploy: `cf deploy mta_archives/*.mtar`
- [ ] Verify: `cf mta <app-id>`

---

**Last Updated**: 2025-11-18  
**Author**: Developer Documentation Team  
**Version**: 1.0.0

For questions or feedback, please refer to the [SAP Community](https://community.sap.com/) or your project's documentation maintainer.
