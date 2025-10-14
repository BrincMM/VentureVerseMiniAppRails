# Developer Get Profile API

This API endpoint retrieves the profile information of a developer.

## Endpoint

```
GET /api/v1/developers/profile
```

## Authentication

Requires API Key in the Authorization header:
```
Authorization: Bearer YOUR_API_KEY
```

## Request Parameters

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| email     | string | Yes      | Developer's email address (query parameter) |

## Request Example

```bash
GET /api/v1/developers/profile?email=developer@example.com
```

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "Profile retrieved successfully",
  "data": {
    "developer": {
      "id": 1,
      "email": "developer@example.com",
      "name": "John Developer",
      "github": "https://github.com/johndeveloper",
      "status": "active",
      "role": "developer",
      "sign_in_count": 15,
      "current_sign_in_at": "2025-10-09T10:15:30.123Z",
      "last_sign_in_at": "2025-10-08T14:20:10.456Z",
      "created_at": "2025-10-01T08:00:00.000Z",
      "updated_at": "2025-10-09T10:15:30.123Z"
    }
  }
}
```

## Error Response

### Status Code: 404 Not Found

```json
{
  "success": false,
  "message": "Developer not found",
  "errors": null
}
```

## Field Descriptions

| Field              | Type     | Description |
|--------------------|----------|-------------|
| id                 | integer  | Unique developer ID |
| email              | string   | Developer's email address |
| name               | string   | Developer's full name |
| github             | string   | GitHub profile URL (nullable) |
| status             | string   | Account status: "pending", "active", or "suspended" |
| role               | string   | Developer role (currently always "developer") |
| sign_in_count      | integer  | Total number of successful sign-ins |
| current_sign_in_at | datetime | Timestamp of the most recent sign-in |
| last_sign_in_at    | datetime | Timestamp of the previous sign-in |
| created_at         | datetime | Account creation timestamp |
| updated_at         | datetime | Last update timestamp |

## Status Values

- **pending**: Account created but email not confirmed
- **active**: Account is active and can be used
- **suspended**: Account has been suspended

## Notes

- Password hash is never included in the response
- IP addresses are not included in the profile response
- Use the email parameter to identify which developer's profile to retrieve



