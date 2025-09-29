# List Categories

Lists available categories with optional search and pagination.

**URL** : `/api/v1/categories`

**Method** : `GET`

## Request Example

```http
GET /api/v1/categories?search=tech&per_page=10&page=1 HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Accept: application/json
```

## Parameters

| Parameter | Type   | Required | Description                                      |
|-----------|--------|----------|--------------------------------------------------|
| search    | string | No       | Case-insensitive name filter                     |
| per_page  | number | No       | Records per page (default 10, maximum 100)       |
| page      | number | No       | Page number (default 1)                          |

## Success Response

**Code** : `200 OK`

```json
{
  "success": true,
  "message": "Categories retrieved successfully",
  "data": {
    "categories": [
      {
        "id": 1,
        "name": "Technology",
        "created_at": "2025-01-01T00:00:00Z",
        "updated_at": "2025-01-01T00:00:00Z"
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

Errors follow the shared `general/errors.json` format.

**Condition** : Invalid pagination input.

**Code** : `422 UNPROCESSABLE ENTITY`

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

- Results are sorted by `name` ascending, then `id`.
- Pagination metadata mirrors other list endpoints in the API.

