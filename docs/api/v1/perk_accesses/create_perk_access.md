# Grant Perk Access

Grants a user access to a specific perk.

**URL** : `/api/v1/perk_accesses`

**Method** : `POST`

## Request Example

```http
POST /api/v1/perk_accesses HTTP/1.1
Content-Type: application/json
Authorization: Bearer YOUR_API_KEY

{
  "user_id": 1,
  "perk_id": 2
}
```

## Parameters

| Parameter | Type   | Required | Description             |
|-----------|--------|----------|-------------------------|
| user_id   | number | Yes      | ID of the user          |
| perk_id   | number | Yes      | ID of the perk          |

## Success Response

**Code** : `201 CREATED`

**Response example**

```json
{
  "success": true,
  "message": "Perk access granted successfully",
  "data": {
    "perk_access": {
      "id": 10,
      "user_id": 1,
      "perk_id": 2,
      "created_at": "2025-01-01T00:00:00Z"
    }
  }
}
```

## Error Responses

**Condition** : Missing parameters or invalid values.

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Invalid parameters",
  "errors": [
    "User ID and Perk ID are required"
  ]
}
```

**Condition** : User or perk not found.

**Code** : `404 NOT FOUND`

```json
{
  "success": false,
  "message": "User not found",
  "errors": [
    "User does not exist"
  ]
}
```

**Condition** : User already has access to the perk.

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Already has access",
  "errors": [
    "User already has access to this perk"
  ]
}
```

