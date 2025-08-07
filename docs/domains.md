# API Domains

## Available Domains

### Production
- **Domain**: `miniapp.ventureverse.com`
- **Usage**: For production environment
- **Example**: `https://miniapp.ventureverse.com/api/v1/apps`

### Staging
- **Domain**: `stageminiapp.ventureverse.com`
- **Usage**: For testing and development
- **Example**: `https://stageminiapp.ventureverse.com/api/v1/apps`

## Environment Usage Guidelines

### Production Environment
- Use `miniapp.ventureverse.com` for:
  - Live applications
  - Production deployments
  - Real user traffic

### Staging Environment
- Use `stageminiapp.ventureverse.com` for:
  - Development and testing
  - Integration testing
  - Pre-production validation

## Best Practices
1. Always test new integrations in staging first
2. Use environment variables to manage domain URLs
3. Implement environment-specific configuration
4. Never use production tokens in staging environment and vice versa