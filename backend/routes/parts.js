import express from 'express';
import { pool } from '../config/database.js';

const router = express.Router();

// Get parts by category and vehicle
router.get('/', async (req, res) => {
  try {
    const { categoryId, vehicleId } = req.query;

    if (!categoryId || !vehicleId) {
      return res.status(400).json({ error: 'Category ID and Vehicle ID are required' });
    }

    // Validate that the category is a parts category (10-20)
    const categoryNum = parseInt(categoryId);
    if (categoryNum < 10 || categoryNum > 20) {
      return res.status(400).json({ error: 'Invalid parts category. Must be between 10 and 20.' });
    }

    // Get vehicle details to check compatibility
    const vehicleQuery = `
      SELECT vehicle_type_id, vehicle_make_id, vehicle_model_id, vehicle_submodel_id, vehicle_year
      FROM garage_items
      WHERE id = $1
    `;
    const vehicleResult = await pool.query(vehicleQuery, [vehicleId]);
    
    if (vehicleResult.rows.length === 0) {
      return res.status(404).json({ error: 'Vehicle not found' });
    }

    const vehicle = vehicleResult.rows[0];

    // Get compatible parts from products table
    const partsQuery = `
      SELECT 
        p.id,
        p.title as name,
        p.description,
        p.price,
        p.condition,
        p.image_url,
        p.user_id as seller_id,
        u.username as seller_name
      FROM products p
      JOIN users u ON p.user_id = u.id
      WHERE p.category_id = $1
      AND p.category_id BETWEEN 10 AND 20
      ORDER BY p.created_at DESC
    `;

    const partsResult = await pool.query(partsQuery, [categoryId]);

    res.json(partsResult.rows);
  } catch (error) {
    console.error('Error fetching parts:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router; 