# Update Category

Updates the name of an existing category.

**URL** : `/api/v1/categories/:id`

**Method** : `PATCH`

## Request Example

```http
PATCH /api/v1/categories/1 HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "category": {
    "name": "Fintech"
  }
}
```

## Parameters

| Parameter | Type   | Required | Description                  |
|-----------|--------|----------|------------------------------|
| id        | number | Yes      | Category ID                  |
| category  | object | Yes      | Wrapper for updated content  |
| name      | string | No       | New category name            |

## Success Response

**Code** : `200 OK`

```json
{
  "success": true,
  "message": "Category updated successfully",
  "data": {
    "category": {
      "id": 1,
      "name": "Fintech",
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2025-02-01T00:00:00Z"
    }
  }
}
```

## Error Responses

Errors follow the shared `general/errors.json` format.

**Condition** : Category not found.

**Code** : `404 NOT FOUND`

```json
{
  "success": false,
  "message": "Category not found",
  "errors": [
    "Category does not exist"
  ]
}
```

**Condition** : Validation fails.

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Failed to update category",
  "errors": [
    "Name can't be blank"
  ]
}
```

## Notes

- Only the provided fields are updated; omit attributes to leave them unchanged.
- Name uniqueness is case-insensitive.

