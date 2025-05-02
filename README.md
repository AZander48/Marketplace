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
