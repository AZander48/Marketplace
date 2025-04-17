import express from 'express';
import { pool } from '../config/database.js';

const router = express.Router();

// Test endpoint
router.get('/test', async (req, res) => {
  try {
    // Test database connection
    const connectionTest = await pool.query('SELECT NOW()');
    console.log('Database connection test:', connectionTest.rows[0]);

    // Test countries table
    const countriesTest = await pool.query('SELECT COUNT(*) FROM countries');
    console.log('Countries count:', countriesTest.rows[0]);

    res.json({
      status: 'success',
      database: 'connected',
      countriesCount: countriesTest.rows[0].count
    });
  } catch (error) {
    console.error('Test endpoint error:', error);
    res.status(500).json({ 
      status: 'error',
      error: error.message,
      stack: error.stack
    });
  }
});

// Get all countries
router.get('/countries', async (req, res) => {
  try {
    console.log('Attempting to fetch countries...');
    const result = await pool.query('SELECT * FROM countries ORDER BY name');
    console.log('Countries query successful:', result.rows);
    
    if (result.rows.length === 0) {
      console.log('No countries found in the database');
      return res.status(404).json({ 
        error: 'No countries found',
        message: 'The countries table is empty. Please check if the database was properly initialized.'
      });
    }
    
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching countries:', error);
    console.error('Error details:', {
      message: error.message,
      code: error.code,
      detail: error.detail,
      hint: error.hint,
      position: error.position,
      where: error.where
    });
    
    res.status(500).json({ 
      error: 'Internal server error',
      message: error.message,
      details: {
        code: error.code,
        detail: error.detail,
        hint: error.hint
      }
    });
  }
});

// Get states by country
router.get('/states/:countryId', async (req, res) => {
  try {
    const { countryId } = req.params;
    const result = await pool.query(
      'SELECT * FROM states WHERE country_id = $1 ORDER BY name',
      [countryId]
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching states:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get cities by state
router.get('/cities/:stateId', async (req, res) => {
  try {
    const { stateId } = req.params;
    const result = await pool.query(
      'SELECT * FROM cities WHERE state_id = $1 ORDER BY name',
      [stateId]
    );
    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching cities:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Search cities
router.get('/cities/search', async (req, res) => {
  try {
    const { query } = req.query;
    if (!query) {
      return res.status(400).json({ error: 'Search query is required' });
    }

    const result = await pool.query(`
      SELECT c.*, s.name as state_name, s.code as state_code, co.name as country_name
      FROM cities c
      JOIN states s ON c.state_id = s.id
      JOIN countries co ON s.country_id = co.id
      WHERE c.name ILIKE $1
      ORDER BY c.name
      LIMIT 10
    `, [`%${query}%`]);

    res.json(result.rows);
  } catch (error) {
    console.error('Error searching cities:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router; 