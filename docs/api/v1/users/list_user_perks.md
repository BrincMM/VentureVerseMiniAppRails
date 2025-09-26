# List User Perks

Retrieves all perks accessible to a specific user with optional filtering and pagination.

**URL** : `/api/v1/users/:user_id/perks`

**Method** : `GET`

## Request Example

```http
GET /api/v1/users/1/perks?category=Technology&tags=remote&per_page=10&page=1
```

## Parameters

| Parameter | Type   | Required | Description                                      |
|-----------|--------|----------|--------------------------------------------------|
| user_id   | number | Yes      | ID of the user                                   |
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
  "message": "User perks retrieved successfully",
  "data": {
    "perks": [
      {
        "id": 2,
        "partner_name": "Beta Partner",
        "category": "Finance",
        "sector": "Banking",
        "company_website": "https://beta.example.com",
        "contact_email": "contact@beta.example.com",
        "contact": "Bob",
        "tags": ["wellness"],
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

## Error Responses

**Condition** : User not found.

**Code** : `404 NOT FOUND`

```json
{
  "success": false,
  "message": "User not found",
  "errors": [
    "User does not exist"
  ]
}
```

**Condition** : Invalid pagination parameters.

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

- `has_next`, `total_count`, `total_pages`, `per_page`, `current_page` 字段与全局分页约定一致。
- 结果按 `partner_name` 升序，其次 `id` 升序排序。



