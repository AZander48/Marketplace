# Marketplace App

A full-stack marketplace application built with Flutter and Node.js.

## Project Structure

This project consists of two main parts:
- Flutter frontend application (`/frontend`)
- Node.js backend server (`/backend`)

## Prerequisites

- Flutter SDK (latest stable version)
- Node.js (v14 or higher)
- PostgreSQL database
- Git

## Backend Setup

1. Navigate to the backend directory:
```bash
cd backend
```

2. Install dependencies:
```bash
npm install
```

3. Create a `.env` file based on `.env_example`:
```bash
cp .env_example .env
```

4. Update the `.env` file with your database credentials:
```
DB_USER=postgres
DB_HOST=localhost
DB_NAME=marketplace_db
DB_PASSWORD=your_password
DB_PORT=5432
PORT=3000
JWT_SECRET=your-secret-jwt-key
```

5. Start the backend server:
```bash
npm start
```

The server will run on `http://localhost:3000` by default.

## Frontend Setup

1. Navigate to the frontend directory:
```bash
cd frontend
```

2. Install Flutter dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Switching Between Localhost and Deployed Backend

### Frontend Configuration

1. Open the file `/frontend/lib/services/api_service.dart` (or equivalent configuration file)

2. For localhost development:
```dart
// For Android Emulator with localhost backend
static const String baseUrl = 'http://10.0.2.2:3000/api';

// For iOS Simulator with localhost backend
// static const String baseUrl = 'http://127.0.0.1:3000/api';

// For physical device testing with local network
// static const String baseUrl = 'http://192.168.1.X:3000/api';

// For production deployed backend
// static const String baseUrl = 'https://your-deployed-backend.com/api';
```

3. For production/deployed backend:
```dart
// For production deployed backend
static const String baseUrl = 'https://your-deployed-backend.com/api';

// Comment out other baseUrl options
// static const String baseUrl = 'http://10.0.2.2:3000/api';
```

### Backend Deployment

1. Deploy the backend to your preferred hosting service (Heroku, DigitalOcean, AWS, etc.)

2. Update the database connection in `.env` for production:
```
DB_USER=production_user
DB_HOST=production_host
DB_NAME=production_db
DB_PASSWORD=production_password
DB_PORT=5432
PORT=process.env.PORT
JWT_SECRET=your-secret-jwt-key
```

3. For local testing with production database:
```bash
# Set the environment variable to use production config
export NODE_ENV=production
npm start
```

4. For local development with local database:
```bash
# Set the environment variable to use development config
export NODE_ENV=development
npm start
```

### Database Configuration

1. For localhost development, use:
```bash
# Run the localhost version of the insert script
psql -U postgres -d marketplace_db -f ./backend/sql/insert_data_localhost.sql
```

2. For production deployment, use:
```bash
# Run the production version of the insert script
psql -U postgres -d marketplace_db -f ./backend/sql/insert_data.sql
```

## Development

### Backend Development
- The backend uses Express.js and follows a modular structure
- API routes are located in `/backend/routes`
- Database queries are in `/backend/sql`
- Configuration files are in `/backend/config`
- Environment variables are managed through `.env` file

### Frontend Development
- The app follows a clean architecture pattern
- Screens are located in `/frontend/lib/screens`
- Reusable widgets are in `/frontend/lib/widgets`
- API services are in `/frontend/lib/services`
- State management is handled in `/frontend/lib/providers`
- Data models are in `/frontend/lib/models`

## Database Setup

1. Install PostgreSQL if you haven't already
2. Create a new database:
```sql
CREATE DATABASE marketplace_db;
```

3. Run the SQL scripts in `/backend/sql` to set up the database schema and initial data

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Express.js Documentation](https://expressjs.com/)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Flutter Widget Catalog](https://docs.flutter.dev/development/ui/widgets)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

## Contributing

1. Create a new branch for your feature
2. Make your changes
3. Submit a pull request

## License

This project is proprietary and confidential. All rights reserved.
