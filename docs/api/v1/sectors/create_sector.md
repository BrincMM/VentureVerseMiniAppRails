# Create Sector

Creates a new sector record.

**URL** : `/api/v1/sectors`

**Method** : `POST`

## Request Example

```http
POST /api/v1/sectors HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "sector": {
    "name": "Fintech"
  }
}
```

## Parameters

| Parameter | Type   | Required | Description                 |
|-----------|--------|----------|-----------------------------|
| sector    | object | Yes      | Wrapper for sector payload  |
| name      | string | Yes      | Sector name (unique)        |

## Success Response

**Code** : `201 CREATED`

```json
{
  "success": true,
  "message": "Sector created successfully",
  "data": {
    "sector": {
      "id": 3,
      "name": "Fintech",
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
  "message": "Failed to create sector",
  "errors": [
    "Name can't be blank"
  ]
}
```

## Notes

- Sector names are validated case-insensitively for uniqueness.
- Provide the wrapper key `sector` in the request payload.

