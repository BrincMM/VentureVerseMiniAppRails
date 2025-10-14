# Developer Update Profile API

This API endpoint allows developers to update their profile information.

## Endpoint

```
PATCH /api/v1/developers/:developer_id/profile
```

## Authentication

Requires API Key in the Authorization header:
```
Authorization: Bearer YOUR_API_KEY
```

## URL Parameters

| Parameter    | Type    | Required | Description |
|--------------|---------|----------|-------------|
| developer_id | integer | Yes      | Developer's ID |

## Request Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| name      | string | No       | Developer's full name |
| github    | string | No       | GitHub profile URL |

## Request Example

```bash
PATCH /api/v1/developers/1/profile
```

```json
{
  "name": "John Updated Developer",
  "github": "https://github.com/johndev"
}
```

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "developer": {
      "id": 1,
      "email": "developer@example.com",
      "name": "John Updated Developer",
      "github": "https://github.com/johndev",
      "status": "active",
      "role": "developer",
      "sign_in_count": 15,
      "current_sign_in_at": "2025-10-09T10:15:30.123Z",
      "last_sign_in_at": "2025-10-08T14:20:10.456Z",
      "created_at": "2025-10-01T08:00:00.000Z",
      "updated_at": "2025-10-09T12:30:45.789Z"
    }
  }
}
```

## Error Response

### Status Code: 404 Not Found

```json
{
  "success": false,
  "message": "Developer not found",
  "errors": null
}
```

### Status Code: 422 Unprocessable Entity

```json
{
  "success": false,
  "message": "Failed to update profile",
  "errors": [
    "Github must be a valid URL"
  ]
}
```

## Validation Rules

1. Developer ID must match an existing developer account
2. If provided, github must be a valid URL

## Notes

- Only include the fields you want to update in the request
- Omitted fields will remain unchanged
- The developer_id in the URL identifies which developer to update
- The `updated_at` timestamp is automatically updated on successful changes

## Example: Update Only Name

```bash
PATCH /api/v1/developers/1/profile
```

```json
{
  "name": "New Name Only"
}
```

## Example: Update Only GitHub

```bash
PATCH /api/v1/developers/1/profile
```

```json
{
  "github": "https://github.com/newgithubusername"
}
```

## Example: Update Both

```bash
PATCH /api/v1/developers/1/profile
```

```json
{
  "name": "Full Name Update",
  "github": "https://github.com/updatedgithub"
}
```

## Protected Fields

The following fields **cannot** be updated through this endpoint:
- `email` - For security, email changes require a separate verification process
- `password` - Use `/api/v1/developers/update_password` endpoint instead
- `status` - Can only be changed by administrators
- `role` - Can only be changed by administrators
- `sign_in_count`, `sign_in_at`, `sign_in_ip` - Automatically managed by the system



