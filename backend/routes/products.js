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
      SELECT p.*, u.username as seller_name 
      FROM products p
      JOIN users u ON p.user_id = u.id
      ORDER BY p.created_at DESC
    `);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching products:', error);
    res.status(500).json({ message: 'Error fetching products' });
  }
});

// Search products
router.get('/search', async (req, res) => {
  try {
    const { query } = req.query;
    console.log('Search query:', query);

    if (!query) {
      return res.status(400).json({ message: 'Search query is required' });
    }

    // Search in title, description, and location
    const result = await pool.query(
      `SELECT p.*, u.username as seller_name 
       FROM products p 
       JOIN users u ON p.user_id = u.id 
       WHERE p.title ILIKE $1 
       OR p.description ILIKE $1 
       OR p.location ILIKE $1 
       ORDER BY p.created_at DESC`,
      [`%${query}%`]
    );

    console.log('Search results:', result.rows.length);
    res.json(result.rows);
  } catch (error) {
    console.error('Search error:', error);
    res.status(500).json({ message: 'Error searching products' });
  }
});

// Get a single product
router.get('/:id(\\d+)', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT p.*, u.username as seller_name FROM products p JOIN users u ON p.user_id = u.id WHERE p.id = $1',
      [req.params.id]
    );

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
      category,
      condition,
      location,
      userId,
    } = req.body;

    const imageUrl = req.file ? `/uploads/${req.file.filename}` : null;

    const result = await pool.query(
      `INSERT INTO products (
        title, description, price, image_url, user_id, 
        category, condition, location
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      RETURNING *`,
      [
        title,
        description,
        price,
        imageUrl,
        userId,
        category,
        condition,
        location,
      ]
    );

    res.status(201).json(result.rows[0]);
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
      category,
      condition,
      location,
    } = req.body;

    const imageUrl = req.file ? `/uploads/${req.file.filename}` : null;

    const result = await pool.query(
      `UPDATE products 
       SET title = $1, description = $2, price = $3, 
           image_url = COALESCE($4, image_url),
           category = $5, condition = $6, location = $7
       WHERE id = $8
       RETURNING *`,
      [
        title,
        description,
        price,
        imageUrl,
        category,
        condition,
        location,
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

export default router; 