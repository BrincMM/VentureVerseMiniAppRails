# Developer Update Profile API

This API endpoint allows developers to update their profile information.

## Endpoint

```
PATCH /api/v1/developers/profile
```

## Authentication

Requires API Key in the Authorization header:
```
Authorization: Bearer YOUR_API_KEY
```

## Request Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| email     | string | Yes      | Developer's email address (for identification) |
| name      | string | No       | Developer's full name |
| github    | string | No       | GitHub username (must be unique) |

## Request Example

```json
{
  "email": "developer@example.com",
  "name": "John Updated Developer",
  "github": "johndev"
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
      "github": "johndev",
      "status": "active",
      "role": "developer",
      "sign_in_count": 15,
      "current_sign_in_at": "2025-10-09T10:15:30.123Z",
      "last_sign_in_at": "2025-10-08T14:20:10.456Z",
      "confirmed_at": "2025-10-01T08:00:00.000Z",
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
    "Github has already been taken"
  ]
}
```

## Validation Rules

1. Email must match an existing developer account
2. If provided, github username must be unique
3. Email cannot be changed through this endpoint (for security)

## Notes

- Only include the fields you want to update in the request
- Omitted fields will remain unchanged
- The email parameter is required to identify which developer to update, but the email itself cannot be changed
- To change the email address, a separate email change process should be implemented
- The `updated_at` timestamp is automatically updated on successful changes

## Example: Update Only Name

```json
{
  "email": "developer@example.com",
  "name": "New Name Only"
}
```

## Example: Update Only GitHub

```json
{
  "email": "developer@example.com",
  "github": "newgithubusername"
}
```

## Example: Update Both

```json
{
  "email": "developer@example.com",
  "name": "Full Name Update",
  "github": "updatedgithub"
}
```

## Protected Fields

The following fields **cannot** be updated through this endpoint:
- `email` - For security, email changes require a separate verification process
- `password` - Use `/api/v1/developers/update_password` endpoint instead
- `status` - Can only be changed by administrators
- `role` - Can only be changed by administrators
- `sign_in_count`, `sign_in_at`, `sign_in_ip` - Automatically managed by the system
- `confirmed_at` - Managed by the email confirmation process



