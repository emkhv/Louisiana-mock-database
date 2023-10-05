# Louisiana Museum Mock Database

## Overview

The Louisiana Museum Mock Database is a simulated database designed to emulate the data management needs of the Louisiana Museum of Modern Art in Denmark. This mock database provides a structured and efficient way to simulate the storage, retrieval, and management of artwork information, artists, exhibitions, and more as if it were the real Louisiana Museum database.
![Uploading poster.png…]()

## Features
1. **Comprehensive Data Structure:** Organized into 15 tables, covering events, artworks, memberships, payments, and more.
2. **Data Integrity:** Enforced through foreign key constraints to maintain data relationships.
3. **Last Update Tracking:** Records the last update timestamp for auditing and monitoring changes.
4. **Data Entry Convenience:** User-friendly functions simplify data insertion, such as `insert_address` and `insert_artwork`.
5. **Security and Access Control:** Implements role-based access control and schema isolation for data protection.
6. **Triggers and Functions:** Uses triggers and PL/pgSQL functions to automate tasks and enhance functionality.
7. **Data Analysis and Reporting:** Supports complex SQL queries for data analysis and reporting.

## Functions

The Louisiana Museum Mock Database includes the following custom functions:

### Automatic Last Update

- **Function Name:** [`last_updated`](2.last_update_column.sql)
- **Description:** These PL/pgSQL functions and triggers automate the addition of a last_update column with a current timestamp default to all tables in the ls_museum schema. They also create triggers that update the last_update column automatically before any data update, enhancing data tracking and auditing capabilities.

### Simulated Bulk Data Insertion

- **Function Name:** [`insert_address`](3.insert_address_function.sql)
- **Description:** This PL/pgSQL function inserts address details, including address lines, city, country, and postal code, into the database. It returns the newly created or existing address's unique identifier (address_id). The function automatically manages duplicates, making it convenient for adding complete address information in a single call.

### Simulated Artwork Insertion

- **Function Name:** [`insert_artwork`](4.insert_artwork_function.sql)
- **Description: The function allows you to conveniently enter details of an artwork, including its name, artist, creation year, event name, and supplier's name in a single operation. It returns the unique identifier (artwork_id) of the newly inserted artwork. This function simplifies the process of adding artwork information, making it efficient and user-friendly.

### Artwork Retrieval by Artist

- **Function Name:** [`get_artwork_by_artist`](5.get_artworks_by_artist.sql)
- **Description:** Simulate searching for artworks by inserting the artist's name. The function retrieves artworks associated with the specified artist.

## Database Schema

The Louisiana Museum Mock Database comprises 15 tables, each designed to store specific types of data related to the museum's operations. Here's an overview of the database schema:

1. `art_work`: Stores information about artworks, including name, artist, creation year, event association, and supplier details.
2. `event`: Contains data about museum events, including event name, type, ticket cost, dates, and descriptions.
3. `ticket`: Records details of tickets issued for museum events.
4. `membership_card`: Stores data about membership cards issued to museum members, including membership type and card status.
5. `membership_type`: Contains information about different membership types, including names, descriptions, monthly costs, and age-related discounts.
6. `person`: Stores information about individuals, including their names, addresses, phone numbers, emails, and dates of birth.
7. `purchase`: Records details of purchases made by museum visitors, including order IDs, staff IDs, total amounts, and purchase dates.
8. `address`: Contains address information, including address lines, city associations, and postal codes.
9. `city`: Stores data about cities, including city names and country associations.
10. `country`: Contains information about countries, including country names.
11. `event_type`: Records event types such as exhibitions, conferences, concerts, lectures, and workshops.
12. `staff_employee`: Stores data about museum staff members, including job titles, salaries, work start dates, and employment status.
13. `supplier`: Contains information about suppliers, including names, emails, contact numbers, and descriptions.
14. `hall`: Records data about museum halls, including hall names and descriptions.
15. `payment`: Stores details of payments made for purchases, including payment amounts, statuses, purchase associations, and payment dates.
16. `order_list`: Contains data about orders made, including item IDs and quantities.

The DDL script for creating these tables, along with constraints, can be found in [1.DB_DDL.sql](1.DB_DDL.sql).

For more detailed information about each table's structure and constraints, check out the scheme of the database [scheme](mock-db-scheme.PNG).



## [Access Control and Roles](7.DCL_manager.sql)

The Louisiana Museum Mock Database uses Data Control Language (DCL) commands to manage access control and define roles within the database.

### Roles

- **`manager_ls`:** This role is created to provide read-only access to the database for managers. It has the following permissions:
  - `CONNECT` to the `louisiana_museum` database.
  - `USAGE` on the `ls_museum` schema.
  - `SELECT` on all tables within the `ls_museum` schema.
  - Default privileges are set to allow `SELECT` on future tables created within the `ls_museum` schema.

### Revoking Public Permissions

To enhance security, the following permissions are revoked from the `PUBLIC` role:
- `CREATE` on the `ls_museum` schema.
- All privileges on the `louisiana_museum` database.

### User-Specific Roles (Optional)

You can create user-specific roles as needed. For example:
```sql
-- CREATE ROLE Risti_Bjerring noinherit login PASSWORD 's3cr3t';
-- GRANT manager_ls TO Risti_Bjerring;
```

## [Populating the Database](6.DML.sql)
To populate the database with initial data, you can use the provided DML script. This script contains SQL queries for inserting data into the database tables, making it easy to get started with a pre-configured dataset.

## [SELECT Query Details](8.DQL(Select).sql)

The query retrieves the following information:

- Event details, including event name, description, hall name, event type, ticket cost, event director, and director's address.
- Artwork information, such as artwork name and artist name.
- Supplier details for artwork.
- Ticket details, including ticket name and owner.
- Payment information, including payment amount and status.
- Membership type and member's address for memberships.
- Address information for event directors and members.

### Usage

You can execute this query to review data with the last update timestamp within the last month. It helps maintain data integrity and quality in the museum database, ensuring that recent updates are accurate and appropriately recorded.

     

## Getting Started

To interact with the Louisiana Museum Mock Database, you can follow these steps:

1. Clone the repository:

   ```shell
   git clone https://github.com/emkhv/louisiana-mock-database.git
   cd louisiana-mock-database
   ```

       
## Running The Scripts 

To execute the scripts in the correct order, follow these steps:

1. Open your preferred database management tool or command-line interface.
2. Connect to your PostgreSQL database.
3. Navigate to the directory where the scripts are located.
4. Run each script one by one, following the **numerical order** in the script filenames.

By running the scripts in the order specified by the filenames (e.g., 01.DB_DDL.sql, 02.last_update_column.sql, etc.), you'll ensure that the data is inserted into the database tables as intended.
   
### Requirements
PostgreSQL Database
SQL Client
