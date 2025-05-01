import express from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { pool } from '../config/database.js';

const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET;

// Export the middleware
export const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'No token provided' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ message: 'Invalid token' });
    }
    req.user = user;
    next();
  });
};

// Register endpoint
router.post('/register', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    // Validate required fields
    if (!username || !email || !password) {
      return res.status(400).json({ 
        message: 'Missing required fields',
        received: { username, email, password: password ? '***' : null }
      });
    }

    // Check if user already exists
    const userExists = await pool.query(
      'SELECT * FROM users WHERE email = $1 OR username = $2',
      [email, username]
    );

    if (userExists.rows.length > 0) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // Hash password
    const password_hash = await bcrypt.hash(password, 10);

    // Create user
    const result = await pool.query(
      'INSERT INTO users (username, email, password_hash, created_at, updated_at, last_active) VALUES ($1, $2, $3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id, username, email',
      [username, email, password_hash]
    );

    const user = result.rows[0];
    const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '24h' });

    res.status(201).json({
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
      },
      token,
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ 
      message: 'Error registering user',
      error: error.message,
      detail: error.detail
    });
  }
});

// Login endpoint
router.post('/login', async (req, res) => {
  try {
    const { identifier, password } = req.body;
    console.log('Login attempt with:', { identifier, password });

    // First get the user
    const result = await pool.query(
      `SELECT id, username, email, password_hash FROM users 
       WHERE email = $1 OR username = $1`,
      [identifier]
    );

    console.log('Database query result:', result.rows);

    if (result.rows.length === 0) {
      console.log('No user found with identifier:', identifier);
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const user = result.rows[0];
    console.log('Found user:', user);

    // Verify password using bcrypt
    const isValidPassword = await bcrypt.compare(password, user.password_hash);
    if (!isValidPassword) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Generate token
    const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '24h' });

    res.json({
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
      },
      token,
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ message: 'Error logging in' });
  }
});

// Get user profile
router.get('/me', authenticateToken, async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        u.*,
        c.name as city_name,
        s.name as state_name,
        s.code as state_code,
        co.name as country_name,
        co.code as country_code,
        (
          SELECT json_agg(
            json_build_object(
              'id', ulp.id,
              'user_id', ulp.user_id,
              'city_id', ulp.city_id,
              'is_primary', ulp.is_primary,
              'created_at', ulp.created_at,
              'city_name', c2.name,
              'state_name', s2.name,
              'state_code', s2.code,
              'country_name', co2.name,
              'country_code', co2.code
            )
          )
          FROM user_location_preferences ulp
          LEFT JOIN cities c2 ON ulp.city_id = c2.id
          LEFT JOIN states s2 ON c2.state_id = s2.id
          LEFT JOIN countries co2 ON s2.country_id = co2.id
          WHERE ulp.user_id = u.id
        ) as location_preferences
      FROM users u
      LEFT JOIN cities c ON u.city_id = c.id
      LEFT JOIN states s ON c.state_id = s.id
      LEFT JOIN countries co ON s.country_id = co.id
      WHERE u.id = $1
    `, [req.user.id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const user = result.rows[0];
    res.json(user);
  } catch (error) {
    console.error('Error fetching user profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router; 