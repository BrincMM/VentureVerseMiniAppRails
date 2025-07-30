# Get User Profile

Get user profile by email.

**URL** : `/api/v1/users/profile`

**Method** : `GET`

**Auth required** : NO

**Parameters**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| email | string | User's email address | Yes |

## Success Response

**Code** : `200 OK`

**Content example**

```json
{
  "status": "success",
  "message": "Profile retrieved successfully",
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "google_id": null,
      "first_name": "John",
      "last_name": "Doe",
      "country": "US",
      "age_consent": true,
      "avatar": null,
      "nick_name": "johndoe",
      "linkedIn": "https://linkedin.com/in/johndoe",
      "twitter": "https://twitter.com/johndoe",
      "monthly_credit_balance": 100.0,
      "top_up_credit_balance": 50.0,
      "tier_id": 1,
      "user_roles": ["user"],
      "created_at": "2024-01-01T00:00:00.000Z",
      "updated_at": "2024-01-01T00:00:00.000Z"
    }
  }
}
```

## Error Response

**Condition** : If user is not found.

**Code** : `404 NOT FOUND`

**Content** :

```json
{
  "success": false,
  "message": "User not found"
}
``` 