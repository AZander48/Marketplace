import pkg from 'pg';
const { Pool } = pkg;
import dotenv from 'dotenv';

dotenv.config();

// Debug logging for environment
console.log('Environment:', {
  NODE_ENV: process.env.NODE_ENV,
  DATABASE_URL: process.env.DATABASE_URL,
  PGHOST: process.env.PGHOST,
  PGDATABASE: process.env.PGDATABASE,
  PGUSER: process.env.PGUSER,
  // Don't log the actual password
  HAS_PGPASSWORD: !!process.env.PGPASSWORD,
});

// Common pool settings
const commonConfig = {
  max: 20, // Maximum number of clients in the pool
  idleTimeoutMillis: 30000, // How long a client is allowed to remain idle before being closed
  connectionTimeoutMillis: 2000, // How long to wait for a connection
};

// Parse DATABASE_URL if available
let databaseUrl;
try {
  if (process.env.DATABASE_URL) {
    const url = new URL(process.env.DATABASE_URL);
    databaseUrl = {
      user: url.username,
      password: url.password,
      host: url.hostname,
      port: url.port,
      database: url.pathname.split('/')[1],
    };
    console.log('Parsed DATABASE_URL:', {
      host: databaseUrl.host,
      port: databaseUrl.port,
      database: databaseUrl.database,
      user: databaseUrl.user,
      // Don't log the actual password
      hasPassword: !!databaseUrl.password,
    });
  }
} catch (error) {
  console.error('Error parsing DATABASE_URL:', error);
}

// Development configuration (localhost)
const developmentConfig = {
  ...commonConfig,
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
};

// Production configuration (Render)
const productionConfig = {
  ...commonConfig,
  ...(databaseUrl || {
    user: process.env.PGUSER,
    password: process.env.PGPASSWORD,
    host: process.env.PGHOST,
    port: parseInt(process.env.PGPORT || '5432'),
    database: process.env.PGDATABASE,
  }),
  ssl: {
    rejectUnauthorized: false // Required for Render's PostgreSQL
  },
};

// Choose configuration based on environment
const isProduction = process.env.NODE_ENV === 'production';
const poolConfig = isProduction ? productionConfig : developmentConfig;

console.log('Database configuration:', {
  isProduction,
  host: poolConfig.host,
  port: poolConfig.port,
  database: poolConfig.database,
  user: poolConfig.user,
  // Don't log the actual password
  hasPassword: !!poolConfig.password,
  ssl: !!poolConfig.ssl,
});

console.log(`Using ${process.env.NODE_ENV === 'production' ? 'production' : 'development'} database configuration`);
console.log(`Connecting to database at ${poolConfig.host}:${poolConfig.port}/${poolConfig.database}`);

export const pool = new Pool(poolConfig);

// Add event listeners for pool error handling
pool.on('error', (err, client) => {
  console.error('Unexpected error on idle client:', err);
});

pool.on('connect', () => {
  const config = pool.options;
  console.log(`Database connected successfully to ${config.host}:${config.port}/${config.database}`);
});

// Wrapper for database queries with better error handling
export const query = async (text, params) => {
  const client = await pool.connect();
  try {
    const start = Date.now();
    const res = await client.query(text, params);
    const duration = Date.now() - start;
    console.log('Executed query', { text, duration, rows: res.rowCount });
    return res;
  } catch (err) {
    console.error('Database query error:', err);
    throw err;
  } finally {
    client.release();
  }
}; 