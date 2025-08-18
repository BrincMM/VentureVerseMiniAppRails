# Update User Profile API

## Endpoint

```
PATCH /api/v1/users/:user_id/profile
```

## Description

Update the current user's profile information and roles. All fields are optional - only the provided fields will be updated.

## URL Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| user_id   | integer | yes   | ID of the user to update |

## Request Parameters

| Parameter  | Type   | Required | Description |
|------------|--------|----------|-------------|
| first_name | string | no       | User's first name |
| last_name  | string | no       | User's last name |
| country    | string | no       | User's country |
| avatar     | string | no       | URL to user's avatar image |
| nick_name  | string | no       | User's nickname (must be unique) |
| linkedIn   | string | no       | User's LinkedIn profile URL |
| twitter    | string | no       | User's Twitter profile URL |
| roles      | array  | no       | Array of roles. Valid values: ["founder", "mentor", "investor"]. Will replace existing roles. |

## Request Example

```json
{
  "first_name": "John",
  "last_name": "Doe",
  "country": "US",
  "avatar": "https://example.com/avatar.jpg",
  "nick_name": "johndoe",
  "linkedIn": "https://linkedin.com/in/johndoe",
  "twitter": "https://twitter.com/johndoe",
  "roles": ["founder", "mentor"]
}
```

## Response

### Success Response

**Code**: 200 OK

```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "google_id": null,
      "first_name": "John",
      "last_name": "Doe",
      "country": "US",
      "age_consent": true,
      "avatar": "https://example.com/avatar.jpg",
      "nick_name": "johndoe",
      "linkedIn": "https://linkedin.com/in/johndoe",
      "twitter": "https://twitter.com/johndoe",
      "monthly_credit_balance": 0.0,
      "topup_credit_balance": 0.0,
      "tier_id": null,
      "user_roles": ["founder", "mentor"],
      "created_at": "2025-07-29T08:34:14.289Z",
      "updated_at": "2025-07-29T08:34:14.289Z"
    }
  }
}
```

### Error Response

**Code**: 422 Unprocessable Entity

```json
{
  "success": false,
  "message": "Failed to update profile",
  "errors": [
    "First name can't be blank",
    "Nick name has already been taken"
  ]
}
```

## Validation Rules

1. `first_name` cannot be blank if provided
2. `nick_name` must be unique across all users if provided
3. `linkedIn`, `twitter`, and `avatar` must be valid URLs if provided
4. `roles` must contain valid role values if provided

## Example

```bash
curl -X PATCH \
  'http://api.example.com/api/v1/users/1/profile' \
  -H 'Content-Type: application/json' \
  -d '{
    "first_name": "John",
    "last_name": "Doe",
    "country": "US",
    "roles": ["founder", "mentor"]
  }'
```