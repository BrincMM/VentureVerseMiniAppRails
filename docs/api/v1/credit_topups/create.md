# Create Credit Topup API

Creates a credit topup record and updates the user's topup credit balance.

**URL** : `/api/v1/credit_topups`

**Method** : `POST`

## Request Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| user_id   | number | Yes      | User ID |
| credits   | number | Yes      | Amount of credits to add to user's topup balance. Must be greater than 0 |

## Request Example

```json
{
  "user_id": 123,
  "credits": 100.0
}
```

## Success Response

**Code** : `201 Created`

```json
{
  "success": true,
  "message": "Credit topup record created successfully",
  "data": {
    "credits": 100.0,
    "credit_topup_record": {
      "id": 1,
      "user_id": 123,
      "credits": 100.0,
      "timestamp": "2024-03-19T10:30:00Z",
      "created_at": "2024-03-19T10:30:00Z",
      "updated_at": "2024-03-19T10:30:00Z"
    },
    "user": {
      "id": 123,
      "monthly_credit_balance": 1000.0,
      "topup_credit_balance": 600.0
    }
  }
}
```

## Error Response

### Invalid Parameters

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Failed to create credit topup",
  "errors": [
    "Credits must be greater than 0"
  ]
}
```

### User Not Found

**Code** : `404 NOT FOUND`

```json
{
  "success": false,
  "message": "User not found",
  "errors": [
    "User not found"
  ]
}
```

## Notes

- Credits must be a positive number greater than 0
- The topup amount is added directly to the user's topup_credit_balance
- The operation is performed atomically to prevent race conditions
- Timestamp is automatically set to the current time when the record is created
