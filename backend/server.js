const express = require('express');
const cors = require('cors');
const db = require('./config/database');
require('dotenv').config();

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Test database connection
app.get('/api/test-connection', async (req, res) => {
  try {
    const result = await db.query('SELECT NOW()');
    res.json({
      status: 'success',
      message: 'Database connection successful',
      timestamp: result.rows[0].now
    });
  } catch (err) {
    console.error('Database connection error:', err);
    res.status(500).json({
      status: 'error',
      message: 'Database connection failed',
      error: err.message
    });
  }
});

// API Routes
app.get('/api/products', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM products');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/products/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await db.query('SELECT * FROM products WHERE id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Product not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/products', async (req, res) => {
  try {
    const { user_id, title, description, price, category, condition, location } = req.body;
    const result = await db.query(
      'INSERT INTO products (user_id, title, description, price, category, condition, location) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
      [user_id, title, description, price, category, condition, location]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Start server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
}); 