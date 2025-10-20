# Update Perk

Updates attributes of an existing perk.

**URL** : `/api/v1/perks/:id`

**Method** : `PATCH`

## Request Examples

**Example 1: Using string format for tags**

```http
PATCH /api/v1/perks/1 HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "perk": {
    "partner_name": "Updated Partner",
    "category_id": 5,
    "tags": "remote,global"
  }
}
```

**Example 2: Using array format for tags**

```http
PATCH /api/v1/perks/1 HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "perk": {
    "partner_name": "Updated Partner",
    "category_id": 5,
    "tags": ["remote", "global"]
  }
}
```

## Parameters

| Parameter       | Type         | Required | Description                                                        |
|-----------------|--------------|----------|--------------------------------------------------------------------|
| id              | number       | Yes      | ID of the perk to update                                           |
| perk            | object       | Yes      | Wrapper for attributes to be updated                               |
| partner_name    | string       | No       | Updated partner name                                               |
| category_id     | number       | No       | Updated category ID                                                |
| sector_id       | number       | No       | Updated sector ID                                                  |
| company_website | string       | No       | Updated company website                                            |
| contact_email   | string       | No       | Updated contact email                                              |
| contact         | string       | No       | Updated contact person                                             |
| tags            | string/array | No       | Tags as comma-separated string (e.g., "ai,remote") or array (e.g., ["ai", "remote"]) |

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
      "category": {
        "id": 5,
        "name": "Updated Category"
      },
      "sector": {
        "id": 2,
        "name": "AI"
      },
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

