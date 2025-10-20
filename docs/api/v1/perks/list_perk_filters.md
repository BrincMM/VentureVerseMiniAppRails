# List Perk Filters

Retrieves the available categories, sectors, and tags for perks based on the provided filters.

**URL** : `/api/v1/perks/filters`

**Method** : `GET`

## Request Example

```http
GET /api/v1/perks/filters HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Accept: application/json
```

## Parameters

| Parameter | Type   | Required | Description                                      |
|-----------|--------|----------|--------------------------------------------------|
| category_id | number | No       | Filter the aggregation to a specific category    |
| sector_id   | number | No       | Filter the aggregation to a specific sector      |
| tags        | string | No       | Filter the aggregation by tags (comma-separated) |

## Success Response

**Code** : `200 OK`

**Response example**

```json
{
  "success": true,
  "message": "Perk filters retrieved successfully",
  "data": {
    "used_categories": [
      {
        "id": 1,
        "name": "Technology",
        "count": 3
      }
    ],
    "used_sectors": [
      {
        "id": 2,
        "name": "AI",
        "count": 2
      }
    ],
    "used_tags": [
      {
        "name": "remote",
        "count": 2
      }
    ]
  }
}
```

## Notes

- Aggregated results respect the same filtering logic as `/api/v1/perks`.
- `count` represents how many perks match the filters for that category, sector, or tag.
- When no matching records are found, arrays are returned empty.

