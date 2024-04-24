// routes/user.js

const express = require('express');
const router = express.Router();
const UserController = require('../controllers/UserController');

// GET user data by ID
router.get('/:userId', UserController.getUserDataById);

// PUT update user data by ID
router.put('/:userId', UserController.updateUserDataById);

module.exports = router;