
# Inventory Management Service API

## Endpoints

### 1. Create a New Inventory Item
- **Endpoint:** `POST /inventory`
- **Description:** Creates a new inventory item.
- **Request Payload:**
  \`\`\`json
  {
    "productId": "string",
    "quantity": "integer",
    "location": "string"
  }
  \`\`\`
- **Response Payload:**
  \`\`\`json
  {
    "itemId": "string",
    "productId": "string",
    "quantity": "integer",
    "location": "string",
    "createdAt": "string"
  }
  \`\`\`
- **HTTP Status Codes:**
  - **201 Created:** The inventory item was successfully created.
  - **400 Bad Request:** The request was invalid or cannot be otherwise served.

### 2. Retrieve Inventory Item Details
- **Endpoint:** `GET /inventory/{itemId}`
- **Description:** Retrieves details of an inventory item by item ID.
- **Response Payload:**
  \`\`\`json
  {
    "itemId": "string",
    "productId": "string",
    "quantity": "integer",
    "location": "string",
    "createdAt": "string"
  }
  \`\`\`
- **HTTP Status Codes:**
  - **200 OK:** The request was successful and the inventory item details are returned.
  - **404 Not Found:** The requested inventory item was not found.

### 3. Update Inventory Item
- **Endpoint:** `PUT /inventory/{itemId}`
- **Description:** Updates an existing inventory item.
- **Request Payload:**
  \`\`\`json
  {
    "quantity": "integer",
    "location": "string"
  }
  \`\`\`
- **Response Payload:**
  \`\`\`json
  {
    "itemId": "string",
    "productId": "string",
    "quantity": "integer",
    "location": "string",
    "updatedAt": "string"
  }
  \`\`\`
- **HTTP Status Codes:**
  - **200 OK:** The inventory item was successfully updated.
  - **400 Bad Request:** The request was invalid or cannot be otherwise served.
  - **404 Not Found:** The requested inventory item was not found.

### 4. Delete Inventory Item
- **Endpoint:** `DELETE /inventory/{itemId}`
- **Description:** Deletes an inventory item by item ID.
- **HTTP Status Codes:**
  - **204 No Content:** The inventory item was successfully deleted.
  - **404 Not Found:** The requested inventory item was not found.
