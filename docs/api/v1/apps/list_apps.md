# List Apps

Lists available apps with optional filtering and pagination.

**URL** : `/api/v1/apps`

**Method** : `GET`

## Request Example

```http
GET /api/v1/apps?category_id=1&sector_id=2&tags=ai,machine-learning&per_page=10&page=1
```

## Parameters

| Parameter | Type   | Required | Description                                |
|-----------|--------|----------|--------------------------------------------|
| category_id | number | No    | Filter apps by category ID                 |
| sector_id   | number | No    | Filter apps by sector ID                   |
| tags      | string | No       | Filter apps by tags (comma-separated)      |
| per_page  | number | No       | Number of records per page (max 100, default 10) |
| page      | number | No       | Page number (default 1) |

## Success Response

**Code** : `200 OK`

**Response example**

```json
{
  "success": true,
  "message": "Apps retrieved successfully",
  "data": {
    "apps": [
      {
        "id": 1,
        "app_name": "Test App",
        "description": "A test application",
        "category": {
          "id": 1,
          "name": "AI"
        },
        "sector": {
          "id": 2,
          "name": "Technology"
        },
        "app_url": "https://example.com",
        "status": "active",
        "developer_id": null,
        "rate_limit_max_requests": 1000,
        "rate_limit_window_ms": 60000,
        "tags": ["ai", "machine-learning"],
        "created_at": "2024-01-01T00:00:00Z",
        "updated_at": "2024-01-01T00:00:00Z"
      }
    ],
    "has_next": true,
    "total_count": 100,
    "total_pages": 10,
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
    "Page size must be between 1 and 100"
  ]
}
```

## Notes

- `has_next` indicates whether there are more records available
- `total_count` shows the total number of records matching the filter criteria
- `total_pages` shows the total number of pages based on per_page value
- `current_page` shows the current page number
- `per_page` shows the number of records per page
- Results are ordered by creation date (newest first)
- Maximum page size is 100 records