# Developer Disable App API

This API endpoint performs a soft delete on an app by setting its status to "disabled".

## Endpoint

```
DELETE /api/v1/developers/apps/:id
```

## Authentication

Requires API Key in the Authorization header:
```
Authorization: Bearer YOUR_API_KEY
```

## URL Parameters

| Parameter | Type    | Required | Description |
|-----------|---------|----------|-------------|
| id        | integer | Yes      | App ID |

## Request Example

```
DELETE /api/v1/developers/apps/123
```

No request body is required.

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "App disabled successfully",
  "data": {
    "app": {
      "id": 123,
      "status": "disabled"
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

If the status update fails (rare):

```json
{
  "success": false,
  "message": "Failed to disable app",
  "errors": [
    "Error message details"
  ]
}
```

## Behavior

### Soft Delete

This endpoint performs a **soft delete**, meaning:
- The app record is NOT physically removed from the database
- The app's status is changed to "disabled"
- All app data (name, description, etc.) is preserved
- All related records (api_keys, app_activities, etc.) are preserved
- The app can be re-enabled by updating its status to "active" via the update endpoint

### What Happens to Related Data

| Related Data     | Behavior |
|------------------|----------|
| API Keys         | Preserved (not revoked automatically) |
| App Activities   | Preserved |
| App Accesses     | Preserved |
| Category/Sector  | Preserved |
| Tags             | Preserved |

## Notes

- No ownership verification is performed (any valid API key can disable any app)
- This is a soft delete operation - the app still exists in the database
- To re-enable a disabled app, use `PATCH /api/v1/developers/apps/:id` with `status: "active"`
- To hard delete an app, manual database intervention is required
- API keys associated with the app are NOT automatically revoked
- Consider manually revoking API keys after disabling an app if needed

## Re-enabling a Disabled App

To re-enable a disabled app, use the update endpoint:

```
PATCH /api/v1/developers/apps/123

{
  "status": "active"
}
```

## Related Endpoints

- To update app status or other fields, use `PATCH /api/v1/developers/apps/:id`
- To view app details (including disabled apps), use `GET /api/v1/developers/apps/:id`
- To revoke API keys, see [API Keys documentation](./api_keys_destroy.md)

## Hard Delete vs Soft Delete

| Operation    | Method | Status Change | Database Record |
|--------------|--------|---------------|-----------------|
| Soft Delete  | DELETE | → disabled    | Preserved       |
| Hard Delete  | N/A    | N/A           | Removed         |

Currently, only soft delete is supported via the API. Hard delete requires direct database access.


