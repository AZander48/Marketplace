import express from 'express';
import { query } from '../config/database.js';

const router = express.Router();

// Get all garage items for a user
router.get('/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const result = await query(
      'SELECT * FROM garage_items WHERE user_id = $1 ORDER BY created_at DESC',
      [userId]
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching garage items:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add a new garage item
router.post('/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    const { name, description, image_url, vehicle_type_id, vehicle_year, vehicle_make_id, vehicle_model_id, vehicle_submodel_id } = req.body;
    
    const result = await query(
      `INSERT INTO garage_items 
       (user_id, name, description, image_url, vehicle_type_id, vehicle_year, vehicle_make_id, vehicle_model_id, vehicle_submodel_id)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
       RETURNING *`,
      [userId, name, description, image_url, vehicle_type_id, vehicle_year, vehicle_make_id, vehicle_model_id, vehicle_submodel_id]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error adding garage item:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete a garage item
router.delete('/:userId/:itemId', async (req, res) => {
  try {
    const { userId, itemId } = req.params;
    await query(
      'DELETE FROM garage_items WHERE user_id = $1 AND id = $2',
      [userId, itemId]
    );
    res.status(204).send();
  } catch (error) {
    console.error('Error deleting garage item:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update a garage item
router.put('/:userId/:itemId', async (req, res) => {
  try {
    const { userId, itemId } = req.params;
    const { name, description, image_url, vehicle_type_id, vehicle_year, vehicle_make_id, vehicle_model_id, vehicle_submodel_id } = req.body;
    
    const result = await query(
      `UPDATE garage_items 
       SET name = $1, description = $2, image_url = $3, vehicle_type_id = $4, 
           vehicle_year = $5, vehicle_make_id = $6, vehicle_model_id = $7, vehicle_submodel_id = $8
       WHERE user_id = $9 AND id = $10
       RETURNING *`,
      [name, description, image_url, vehicle_type_id, vehicle_year, vehicle_make_id, vehicle_model_id, vehicle_submodel_id, userId, itemId]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Garage item not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error updating garage item:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Set a garage item as primary
router.put('/:userId/:itemId/primary', async (req, res) => {
  try {
    const { userId, itemId } = req.params;
    
    // First, set all items to non-primary
    await query(
      'UPDATE garage_items SET is_primary = false WHERE user_id = $1',
      [userId]
    );
    
    // Then set the selected item as primary
    const result = await query(
      `UPDATE garage_items 
       SET is_primary = true
       WHERE user_id = $1 AND id = $2
       RETURNING *`,
      [userId, itemId]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Garage item not found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error setting primary vehicle:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get the primary vehicle for a user
router.get('/:userId/primary', async (req, res) => {
  try {
    const { userId } = req.params;
    const result = await query(
      'SELECT * FROM garage_items WHERE user_id = $1 AND is_primary = true',
      [userId]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'No primary vehicle found' });
    }
    
    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error fetching primary vehicle:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router; 