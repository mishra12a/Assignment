const express = require('express');
const { createProduct, getProducts, updateProduct, deleteProduct } = require('../controller/productcontrol');
const { verifyToken } = require('../middleware/middleware');
const router = express.Router();

router.post('/products', verifyToken, createProduct);
router.get('/getproducts', verifyToken, getProducts);
router.put('/products/:id', verifyToken, updateProduct);
router.delete('/products/:id', verifyToken, deleteProduct);

module.exports = router;
