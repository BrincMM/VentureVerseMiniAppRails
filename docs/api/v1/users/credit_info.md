# Get User Credit Info

Get user's credit information including tier details, credit balances, and remaining credit ratio.

**URL** : `/api/v1/users/profiles/:user_id/credit_info`

**Method** : `GET`

**Auth required** : YES

**Parameters**

| Name | Type | Description | Required |
|------|------|-------------|----------|
| user_id | integer | ID of the user | Yes |

## Success Response

**Code** : `200 OK`

**Content example**

```json
{
  "success": true,
  "message": "Credit info retrieved successfully",
  "data": {
    "user": {
      "tier": {
        "id": 1,
        "name": "Pro",
        "monthly_credit": 1000.0
      },
      "monthly_credit_balance": 800.0,
      "topup_credit_balance": 200.0,
      "remaining_ratio": 0.83
    }
  }
}
```

### Response Fields Explanation

| Field | Type | Description |
|-------|------|-------------|
| tier.id | integer | The ID of user's current tier |
| tier.name | string | The name of user's current tier |
| tier.monthly_credit | float | The total monthly credit allocation for this tier |
| monthly_credit_balance | float | User's remaining monthly credit balance |
| topup_credit_balance | float | User's remaining topup credit balance |
| remaining_ratio | float | Ratio of remaining credits to total available credits. Calculated as: (monthly_credit_balance + topup_credit_balance) / (monthly_credit + topup_credit_balance) |

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