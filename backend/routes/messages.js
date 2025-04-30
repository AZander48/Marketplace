import express from 'express';
import { pool } from '../config/database.js';
import { authenticateToken } from './auth.js';

const router = express.Router();

// Get messages for a product
router.get('/product/:productId', authenticateToken, async (req, res) => {
  try {
    const { productId } = req.params;
    const result = await pool.query(`
      SELECT 
        m.*,
        s.username as sender_name,
        r.username as receiver_name,
        p.title as product_title
      FROM messages m
      LEFT JOIN users s ON m.sender_id = s.id
      LEFT JOIN users r ON m.receiver_id = r.id
      LEFT JOIN products p ON m.product_id = p.id
      WHERE m.product_id = $1
      ORDER BY m.created_at ASC
    `, [productId]);

    res.json(result.rows);
  } catch (error) {
    console.error('Error fetching messages:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Send a message
router.post('/', authenticateToken, async (req, res) => {
  try {
    const { product_id, receiver_id, message } = req.body;
    const sender_id = req.user.userId; // Changed from req.user.id to req.user.userId

    // Validate required fields
    if (!product_id || !receiver_id || !message || !sender_id) {
      return res.status(400).json({ 
        error: 'Missing required fields',
        received: { product_id, receiver_id, message, sender_id }
      });
    }

    const result = await pool.query(`
      INSERT INTO messages (
        sender_id, receiver_id, product_id, message, 
        created_at, updated_at, is_read
      ) VALUES ($1, $2, $3, $4, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false)
      RETURNING *
    `, [sender_id, receiver_id, product_id, message]);

    // Get the full message details including usernames
    const fullMessage = await pool.query(`
      SELECT 
        m.*,
        s.username as sender_name,
        r.username as receiver_name,
        p.title as product_title
      FROM messages m
      LEFT JOIN users s ON m.sender_id = s.id
      LEFT JOIN users r ON m.receiver_id = r.id
      LEFT JOIN products p ON m.product_id = p.id
      WHERE m.id = $1
    `, [result.rows[0].id]);

    res.status(201).json(fullMessage.rows[0]);
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Mark message as read
router.put('/:messageId/read', authenticateToken, async (req, res) => {
  try {
    const { messageId } = req.params;
    const result = await pool.query(`
      UPDATE messages 
      SET is_read = true, updated_at = CURRENT_TIMESTAMP
      WHERE id = $1
      RETURNING *
    `, [messageId]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Message not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Error marking message as read:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

export default router;
