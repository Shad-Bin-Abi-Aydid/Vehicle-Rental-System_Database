
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

-- using Trigger to calculate total_price automatically
-- execute function
CREATE OR REPLACE FUNCTION calculate_total_cost () RETURNS TRIGGER LANGUAGE PLPGSQL AS $$

    DECLARE
      daily_price NUMERIC(10,2);
      total_days INTEGER;
    BEGIN

      -- get the price perday
      SELECT price_per_day INTO daily_price FROM vehicles WHERE id = NEW.vehicle_id;

      -- Calculate total days
      total_days := (NEW.end_date - NEW.start_date) + 1;

      -- Calculate the total cost
      NEW.total_cost := total_days * daily_price;

      RETURN NEW;
  
    END;
  $$;

-- ctrate trigger
CREATE TRIGGER trg_calculate_total_cost BEFORE INSERT
OR
UPDATE ON bookings FOR EACH ROW
EXECUTE FUNCTION calculate_total_cost ();

-- Insert values in the users table
INSERT INTO
  users (role, name, email, password, phone_number)
VALUES
  (
    'customer',
    'Alice',
    'alice@example.com',
    'password123',
    '1234567890'
  ),
  (
    'admin',
    'Bob',
    'bob@example.com',
    'password123',
    '0987654321'
  ),
  (
    'customer',
    'Charlie',
    'charlie@example.com',
    'password123',
    '1122334455'
  );

-- Insert into the vehicles table
INSERT INTO
  vehicles (
    name,
    type,
    model,
    registration_number,
    price_per_day,
    status
  )
VALUES
  (
    'Toyota Corolla',
    'car',
    '2022',
    'ABC-123',
    50,
    'available'
  ),
  (
    'Honda Civic',
    'car',
    '2021',
    'DEF-456',
    60,
    'rented'
  ),
  (
    'Yamaha R15',
    'bike',
    '2023',
    'GHI-789',
    30,
    'available'
  ),
  (
    'Ford F-150',
    'truck',
    '2020',
    'JKL-012',
    100,
    'maintenance'
  );

-- Insert values to the bookings
INSERT INTO
  bookings (user_id, vehicle_id, start_date, end_date, status)
VALUES
  (1, 2, '2023-10-01', '2023-10-05', 'completed'),
  (1, 2, '2023-11-01', '2023-11-03', 'completed'),
  (3, 2, '2023-12-01', '2023-12-02', 'confirmed'),
  (1, 1, '2023-12-10', '2023-12-12', 'pending');

-- Question 1 inner join
select
  u.name as customer_name,
  v.name as vehicle_name,
  b.start_date,
  b.end_date,
  b.status
from
  bookings as b
  inner join users as u on b.user_id = u.id
  inner join vehicles as v on b.vehicle_id = v.id;

-- Question 2 finds all vehicle which never been booked
select
  *
from
  vehicles as v
where
  not exists (
    select
      *
    from
      bookings as b
    where
      b.vehicle_id = v.id
  );

-- Question 3 Retrieve all available vehicles of a specific type
select
  *
from
  vehicles
where
  type = 'car'
  and status = 'available';

-- Question 4
select
  v.name as vehicle_name,
  count(*) as total_booking
from
  bookings as b
  join vehicles as v on b.vehicle_id = v.id
group by
  b.vehicle_id,
  v.name
having
  count(*) > 2;