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

## Success Response

**Code**: 200 OK

**Response Body**:

```json
{
  "success": true,
  "message": "Plan cancelled successfully",
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "name": "John Doe",
      "tier": {
        "id": 1,
        "name": "Basic",
        "description": "Basic tier",
        "credit_amount": 100,
        "price": 10.0
      },
      "stripe_info": {
        "subscription_status": "canceled",
        "next_subscription_time": "2024-02-01T00:00:00.000Z"
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
  "errors": null,
  "data": null
}
```

### No Active Subscription

**Code**: 422 Unprocessable Entity

**Response Body**:
```json
{
  "success": false,
  "message": "No active subscription found",
  "errors": null,
  "data": null
}
```

### Failed to Cancel Plan

**Code**: 422 Unprocessable Entity

**Response Body**:
```json
{
  "success": false,
  "message": "Failed to cancel plan",
  "errors": ["Error message details"],
  "data": null
}
```