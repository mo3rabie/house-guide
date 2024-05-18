const mongoose = require('mongoose');

// Define the schema for the Chat model
const chatSchema = new mongoose.Schema({
    participants: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User' // Refers to the User model
    }],
    messages: [{
        sender: {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User' // Refers to the User model
        },
        content: String,
        timestamp: {
            type: Date,
            default: Date.now
        }
    }]
});

// Create the Mongoose model using the schema
const Chat = mongoose.model('Chat', chatSchema);

// Export the Chat model
module.exports = Chat;
