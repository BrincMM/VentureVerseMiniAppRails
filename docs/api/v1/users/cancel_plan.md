# Cancel Plan API

Cancel the current subscription plan for a user.

## Endpoint

```
POST /api/v1/users/cancel_plan
```

## Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| user_id   | number | Yes      | The ID of the user whose plan should be canceled |

## Request Example

```http
POST /api/v1/users/cancel_plan HTTP/1.1
Authorization: Bearer <API_TOKEN>
Content-Type: application/json

{
  "user_id": 1
}
```

## Success Response

**Code**: 200 OK

**Response Body**:

> **Note:** Cancelling a plan updates only `stripe_info.subscription_status` to `canceled`. Fields on `users`, including `tier_id`, remain unchanged.

```json
{
  "success": true,
  "message": "Plan cancelled successfully",
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
      "tier_id": 1,
      "user_roles": ["founder"],
      "created_at": "2024-03-19T10:00:00Z",
      "updated_at": "2024-03-19T10:00:00Z",
      "stripe_info": {
        "stripe_customer_id": "cus_xxx",
        "subscription_id": "sub_xxx",
        "subscription_status": "canceled",
        "next_subscription_time": "2024-04-19T10:00:00Z"
      }
    }
  }
}
```

## Error Responses

### User Not Found

**Code**: 404 Not Found

**Response Body**:
```json
{
  "success": false,
  "message": "User not found",
  "errors": null
}
```

### No Active Subscription

**Code**: 422 Unprocessable Entity

**Response Body**:
```json
{
  "success": false,
  "message": "No active subscription found",
  "errors": null
}
```

### Failed to Cancel Plan

**Code**: 422 Unprocessable Entity

**Response Body**:
```json
{
  "success": false,
  "message": "Failed to cancel plan",
  "errors": [
    "Stripe customer can't be blank"
  ]
}
```

### Unauthorized

**Code**: 401 Unauthorized

**Response Body**:

```
HTTP Token: Access denied.
```