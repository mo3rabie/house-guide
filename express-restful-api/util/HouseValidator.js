// util/HouseValidator.js

function validateHouse(req, res, next) {
    const { name, phone, address, price, description, images } = req.body;
    if (!name || !phone || !address || !price || !description || !images) {
      return res.status(400).json({ error: "Missing required fields" });
    }
    next();
  }
  
  module.exports = { validateHouse };
  