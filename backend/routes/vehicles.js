import express from 'express';
import { query } from '../config/database.js';

const router = express.Router();

// Get all vehicle types
router.get('/types', async (req, res) => {
  try {
    const result = await query(
      'SELECT id, name FROM vehicle_types ORDER BY name'
    );
    res.json({ types: result.rows });
  } catch (error) {
    console.error('Error fetching vehicle types:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get makes for a specific type
router.get('/makes/:typeId', async (req, res) => {
  try {
    const { typeId } = req.params;
    const result = await query(
      'SELECT id, name FROM vehicle_makes WHERE type_id = $1 ORDER BY name',
      [typeId]
    );
    res.json({ makes: result.rows });
  } catch (error) {
    console.error('Error fetching vehicle makes:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get models for a specific make
router.get('/models/:makeId', async (req, res) => {
  try {
    const { makeId } = req.params;
    const result = await query(
      'SELECT id, name FROM vehicle_models WHERE make_id = $1 ORDER BY name',
      [makeId]
    );
    res.json({ models: result.rows });
  } catch (error) {
    console.error('Error fetching vehicle models:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get submodels for a specific model
router.get('/submodels/:modelId', async (req, res) => {
  try {
    const { modelId } = req.params;
    const result = await query(
      'SELECT id, name FROM vehicle_submodels WHERE model_id = $1 ORDER BY name',
      [modelId]
    );
    res.json({ submodels: result.rows });
  } catch (error) {
    console.error('Error fetching vehicle submodels:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add a new vehicle type
router.post('/types', async (req, res) => {
  try {
    const { name } = req.body;
    const result = await query(
      'INSERT INTO vehicle_types (name) VALUES ($1) RETURNING id, name',
      [name]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error adding vehicle type:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add a new vehicle make
router.post('/makes', async (req, res) => {
  try {
    const { typeId, name } = req.body;
    const result = await query(
      'INSERT INTO vehicle_makes (type_id, name) VALUES ($1, $2) RETURNING id, name',
      [typeId, name]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error adding vehicle make:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add a new vehicle model
router.post('/models', async (req, res) => {
  try {
    const { makeId, name } = req.body;
    const result = await query(
      'INSERT INTO vehicle_models (make_id, name) VALUES ($1, $2) RETURNING id, name',
      [makeId, name]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error adding vehicle model:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add a new vehicle submodel
router.post('/submodels', async (req, res) => {
  try {
    const { modelId, name } = req.body;
    const result = await query(
      'INSERT INTO vehicle_submodels (model_id, name) VALUES ($1, $2) RETURNING id, name',
      [modelId, name]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Error adding vehicle submodel:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router; 