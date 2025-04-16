import express from 'express';
import authRoutes from './auth.js';
import productRoutes from './products.js';
import testRoutes from './test.js';
import categoryRoutes from './categories.js';

const router = express.Router();

// Mount the routes
router.use('/auth', authRoutes);
router.use('/products', productRoutes);
router.use('/test', testRoutes);
router.use('/categories', categoryRoutes);

export default router; 