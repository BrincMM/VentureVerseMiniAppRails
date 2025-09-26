# Revoke Perk Access

Revokes an existing perk access record.

**URL** : `/api/v1/perk_accesses/:id`

**Method** : `DELETE`

## Request Example

```http
DELETE /api/v1/perk_accesses/10 HTTP/1.1
Authorization: Bearer YOUR_API_KEY
```

## Parameters

| Parameter | Type   | Required | Description                 |
|-----------|--------|----------|-----------------------------|
| id        | number | Yes      | ID of the perk access entry |

## Success Response

**Code** : `200 OK`

**Response example**

```json
{
  "success": true,
  "message": "Perk access revoked successfully",
  "data": {
    "perk_access": {
      "id": 10,
      "user_id": 1,
      "perk_id": 2
    }
  }
}
```

## Error Response

**Condition** : When the specified perk access does not exist.

**Code** : `404 NOT FOUND`

```json
{
  "success": false,
  "message": "Perk access not found",
  "errors": [
    "Perk access does not exist"
  ]
}
```



