const express = require('express');
const router = express.Router();
const { register, login , logout } = require('../controllers/AuthController');
const validateUserMiddleware = require('../middlewares/UserMiddlewareValidator');
const AuthMiddleware = require('../middlewares/AuthMiddleware');

// Register a new user
router.post('/register', validateUserMiddleware, register);

// Login
router.post('/login', login);

// Route for user logout
router.post('/logout', AuthMiddleware, logout);

module.exports = router;
