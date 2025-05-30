import express from 'express';
import { pool } from '../config/database.js';
import multer from 'multer';
import path from 'path';

const router = express.Router();

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + path.extname(file.originalname));
  },
});

const upload = multer({ storage });

// Get all products
router.get('/', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        p.*, 
        u.username as seller_name,
        c.name as city_name,
        s.name as state_name,
        s.code as state_code,
        co.name as country_name,
        co.code as country_code,
        cat.name as category_name
      FROM products p
      LEFT JOIN users u ON p.user_id = u.id
      LEFT JOIN cities c ON p.city_id = c.id
      LEFT JOIN states s ON c.state_id = s.id
      LEFT JOIN countries co ON s.country_id = co.id
      LEFT JOIN categories cat ON p.category_id = cat.id
      ORDER BY p.created_at DESC
    `);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Search products
router.get('/search', async (req, res) => {
  const { query } = req.query;
  
  if (!query) {
    return res.status(400).json({ error: 'Search query is required' });
  }

  try {
    const searchQuery = `%${query}%`;
    const result = await pool.query(`
      SELECT 
        p.*, 
        u.username as seller_name,
        c.name as city_name,
        s.name as state_name,
        s.code as state_code,
        co.name as country_name,
        co.code as country_code,
        cat.name as category_name
      FROM products p
      LEFT JOIN users u ON p.user_id = u.id
      LEFT JOIN cities c ON p.city_id = c.id
      LEFT JOIN states s ON c.state_id = s.id
      LEFT JOIN countries co ON s.country_id = co.id
      LEFT JOIN categories cat ON p.category_id = cat.id
      WHERE p.title ILIKE $1 
      OR p.description ILIKE $1
      OR c.name ILIKE $1
      OR s.name ILIKE $1
      OR co.name ILIKE $1
      OR cat.name ILIKE $1
      ORDER BY p.created_at DESC
    `, [searchQuery]);

    console.log('Search query:', query);
    console.log('Results found:', result.rows.length);
    res.json(result.rows);
  } catch (error) {
    console.error('Error searching products:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get a single product
router.get('/:id(\\d+)', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        p.*, 
        u.username as seller_name,
        c.name as city_name,
        s.name as state_name,
        s.code as state_code,
        co.name as country_name,
        co.code as country_code,
        cat.name as category_name
      FROM products p
      LEFT JOIN users u ON p.user_id = u.id
      LEFT JOIN cities c ON p.city_id = c.id
      LEFT JOIN states s ON c.state_id = s.id
      LEFT JOIN countries co ON s.country_id = co.id
      LEFT JOIN categories cat ON p.category_id = cat.id
      WHERE p.id = $1
    `, [req.params.id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error fetching product:', error);
    res.status(500).json({ message: 'Error fetching product' });
  }
});

// Create a product
router.post('/', upload.single('image'), async (req, res) => {
  try {
    const {
      title,
      description,
      price,
      category_id,
      condition,
      city_id,
      user_id,
    } = req.body;

    const imageUrl = req.file ? `/uploads/${req.file.filename}` : null;

    const result = await pool.query(
      `INSERT INTO products (
        title, description, price, image_url, user_id, 
        category_id, condition, city_id, created_at, updated_at
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
      RETURNING *`,
      [
        title,
        description,
        price,
        imageUrl,
        user_id,
        category_id,
        condition,
        city_id,
      ]
    );

    // Get the full product details including related data
    const fullProduct = await pool.query(`
      SELECT 
        p.*, 
        u.username as seller_name,
        c.name as city_name,
        s.name as state_name,
        s.code as state_code,
        co.name as country_name,
        co.code as country_code,
        cat.name as category_name
      FROM products p
      LEFT JOIN users u ON p.user_id = u.id
      LEFT JOIN cities c ON p.city_id = c.id
      LEFT JOIN states s ON c.state_id = s.id
      LEFT JOIN countries co ON s.country_id = co.id
      LEFT JOIN categories cat ON p.category_id = cat.id
      WHERE p.id = $1
    `, [result.rows[0].id]);

    res.status(201).json(fullProduct.rows[0]);
  } catch (error) {
    console.error('Error creating product:', error);
    res.status(500).json({ message: 'Error creating product' });
  }
});

// Update a product
router.put('/:id(\\d+)', upload.single('image'), async (req, res) => {
  try {
    const {
      title,
      description,
      price,
      category_id,
      condition,
      city_id,
    } = req.body;

    const imageUrl = req.file ? `/uploads/${req.file.filename}` : null;

    const result = await pool.query(
      `UPDATE products 
       SET title = $1, description = $2, price = $3, 
           image_url = COALESCE($4, image_url),
           category_id = $5, condition = $6, city_id = $7
       WHERE id = $8
       RETURNING *`,
      [
        title,
        description,
        price,
        imageUrl,
        category_id,
        condition,
        city_id,
        req.params.id,
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error updating product:', error);
    res.status(500).json({ message: 'Error updating product' });
  }
});

// Delete a product
router.delete('/:id(\\d+)', async (req, res) => {
  try {
    const result = await pool.query(
      'DELETE FROM products WHERE id = $1 RETURNING *',
      [req.params.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Product not found' });
    }

    res.json({ message: 'Product deleted successfully' });
  } catch (error) {
    console.error('Error deleting product:', error);
    res.status(500).json({ message: 'Error deleting product' });
  }
});

// Get user's products
router.get('/user/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const result = await pool.query(`
      SELECT 
        p.*, 
        u.username as seller_name,
        c.name as city_name,
        s.name as state_name,
        s.code as state_code,
        co.name as country_name,
        co.code as country_code,
        cat.name as category_name
      FROM products p
      LEFT JOIN users u ON p.user_id = u.id
      LEFT JOIN cities c ON p.city_id = c.id
      LEFT JOIN states s ON c.state_id = s.id
      LEFT JOIN countries co ON s.country_id = co.id
      LEFT JOIN categories cat ON p.category_id = cat.id
      WHERE p.user_id = $1
      ORDER BY p.created_at DESC
    `, [userId]);

    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching user products:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router; 