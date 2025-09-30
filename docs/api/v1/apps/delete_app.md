# Delete App

Deletes an existing app.

**URL** : `/api/v1/apps/:id`

**Method** : `DELETE`

## Request Example

```http
DELETE /api/v1/apps/3 HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
```

## Parameters

No request body is required.

## Success Response

**Code** : `200 OK`

```json
{
  "success": true,
  "message": "App deleted successfully",
  "data": {
    "app": {
      "id": 3,
      "app_name": "Productivity Tool Pro",
      "description": "Adds advanced automation features",
      "category": {
        "id": 1,
        "name": "AI"
      },
      "sector": {
        "id": 2,
        "name": "Technology"
      },
      "link": "https://productivity.example.com",
      "tags": ["automation", "workflow"],
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2025-01-02T12:00:00Z"
    }
  }
}
```

## Error Response

Errors follow the shared `general/errors.json` format.

**Condition** : App not found.

**Code** : `404 NOT FOUND`

```json
{
  "success": false,
  "message": "App not found",
  "errors": [
    "App does not exist"
  ]
}
```

## Notes

- The response includes the deleted record for reference, even though it is no longer available.
- All error responses reuse `api/v1/general/errors.json.jbuilder`.

