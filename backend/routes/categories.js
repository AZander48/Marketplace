import express from 'express';
import { pool, query } from '../config/database.js';

const router = express.Router();

// Get all categories
router.get('/', async (req, res) => {
  try {
    console.log('Fetching all categories...');
    const result = await query(
      'SELECT * FROM categories ORDER BY name'
    );
    console.log(`Successfully fetched ${result.rows.length} categories`);
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching categories:', error);
    // Send more specific error message based on the error type
    if (error.code === '3D000') {
      res.status(500).json({ message: 'Database not found. Please check database configuration.' });
    } else if (error.code === '28P01') {
      res.status(500).json({ message: 'Database authentication failed. Please check credentials.' });
    } else if (error.code === '42P01') {
      res.status(500).json({ message: 'Categories table not found. Please check if database is properly initialized.' });
    } else {
      res.status(500).json({ 
        message: 'Error fetching categories',
        error: process.env.NODE_ENV === 'development' ? error.message : undefined
      });
    }
  }
});

// Get products by category
router.get('/:id/products', async (req, res) => {
  try {
    const { id } = req.params;
    const { limit = 20, offset = 0, search, vehicleId } = req.query;

    // If vehicleId is provided, get vehicle details first
    let vehicleDetails = null;
    if (vehicleId) {
      const vehicleResult = await pool.query(
        `SELECT vehicle_type_id, vehicle_make_id, vehicle_model_id, vehicle_submodel_id, vehicle_year
         FROM garage_items
         WHERE id = $1`,
        [vehicleId]
      );
      
      if (vehicleResult.rows.length > 0) {
        vehicleDetails = vehicleResult.rows[0];
      }
    }

    let query = `
      SELECT p.*, u.username as seller_name, c.name as category_name
      FROM products p
      JOIN users u ON p.user_id = u.id
      JOIN categories c ON p.category_id = c.id
      WHERE p.category_id = $1
    `;
    const queryParams = [id];

    if (search) {
      query += ` AND (
        p.title ILIKE $${queryParams.length + 1} OR
        p.description ILIKE $${queryParams.length + 1}
      )`;
      queryParams.push(`%${search}%`);
    }

    if (vehicleDetails) {
      query += ` AND (
        p.compatibility_info->>'vehicle_type_id' = $${queryParams.length + 1} OR
        p.compatibility_info->>'vehicle_make_id' = $${queryParams.length + 2} OR
        p.compatibility_info->>'vehicle_model_id' = $${queryParams.length + 3} OR
        p.compatibility_info->>'vehicle_submodel_id' = $${queryParams.length + 4}
      )`;
      queryParams.push(
        vehicleDetails.vehicle_type_id?.toString(),
        vehicleDetails.vehicle_make_id?.toString(),
        vehicleDetails.vehicle_model_id?.toString(),
        vehicleDetails.vehicle_submodel_id?.toString()
      );
    }

    query += `
      ORDER BY p.created_at DESC
      LIMIT $${queryParams.length + 1} OFFSET $${queryParams.length + 2}
    `;
    queryParams.push(limit, offset);

    const result = await pool.query(query, queryParams);

    // Get total count for pagination
    let countQuery = 'SELECT COUNT(*) FROM products WHERE category_id = $1';
    const countParams = [id];

    if (search) {
      countQuery += ` AND (
        title ILIKE $${countParams.length + 1} OR
        description ILIKE $${countParams.length + 1}
      )`;
      countParams.push(`%${search}%`);
    }

    if (vehicleDetails) {
      countQuery += ` AND (
        compatibility_info->>'vehicle_type_id' = $${countParams.length + 1} OR
        compatibility_info->>'vehicle_make_id' = $${countParams.length + 2} OR
        compatibility_info->>'vehicle_model_id' = $${countParams.length + 3} OR
        compatibility_info->>'vehicle_submodel_id' = $${countParams.length + 4}
      )`;
      countParams.push(
        vehicleDetails.vehicle_type_id?.toString(),
        vehicleDetails.vehicle_make_id?.toString(),
        vehicleDetails.vehicle_model_id?.toString(),
        vehicleDetails.vehicle_submodel_id?.toString()
      );
    }

    const countResult = await pool.query(countQuery, countParams);

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
    const result = await pool.query(
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