import express from 'express';
import { pool } from '../config/database.js';
import { authenticateToken } from '../middleware/auth.js';

const router = express.Router();

// Record user interaction
router.post('/interaction', authenticateToken, async (req, res) => {
  try {
    const { productId, interactionType } = req.body;
    const userId = req.user.id;

    // Record the interaction
    await pool.query(
      `INSERT INTO user_interactions (user_id, product_id, interaction_type)
       VALUES ($1, $2, $3)
       ON CONFLICT (user_id, product_id, interaction_type) DO NOTHING`,
      [userId, productId, interactionType]
    );

    // Update product popularity
    await pool.query(
      `INSERT INTO product_popularity (product_id, ${interactionType}_count)
       VALUES ($1, 1)
       ON CONFLICT (product_id) DO UPDATE
       SET ${interactionType}_count = product_popularity.${interactionType}_count + 1,
           last_updated = CURRENT_TIMESTAMP`,
      [productId]
    );

    res.status(200).json({ message: 'Interaction recorded' });
  } catch (error) {
    console.error('Error recording interaction:', error);
    res.status(500).json({ message: 'Error recording interaction' });
  }
});

// Get personalized recommendations
router.get('/personalized', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;

    // Get user preferences
    const preferencesResult = await pool.query(
      'SELECT * FROM user_preferences WHERE user_id = $1',
      [userId]
    );

    const preferences = preferencesResult.rows[0] || {
      preferred_categories: [],
      preferred_price_range: { min: 0, max: 1000000 },
      preferred_locations: []
    };

    // Get user's recent interactions
    const interactionsResult = await pool.query(
      `SELECT DISTINCT product_id, interaction_type 
       FROM user_interactions 
       WHERE user_id = $1 
       ORDER BY created_at DESC 
       LIMIT 10`,
      [userId]
    );

    const interactedProductIds = interactionsResult.rows.map(row => row.product_id);

    // Get recommendations based on:
    // 1. User preferences
    // 2. Popular products in preferred categories
    // 3. Similar products to previously interacted items
    const recommendations = await pool.query(
      `WITH user_preferences AS (
         SELECT 
           COALESCE($2::jsonb, '[]'::jsonb) as categories,
           COALESCE($3::jsonb, '{"min":0,"max":1000000}'::jsonb) as price_range,
           COALESCE($4::jsonb, '[]'::jsonb) as locations
       )
       SELECT DISTINCT p.*, 
              u.username as seller_name,
              pp.view_count + pp.favorite_count * 2 + pp.purchase_count * 3 as popularity_score
       FROM products p
       JOIN users u ON p.user_id = u.id
       JOIN product_popularity pp ON p.id = pp.product_id
       CROSS JOIN user_preferences up
       WHERE p.id NOT IN (${interactedProductIds.length > 0 ? interactedProductIds.join(',') : '0'})
       AND (
         -- Match preferred categories
         p.category = ANY(up.categories::text[])
         OR
         -- Match preferred price range
         (p.price BETWEEN (up.price_range->>'min')::numeric AND (up.price_range->>'max')::numeric)
         OR
         -- Match preferred locations
         p.location = ANY(up.locations::text[])
       )
       ORDER BY popularity_score DESC, p.created_at DESC
       LIMIT 20`,
      [
        userId,
        preferences.preferred_categories,
        preferences.preferred_price_range,
        preferences.preferred_locations
      ]
    );

    res.json(recommendations.rows);
  } catch (error) {
    console.error('Error getting recommendations:', error);
    res.status(500).json({ message: 'Error getting recommendations' });
  }
});

// Update user preferences
router.put('/preferences', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.id;
    const { categories, priceRange, locations } = req.body;

    await pool.query(
      `INSERT INTO user_preferences 
       (user_id, preferred_categories, preferred_price_range, preferred_locations)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (user_id) DO UPDATE
       SET preferred_categories = $2,
           preferred_price_range = $3,
           preferred_locations = $4,
           last_updated = CURRENT_TIMESTAMP`,
      [userId, categories, priceRange, locations]
    );

    res.status(200).json({ message: 'Preferences updated' });
  } catch (error) {
    console.error('Error updating preferences:', error);
    res.status(500).json({ message: 'Error updating preferences' });
  }
});

export default router; 