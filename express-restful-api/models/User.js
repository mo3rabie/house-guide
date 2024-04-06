// models/User.js
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
  },
  password: {
    type: String,
    required: true,
  },
  phoneNumber: { 
    type: String, 
    required: true 
  },
  profilePicture: { 
    type: String 
 },
  addedHouses: [{ 
    type: mongoose.Schema.Types.ObjectId, ref: 'house'
   }], // Reference to House collection
  bookMark: [{
     type: mongoose.Schema.Types.ObjectId, ref: 'house'
     }], // Reference to House collection this Book Marked by user 
});

module.exports = mongoose.model('User', userSchema);