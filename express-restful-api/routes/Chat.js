// routes/chat.js

const express = require('express');
const router = express.Router();
const AuthMiddleware = require('../middlewares/AuthMiddleware');
const ChatController = require('../controllers/ChatController');

// Create a new chat
router.post('/chat', AuthMiddleware, ChatController.createChat);

// Send a message in a chat
router.post('/chat/:chatId/send', AuthMiddleware, ChatController.sendChatMessage);

// get a chat by user id
router.get('/chat', AuthMiddleware, ChatController.getChatByUserId);

module.exports = router;