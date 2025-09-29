# Update Perk

Updates attributes of an existing perk.

**URL** : `/api/v1/perks/:id`

**Method** : `PATCH`

## Request Example

```http
PATCH /api/v1/perks/1 HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "perk": {
    "partner_name": "Updated Partner",
    "category": "Updated Category",
    "tags": "remote,global"
  }
}
```

## Parameters

| Parameter    | Type   | Required | Description                               |
|--------------|--------|----------|-------------------------------------------|
| id           | number | Yes      | ID of the perk to update                  |
| perk         | object | Yes      | Wrapper for attributes to be updated      |
| partner_name | string | No       | Updated partner name                      |
| category     | string | No       | Updated category                          |
| sector       | string | No       | Updated sector                            |
| company_website | string | No   | Updated company website                   |
| contact_email   | string | No   | Updated contact email                     |
| contact         | string | No   | Updated contact person                    |
| tags            | string | No   | Comma-separated list of tag names         |

## Success Response

**Code** : `200 OK`

**Response example**

```json
{
  "success": true,
  "message": "Perk updated successfully",
  "data": {
    "perk": {
      "id": 1,
      "partner_name": "Updated Partner",
      "category": "Updated Category",
      "sector": "AI",
      "company_website": "https://alpha.example.com",
      "contact_email": "contact@alpha.example.com",
      "contact": "Alice",
      "tags": ["global", "remote"],
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-02-01T00:00:00Z"
    }
  }
}
```

## Error Responses

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

**Condition** : Invalid parameters.

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Failed to update perk",
  "errors": [
    "Company website can't be blank"
  ]
}
```

## Notes

- Tags can be supplied as a comma-separated string or array; they are normalized before saving.
- Only supplied attributes are updated; omit fields to leave them unchanged.

