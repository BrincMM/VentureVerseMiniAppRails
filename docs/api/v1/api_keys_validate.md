# API Key Validation

This API endpoint validates an API key and returns associated app and developer information. This is the primary endpoint used by SDKs to verify credentials during initialization.

## Endpoint

```
POST /api/v1/api_keys/validate
```

## Authentication

Requires API Key in the Authorization header:
```
Authorization: Bearer YOUR_API_KEY
```

## Request Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| key       | string | Yes      | The API key to validate (64-character hex string) |

## Request Example

```bash
curl -X POST \
  https://api.example.com/api/v1/api_keys/validate \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "key": "vv_1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"
  }'
```

```json
{
  "key": "vv_1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"
}
```

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "API key is valid",
  "data": {
    "api_key": {
      "id": 456,
      "status": "active",
      "rate_limit_per_minute": 100,
      "rate_limit_per_day": 10000,
      "expires_at": "2025-02-15T10:30:00.000Z",
      "last_used_at": "2025-01-15T10:30:00.000Z"
    },
    "app": {
      "id": 123,
      "name": "My App",
      "status": "active"
    },
    "developer": {
      "id": 789,
      "email": "developer@example.com",
      "name": "John Developer"
    }
  }
}
```

## Error Responses

### Status Code: 400 Bad Request

When API key parameter is missing:

```json
{
  "success": false,
  "message": "API key is required",
  "errors": null
}
```

### Status Code: 401 Unauthorized

When API key is invalid (not found):

```json
{
  "success": false,
  "message": "Invalid API key",
  "errors": null
}
```

When API key is revoked:

```json
{
  "success": false,
  "message": "API key is revoked",
  "errors": null
}
```

When API key is expired:

```json
{
  "success": false,
  "message": "API key is expired",
  "errors": null
}
```

When authorization header is missing or invalid:

```json
{
  "success": false,
  "message": "Unauthorized",
  "errors": null
}
```

## Behavior

1. **Validates Key Presence**: Checks that the `key` parameter is provided
2. **Looks Up Key**: Searches for the API key in the database
3. **Checks Status**: Verifies the key has `status = active`
4. **Checks Expiration**: Verifies the key hasn't expired based on `expires_at` timestamp
5. **Records Usage**: Updates the `last_used_at` timestamp to the current time
6. **Returns Data**: Provides comprehensive information about:
   - The API key itself (status, rate limits, expiration)
   - The associated app (ID, name, status, app-level rate limits)
   - The developer who owns the app (ID, email, name)

## Response Data Details

### API Key Object
- `id`: Unique identifier for the API key
- `status`: Current status ("active", "revoked", or "expired")
- `rate_limit_per_minute`: Maximum requests per minute for this key
- `rate_limit_per_day`: Maximum requests per day for this key
- `expires_at`: When the key expires (null if no expiration)
- `last_used_at`: Last time the key was successfully validated

### App Object
- `id`: Unique identifier for the app
- `name`: App name
- `status`: App status ("active", "disabled", "reviewing", or "dev")

### Developer Object
- `id`: Unique identifier for the developer
- `email`: Developer's email address
- `name`: Developer's name (may be null)

## Validation Rules

1. **API Key Format**: Must be a 64-character hexadecimal string
2. **Status Check**: Key must have `status = "active"`
3. **Date Expiration**: If `expires_at` is set, must be in the future
4. **Both Conditions**: Key is valid only if both status is active AND not expired by date

## Use Cases

### SDK Initialization
SDKs should call this endpoint during initialization to:
1. Verify the provided credentials are valid
2. Retrieve rate limit information for the API key
3. Get developer and app metadata

### Example SDK Usage
```javascript
// SDK initialization
const sdk = new VentureVerseSDK({
  apiKey: 'vv_1234567890abcdef...'
});

// SDK internally calls validate endpoint
await sdk.init(); // Validates key and stores rate limits
```

## Notes

- This endpoint updates `last_used_at` on every successful validation
- Rate limits are provided at the API key level (not at app level)
- SDKs should cache the validation response to avoid repeated calls
- Consider caching the validation result for 5-15 minutes
- If developer is null (app not associated with a developer), the developer object won't be included in the response

## Rate Limiting

This endpoint itself is subject to rate limiting:
- Uses the standard API authentication rate limits
- Does NOT consume the app's API key rate limits
- Consider caching validation results to minimize calls

## Security Considerations

- Always transmit API keys over HTTPS
- Never log or expose API keys in error messages
- Implement proper error handling to avoid key leakage
- Consider implementing retry logic with exponential backoff
- Cache validation results securely and temporarily

## Related Endpoints

- To rotate an API key, use `POST /api/v1/developers/apps/:app_id/api_keys/rotate`
- To view app details, use `GET /api/v1/developers/apps/:id`
- To list all apps for a developer, use `GET /api/v1/developers/:developer_id/apps`

