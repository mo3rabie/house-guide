// controllers/UserController.js

const UserModel = require('../models/UserModel');
const { CastError } = require('mongoose'); // Import CastError from Mongoose

async function getUserDataById(req, res) {

    try {
        const userData = await UserModel.getUserById(req.params.userId); // Ensure userId is a valid ObjectId string
        res.status(200).json(userData);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

// async function updateUserDataById(req, res) {
//     const userId = req.params.userId;
//     const newData = req.body;

//     try {
//         const updatedUserData = await UserModel.updateUserDataById(userId, newData);
//         res.status(200).json(updatedUserData);
//     } catch (error) {
//         console.error(error);
//         res.status(500).json({ error: 'Internal server error' });
//     }
// }

async function getUserData(req, res) {
    try {
        // Get the user ID from the token
        const userId = req.userId;
        const userData = await UserModel.getUserById(userId);
        res.status(200).json(userData);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

async function updateUserData(req, res) {
    try {
        // Get the user ID from the token
        const userId = req.userId;
        const newData = req.body;

        const updatedUserData = await UserModel.updateUserDataById(userId, newData);
        res.status(200).json(updatedUserData);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

// Create a new chat
async function createChat(req, res) {
    try {
        const { participants } = req.body;
        const chat = await UserModel.findByIdAndUpdate(req.userId, {
            $push: {
                chats: {
                    participants
                }
            }
        }, { new: true });
        res.status(201).json(chat);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Could not create chat' });
    }
}

// Send a message in a chat
async function sendMessage(req, res) {
    try {
        const { chatId } = req.params;
        const { sender, content } = req.body;

        const userId = req.userId;
        const user = await UserModel.findById(userId);

        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        const chat = user.chats.find(chat => chat._id.toString() === chatId);
        if (!chat) {
            return res.status(404).json({ error: 'Chat not found' });
        }

        chat.messages.push({ sender, content });
        await user.save();

        res.json(chat);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Could not send message' });
    }
}

// Function to upload profile picture
async function uploadProfilePicture(req, res) {
    try {
        // Get the user ID from the token
        const userId = req.userId;

        // Check if a file was uploaded
        if (!req.file) {
            return res.status(400).json({ error: 'No file uploaded' });
        }

        // Get the filename of the uploaded file
        const filename = req.file.filename;

        // Update the user's profile picture in the database
        await UserModel.findByIdAndUpdate(userId, { profilePicture: filename });

        // Send success response
        res.status(200).json({ message: 'Profile picture uploaded successfully', filename: filename });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

module.exports = { getUserDataById, updateUserData, getUserData, createChat, sendMessage, uploadProfilePicture}; 
