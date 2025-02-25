# 📊 Oracle SQL Inventory Management System

This project is an **Oracle SQL-based inventory management system** that keeps track of product stock levels and records daily transactions. It updates the product quantities based on different actions (`U`, `I`, `D`, `X`) recorded in a transaction table.

## 🚀 Features
- ✅ **Manages product inventory** using an SQL database
- ✅ **Automated stock updates** through daily transactions
- ✅ **Handles different actions** (`U` for update, `I` for increment/decrement, `D` for delete)
- ✅ **Automatically logs transaction status** in the `DAILYRUNshutinghsu` table
- ✅ **Uses PL/SQL to handle stock updates dynamically**

---

## 🛠️ Database Structure

### **Tables**
1️⃣ **`PRODUCTshutinghsu`** - Stores product inventory  
2️⃣ **`DAILYRUNshutinghsu`** - Records daily transactions and their statuses

### **Columns in `PRODUCTshutinghsu`**
| Column  | Data Type  | Description |
|---------|-----------|-------------|
| `prod_no` | `NUMBER(5) PRIMARY KEY` | Unique product identifier |
| `qty` | `NUMBER(10)` | Quantity in stock |

### **Columns in `DAILYRUNshutinghsu`**
| Column  | Data Type  | Description |
|---------|-----------|-------------|
| `product_no` | `NUMBER(5)` | Product ID |
| `action` | `CHAR(1)` | Action type (`U`, `I`, `D`) |
| `amount` | `NUMBER(4)` | Quantity change amount |
| `whendate` | `DATE` | Transaction date |
| `status` | `VARCHAR2(50)` | Status message |

---

## 📌 Actions & Behavior

| Action | Description |
|--------|-------------|
| **U (Update)** | If the product exists, updates `qty` to `amount`; otherwise, inserts a new product. |
| **I (Increment/Decrement)** | Increases or decreases the quantity based on `amount`. If the product doesn’t exist and `amount > 0`, it is inserted. |
| **D (Delete)** | Deletes the product if it exists. |
| **X (Invalid Action)** | Logs an error message. |
