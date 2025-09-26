# List Perks

Lists available perks with optional filtering and pagination.

**URL** : `/api/v1/perks`

**Method** : `GET`

## Request Example

```http
GET /api/v1/perks?category=Technology&sector=AI&tags=remote,discount&per_page=10&page=1
```

## Parameters

| Parameter | Type   | Required | Description                                      |
|-----------|--------|----------|--------------------------------------------------|
| category  | string | No       | Filter perks by category                         |
| sector    | string | No       | Filter perks by sector                           |
| tags      | string | No       | Filter perks by tags (comma-separated)           |
| per_page  | number | No       | Number of records per page (max 100, default 10) |
| page      | number | No       | Page number (default 1)                          |

## Success Response

**Code** : `200 OK`

**Response example**

```json
{
  "success": true,
  "message": "Perks retrieved successfully",
  "data": {
    "perks": [
      {
        "id": 1,
        "partner_name": "Alpha Partner",
        "category": "Technology",
        "sector": "AI",
        "company_website": "https://alpha.example.com",
        "contact_email": "contact@alpha.example.com",
        "contact": "Alice",
        "tags": ["remote", "discount"],
        "created_at": "2024-01-01T00:00:00Z",
        "updated_at": "2024-01-01T00:00:00Z"
      }
    ],
    "has_next": false,
    "total_count": 1,
    "total_pages": 1,
    "per_page": 10,
    "current_page": 1
  }
}
```

## Error Response

**Condition** : If provided parameters are invalid.

**Code** : `422 UNPROCESSABLE ENTITY`

**Content example**

```json
{
  "success": false,
  "message": "Invalid parameters",
  "errors": [
    "Per page must be between 1 and 100"
  ]
}
```

## Notes

- `has_next` indicates whether there are more records available.
- `total_count` shows the total number of records matching the filter criteria.
- `total_pages` shows the total number of pages based on `per_page`.
- `current_page` shows the current page number.
- `per_page` shows the number of records per page.
- Results are ordered by partner name ascending, then ID ascending.
- Maximum page size is 100 records.

