// controllers/HouseController.js

const House = require('../models/HouseModel');



async function createHouse(req, res) {
  try {
    const { body } = req;
    const files = req.files;

    console.log('Request Body:', body);
    console.log('Uploaded Files:', files);

    if (!files || files.length === 0) {
      throw new Error('No files uploaded');
    }

    // Remove 'uploads/' from the file paths
    const images = files.map(file => file.path.replace(/^uploads[\/\\]/, ''));
    console.log('Images Files:', images);

    const house = await House.create({
      ...body,
      ownerId: req.userId,
      images
    });

    console.log('New House:', house);
    res.status(201).json({ message: 'House created successfully', house });
  } catch (error) {
    console.error('Error creating house:', error);
    res.status(500).json({ error: 'Internal server error', details: error.message });
  }
}



async function getAllHouses(req, res) {
  try {
    const houses = await House.find();
    res.json(houses);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}


async function getHouseById(req, res) {
  const { id } = req.params;
  try {
    const house = await House.findById(id);
    if (!house) {
      return res.status(404).json({ error: "House not found" });
    }
    res.json(house);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}



async function deleteHouseById(req, res) {
  const { id } = req.params;
  try {
   const house = await House.findByIdAndDelete(id);
    res.status(204).json({ message: 'House Deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function getHouseByOwnerId(req, res) {
  const { ownerId } = req.params;
  try {
    const houses = await House.find({ ownerId });
    if (!houses) {
      return res.status(404).json({ error: "House not found for the given owner ID" });
    }
    res.json(houses);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function searchHouseByAddress(req, res) {
  const { address } = req.params;
  try {
    // Perform a search based on the address
    const houses = await House.searchHouseByAddress(address);

    if (houses.length === 0) {
      return res.status(404).json({ error: "No houses found for the given address" });
    }

    res.json(houses);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}


  


module.exports = {
  createHouse,
  getAllHouses,
  getHouseById,
  deleteHouseById,
  getHouseByOwnerId,
  searchHouseByAddress
};
