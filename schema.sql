
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS vehicles;
DROP TABLE IF EXISTS users;

DROP TYPE IF EXISTS booking_status;
DROP TYPE IF EXISTS vehicle_status;
DROP TYPE IF EXISTS vehicle_type;
DROP TYPE IF EXISTS user_role;

CREATE TYPE user_role AS ENUM ('admin', 'customer');

CREATE TYPE vehicle_type AS ENUM ('car', 'bike', 'truck');

CREATE TYPE vehicle_status AS ENUM (
  'available',
  'rented',
  'maintenance'
);

CREATE TYPE booking_status AS ENUM (
  'pending',
  'confirmed',
  'completed',
  'cancelled'
);

-- Create Users table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  role user_role NOT NULL,
  name VARCHAR(50) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password TEXT NOT NULL,
  phone_number VARCHAR(20)
);

-- Create vehicles table
CREATE TABLE vehicles (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  type vehicle_type NOT NULL,
  model VARCHAR(100),
  registration_number VARCHAR(50) UNIQUE NOT NULL,
  price_per_day NUMERIC(10,2) NOT NULL CHECK (price_per_day > 0),
  status vehicle_status
);

-- Create bookings table
CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  vehicle_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status booking_status,
  total_cost NUMERIC(10,2) CHECK (total_cost >= 0),

  CONSTRAINT fk_user
    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE CASCADE,

  CONSTRAINT fk_vehicle
    FOREIGN KEY (vehicle_id)
    REFERENCES vehicles(id)
    ON DELETE RESTRICT,

  CONSTRAINT valid_dates
    CHECK (end_date >= start_date)
);




