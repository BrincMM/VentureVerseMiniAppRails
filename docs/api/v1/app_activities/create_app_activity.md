# Create App Activity

Creates a new app activity record.

**URL** : `/api/v1/app_activities`

**Method** : `POST`

## Request Parameters

| Parameter | Type   | Required | Description                    |
|-----------|--------|----------|--------------------------------|
| app_id    | integer| Yes      | ID of the app                  |
| action    | string | Yes      | Type of activity               |
| details   | object | No       | Additional activity details    |

## Request Example

```json
{
  "app_id": 1,
  "action": "view",
  "details": {
    "duration": "5m",
    "source": "recommendation"
  }
}
```

## Success Response

**Code** : `201 Created`

**Response example**

```json
{
  "success": true,
  "message": "App activity created successfully",
  "data": {
    "app_activity": {
      "id": 1,
      "app_id": 1,
      "user_id": 123,
      "action": "view",
      "details": {
        "duration": "5m",
        "source": "recommendation"
      },
      "created_at": "2024-03-20T08:34:14.289Z",
      "updated_at": "2024-03-20T08:34:14.289Z"
    }
  }
}
```

## Error Response

**Condition** : If provided parameters are invalid.

**Code** : `422 UNPROCESSABLE ENTITY`

**Content example**

```json
{
  "success": false,
  "message": "Failed to create app activity",
  "errors": [
    "App must exist",
    "Action can't be blank"
  ]
}
```

## Validation Rules

1. App must exist in the system
2. Action cannot be blank
3. User must be authenticated
4. Details must be a valid JSON object if provided