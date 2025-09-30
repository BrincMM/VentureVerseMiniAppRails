# Create Perk

Creates a new perk entry.

**URL** : `/api/v1/perks`

**Method** : `POST`

## Request Example

```http
POST /api/v1/perks HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "perk": {
    "partner_name": "Gamma Partner",
    "category_id": 1,
    "sector_id": 2,
    "company_website": "https://gamma.example.com",
    "contact_email": "contact@gamma.example.com",
    "contact": "Grace",
    "tags": "innovation,ai"
  }
}
```

## Parameters

| Parameter        | Type   | Required | Description                                            |
|------------------|--------|----------|--------------------------------------------------------|
| perk             | object | Yes      | Wrapper for perk attributes                            |
| partner_name     | string | Yes      | Name of the partner providing the perk                 |
| category_id      | number | Yes      | ID of the category associated with the perk            |
| sector_id        | number | Yes      | ID of the sector associated with the perk              |
| company_website  | string | Yes      | Company website URL                                    |
| contact_email    | string | Yes      | Contact email address                                  |
| contact          | string | Yes      | Contact person name                                    |
| tags             | string | No       | Comma-separated list of tag names                      |

## Success Response

**Code** : `201 CREATED`

**Response example**

```json
{
  "success": true,
  "message": "Perk created successfully",
  "data": {
    "perk": {
      "id": 10,
      "partner_name": "Gamma Partner",
      "category": {
        "id": 1,
        "name": "Technology"
      },
      "sector": {
        "id": 2,
        "name": "AI"
      },
      "company_website": "https://gamma.example.com",
      "contact_email": "contact@gamma.example.com",
      "contact": "Grace",
      "tags": ["ai", "innovation"],
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
  "message": "Failed to create perk",
  "errors": [
    "Partner name can't be blank"
  ]
}
```

## Notes

- Tags can be provided as a comma-separated string or array; they are normalized and stored as a unique list.
- Authentication via API token is required for all requests.

