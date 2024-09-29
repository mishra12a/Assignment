const db = require('../configuration/db');
const jwt = require('jsonwebtoken');
require('dotenv').config();

// Signup
exports.signup = (req, res) => {
    // Make sure the request is a POST request
    if (req.method !== 'POST') {
        return res.status(405).send('Method not allowed');
    }

    // Extract the username and password from the request body
    const { username, passkey } = req.body;
    console.log(" username =", username, " passkey =", passkey);
    console.log("process.env.JWT_SECRET =", process.env.JWT_SECRET);
    console.log("the request body =", req.body);
    // Check that the username and password are provided
    if (!username || !passkey) {
        return res.status(400).send('Username and password are required');
    }

    // Insert the new user into the database
    const sql = `INSERT INTO users (username, passkey) VALUES (?, ?)`;
    db.query(sql, [username, passkey], (err, result) => {
        // If there's an error, send a 500 response
        if (err) {
            console.error(err);
            return res.status(500).send('Error signing up');
        }
        // Otherwise, send a success message
        res.send('User registered');
    });
};

// Login
exports.login = (req, res) => {
    // Extract the username and password from the request body
    const { username, passkey } = req.body;

    // Find the user in the database
    const sql = 'SELECT * FROM users WHERE username = ?';
    db.query(sql, [username], (err, result) => {
        // If there's an error or the user doesn't exist, send a 400 response
        if (err || result.length === 0) {
            return res.status(400).send('User not found');
        }

        // Extract the user from the result
        const user = result[0];

        // Compare the provided password with the stored password
        if (passkey !== user.passkey) {
            return res.status(401).send('Invalid password');
        }

        // Generate a JWT token with the user's ID
        const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET);
        console.log("LOGIN WOEKA");
        // Send the token as the response
        res.json({ token });
    });
};