# Update Password API

This API endpoint allows users to update their password by providing their email and new password.

## Endpoint

```
PATCH /api/v1/users/update_password
```

## Request Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| email     | string | Yes      | User's email address |
| password  | string | Yes      | User's new password |

## Request Example

```json
{
  "email": "user@example.com",
  "password": "new_password123"
}
```

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "Password updated successfully",
  "data": {
    "user": {
      "id": 987556849,
      "email": "user@example.com",
      "google_id": null,
      "first_name": "John",
      "last_name": "Doe",
      "country": "US",
      "age_consent": true,
      "avatar": "https://example.com/avatar.jpg",
      "nick_name": "johndoe123",
      "linkedIn": "https://linkedin.com/johndoe",
      "twitter": "https://twitter.com/johndoe",
      "monthly_credit_balance": 0.0,
      "topup_credit_balance": 0.0,
      "tier_id": null,
      "user_roles": [
        "mentor",
        "investor"
      ],
      "created_at": "2025-07-29T08:34:14.289Z",
      "updated_at": "2025-07-29T08:34:14.289Z"
    }
  }
}
```

## Error Responses

### Status Code: 404 Not Found

```json
{
  "success": false,
  "message": "User not found"
}
```

### Status Code: 422 Unprocessable Entity

```json
{
  "success": false,
  "message": "Failed to update password",
  "errors": [
    "Password is too short (minimum is 8 characters)"
  ]
}
```

## Validation Rules

1. Email must be a valid email format
2. Password must meet the application's password requirements
3. User must exist in the system 