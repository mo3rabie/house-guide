// AuthMiddleware.js

// Import necessary modules
const jwt = require('jsonwebtoken');
const User = require('../models/UserModel');

// Middleware function for authentication
async function authMiddleware(req, res, next) {
    // Get the token from the request headers
    const token = req.headers.authorization;

    if (!token) {
        return res.status(401).json({ error: 'Token is empty' });
    }

    try {
        // Verify the token
        const decoded = jwt.verify(token.split(' ')[1], process.env.JWT_SECRET);

        // Attach the user ID to the request for further processing
        req.userId = decoded.userId;

        // Update the lastLogout timestamp for the user
        await User.findByIdAndUpdate(decoded.userId, { lastLogout: new Date() });

        // If you have session data to clear, you can do so here
        // For example, if you are using express-session:
        if (req.session) {
            req.session.destroy((err) => {
                if (err) {
                    console.error("Error destroying session:", err);
                    return res.status(500).json({ error: 'Failed to clear session data' });
                }
                // Successfully cleared session data
                console.log("Session data cleared");
                next(); // Move to the next middleware or route handler
            });
        } else {
            console.warn("No session found");
            next(); // Move to the next middleware or route handler
        }
    } catch (error) {
        console.error("Token verification error:", error.message);
        return res.status(401).json({ error: 'Invalid or expired token.' });
    }
}

module.exports = authMiddleware;
