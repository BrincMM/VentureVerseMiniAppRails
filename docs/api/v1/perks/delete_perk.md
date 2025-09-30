# Delete Perk

Deletes an existing perk.

**URL** : `/api/v1/perks/:id`

**Method** : `DELETE`

## Request Example

```http
DELETE /api/v1/perks/1 HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Accept: application/json
```

## Parameters

| Parameter | Type   | Required | Description             |
|-----------|--------|----------|-------------------------|
| id        | number | Yes      | ID of the perk to delete |

## Success Response

**Code** : `200 OK`

**Response example**

```json
{
  "success": true,
  "message": "Perk deleted successfully",
  "data": {
    "perk": {
      "id": 1,
      "partner_name": "Alpha Partner",
      "category": {
        "id": 1,
        "name": "Technology"
      },
      "sector": {
        "id": 2,
        "name": "AI"
      },
      "company_website": "https://alpha.example.com",
      "contact_email": "contact@alpha.example.com",
      "contact": "Alice",
      "tags": ["remote", "discount"],
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  }
}
```

## Error Response

Errors follow the shared `general/errors.json` format.

**Condition** : Perk not found.

**Code** : `404 NOT FOUND`

```json
{
  "success": false,
  "message": "Perk not found",
  "errors": [
    "Perk does not exist"
  ]
}
```

## Notes

- The response includes a snapshot of the perk data (including tags) before deletion for auditing.
- Authentication via API token is required for all requests.

