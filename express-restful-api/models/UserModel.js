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
        ref: 'houses'
    }], // Reference to House collection
    bookMark: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'houses'
    }], // Reference to House collection this Book Marked by user 

    lastLogout: {
        type: Date
    }

});

// Function to get user by ID
async function getUserById(userId) {
    return await this.findById(userId);
}

// Function to update user data by ID
async function updateUserDataById(userId, newData) {
    return await this.findByIdAndUpdate(userId, newData, { new: true });
}

userSchema.methods.logout = async function () {
    // Update the lastLogout timestamp
    this.lastLogout = new Date();
    await this.save(); // Save the user document
};

// Add the functions to the schema as static methods
userSchema.statics.getUserById = getUserById;
userSchema.statics.updateUserDataById = updateUserDataById;

module.exports = mongoose.model('User', userSchema);
