# Verify Password API

This API endpoint verifies if the provided email and password match.

## Endpoint

```
POST /api/v1/users/verify_password
```

## Request Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| email     | string | Yes      | User's email address |
| password  | string | Yes      | User's password |

## Request Example

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "User logged in",
  "data": {
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
    "top_up_credit_balance": 0.0,
    "tier_id": null,
    "user_roles": [
      "mentor",
      "investor"
    ],
    "created_at": "2025-07-29T08:34:14.289Z",
    "updated_at": "2025-07-29T08:34:14.289Z"
  }
}
```

## Error Response

### Status Code: 401 Unauthorized

```json
{
  "success": false,
  "message": "Invalid email or password"
}
```

## Validation Rules

1. Email must be a valid email format
2. Password cannot be blank 