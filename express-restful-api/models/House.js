const mongoose = require('mongoose');

// Define the schema for the House collection
const houseSchema = new mongoose.Schema({
  name: {
     type: String,
     required: true
     },
  phone: { 
    type: String,
    required: true
     },
  address: {
     type: String, 
     required: true
      },
  price: {
     type: String,
      required: true
      },
  description: {
     type: String,
     required: true
      },
  images: {
     type: [String], 
     default: []
      },
  ownerId: {
     type: String,
      required: true
      }, // New field for storing the UID of the user who added the house
});
// Create models based on the schemas
const House = mongoose.model('House', houseSchema);

module.exports = House;