# List Tiers

Lists all active subscription tiers.

**URL** : `/api/v1/tiers`

**Method** : `GET`

## Request Example

```http
GET /api/v1/tiers
```

## Success Response

**Code** : `200 OK`

**Response example**

```json
{
  "success": true,
  "message": "Tiers retrieved successfully",
  "data": {
    "tiers": [
      {
        "id": 1,
        "name": "Basic",
        "stripe_price_id": "price_H5ggYwtDq5YPwR",
        "active": true,
        "monthly_tier_price": 9.99,
        "created_at": "2024-01-01T00:00:00Z",
        "updated_at": "2024-01-01T00:00:00Z"
      }
    ]
  }
}
```

## Notes

- Only active tiers are returned
- Results are ordered by monthly price (low to high)
- No pagination is implemented as the number of tiers is expected to be small
- The `monthly_tier_price` field represents the monthly subscription price in USD