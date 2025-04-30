DROP DATABASE IF EXISTS marketplace_db;
-- Create database
CREATE DATABASE marketplace_db;

-- Create user (replace 'your_password' with a secure password)
CREATE USER marketplace_user WITH PASSWORD 'your_password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE marketplace_db TO marketplace_user;

-- Connect to the database
\c marketplace_db