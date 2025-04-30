import express from 'express';
import { pool } from '../config/database.js';

const router = express.Router();

// Test database connection
router.get('/', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json({
      message: 'Database connection successful',
      timestamp: result.rows[0].now,
    });
  } catch (error) {
    console.error('Database connection error:', error);
    res.status(500).json({ message: 'Database connection failed' });
  }
});

export default router; 