// middlewares/UserMiddlewareValidator.js

const userValidator = require('../util/UserValidator');

// Middleware function to validate user data
function validateUser(req, res, next) {

  // Validate user data using the userValidator function
  const isValid = userValidator(req.body);

  if (!isValid) {
    // If user data is invalid, send an error response
    return res.status(400).json({ error: 'Invalid user data', details: userValidator.errors });
  }

  // If user data is valid, proceed to the next middleware or route handler
  next();
}

module.exports = validateUser;
