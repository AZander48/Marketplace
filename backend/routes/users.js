import express from 'express';
import { pool } from '../config/database.js';
import { authenticateToken } from './auth.js';

const router = express.Router();

// Get user profile
router.get('/:userId', async (req, res) => {
  try {
    const { userId } = req.params;
    
    const result = await pool.query(
      `SELECT 
        u.id,
        u.username,
        u.email,
        c.name as location,
        u.created_at,
        COALESCE(AVG(r.rating), 0) as average_rating
      FROM users u
      LEFT JOIN cities c ON u.city_id = c.id
      LEFT JOIN reviews r ON r.reviewed_id = u.id
      WHERE u.id = $1
      GROUP BY u.id, c.name`,
      [userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error fetching user profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get user rating
router.get('/:userId/rating', async (req, res) => {
  try {
    const { userId } = req.params;
    
    const result = await pool.query(
      `SELECT COALESCE(AVG(rating), 0) as average_rating 
       FROM reviews 
       WHERE reviewed_id = $1`,
      [userId]
    );

    res.json({ average_rating: parseFloat(result.rows[0].average_rating) });
  } catch (error) {
    console.error('Error fetching user rating:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get user products
router.get('/:userId/products', async (req, res) => {
  try {
    const { userId } = req.params;
    
    const result = await pool.query(
      `SELECT p.*, c.name as category_name 
       FROM products p 
       LEFT JOIN categories c ON p.category_id = c.id 
       WHERE p.user_id = $1 
       ORDER BY p.created_at DESC`,
      [userId]
    );

    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching user products:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get user profile by ID
router.get('/:id', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        u.id,
        u.username,
        u.email,
        u.profile_image_url,
        u.bio,
        u.phone_number,
        u.is_verified,
        u.last_active,
        u.created_at,
        c.name as city_name,
        s.name as state_name,
        co.name as country_name,
        (
          SELECT COUNT(*)
          FROM products
          WHERE user_id = u.id
        ) as listing_count,
        (
          SELECT COALESCE(AVG(rating), 0)
          FROM reviews
          WHERE reviewed_id = u.id
        ) as average_rating,
        (
          SELECT COUNT(*)
          FROM reviews
          WHERE reviewed_id = u.id
        ) as review_count
      FROM users u
      LEFT JOIN cities c ON u.city_id = c.id
      LEFT JOIN states s ON c.state_id = s.id
      LEFT JOIN countries co ON s.country_id = co.id
      WHERE u.id = $1
    `, [req.params.id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    const user = result.rows[0];
    res.json(user);
  } catch (error) {
    console.error('Error getting user:', error);
    res.status(500).json({ message: 'Error getting user profile' });
  }
});

// Update user profile (requires authentication)
router.put('/:id', authenticateToken, async (req, res) => {
  try {
    // Ensure users can only update their own profile
    if (req.user.id !== parseInt(req.params.id)) {
      return res.status(403).json({ message: 'Not authorized to update this profile' });
    }

    const { username, bio, phone_number, city_id } = req.body;

    // Check if username is already taken
    if (username) {
      const usernameCheck = await pool.query(
        'SELECT id FROM users WHERE username = $1 AND id != $2',
        [username, req.user.id]
      );
      if (usernameCheck.rows.length > 0) {
        return res.status(400).json({ message: 'Username already taken' });
      }
    }

    const result = await pool.query(`
      UPDATE users
      SET 
        username = COALESCE($1, username),
        bio = COALESCE($2, bio),
        phone_number = COALESCE($3, phone_number),
        city_id = COALESCE($4, city_id),
        updated_at = CURRENT_TIMESTAMP
      WHERE id = $5
      RETURNING 
        id, 
        username, 
        email, 
        profile_image_url, 
        bio, 
        phone_number, 
        is_verified, 
        last_active, 
        created_at
    `, [username, bio, phone_number, city_id, req.user.id]);

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error updating user:', error);
    res.status(500).json({ message: 'Error updating user profile' });
  }
});

// Get user's reviews
router.get('/:id/reviews', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        r.*,
        u.username as reviewer_name,
        u.profile_image_url as reviewer_image
      FROM reviews r
      JOIN users u ON r.reviewer_id = u.id
      WHERE r.reviewed_id = $1
      ORDER BY r.created_at DESC
    `, [req.params.id]);

    res.json(result.rows);
  } catch (error) {
    console.error('Error getting user reviews:', error);
    res.status(500).json({ message: 'Error getting user reviews' });
  }
});

// Get user's statistics
router.get('/:id/stats', async (req, res) => {
  try {
    const stats = await pool.query(`
      SELECT 
        (SELECT COUNT(*) FROM products WHERE user_id = $1) as total_listings,
        (SELECT COUNT(*) FROM orders WHERE seller_id = $1) as total_sales,
        (SELECT COUNT(*) FROM orders WHERE buyer_id = $1) as total_purchases,
        (
          SELECT COALESCE(AVG(rating), 0) 
          FROM reviews 
          WHERE reviewed_id = $1
        ) as average_rating,
        (
          SELECT COUNT(*) 
          FROM reviews 
          WHERE reviewed_id = $1
        ) as total_reviews
    `, [req.params.id]);

    res.json(stats.rows[0]);
  } catch (error) {
    console.error('Error getting user stats:', error);
    res.status(500).json({ message: 'Error getting user statistics' });
  }
});

// Upload profile image
router.post('/:id/profile-image', authenticateToken, async (req, res) => {
  try {
    // Ensure users can only update their own profile image
    if (req.user.id !== parseInt(req.params.id)) {
      return res.status(403).json({ message: 'Not authorized to update this profile' });
    }

    // TODO: Implement file upload logic
    // This would involve using a package like multer for handling file uploads
    // and possibly a cloud storage service like AWS S3 for storing the images

    res.status(501).json({ message: 'Profile image upload not implemented yet' });
  } catch (error) {
    console.error('Error uploading profile image:', error);
    res.status(500).json({ message: 'Error uploading profile image' });
  }
});

export default router; 