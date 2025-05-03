# Marketplace App Backend

The backend server for a marketplace application built with Node.js, Express, and PostgreSQL.

## Overview

This backend provides a RESTful API for the Marketplace App, a platform where users can buy and sell various items, with a focus on vehicle parts and accessories. The API handles user authentication, product listings, search functionality, messaging, and more.

## Setup

### Prerequisites

- Node.js (v14+ recommended)
- PostgreSQL (v12+ recommended)
- npm or yarn

### Installation

1. Clone the repository
2. Navigate to the backend directory: `cd backend`
3. Install dependencies: `npm install`
4. Create a `.env` file based on `.env_example` and add your configuration
5. Set up the PostgreSQL database and run the SQL scripts in the `sql/` directory
6. Start the server: `npm start`

### Environment Variables

See `.env_example` for required environment variables.

## Database

The application uses PostgreSQL with the following main tables:
- users
- products
- categories
- vehicle_types, vehicle_makes, vehicle_models, vehicle_submodels
- messages
- orders
- reviews
- notifications

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login user
- `GET /api/auth/me` - Get current user info

### Users
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/:id` - Update user
- `GET /api/users/:id/products` - Get products by user

### Products
- `GET /api/products` - Get products (with filtering)
- `GET /api/products/:id` - Get product by ID
- `POST /api/products` - Create product
- `PUT /api/products/:id` - Update product
- `DELETE /api/products/:id` - Delete product

### Vehicles
- `GET /api/vehicles/types` - Get vehicle types
- `GET /api/vehicles/makes` - Get vehicle makes
- `GET /api/vehicles/models` - Get vehicle models
- `GET /api/vehicles/submodels` - Get vehicle submodels

### Messages
- `GET /api/messages` - Get messages for current user
- `POST /api/messages` - Send a message

### Orders
- `GET /api/orders` - Get orders for current user
- `POST /api/orders` - Create an order
- `PUT /api/orders/:id` - Update order status

## Development

### Running in Development Mode

```
npm run dev
```

This will start the server with nodemon for automatic reloading.

### Database Migrations

For PostgreSQL setup, run the scripts in the following order:
1. `sql/create_tables.sql`
2. `sql/insert_data.sql` or `sql/insert_data_localhost.sql` for local development

### Troubleshooting

If you encounter a duplicate key error with `vehicle_types`, it's because the `insert_data_localhost.sql` file has duplicate vehicle type insertions. The issue has been fixed in the latest version.

## Deployment

The application is configured for deployment on Heroku using the Procfile.

## License

See the LICENSE file for details.
