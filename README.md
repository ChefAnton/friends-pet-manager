# friends-pet-manager
An AI built web app that manages a list of friends and their pets.

## Initial Prompt:

Friend’s Pet list web app.
Create a business specification for the following described system:

Frontend UI:
The system is a web app that allows users to log in and maintain a list of their friends and their pets, and the birthdays of their friends and pets.
- to use the system a user must be logged in.
  - if the user has no account, they will be prompted to create an account
  - An account creation feature is needed
    - user enters user name and password
    - password must be at least 8 characters and contain numbers and letters, with symbols optional.  Spaces are acceptable.
    - User details are kept in a database managed via CRUD APIs
  - After logging in the user will be directed to a page where they can maintain a list of people (first name, last name, gender, dob, description) and the pets they own (pet type, pet breed, pet name, dob, description).  
  - A person may have more than one pet.
  - Each user has their own unique list of friends and pets.
  - Friends and pets may be removed.
  - User and pet details are kept in a database, managed via CRUD APIs

Back-end of the system:
- back-end has a mysql database.
  - Design data model to satisfy UI requirements for users, friends, and pets.
    - Include audit data in each table with:
      - user who created or updated
      - time of create or update
      - action: create, update, delete
    - Each table should have an associated history table containing a history of creates, updates, and deletes.  The history tables should be populated using DB triggers.
- API is a simple spring boot application, with controllers for:
  - user creation and login
  - friend management
  - pet management
- API functions are simple CRUD operations.
