# Create Category

Creates a new category record.

**URL** : `/api/v1/categories`

**Method** : `POST`

## Request Example

```http
POST /api/v1/categories HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "category": {
    "name": "Marketing"
  }
}
```

## Parameters

| Parameter | Type   | Required | Description                    |
|-----------|--------|----------|--------------------------------|
| category  | object | Yes      | Wrapper for category payload   |
| name      | string | Yes      | Category name (must be unique) |

## Success Response

**Code** : `201 CREATED`

```json
{
  "success": true,
  "message": "Category created successfully",
  "data": {
    "category": {
      "id": 3,
      "name": "Marketing",
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2025-01-01T00:00:00Z"
    }
  }
}
```

## Error Response

Errors follow the shared `general/errors.json` format.

**Condition** : Missing or invalid parameters.

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Failed to create category",
  "errors": [
    "Name can't be blank"
  ]
}
```

## Notes

- Category names are validated case-insensitively for uniqueness.
- Provide the wrapper key `category` in the request payload.

