# Memo API

A simple REST API for managing memos.

## Base URL

### Production

```text
https://your-api-domain.example.com
```

### Local Development

```text
http://localhost:8080
```

---

# Authentication

All endpoints require an API key. Send it with either `X-API-Key`:

```http
X-API-Key: your-api-key
```

or as a bearer token:

```http
Authorization: Bearer your-api-key
```

Configure one or more valid keys with the `API_KEYS` environment variable:

```bash
API_KEYS="first-key,second-key" dart run bin/server.dart
```

If `API_KEYS` is empty, the server fails to start so the API is not accidentally exposed without authentication.

---

# Memo Object

```json
{
  "id": "abc123",
  "title": "Shopping List",
  "content": "Milk, Bread, Eggs",
  "createdAt": "2026-06-06T12:34:56.789Z",
  "updatedAt": "2026-06-06T12:34:56.789Z"
}
```

| Field     | Type     | Description                       |
| --------- | -------- | --------------------------------- |
| id        | string   | Unique memo identifier            |
| title     | string   | Memo title                        |
| content   | string   | Memo content                      |
| createdAt | datetime | Creation timestamp (UTC)          |
| updatedAt | datetime | Last modification timestamp (UTC) |

---

# Endpoints

## Get All Memos

Returns all memos.

### Request

```http
GET /memos
```

### Example

```bash
curl https://your-api-domain.example.com/memos \
  -H "X-API-Key: your-api-key"
```

### Success Response

**Status Code**

```text
200 OK
```

**Body**

```json
[
  {
    "id": "abc123",
    "title": "Shopping List",
    "content": "Milk, Bread, Eggs",
    "createdAt": "2026-06-06T12:34:56.789Z",
    "updatedAt": "2026-06-06T12:34:56.789Z"
  }
]
```

---

## Get Memo By ID

Returns a specific memo.

### Request

```http
GET /memos/{id}
```

### Example

```bash
curl https://your-api-domain.example.com/memos/abc123 \
  -H "X-API-Key: your-api-key"
```

### Success Response

**Status Code**

```text
200 OK
```

### Error Response

**Status Code**

```text
404 Not Found
```

```json
{
  "error": "Memo not found."
}
```

---

## Create Memo

Creates a new memo.

### Request

```http
POST /memos
```

### Request Body

```json
{
  "title": "Shopping List",
  "content": "Milk, Bread, Eggs"
}
```

### Example

```bash
curl -X POST https://your-api-domain.example.com/memos \
  -H "X-API-Key: your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Shopping List",
    "content": "Milk, Bread, Eggs"
  }'
```

### Success Response

**Status Code**

```text
201 Created
```

**Body**

```json
{
  "id": "abc123",
  "title": "Shopping List",
  "content": "Milk, Bread, Eggs",
  "createdAt": "2026-06-06T12:34:56.789Z",
  "updatedAt": "2026-06-06T12:34:56.789Z"
}
```

### Error Response

**Status Code**

```text
400 Bad Request
```

```json
{
  "error": "Title is required."
}
```

---

## Update Memo

Updates an existing memo.

### Request

```http
PUT /memos/{id}
```

### Request Body

```json
{
  "title": "Updated Title",
  "content": "Updated Content"
}
```

### Example

```bash
curl -X PUT https://your-api-domain.example.com/memos/abc123 \
  -H "X-API-Key: your-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Updated Title",
    "content": "Updated Content"
  }'
```

### Success Response

**Status Code**

```text
200 OK
```

### Error Response

**Status Code**

```text
404 Not Found
```

```json
{
  "error": "Memo not found."
}
```

---

## Delete Memo

Deletes a memo.

### Request

```http
DELETE /memos/{id}
```

### Example

```bash
curl -X DELETE https://your-api-domain.example.com/memos/abc123 \
  -H "X-API-Key: your-api-key"
```

### Success Response

**Status Code**

```text
200 OK
```

**Body**

```json
{
  "message": "Memo deleted."
}
```

### Error Response

**Status Code**

```text
404 Not Found
```

```json
{
  "error": "Memo not found."
}
```

---

# Status Codes

| Code | Description                    |
| ---- | ------------------------------ |
| 200  | Request completed successfully |
| 201  | Resource created successfully  |
| 400  | Invalid request                |
| 401  | Missing or invalid API key     |
| 404  | Resource not found             |
| 500  | Internal server error          |

---

# Content Type

All requests and responses use JSON.

```http
Content-Type: application/json
```
