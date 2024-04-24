const express = require('express');
const router = express.Router();
const { register, login } = require('../controllers/AuthController');
const validateUserMiddleware = require('../middlewares/UserMiddlewareValidator');

// Register a new user
router.post('/register', validateUserMiddleware, register);

// Login
router.post('/login', login);

module.exports = router;
