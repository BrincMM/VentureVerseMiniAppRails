# Google Sign Up API

This API endpoint allows users to register using their Google account.

## Endpoint

```
POST /api/v1/users/google_signup
```

## Request Parameters

| Parameter    | Type    | Required | Description |
|-------------|---------|----------|-------------|
| email       | string  | Yes      | User's email address |
| google_id   | string  | Yes      | Google account ID |
| first_name  | string  | Yes      | User's first name |
| last_name   | string  | Yes      | User's last name |
| age_consent | boolean | Yes      | Must be true to indicate user is of legal age |
| country     | string  | No       | User's country code |
| nick_name   | string  | No       | User's nickname (must be unique) |
| linkedIn    | string  | No       | User's LinkedIn profile URL |
| twitter     | string  | No       | User's Twitter profile URL |
| avatar      | string  | No       | User's avatar URL |
| user_roles  | array   | No       | Array of roles. Possible values: ["founder", "mentor", "investor"] |

## Request Example

```json
{
  "email": "newuser@example.com",
  "google_id": "google123",
  "first_name": "John",
  "last_name": "Doe",
  "age_consent": true,
  "country": "US",
  "nick_name": "johndoe123",
  "linkedIn": "https://linkedin.com/johndoe",
  "twitter": "https://twitter.com/johndoe",
  "avatar": "https://example.com/avatar.jpg",
  "user_roles": ["founder", "mentor"]
}
```

## Success Response

### Status Code: 201 Created

```json
{
  "success": true,
  "message": "User created successfully",
  "data": {
    "user": {
      "id": 987556849,
      "email": "newuser@example.com",
      "google_id": "google123",
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
        "founder",
        "mentor"
      ],
      "created_at": "2025-07-29T08:34:14.306Z",
      "updated_at": "2025-07-29T08:34:14.306Z"
    }
  }
}
```

## Error Response

### Status Code: 422 Unprocessable Entity

```json
{
  "success": false,
  "message": "Failed to create user",
  "errors": [
    "Email has already been taken",
    "First name can't be blank",
    "Age consent must be accepted"
  ]
}
```

## Validation Rules

1. Email must be a valid email format
2. Email must be unique in the system
3. Google ID must be unique in the system
4. First name and last name cannot be blank
5. Age consent must be true
6. If provided, nick_name must be unique
7. If provided, linkedIn, twitter, and avatar must be valid URLs
8. If provided, user_roles must contain valid roles (founder, mentor, or investor) 