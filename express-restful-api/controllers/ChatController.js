// controllers/ChatController.js

const Chat = require('../models/ChatModel');


// Method to create a new chat
async function createChat(req, res) {
    try {
        const senderId = req.userId;
        const receiverId = req.body.receiverId;

        // Ensure the receiverId is provided
        if (!receiverId) {
            return res.status(400).json({ error: 'Receiver ID is required' });
        }

        // Create a new chat with the sender and receiver as participants
        const participants = [senderId, receiverId];
        const chat = new Chat({ participants });
        await chat.save();

        res.status(201).json({ message: 'Chat created successfully', chat });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}


// Method to send a chat message
async function sendChatMessage(req, res) {
    try {
        const { chatId } = req.params;
        const { sender } = req.userId;
        const { content } = req.body;

        // Find the chat by ID
        const chat = await Chat.findById(chatId);

        if (!chat) {
            return res.status(404).json({ error: 'Chat not found' });
        }

        // Add the message to the chat
        chat.messages.push({ sender, content });
        await chat.save();

        res.status(200).json({ message: 'Message sent successfully', chat });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

// Method to get chat messages by user ID
async function getChatByUserId(req, res) {
    try {
        // Ensure userId is provided in the request
        const userId = req.userId;
        if (!userId) {
            return res.status(400).json({ error: 'User ID is required' });
        }

        // Find chats where the user is a participant
        const chats = await Chat.find({ 'participants': userId });

        // If no chats found, respond with a 404 status
        if (!chats || chats.length === 0) {
            return res.status(404).json({ error: 'No chats found for the user' });
        }

        res.status(200).json(chats);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}




module.exports = { sendChatMessage, getChatByUserId, createChat };