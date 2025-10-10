# Developer Verify Forget Password API

This API endpoint verifies the password reset verification code sent via email.

## Endpoint

```
POST /api/v1/developers/verify_forget_password
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
| code      | string | Yes      | 6-digit verification code |

## Request Example

```json
{
  "email": "developer@example.com",
  "code": "123456"
}
```

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "Code verified successfully",
  "data": {
    "email": "developer@example.com"
  }
}
```

## Error Response

### Status Code: 401 Unauthorized

```json
{
  "success": false,
  "message": "Invalid or expired code",
  "errors": null
}
```

### Status Code: 422 Unprocessable Entity

```json
{
  "success": false,
  "message": "Failed to verify code",
  "errors": [
    "Email and code are required"
  ]
}
```

## Validation Rules

1. Both email and code must be provided
2. The code must match the most recent code generated for the email
3. The code must have been created within the last 1 hour
4. Only the most recent code for an email is considered valid

## Notes

- Verification codes expire after 1 hour
- If multiple codes are generated for the same email, only the most recent one is valid
- After successful verification, use the `/api/v1/developers/update_password` endpoint to set a new password
- Codes are not automatically deleted after verification, allowing for multiple verification attempts

## Password Reset Flow

1. Request code: `POST /api/v1/developers/forget_password`
2. **Verify code: `POST /api/v1/developers/verify_forget_password`** (This endpoint)
3. Update password: `PATCH /api/v1/developers/update_password`

## Example Codes

The system generates 6-digit codes ranging from `100000` to `999999`.

Examples:
- `123456`
- `987654`
- `555123`


