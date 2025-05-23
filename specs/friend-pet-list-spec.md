# Friend’s Pet List Web App – Business Specification

## Table of Contents
- [Overview](#overview)
- [Actors & Roles](#actors--roles)
- [Functional Requirements](#functional-requirements)
  - [Authentication & Account Management](#authentication--account-management)
  - [Friend & Pet Management](#friend--pet-management)
- [Data Model](#data-model)
  - [Core Tables](#core-tables)
  - [History Tables & Triggers](#history-tables--triggers)
- [API Specification](#api-specification)
  - [Authentication](#authentication)
  - [Friend Management](#friend-management)
  - [Pet Management](#pet-management)
- [Security & Data Protection](#security--data-protection)
- [Non-Functional Requirements](#non-functional-requirements)

---

## Overview
The Friend’s Pet List Web App lets registered users maintain a personalized directory of their friends and each friend’s pets. Users can record first/last names, genders, dates of birth, and descriptions for both friends and pets. All data is private to each user.

---

## Actors & Roles

1. **Anonymous Visitor**  
   - View login screen  
   - View “Create Account” screen  

2. **Registered User**  
   - Log in with username & password  
   - Create, read, update, delete (“CRUD”) their own friends and pets  
   - Cannot access other users’ data  

---

## Functional Requirements

### Authentication & Account Management

1. **Login**  
   - Endpoint: `/users/login`  
   - Fields: Username, Password  
   - Validates credentials; on success returns JWT token  
   - On failure returns error message  

2. **Account Creation**  
   - Endpoint: `/users/register`  
   - Fields: Desired Username, Password, Confirm Password  
   - Password rules:  
     - ≥ 8 characters  
     - At least one letter and one digit (symbols & spaces allowed)  
     - Passwords must match  
   - On success redirects to login with confirmation  

---

### Friend & Pet Management

1. **Master Screen**  
   - Tabs: Friends | Pets  
   - Lists each friend/pet with key fields and Edit/Delete actions  
   - Buttons: Add Friend, Add Pet  

2. **Friend Form** (Add/Edit)  
   - Fields:  
     - First Name (required)  
     - Last Name (required)  
     - Gender (optional: Male/Female/Other)  
     - Date of Birth (optional)  
     - Description (optional, max 500 chars)  
   - Actions: Save, Cancel  

3. **Pet Form** (Add/Edit)  
   - Fields:  
     - Owner (select from existing friends)  
     - Pet Type (required)  
     - Breed (optional)  
     - Name (required)  
     - Date of Birth (optional)  
     - Description (optional, max 500 chars)  
   - Actions: Save, Cancel  

4. **Deletion**  
   - Confirmation dialog before delete  
   - On confirm, remove record via API  

---

## Data Model

### Core Tables

1. **Users**  
   - `user_id` PK, UUID  
   - `username` VARCHAR(100), UNIQUE, NOT NULL  
   - `password_hash` VARCHAR(255), NOT NULL  
   - `created_at` DATETIME, NOT NULL  
   - `updated_at` DATETIME, NOT NULL  

2. **Friends**  
   - `friend_id` PK, UUID  
   - `user_id` FK → Users.user_id, NOT NULL  
   - `first_name` VARCHAR(100), NOT NULL  
   - `last_name` VARCHAR(100), NOT NULL  
   - `gender` ENUM('Male','Female','Other'), NULL  
   - `dob` DATE, NULL  
   - `description` TEXT, NULL  
   - **Audit columns**:  
     - `audit_user_id` VARCHAR(100), NOT NULL  
     - `audit_timestamp` DATETIME, NOT NULL  
     - `audit_action` ENUM('CREATE','UPDATE','DELETE'), NOT NULL  

3. **Pets**  
   - `pet_id` PK, UUID  
   - `friend_id` FK → Friends.friend_id, NOT NULL  
   - `pet_type` VARCHAR(100), NOT NULL  
   - `breed` VARCHAR(100), NULL  
   - `name` VARCHAR(100), NOT NULL  
   - `dob` DATE, NULL  
   - `description` TEXT, NULL  
   - **Audit columns**:  
     - `audit_user_id` VARCHAR(100), NOT NULL  
     - `audit_timestamp` DATETIME, NOT NULL  
     - `audit_action` ENUM('CREATE','UPDATE','DELETE'), NOT NULL  

---

### History Tables & Triggers

For **Friends_History** and **Pets_History**:  
- **Columns**:  
  - `history_id` PK, AUTO‐INCREMENT  
  - All columns from the core table (including audit columns)  
  - `operation_by` VARCHAR(100), NOT NULL  
  - `operation_ts` DATETIME, NOT NULL  
  - `operation_type` ENUM('CREATE','UPDATE','DELETE'), NOT NULL  

- **DB Triggers** on main tables:  
  - AFTER INSERT → record CREATE  
  - AFTER UPDATE → record UPDATE  
  - AFTER DELETE → record DELETE  

---

## API Specification

Base URL: `/api/v1`  
All responses JSON. Standard HTTP status codes apply.

### Authentication

- **POST /users/register**  
  - Request: `{ "username": "...", "password": "..." }`  
  - 201 Created / 400 Bad Request / 409 Conflict  

- **POST /users/login**  
  - Request: `{ "username": "...", "password": "..." }`  
  - 200 OK `{ "token": "JWT..." }` / 401 Unauthorized  

---

### Friend Management (JWT required)

- **GET /friends** → list all friends for current user  
- **GET /friends/{friendId}** → get one friend  
- **POST /friends** → create friend  
- **PUT /friends/{friendId}** → update friend  
- **DELETE /friends/{friendId}** → delete friend  

---

### Pet Management (JWT required)

- **GET /pets** → list all pets for current user  
- **GET /pets/{petId}** → get one pet  
- **POST /pets** → create pet  
- **PUT /pets/{petId}** → update pet  
- **DELETE /pets/{petId}** → delete pet  

---

## Security & Data Protection

1. **Password Storage**: bcrypt/Argon2 with per-user salt  
2. **Authentication**: JWT with expiration (e.g. 1 hr)  
3. **Authorization**: Verify resource ownership on every request  
4. **Transport**: HTTPS enforced  

---

## Non-Functional Requirements

- **Performance**:  
  - Page load < 2 sec  
  - API response < 200 ms  

- **Scalability**:  
  - Stateless Spring Boot, horizontal scaling  

- **Maintainability**:  
  - Clear code layering (controller/service/repository)  
  - Well-commented, modular functions  

- **Audit & Compliance**:  
  - All changes recorded in history tables  
  - Retention per policy (e.g. GDPR)  
