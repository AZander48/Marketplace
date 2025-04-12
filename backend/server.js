import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import routes from './routes/index.js';
import { query } from './config/database.js';
import multer from 'multer';
import fs from 'fs';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

// Load environment variables
dotenv.config();

const app = express();
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const port = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const uploadDir = path.join(__dirname, 'uploads');
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ 
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB limit
  },
  fileFilter: (req, file, cb) => {
    const allowedTypes = ['image/jpeg', 'image/png', 'image/gif'];
    if (!allowedTypes.includes(file.mimetype)) {
      cb(new Error('Invalid file type. Only JPEG, PNG and GIF are allowed.'));
    } else {
      cb(null, true);
    }
  }
});

// Middleware
app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Auth middleware
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid token' });
    }
    req.user = user;
    next();
  });
};

// Routes
app.use('/api', routes);

// Auth routes
app.post('/api/auth/register', async (req, res) => {
  try {
    const { name, email, password } = req.body;
    
    // Check if user already exists
    const existingUser = await query(
      'SELECT * FROM users WHERE email = $1',
      [email]
    );
    
    if (existingUser.rows.length > 0) {
      return res.status(400).json({ error: 'User already exists' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const result = await query(
      'INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING id, name, email',
      [name, email, hashedPassword]
    );

    // Generate token
    const token = jwt.sign(
      { id: result.rows[0].id, email: result.rows[0].email },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.status(201).json({
      ...result.rows[0],
      token
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/auth/login', async (req, res) => {
  try {
    const { identifier, password } = req.body;

    // Get user by email or username
    const result = await query(
      'SELECT * FROM users WHERE email = $1 OR name = $1',
      [identifier]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    const user = result.rows[0];

    // Check password
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Generate token
    const token = jwt.sign(
      { id: user.id, email: user.email },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.json({
      id: user.id,
      name: user.name,
      email: user.email,
      token
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Protected routes
app.get('/api/auth/me', authenticateToken, async (req, res) => {
  try {
    const result = await query(
      'SELECT id, name, email FROM users WHERE id = $1',
      [req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Test database connection
app.get('/api/test-connection', async (req, res) => {
  try {
    const result = await query('SELECT NOW()');
    res.json({
      status: 'success',
      message: 'Database connection successful',
      timestamp: result.rows[0].now
    });
  } catch (err) {
    console.error('Database connection error:', err);
    res.status(500).json({
      status: 'error',
      message: 'Database connection failed',
      error: err.message
    });
  }
});

// Image upload endpoint
app.post('/api/upload', upload.single('image'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'No file uploaded' });
  }

  // Return the URL of the uploaded image
  const imageUrl = `${process.env.BASE_URL || 'http://localhost:3000'}/uploads/${req.file.filename}`;
  res.json({ url: imageUrl });
});

// Product routes
app.post('/api/products', authenticateToken, async (req, res) => {
  try {
    const { title, description, price, category, condition, location, image_url } = req.body;
    const result = await query(
      'INSERT INTO products (user_id, title, description, price, category, condition, location, image_url) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *',
      [req.user.id, title, description, price, category, condition, location, image_url]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/products', async (req, res) => {
  try {
    const result = await query(
      'SELECT p.*, u.username as seller_name FROM products p JOIN users u ON p.user_id = u.id ORDER BY p.created_at DESC'
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/products/:id', async (req, res) => {
  try {
    const result = await query(
      'SELECT p.*, u.username as seller_name FROM products p JOIN users u ON p.user_id = u.id WHERE p.id = $1',
      [req.params.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Product not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.put('/api/products/:id', authenticateToken, async (req, res) => {
  try {
    const { title, description, price, category, condition, location, image_url } = req.body;
    const result = await query(
      'UPDATE products SET title = $1, description = $2, price = $3, category = $4, condition = $5, location = $6, image_url = $7 WHERE id = $8 AND user_id = $9 RETURNING *',
      [title, description, price, category, condition, location, image_url, req.params.id, req.user.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Product not found or unauthorized' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.delete('/api/products/:id', authenticateToken, async (req, res) => {
  try {
    const result = await query(
      'DELETE FROM products WHERE id = $1 AND user_id = $2 RETURNING *',
      [req.params.id, req.user.id]
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Product not found or unauthorized' });
    }
    res.json({ message: 'Product deleted successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Something went wrong!' });
});

// Start server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
}); 