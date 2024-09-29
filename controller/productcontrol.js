const db = require('../configuration/db');

// Create a product
exports.createProduct = (req, res) => {
    const { name, description, price } = req.body;
    const userId = req.userId;

    const sql = 'INSERT INTO products (name, description, price, user_id) VALUES (?, ?, ?, ?)';
    db.query(sql, [name, description, price, userId], (err, result) => {
        if (err) return res.status(500).send('Error adding product');
        res.send('Product added successfully');
    });
};

// Get all products for a user
exports.getProducts = (req, res) => {
    const userId = req.userId;
    const sql = 'SELECT * FROM products WHERE user_id = ?';
    db.query(sql, [userId], (err, results) => {
        if (err) return res.status(500).send('Error retrieving products');
        res.json(results);
    });
};

// Update a product
exports.updateProduct = (req, res) => {
    const { id } = req.params;
    const { name, description, price } = req.body;
    const userId = req.userId;

    const sql = 'UPDATE products SET name = ?, description = ?, price = ? WHERE id = ? AND user_id = ?';
    db.query(sql, [name, description, price, id, userId], (err, result) => {
        if (err) return res.status(500).send('Error updating product');
        if (result.affectedRows === 0) return res.status(404).send('Product not found');
        res.send('Product updated successfully');
    });
};

// Delete a product
exports.deleteProduct = (req, res) => {
    const { id } = req.params;
    const userId = req.userId;

    const sql = 'DELETE FROM products WHERE id = ? AND user_id = ?';
    db.query(sql, [id, userId], (err, result) => {
        if (err) return res.status(500).send('Error deleting product');
        if (result.affectedRows === 0) return res.status(404).send('Product not found');
        res.send('Product deleted successfully');
    });
};
