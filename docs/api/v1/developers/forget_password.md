# Developer Forget Password API

This API endpoint initiates the password reset process by generating and sending a verification code.

## Endpoint

```
POST /api/v1/developers/forget_password
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

## Request Example

```json
{
  "email": "developer@example.com"
}
```

## Success Response

### Status Code: 201 Created

```json
{
  "success": true,
  "message": "Verification code sent successfully",
  "data": {
    "email": "developer@example.com"
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
  "message": "Failed to create verification code",
  "errors": [
    "Email is required"
  ]
}
```

## Validation Rules

1. Email must be provided
2. Email must match an existing developer account

## Notes

- A 6-digit verification code is generated (e.g., 123456)
- The verification code is valid for 1 hour from creation
- The code is stored in the `forget_passwords` table
- In production, an email with the verification code should be sent to the developer
- Multiple codes can be generated for the same email, but only the most recent one is valid
- Use the `/api/v1/developers/verify_forget_password` endpoint to verify the code

## Flow

1. Developer requests password reset
2. System generates a 6-digit code
3. Code is sent to developer's email (when email service is configured)
4. Developer uses the code with `/verify_forget_password` endpoint
5. After verification, developer can update password with `/update_password` endpoint



