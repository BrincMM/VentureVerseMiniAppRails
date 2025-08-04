# Change Plan API

Changes a user's subscription plan and updates related information.

## Endpoint

```
POST /api/v1/users/change_plan
```

## Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| user_id | integer | Yes | The ID of the user |
| tier_id | integer | Yes | The ID of the new tier |
| subscription_id | string | Yes | The Stripe subscription ID |
| next_subscription_time | datetime | Yes | The next billing cycle date |
| stripe_customer_id | string | No | The Stripe customer ID (optional) |

## Success Response

**Code**: 200 OK

```json
{
  "success": true,
  "message": "Plan changed successfully",
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
      "linkedIn": null,
      "twitter": null,
      "monthly_credit_balance": 100.0,
      "topup_credit_balance": 0.0,
      "tier_id": 2,
      "user_roles": ["founder"],
      "created_at": "2024-03-19T10:00:00Z",
      "updated_at": "2024-03-19T10:00:00Z",
      "stripe_info": {
        "stripe_customer_id": "cus_xxx",
        "subscription_id": "sub_xxx",
        "subscription_status": "active",
        "next_subscription_time": "2024-04-19T10:00:00Z"
      }
    }
  }
}
```

## Error Responses

### User Not Found

**Code**: 404 Not Found

```json
{
  "success": false,
  "message": "User not found",
  "errors": null
}
```

### Tier Not Found

**Code**: 404 Not Found

```json
{
  "success": false,
  "message": "Tier not found",
  "errors": null
}
```

### Validation Error

**Code**: 422 Unprocessable Entity

```json
{
  "success": false,
  "message": "Failed to change plan",
  "errors": [
    "Subscription id can't be blank",
    "Next subscription time can't be blank"
  ]
}
```