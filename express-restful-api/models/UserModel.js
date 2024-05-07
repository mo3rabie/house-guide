// models/User.js

const mongoose = require('mongoose');
const validator = require('validator');

const userSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
        unique: true,
        minlength: 1,
        maxlength: 50
    },
    email: {
        type: String,
        required: true,
        unique: true,
        lowercase: true,
        validate: {
            validator: (value) => {
                return validator.isEmail(value);
            },
            message: '{VALUE} is not a valid Email'
        }
    },
    password: {
        type: String,
        required: true,
        minLength: 6,
        validate: {
            validator: (value) => {
                return validator.isStrongPassword(value);
            },
            message: 'password should contain at least one upper case letter,' +
                'one lower case letter and one special character.'
        }
    },
    phoneNumber: {
        type: String,
        required: true,
        minlength: 11
    },
    profilePicture: {
        type: String
    },
    addedHouses: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'house'
    }], // Reference to House collection
    bookMark: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'house'
    }], // Reference to House collection this Book Marked by user 
    // Chat related fields
    chats: [{
        // Each chat entry will have two participants (users)
        participants: [{
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User'
        }],
        // Array to store messages in the chat
        messages: [{
            // Each message will have a sender (user)
            sender: {
                type: mongoose.Schema.Types.ObjectId,
                ref: 'User'
            },
            // Message content
            content: String,
            // Timestamp of when the message was sent
            timestamp: {
                type: Date,
                default: Date.now
            }
        }]
    }]
});

// Function to get user by ID
async function getUserById(userId) {
    return await this.findById(userId);
}

// Function to update user data by ID
async function updateUserDataById(userId, newData) {
    return await this.findByIdAndUpdate(userId, newData, { new: true });
}

// Add the functions to the schema as static methods
userSchema.statics.getUserById = getUserById;
userSchema.statics.updateUserDataById = updateUserDataById;

module.exports = mongoose.model('User', userSchema);
