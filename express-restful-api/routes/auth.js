// routes/auth.js
const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const validator = require('validator');
const User = require('../models/User');

// Register a new user
router.post('/register', async (req, res) => {
    const { username, email, password, phoneNumber } = req.body;

    // Validate email
    if (!validator.isEmail(email)) {
        return res.status(400).json({ error: 'Invalid email address' });
    }

    // Check if username already exists
    const existingEmail = await User.findOne({ email });
    if (existingEmail) {
        return res.status(400).json({ error: 'Email already exists' });
    }

    // Check if username already exists
    const existingUsername = await User.findOne({ username });
    if (existingUsername) {
        return res.status(400).json({ error: 'Username already exists' });
    }

    // Check if phone number already in use
    const existingPhoneNumber = await User.findOne({ phoneNumber });
    if (existingPhoneNumber) {
        return res.status(400).json({ error: 'Phone number already in use' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    try {
        const user = await User.create({
            username,
            email,
            password: hashedPassword,
            phoneNumber,
            profilePicture: 'https://via.placeholder.com/150', // Default profile picture URL
            addedHouses: [], // Initialize with an empty array
            bookMark: [], // Initialize with an empty array
        });

        res.status(201).json({ message: 'User registered successfully' });
    } catch (error) {
        console.error(error); // Log the error message
        res.status(400).json({ error: 'Registration failed' });
    }
});


// Login
router.post('/login', async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await User.findOne({ email });

        if (!user) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const validPassword = await bcrypt.compare(password, user.password);

        if (!validPassword) {
            return res.status(401).json({ error: 'Invalid credentials' });
        }

        const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
            expiresIn: '1h',
        });

        res.json({ token });
    } catch (error) {
        res.status(400).json({ error: 'Login failed' });
    }
});

module.exports = router;