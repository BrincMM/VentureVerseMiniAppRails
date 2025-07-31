# Remove App Access

Removes access to one or more apps for a specific user.

**URL** : `/api/v1/apps/remove_access`

**Method** : `DELETE`

## Request Example

```http
DELETE /api/v1/apps/remove_access
Content-Type: application/json

{
  "user_id": 1,
  "app_ids": [1, 2, 3]
}
```

## Parameters
| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| user_id   | number | Required | The ID of the user to remove access |
| app_ids   | array  | Required | Array of app IDs to remove access from |

## Response

### Success Response
```json
{
  "success": true,
  "message": "Access removed successfully"
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
  "message": "No access found",
  "errors": ["User does not have access to any of the specified apps"]
}
```

## Status Codes
| Status Code | Description |
|-------------|-------------|
| 200 | Success |
| 404 | User not found or no access found |
| 422 | Invalid parameters |