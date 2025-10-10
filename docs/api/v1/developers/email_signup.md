# Developer Email Sign Up API

This API endpoint allows developers to register an account using their email and password.

## Endpoint

```
POST /api/v1/developers/email_signup
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
| password  | string | Yes      | Developer's password (minimum 6 characters) |
| name      | string | No       | Developer's full name |
| github    | string | No       | Developer's GitHub username (must be unique) |

## Request Example

```json
{
  "email": "developer@example.com",
  "password": "password123",
  "name": "John Developer",
  "github": "johndeveloper"
}
```

## Success Response

### Status Code: 201 Created

```json
{
  "success": true,
  "message": "Developer created successfully",
  "data": {
    "developer": {
      "id": 1,
      "email": "developer@example.com",
      "name": "John Developer",
      "github": "johndeveloper",
      "status": "pending",
      "role": "developer",
      "sign_in_count": 0,
      "current_sign_in_at": null,
      "last_sign_in_at": null,
      "confirmed_at": null,
      "created_at": "2025-10-09T08:34:14.289Z",
      "updated_at": "2025-10-09T08:34:14.289Z"
    }
  }
}
```

## Error Response

### Status Code: 422 Unprocessable Entity

```json
{
  "success": false,
  "message": "Failed to create developer",
  "errors": [
    "Email can't be blank",
    "Email is invalid",
    "Email has already been taken",
    "Password can't be blank",
    "Password is too short (minimum is 6 characters)",
    "Github has already been taken"
  ]
}
```

### Status Code: 401 Unauthorized

```json
{
  "error": "Unauthorized"
}
```

## Validation Rules

1. Email must be a valid email format
2. Email must be unique in the system
3. Password must be at least 6 characters
4. If provided, github username must be unique
5. New developers are created with status "pending" (requires email confirmation)
6. Default role is "developer"

## Notes

- After registration, the developer account will be in "pending" status until email confirmation
- A confirmation email will be sent to the provided email address (if email service is configured)
- The password is automatically hashed using bcrypt before storage



