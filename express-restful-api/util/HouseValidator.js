// util/HouseValidator.js

function validateHouse(req, res, next) {
    const { name, phone, address, price, description } = req.body;
    if (!name || !phone || !address || !price || !description ) {
      return res.status(400).json({ error: "Missing required fields" });
    }
    next();
  }
  
  module.exports = { validateHouse };
  