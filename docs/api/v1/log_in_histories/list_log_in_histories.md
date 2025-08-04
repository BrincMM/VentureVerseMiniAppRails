# List Login Histories

Retrieves a paginated list of login histories with optional filters.

**URL**: `/api/v1/log_in_histories`

**Method**: `GET`

**Authentication required**: Yes

## Query Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| user_id | number | No | Filter by user ID |
| start_date | string | No | Filter login histories after this date (inclusive). Format: ISO 8601 |
| end_date | string | No | Filter login histories before this date (inclusive). Format: ISO 8601 |
| page | number | No | Page number for pagination (default: 1) |
| per_page | number | No | Number of items per page (default: 10, max: 100) |

## Success Response

**Code**: `200 OK`

```json
{
  "success": true,
  "message": "Login histories retrieved successfully",
  "data": {
    "log_in_histories": [
      {
        "id": 1,
        "user_id": 1,
        "timestamp": "2024-01-01T12:00:00Z",
        "metadata": "{\"browser\":\"Chrome\",\"ip\":\"127.0.0.1\"}",
        "created_at": "2024-01-01T12:00:00Z",
        "updated_at": "2024-01-01T12:00:00Z"
      }
    ],
    "has_next": false,
    "total_count": 50,
    "total_pages": 5,
    "current_page": 1,
    "per_page": 10
  }
}
```

## Error Response

### Invalid Pagination Parameters

**Code**: `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Invalid parameters",
  "errors": [
    "Per page must be between 1 and 100"
  ]
}
```

### Invalid Date Format

**Code**: `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Invalid date format",
  "errors": [
    "Start date and end date must be valid dates"
  ]
}
```