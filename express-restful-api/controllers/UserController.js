// controllers/UserController.js

const UserModel = require('../models/UserModel');

async function getUserDataById(req, res) {
    
    try {
        const userData = await UserModel.getUserById(req.params.userId); // Ensure userId is a valid ObjectId string
        res.status(200).json(userData);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

async function updateUserDataById(req, res) {
    const userId = req.params.userId;
    const newData = req.body;

    try {
        const updatedUserData = await UserModel.updateUserDataById(userId, newData);
        res.status(200).json(updatedUserData);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

module.exports = { getUserDataById, updateUserDataById }; 
