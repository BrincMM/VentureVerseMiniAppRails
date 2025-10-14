# Developer Update Password API

This API endpoint allows developers to update their password.

## Endpoint

```
PATCH /api/v1/developers/update_password
```

## Authentication

Requires API Key in the Authorization header:
```
Authorization: Bearer YOUR_API_KEY
```

## Request Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| email     | string | Yes      | Developer's email address |
| password  | string | Yes      | New password (minimum 6 characters) |

## Request Example

```json
{
  "email": "developer@example.com",
  "password": "newpassword123"
}
```

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "Password updated successfully",
  "data": {
    "developer": {
      "id": 1,
      "email": "developer@example.com",
      "name": "John Developer",
      "github": "johndeveloper",
      "status": "active",
      "role": "developer",
      "sign_in_count": 5,
      "current_sign_in_at": "2025-10-09T10:15:30.123Z",
      "last_sign_in_at": "2025-10-08T14:20:10.456Z",
      "created_at": "2025-10-01T08:00:00.000Z",
      "updated_at": "2025-10-09T11:00:00.789Z"
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
  "message": "Failed to update password",
  "errors": [
    "Password can't be blank",
    "Password is too short (minimum is 6 characters)"
  ]
}
```

## Validation Rules

1. Email must match an existing developer account
2. Password must be at least 6 characters
3. The new password is automatically hashed using bcrypt before storage

## Notes

- This endpoint does not require the old password for verification
- Typically used after password reset verification
- For security reasons, consider requiring additional verification before allowing password updates



