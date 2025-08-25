# Create Waiting List Entry API

Subscribes an email to the waiting list. If the email already exists, returns success without creating a duplicate entry.

**URL** : `/api/v1/waiting_lists`

**Method** : `POST`

## Request Parameters

| Parameter      | Type   | Required | Description |
|----------------|--------|----------|-------------|
| email          | string | Yes      | Email address to subscribe to the waiting list |
| subscribe_type | string | No       | Type of subscription. Possible values: ["email", "google"]. Default: "email" |

## Request Example

### Email Subscription
```json
{
  "email": "user@example.com",
  "subscribe_type": "email"
}
```

### Google Subscription
```json
{
  "email": "user@example.com",
  "subscribe_type": "google"
}
```

### Default (Email) Subscription
```json
{
  "email": "user@example.com"
}
```

## Success Response

### New Subscription

**Code** : `201 Created`

```json
{
  "success": true,
  "message": "Successfully subscribed to waiting list",
  "data": {
    "email": "user@example.com",
    "subscribe_type": "email"
  }
}
```

### Existing Subscription

**Code** : `200 OK`

```json
{
  "success": true,
  "message": "Successfully subscribed to waiting list",
  "data": {
    "email": "user@example.com",
    "subscribe_type": "email"
  }
}
```

## Error Response

### Missing Email Parameter

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Invalid parameters",
  "errors": [
    "Email is required"
  ]
}
```

### Invalid Email Format

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Failed to subscribe to waiting list",
  "errors": [
    "Email is invalid"
  ]
}
```

### Invalid Subscribe Type

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Invalid parameters",
  "errors": [
    "Subscribe type must be one of: email, google"
  ]
}
```

## Notes

- Email validation follows standard email format requirements
- Duplicate email submissions return success (200 OK) to provide a consistent user experience
- If `subscribe_type` is not provided, it defaults to "email"
- Valid subscribe types are: "email" and "google"
- Authentication token is required for all requests
