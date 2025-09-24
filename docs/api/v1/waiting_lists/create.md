# Create Waiting List Entry API

Subscribes an email to the waiting list. If the email already exists, returns success without creating a duplicate entry.

**URL** : `/api/v1/waiting_lists`

**Method** : `POST`

## Request Parameters

| Parameter      | Type   | Required | Description |
|----------------|--------|----------|-------------|
| email          | string | Yes      | Email address to subscribe to the waiting list |
| subscribe_type | string | No       | Type of subscription. Possible values: ["email", "google"]. Default: "email" |
| name           | string | No       | Full name of the user (optional, will be used if provided) |
| first_name     | string | No       | First name of the user (optional) |
| last_name      | string | No       | Last name of the user (optional) |

When an existing waiting list entry is found by email, any provided `name`, `first_name`, or `last_name` parameters will update the stored record. Missing fields remain unchanged.

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

### Full Information Example
```json
{
  "email": "user@example.com",
  "subscribe_type": "email",
  "name": "John Doe",
  "first_name": "John",
  "last_name": "Doe"
}
```

### Explicit Name and First/Last Name Example
If you provide all three fields (`name`, `first_name`, and `last_name`), the API will:
- Save `name` as provided (after whitespace normalization)
- Use your provided `first_name` and `last_name` directly (they will not be overridden by splitting `name`)

#### Request
```json
{
  "email": "explicit@example.com",
  "subscribe_type": "email",
  "name": "Baz Qux Quux",
  "first_name": "Given",
  "last_name": "Family"
}
```

#### Response
```json
{
  "success": true,
  "message": "Successfully subscribed to waiting list",
  "data": {
    "email": "explicit@example.com",
    "subscribe_type": "email",
    "name": "Baz Qux Quux",
    "first_name": "Given",
    "last_name": "Family"
  }
}
```

> **Note:** If you omit `first_name` or `last_name`, the API will attempt to split the `name` field to fill in the missing values.

### Name Only Example
If you provide only the `name` field (without `first_name` or `last_name`), the API will attempt to split the name into first and last name components.

#### Request
```json
{
  "email": "nameonly@example.com",
  "subscribe_type": "email",
  "name": "Alice Bob Carol"
}
```

### Updating an Existing Entry Example
If the email already exists, sending another request with new personal details will update the stored values and return a `200 OK` response.

#### Request
```json
{
  "email": "user@example.com",
  "name": "Updated Name",
  "first_name": "Updated",
  "last_name": "Person"
}
```

#### Response
```json
{
  "success": true,
  "message": "Successfully subscribed to waiting list",
  "data": {
    "email": "user@example.com",
    "subscribe_type": "email",
    "name": "Updated Name",
    "first_name": "Updated",
    "last_name": "Person"
  }
}
```

#### Response
```json
{
  "success": true,
  "message": "Successfully subscribed to waiting list",
  "data": {
    "email": "nameonly@example.com",
    "subscribe_type": "email",
    "name": "Alice Bob Carol",
    "first_name": "Alice Bob",
    "last_name": "Carol"
  }
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
    "subscribe_type": "email",
    "name": "John Doe",
    "first_name": "John",
    "last_name": "Doe"
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
    "subscribe_type": "email",
    "name": "Updated Name",
    "first_name": "Updated",
    "last_name": "Person"
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

- The API now accepts optional fields: `name`, `first_name`, and `last_name` for richer user information.
- If both `name` and `first_name`/`last_name` are provided, `name` will be used as the full name.
- After a successful creation, the system will asynchronously sync the waiting list entry to Beehiiv. The API response is not affected by the result of this sync.
- Email validation follows standard email format requirements
- Duplicate email submissions return success (200 OK) to provide a consistent user experience
- If `subscribe_type` is not provided, it defaults to "email"
- Valid subscribe types are: "email" and "google"
- Authentication token is required for all requests
