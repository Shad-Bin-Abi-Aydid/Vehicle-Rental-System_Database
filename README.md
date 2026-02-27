# Vehicle Rental System Database

This repository contains the **database schema** for a Vehicle Rental System — a structured database designed to support the backend of a vehicle rental application.

The schema defines tables and relationships for managing vehicles, customers, rentals, and related data.

## Project Overview

A Vehicle Rental System enables a rental business to:

- Track available vehicles
- Register and manage customers
- Record rental bookings and returns
- Store transaction and payment information

This repository focuses on the **database design** and is ideal as part of a larger application with an API or frontend UI.

##  Repository Contents

| File | Description |
|------|-------------|
| `schema.sql` | SQL script for creating database schema, tables, and relationships |
| `.vscode/` | VS Code workspace settings |
| ER Diagram | https://lucid.app/lucidchart/4b11b1b1-fe5d-4273-af9d-71b7262b9bd2/edit?invitationId=inv_ed9f14c5-0409-4e55-b54c-29f6178c8645|

##  Features (Database Schema)

This database schema typically supports the following:

- **Vehicle Management** – Store details for each vehicle (make, model, year, availability)
- **Customer Records** – Customer information needed to rent vehicles
- **Rental Records** – Track which customers rent which vehicles and for how long
- **Booking History** – Record past and current bookings
- **Transactions / Payments** – Store payment and billing information


##  Technologies Used

- **Database:** PostgreSQL (PL/pgSQL)  

##  Getting Started

To set up the database locally:

1. Clone this repository  
   ```bash
   git clone https://github.com/Shad-Bin-Abi-Aydid/Vehicle-Rental-System_Database.git
