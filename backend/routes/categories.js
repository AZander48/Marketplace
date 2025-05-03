import express from 'express';
import { query } from '../config/database.js';

const router = express.Router();

// Get all categories
router.get('/', async (req, res) => {
  try {
    const result = await query(
      'SELECT * FROM categories ORDER BY name'
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching categories:', error);
    res.status(500).json({ message: 'Error fetching categories' });
  }
});

// Get products by category
router.get('/:id/products', async (req, res) => {
  try {
    const { id } = req.params;
    const { limit = 20, offset = 0 } = req.query;

    const result = await query(
      `SELECT p.*, u.username as seller_name, c.name as category_name
       FROM products p
       JOIN users u ON p.user_id = u.id
       JOIN categories c ON p.category_id = c.id
       WHERE p.category_id = $1
       ORDER BY p.created_at DESC
       LIMIT $2 OFFSET $3`,
      [id, limit, offset]
    );

    // Get total count for pagination
    const countResult = await query(
      'SELECT COUNT(*) FROM products WHERE category_id = $1',
      [id]
    );

    res.json({
      products: result.rows,
      total: parseInt(countResult.rows[0].count),
      limit: parseInt(limit),
      offset: parseInt(offset)
    });
  } catch (error) {
    console.error('Error fetching category products:', error);
    res.status(500).json({ message: 'Error fetching category products' });
  }
});

// Get category details
router.get('/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await query(
      'SELECT * FROM categories WHERE id = $1',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Category not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error fetching category:', error);
    res.status(500).json({ message: 'Error fetching category' });
  }
});

export default router; 