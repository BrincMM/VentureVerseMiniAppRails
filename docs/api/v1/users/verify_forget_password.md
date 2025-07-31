# Verify Forget Password Code API

This API endpoint verifies the 6-digit code sent for password reset.

## Endpoint

```
POST /api/v1/users/verify_forget_password
```

## Request Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| email     | string | Yes      | User's email address |
| code      | number | Yes      | The 6-digit verification code |

## Request Example

```json
{
  "email": "user@example.com",
  "code": 123456
}
```

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "Code verified successfully",
  "data": {
    "email": "user@example.com"
  }
}
```

## Error Responses

### Invalid or Expired Code

**Code**: 401 Unauthorized

```json
{
  "success": false,
  "message": "Invalid or expired code"
}
```

### Missing Parameters

**Code**: 422 Unprocessable Entity

```json
{
  "success": false,
  "message": "Failed to verify code",
  "errors": [
    "Email and code are required"
  ]
}
```

## Notes

1. The verification code expires after 1 hour
2. Only the most recent code for a given email is valid
3. The code must be exactly 6 digits