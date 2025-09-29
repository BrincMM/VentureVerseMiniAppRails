# Update Sector

Updates the name of an existing sector.

**URL** : `/api/v1/sectors/:id`

**Method** : `PATCH`

## Request Example

```http
PATCH /api/v1/sectors/1 HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "sector": {
    "name": "Deep Tech"
  }
}
```

## Parameters

| Parameter | Type   | Required | Description                |
|-----------|--------|----------|----------------------------|
| id        | number | Yes      | Sector ID                  |
| sector    | object | Yes      | Wrapper for updated fields |
| name      | string | No       | New sector name            |

## Success Response

**Code** : `200 OK`

```json
{
  "success": true,
  "message": "Sector updated successfully",
  "data": {
    "sector": {
      "id": 1,
      "name": "Deep Tech",
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2025-02-01T00:00:00Z"
    }
  }
}
```

## Error Responses

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

**Condition** : Validation fails.

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Failed to update sector",
  "errors": [
    "Name can't be blank"
  ]
}
```

## Notes

- Only supplied attributes are modified.
- Name uniqueness is case-insensitive.

