# Developer Verify Password API

This API endpoint allows developers to authenticate and verify their password (login).

## Endpoint

```
POST /api/v1/developers/verify_password
```

## Authentication

Requires API Key in the Authorization header:
```
Authorization: Bearer YOUR_API_KEY
```

## Request Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| email     | string | Yes      | Developer's email address |
| password  | string | Yes      | Developer's password |

## Request Example

```json
{
  "email": "developer@example.com",
  "password": "password123"
}
```

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "Password verified successfully",
  "data": {
    "developer": {
      "id": 1,
      "email": "developer@example.com",
      "name": "John Developer",
      "github": "johndeveloper",
      "status": "active",
      "role": "developer",
      "sign_in_count": 6,
      "current_sign_in_at": "2025-10-09T10:15:30.123Z",
      "last_sign_in_at": "2025-10-08T14:20:10.456Z",
      "confirmed_at": "2025-10-01T08:00:00.000Z",
      "created_at": "2025-10-01T08:00:00.000Z",
      "updated_at": "2025-10-09T10:15:30.123Z"
    }
  }
}
```

## Error Response

### Status Code: 401 Unauthorized

```json
{
  "success": false,
  "message": "Invalid email or password",
  "errors": null
}
```

## Notes

- On successful authentication, the following fields are automatically updated:
  - `sign_in_count` is incremented by 1
  - `current_sign_in_at` is set to the current timestamp
  - `last_sign_in_at` is set to the previous `current_sign_in_at`
  - `current_sign_in_ip` is set to the request IP address
  - `last_sign_in_ip` is set to the previous `current_sign_in_ip`
- Failed login attempts do not update any tracking fields
- This endpoint can be used for both login and password verification scenarios


