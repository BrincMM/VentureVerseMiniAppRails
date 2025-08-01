# List App Activities

Lists app activities with optional filtering and pagination.

**URL** : `/api/v1/app_activities`

**Method** : `GET`

## Request Example

```http
GET /api/v1/app_activities?app_id=1&action=view&per_page=10&page=1
```

## Parameters

| Parameter | Type    | Required | Description                                |
|-----------|---------|----------|--------------------------------------------|
| app_id    | integer | No       | Filter activities by app ID                |
| action    | string  | No       | Filter activities by action type           |
| per_page  | number  | No       | Number of records per page (max 100, default 10) |
| page      | number  | No       | Page number (default 1) |

## Success Response

**Code** : `200 OK`

**Response example**

```json
{
  "success": true,
  "message": "App activities retrieved successfully",
  "data": {
    "app_activities": [
      {
        "id": 1,
        "app_id": 1,
        "user_id": 123,
        "action": "view",
        "details": {
          "duration": "5m",
          "source": "recommendation"
        },
        "created_at": "2024-03-20T08:34:14.289Z",
        "updated_at": "2024-03-20T08:34:14.289Z"
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