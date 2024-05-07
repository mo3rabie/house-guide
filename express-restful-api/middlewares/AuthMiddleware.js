// AuthMiddleware.js

// Import necessary modules
const jwt = require('jsonwebtoken');

// Middleware function for authentication
function authMiddleware(req, res, next) {
    // Get the token from the request headers
    const token = req.headers.authorization;
    console.log("Token received:", token); // Add logging statement

    if (!token) {
        return res.status(401).json({ error: 'Token is empty' });
    }

    try {
        // Verify the token
        const decoded = jwt.verify(token.split(' ')[1], process.env.JWT_SECRET); // Extract token value
        console.log("Token decoded:", decoded); // Add logging statement

        // Attach the user ID to the request for further processing
        req.userId = decoded.userId;

        // Move to the next middleware or route handler
        next();
    } catch (error) {
        console.error("Token verification error:", error.message); // Add logging statement
        return res.status(401).json({ error: 'Unauthorized. Invalid token.' });
    }
}

module.exports = authMiddleware;
