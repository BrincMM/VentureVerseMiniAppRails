# Create Credit Spent API

Calculates the required credit amount for a given cost. This can be used for both estimation and actual spending.

**URL** : `/api/v1/credit_spents`

**Method** : `POST`

## Request Parameters

| Parameter   | Type    | Required | Description |
|------------|---------|----------|-------------|
| cost       | number  | Yes      | Cost in USD |
| type       | string  | Yes      | Type of spending. Possible values: ["app_usage", "content_procurement", "perks_procurement", "nft_procurement"] |
| user_id    | number  | Yes      | User ID |
| estimation | boolean | No       | If true, only returns estimated credit amount. If false, creates a credit spent record. Default: false |

## Request Example

```json
{
  "cost": 0.5,
  "type": "content_procurement",
  "user_id": 123,
  "estimation": true
}
```

## Success Response

### For Estimation (estimation: true)

**Code** : `200 OK`

```json
{
  "success": true,
  "message": "Credit amount calculated successfully",
  "data": {
    "credit_required": 85,
    "user": {
      "id": 123,
      "monthly_credit_balance": 1000.0,
      "topup_credit_balance": 500.0
    }
  }
}
```

### For Actual Spending (estimation: false)

**Code** : `201 Created`

```json
{
  "success": true,
  "message": "Credit spent record created successfully",
  "data": {
    "credits": 85,
    "credit_spent_record": {
      "id": 1,
      "user_id": 123,
      "cost_in_usd": 0.5,
      "credits": 85,
      "spend_type": "content_procurement",
      "timestamp": "2024-03-19T10:30:00Z",
      "created_at": "2024-03-19T10:30:00Z",
      "updated_at": "2024-03-19T10:30:00Z"
    },
    "user": {
      "id": 123,
      "monthly_credit_balance": 1000.0,
      "topup_credit_balance": 500.0
    }
  }
}
```

## Error Response

**Condition** : If parameters are invalid or user not found.

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Invalid parameters",
  "errors": [
    "Cost must be greater than 0",
    "Type must be one of: app_usage, content_procurement, perks_procurement, nft_procurement",
    "User not found"
  ]
}
```

## Notes

- Current credit pricing is 0.01 USD per credit
- The API adds a 70% markup on the cost. For example:
  - If cost is 0.5 USD:
  - Marked up cost = 0.5 × 1.7 = 0.85 USD
  - Credit amount = 0.85 ÷ 0.01 = 85 credits
- Credit amount is always rounded up to the nearest integer