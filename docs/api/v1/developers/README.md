# Developer API Documentation

This directory contains the API documentation for developer-related endpoints.

## Authentication

All Developer API endpoints require an API Key in the Authorization header:

```
Authorization: Bearer YOUR_API_KEY
```

## Available Endpoints

### Account Management

1. **[Developer Registration](register.md)**
   - `POST /api/v1/developers/register`
   - Create a new developer account

2. **[Verify Password (Login)](verify_password.md)**
   - `POST /api/v1/developers/verify_password`
   - Authenticate a developer and verify their password

3. **[Update Password](update_password.md)**
   - `PATCH /api/v1/developers/update_password`
   - Update developer's password

### Password Recovery

4. **[Forget Password](forget_password.md)**
   - `POST /api/v1/developers/forget_password`
   - Request a password reset verification code

5. **[Verify Forget Password](verify_forget_password.md)**
   - `POST /api/v1/developers/verify_forget_password`
   - Verify the password reset code

### Profile Management

6. **[Get Profile](get_profile.md)**
   - `GET /api/v1/developers/profile`
   - Retrieve developer profile information

7. **[Update Profile](update_profile.md)**
   - `PATCH /api/v1/developers/profile`
   - Update developer profile information

## Common Response Format

### Success Response

```json
{
  "success": true,
  "message": "Operation successful",
  "data": {
    "developer": { ... }
  }
}
```

### Error Response

```json
{
  "success": false,
  "message": "Error message",
  "errors": [ "Error detail 1", "Error detail 2" ]
}
```

## Status Codes

- `200 OK` - Successful GET/PATCH request
- `201 Created` - Successful POST request creating a resource
- `401 Unauthorized` - Missing or invalid API key, or invalid credentials
- `404 Not Found` - Resource not found
- `422 Unprocessable Entity` - Validation errors

## Developer Status

Developers can have one of the following statuses:

- **pending** - Account created but email not confirmed
- **active** - Account is active and can be used
- **suspended** - Account has been suspended

## Password Reset Flow

1. **Request Reset**: Call `POST /api/v1/developers/forget_password` with email
2. **Verify Code**: Call `POST /api/v1/developers/verify_forget_password` with email and code
3. **Update Password**: Call `PATCH /api/v1/developers/update_password` with email and new password

## Developer Model

```json
{
  "id": 1,
  "email": "developer@example.com",
  "name": "Developer Name",
  "github": "githubusername",
  "status": "active",
  "role": "developer",
  "sign_in_count": 10,
  "current_sign_in_at": "2025-10-09T10:15:30.123Z",
  "last_sign_in_at": "2025-10-08T14:20:10.456Z",
  "confirmed_at": "2025-10-01T08:00:00.000Z",
  "created_at": "2025-10-01T08:00:00.000Z",
  "updated_at": "2025-10-09T10:15:30.123Z"
}
```

## Notes

- All timestamps are in ISO 8601 format (UTC)
- Password fields are never included in responses
- Email addresses must be unique across all developers
- GitHub usernames must be unique if provided
- Passwords must be at least 6 characters long


