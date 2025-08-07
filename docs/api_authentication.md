# API Authentication Guide

## Overview
The API uses Bearer Token authentication to secure API endpoints. All API requests must include a valid authentication token in the HTTP header.

## API Domains

### Production
```
https://miniapp.ventureverse.com
```

### Staging
```
https://stageminiapp.ventureverse.com
```

## Authentication Header Format
```http
Authorization: Bearer YOUR_API_TOKEN
```

## Usage Examples

### Using cURL

```bash
# Production environment
curl -H "Authorization: Bearer YOUR_API_TOKEN" https://miniapp.ventureverse.com/api/v1/apps

# Staging environment
curl -H "Authorization: Bearer YOUR_API_TOKEN" https://stageminiapp.ventureverse.com/api/v1/apps
```

### Using JavaScript/Fetch
```javascript
// Configure API domain based on environment
const API_DOMAIN = process.env.NODE_ENV === 'production' 
  ? 'https://miniapp.ventureverse.com'
  : 'https://stageminiapp.ventureverse.com';

// Example: List all apps
fetch(`${API_DOMAIN}/api/v1/apps`, {
  headers: {
    'Authorization': 'Bearer YOUR_API_TOKEN'
  }
})
.then(response => response.json())
.then(data => console.log(data));
```

### Using Python/Requests
```python
# Configure API domain based on environment
import os

API_DOMAIN = (
    "https://miniapp.ventureverse.com"
    if os.environ.get("ENV") == "production"
    else "https://stageminiapp.ventureverse.com"
)

headers = {
    'Authorization': 'Bearer YOUR_API_TOKEN'
}

# Example: List all apps
response = requests.get(f"{API_DOMAIN}/api/v1/apps", headers=headers)
data = response.json()
```

## Error Responses

### Unauthorized (401)
If the request doesn't include a token or the token is invalid:

```json
{
  "success": false,
  "message": "Unauthorized",
  "errors": ["Invalid or missing authentication token"]
}
```

## Security Best Practices

1. **Token Protection**
   - Never hardcode tokens in client-side code
   - Don't store tokens in public repositories
   - Use environment variables or secure configuration management
   - Use different tokens for production and staging environments

2. **Transport Security**
   - Always use HTTPS for API requests
   - Never pass tokens in URL parameters
   - Only pass tokens in the Authorization header

3. **Environment Management**
   - Keep production and staging environments strictly separated
   - Never use production tokens in staging environment
   - Use environment variables to manage API domains and tokens

## Example Response
A successful API call (e.g., listing apps) will return:

```json
{
  "success": true,
  "message": "Apps retrieved successfully",
  "data": {
    "apps": [
      {
        "id": 1,
        "app_name": "Example App",
        "description": "App description",
        "category": "Category",
        "sector": "Sector",
        "tags": ["tag1", "tag2"]
      }
    ],
    "total_count": 1,
    "per_page": 10,
    "current_page": 1
  }
}
```

## Common Issues

1. **Getting 401 Unauthorized**
   - Check if the token is correctly formatted with "Bearer " prefix
   - Verify the token is valid
   - Ensure the request URL is correct
   - Confirm you're using the right token for the environment

2. **Best Token Storage Practices**
   - Server-side: Use environment variables
   - Development: Use secure configuration files (exclude from version control)
   - Client-side: Use secure credential storage systems
   - Use environment-specific configuration files