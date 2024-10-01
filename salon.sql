-- Create database
CREATE DATABASE salon:

-- Create the services table
CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

-- Create the customers table
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  phone VARCHAR(15) UNIQUE NOT NULL
);

-- Create the appointments table
CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id),
  service_id INT REFERENCES services(service_id),
  time VARCHAR(50) NOT NULL
);

-- Insert initial data into the services table
INSERT INTO services (name) VALUES 
('cut'),
('color'),
('style');