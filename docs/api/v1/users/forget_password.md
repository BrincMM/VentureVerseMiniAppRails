# Forget Password API

This API endpoint generates a verification code when a user forgets their password.

## Endpoint

```
POST /api/v1/users/forget_password
```

## Request Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| email     | string | Yes      | User's email address |

## Request Example

```json
{
  "email": "user@example.com"
}
```

## Success Response

### Status Code: 201 Created

```json
{
  "success": true,
  "message": "Verification code sent successfully",
  "data": {
    "email": "user@example.com"
  }
}
```

## Error Responses

### User Not Found

**Code**: 404 Not Found

```json
{
  "success": false,
  "message": "User not found"
}
```

### Invalid Parameters

**Code**: 422 Unprocessable Entity

```json
{
  "success": false,
  "message": "Failed to create verification code",
  "errors": [
    "Email can't be blank"
  ]
}
```

## Notes

1. The verification code is a 6-digit number
2. The code is stored in the database and can be used for password reset
3. Each request generates a new code for the user