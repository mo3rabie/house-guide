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

async function bookMark(req, res) {
    try {
        const houseId = req.params.houseId; // Extract houseId from params
        const userId = req.userId; // Get the user ID from the token
    
        // Retrieve the user document from the database
        const user = await UserModel.getUserById(userId); 
    
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }
    
        // Toggle the bookmark state
        const index = user.bookMark.indexOf(houseId);
        if (index === -1) {
            // Add the houseId to bookmarks
            user.bookMark.push(houseId);

        // Save the updated user document
        await user.save();
        res.status(200).json({ message: ' Bookmark is successfully' });
        } else {
            // Remove the houseId from bookmarks
            user.bookMark.splice(index, 1);
                
        // Save the updated user document
        await user.save();
        res.status(200).json({ message: ' Bookmark cancelled !' });
        }

    } catch (error) {
        if (error.name === 'CastError') {
            // Handle CastError (e.g., invalid ObjectId)
            return res.status(400).json({ message: 'Invalid user ID' });
        }
        console.error('Error handling bookmark action:', error);
        res.status(500).json({ message: 'Internal server error' });
       }     
    }


module.exports = { getUserDataById, updateUserDataById, updateUserData, getUserData, uploadProfilePicture, bookMark}; 
