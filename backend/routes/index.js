import express from 'express';
import authRoutes from './auth.js';
import productRoutes from './products.js';
import testRoutes from './test.js';

const router = express.Router();

// Mount the routes
router.use('/auth', authRoutes);
router.use('/products', productRoutes);
router.use('/test', testRoutes);

export default router; 