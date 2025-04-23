import express from 'express';
import { pool } from '../config/database.js';
import { authenticateToken } from './auth.js';

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
router.get('/', authenticateToken, async (req, res) => {
  const userId = req.user?.id; // Get authenticated user if available
  
  try {
    let query;
    const params = [];

    if (userId) {
      // Personalized recommendations for logged-in users
      query = `
        WITH UserPreferences AS (
          SELECT 
            preferred_categories,
            preferred_price_range,
            preferred_locations
          FROM user_preferences
          WHERE user_id = $1
        ),
        UserInteractions AS (
          SELECT 
            product_id,
            COUNT(*) as interaction_count
          FROM user_interactions
          WHERE user_id = $1
          GROUP BY product_id
        ),
        PopularProducts AS (
          SELECT 
            p.*,
            COALESCE(pp.view_count, 0) as view_count,
            COALESCE(pp.favorite_count, 0) as favorite_count
          FROM products p
          LEFT JOIN product_popularity pp ON p.id = pp.product_id
          WHERE p.created_at >= NOW() - INTERVAL '30 days'
        )
        SELECT DISTINCT 
          p.*,
          u.username as seller_name,
          c.name as category_name,
          COALESCE(ui.interaction_count, 0) * 2 + 
          COALESCE(pp.view_count, 0) * 0.3 + 
          COALESCE(pp.favorite_count, 0) * 1.5 as relevance_score
        FROM PopularProducts pp
        JOIN products p ON p.id = pp.product_id
        JOIN users u ON p.user_id = u.id
        JOIN categories c ON p.category_id = c.id
        LEFT JOIN UserInteractions ui ON p.id = ui.product_id
        LEFT JOIN UserPreferences up ON TRUE
        WHERE 
          CASE 
            WHEN up.preferred_categories IS NOT NULL 
            THEN p.category_id = ANY(up.preferred_categories)
            ELSE TRUE
          END
        AND
          CASE 
            WHEN up.preferred_price_range IS NOT NULL 
            THEN p.price BETWEEN (up.preferred_price_range->>'min')::numeric 
                             AND (up.preferred_price_range->>'max')::numeric
            ELSE TRUE
          END
        ORDER BY relevance_score DESC
        LIMIT 20;
      `;
      params.push(userId);
    } else {
      // Default recommendations for non-logged-in users based on popularity
      query = `
        SELECT 
          p.*,
          u.username as seller_name,
          c.name as category_name,
          COALESCE(pp.view_count, 0) * 0.3 + 
          COALESCE(pp.favorite_count, 0) * 1.5 as relevance_score
        FROM products p
        JOIN users u ON p.user_id = u.id
        JOIN categories c ON p.category_id = c.id
        LEFT JOIN product_popularity pp ON p.id = pp.product_id
        WHERE p.created_at >= NOW() - INTERVAL '30 days'
        ORDER BY relevance_score DESC
        LIMIT 20;
      `;
    }

    const result = await pool.query(query, params);
    res.json({ products: result.rows });
  } catch (error) {
    console.error('Error getting recommendations:', error);
    res.status(500).json({ error: 'Failed to get recommendations' });
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