# List App Filters

Retrieves the available categories, sectors, and tags for apps based on the provided filters.

**URL** : `/api/v1/apps/filters`

**Method** : `GET`

## Request Example

```http
GET /api/v1/apps/filters HTTP/1.1
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
  "message": "App filters retrieved successfully",
  "data": {
    "used_categories": [
      {
        "id": 1,
        "name": "Technology",
        "count": 4
      }
    ],
    "used_sectors": [
      {
        "id": 2,
        "name": "AI",
        "count": 3
      }
    ],
    "used_tags": [
      {
        "name": "ai",
        "count": 3
      }
    ]
  }
}
```

## Notes

- Aggregated results respect the same filtering logic as `/api/v1/apps`.
- `count` represents how many apps match the filters for that category, sector, or tag.
- When no matching records are found, arrays are returned empty.

