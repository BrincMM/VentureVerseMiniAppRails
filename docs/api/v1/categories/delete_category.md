# Delete Category

Deletes the specified category.

**URL** : `/api/v1/categories/:id`

**Method** : `DELETE`

## Request Example

```http
DELETE /api/v1/categories/1 HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Accept: application/json
```

## Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| id        | number | Yes      | Category ID |

## Success Response

**Code** : `200 OK`

```json
{
  "success": true,
  "message": "Category deleted successfully",
  "data": {
    "category": {
      "id": 1,
      "name": "Technology",
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2025-01-01T00:00:00Z"
    }
  }
}
```

## Error Response

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

## Notes

- The response returns the deleted category payload for auditing purposes.
- Deletions are irreversible.

