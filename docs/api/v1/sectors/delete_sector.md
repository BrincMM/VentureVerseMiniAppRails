# Delete Sector

Deletes the specified sector.

**URL** : `/api/v1/sectors/:id`

**Method** : `DELETE`

## Request Example

```http
DELETE /api/v1/sectors/1 HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Accept: application/json
```

## Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| id        | number | Yes      | Sector ID   |

## Success Response

**Code** : `200 OK`

```json
{
  "success": true,
  "message": "Sector deleted successfully",
  "data": {
    "sector": {
      "id": 1,
      "name": "AI",
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2025-01-01T00:00:00Z"
    }
  }
}
```

## Error Response

Errors follow the shared `general/errors.json` format.

**Condition** : Sector not found.

**Code** : `404 NOT FOUND`

```json
{
  "success": false,
  "message": "Sector not found",
  "errors": [
    "Sector does not exist"
  ]
}
```

## Notes

- The response includes the deleted sector payload for reference.
- Deletions are irreversible.

