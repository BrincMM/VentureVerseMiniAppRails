# Add App Access

Grants access to one or more apps for a specific user.

**URL** : `/api/v1/apps/add_access`

**Method** : `POST`

## Request Example

```http
POST /api/v1/apps/add_access
Content-Type: application/json

{
  "user_id": 1,
  "app_ids": [1, 2, 3]
}
```

## Parameters
| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| user_id   | number | Required | The ID of the user to grant access |
| app_ids   | array  | Required | Array of app IDs to grant access to |

## Response

### Success Response
```json
{
  "success": true,
  "message": "Access granted successfully"
}
```

### Error Response
```json
{
  "success": false,
  "message": "Invalid parameters",
  "errors": ["User ID and App IDs are required"]
}
```

```json
{
  "success": false,
  "message": "User not found",
  "errors": ["User does not exist"]
}
```

```json
{
  "success": false,
  "message": "Invalid app IDs",
  "errors": ["One or more apps do not exist"]
}
```

## Status Codes
| Status Code | Description |
|-------------|-------------|
| 200 | Success |
| 404 | User or App not found |
| 422 | Invalid parameters or validation errors |