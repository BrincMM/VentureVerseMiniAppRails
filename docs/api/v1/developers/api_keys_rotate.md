# Developer Rotate API Key

This API endpoint rotates an app's API key by expiring the current active key and generating a new one.

## Endpoint

```
POST /api/v1/developers/apps/:app_id/api_keys/rotate
```

## Authentication

Requires API Key in the Authorization header:
```
Authorization: Bearer YOUR_API_KEY
```

## URL Parameters

| Parameter | Type    | Required | Description |
|-----------|---------|----------|-------------|
| app_id    | integer | Yes      | The ID of the app whose API key should be rotated |

## Request Body Parameters (Optional)

All parameters are optional. If not provided, values will be inherited from the previous key or use defaults.

| Parameter              | Type    | Required | Description |
|------------------------|---------|----------|-------------|
| rate_limit_per_minute  | integer | No       | Maximum requests per minute (default: 100, or inherited from previous key) |
| rate_limit_per_day     | integer | No       | Maximum requests per day (default: 10000, or inherited from previous key) |
| expires_at             | datetime | No       | API key expiration date (inherited from previous key if not provided) |

## Request Examples

### Basic Rotation (Inherits Settings)
```bash
curl -X POST \
  https://api.example.com/api/v1/developers/apps/123/api_keys/rotate \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json"
```

### Rotation with Custom Rate Limits
```bash
curl -X POST \
  https://api.example.com/api/v1/developers/apps/123/api_keys/rotate \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "rate_limit_per_minute": 200,
    "rate_limit_per_day": 20000,
    "expires_at": "2025-12-31T23:59:59.000Z"
  }'
```

## Success Response

### Status Code: 201 Created

```json
{
  "success": true,
  "message": "API key rotated successfully",
  "data": {
    "api_key": {
      "id": 456,
      "api_key": "vv_1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef",
      "app_id": 123,
      "rate_limit_per_minute": 100,
      "rate_limit_per_day": 10000,
      "status": "active",
      "expires_at": "2025-02-15T10:30:00.000Z",
      "created_at": "2025-01-15T10:30:00.000Z"
    }
  }
}
```

## Error Responses

### Status Code: 404 Not Found

When app is not found:

```json
{
  "success": false,
  "message": "App not found",
  "errors": null
}
```

### Status Code: 422 Unprocessable Entity

When rotation fails due to validation errors:

```json
{
  "success": false,
  "message": "Failed to rotate API key",
  "errors": [
    "Rate limit per minute must be greater than 0"
  ]
}
```

### Status Code: 401 Unauthorized

When authorization header is missing or invalid:

```json
{
  "success": false,
  "message": "Unauthorized",
  "errors": null
}
```

## Behavior

1. **Finds Current Active Key**: Locates the currently active API key for the specified app (if exists)
2. **Expires Current Key**: Changes the status of the current key from `active` to `expired` (if a current key exists)
3. **Generates New Key**: Creates a new API key with:
   - Automatically generated unique key (64-character hex string)
   - Status set to `active`
   - Rate limits: Uses provided values, or inherits from previous key, or uses defaults (100 req/min, 10000 req/day)
   - Expiration: Uses provided value, or inherits from previous key, or no expiration
4. **Atomic Operation**: The entire operation is wrapped in a database transaction to ensure consistency
5. **No Previous Key Required**: If no active API key exists, a new one will be created with default or provided values

## Notes

- Only one API key can be in `active` status per app at any time
- The old API key becomes immediately invalid after rotation (status changed to `expired`)
- The new API key can:
  - Use custom rate limits provided in the request body
  - Inherit rate limits from the previous key (if no values provided and previous key exists)
  - Use default rate limits (100 req/min, 10000 req/day) if no previous key and no values provided
- Rate limit defaults:
  - `rate_limit_per_minute`: 100
  - `rate_limit_per_day`: 10,000
- API key format: 64-character hexadecimal string
- Rotation is atomic - if any step fails, the entire operation is rolled back
- **Works even without previous key**: If no active API key exists for the app, this endpoint will create a new one

## Security Considerations

- Store the new API key securely immediately after rotation
- The old API key cannot be recovered after rotation
- Update all systems using the old API key promptly to avoid service disruption
- Consider implementing a grace period in production where both old and new keys work

## Related Endpoints

- To validate an API key, use `POST /api/v1/api_keys/validate`
- To list all apps for a developer, use `GET /api/v1/developers/:developer_id/apps`
- To view app details, use `GET /api/v1/developers/apps/:id`

**Note**: For security reasons, API keys are only displayed once when created or rotated. They cannot be retrieved again through any API endpoint.

