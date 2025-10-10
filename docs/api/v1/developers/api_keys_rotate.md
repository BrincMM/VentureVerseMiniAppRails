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

## Request Example

```bash
curl -X POST \
  https://api.example.com/api/v1/developers/apps/123/api_keys/rotate \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json"
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

When no active API key exists for this app:

```json
{
  "success": false,
  "message": "No active API key found for this app",
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

1. **Finds Current Active Key**: Locates the currently active API key for the specified app
2. **Expires Current Key**: Changes the status of the current key from `active` to `expired`
3. **Generates New Key**: Creates a new API key with:
   - Automatically generated unique key (64-character hex string)
   - Status set to `active`
   - Same rate limits as the previous key
   - Same expiration settings as the previous key
4. **Atomic Operation**: The entire operation is wrapped in a database transaction to ensure consistency

## Notes

- Only one API key can be in `active` status per app at any time
- The old API key becomes immediately invalid after rotation (status changed to `expired`)
- The new API key inherits the rate limit settings from the previous key
- Rate limits include:
  - `rate_limit_per_minute`: Default 100
  - `rate_limit_per_day`: Default 10,000
- API key format: 64-character hexadecimal string
- Rotation is atomic - if any step fails, the entire operation is rolled back

## Security Considerations

- Store the new API key securely immediately after rotation
- The old API key cannot be recovered after rotation
- Update all systems using the old API key promptly to avoid service disruption
- Consider implementing a grace period in production where both old and new keys work

## Related Endpoints

- To validate an API key, use `POST /api/v1/api_keys/validate`
- To list all apps with their API keys, use `GET /api/v1/developers/apps?email={email}`
- To view app details including API keys, use `GET /api/v1/developers/apps/:id`

