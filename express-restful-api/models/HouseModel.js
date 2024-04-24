// models/HouseModel.js

const mongoose = require('mongoose');

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
  }
});



// Static method to search houses by address
houseSchema.statics.searchHouseByAddress = async function (address) {
   return this.find({ address: { $regex: address, $options: 'i' } }); // Case-insensitive search
 };
 
const House = mongoose.model('House', houseSchema);

module.exports = House;
