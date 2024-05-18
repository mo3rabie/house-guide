// routes/user.js

const express = require('express');
const router = express.Router();
const UserController = require('../controllers/UserController');
const AuthMiddleware = require('../middlewares/AuthMiddleware');
const multer = require('multer');

// Define storage for the uploaded files
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/profiles'); // Set the destination folder for profile pictures
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + '-' + file.originalname); // Set the filename to be unique
    }
});

// Initialize multer with the storage options
const upload = multer({ storage: storage });

// GET user data
router.get('/', AuthMiddleware, UserController.getUserData);

// PUT update user data
router.put('/', AuthMiddleware, UserController.updateUserData);

// GET user data by ID
router.get('/:userId', UserController.getUserDataById);

// PUT update user data by ID
router.put('/:userId', UserController.updateUserDataById);


router.post('/bookmark/:houseId', AuthMiddleware, UserController.bookMark);


// Upload profile picture
router.post('/profile-picture', AuthMiddleware, upload.single('profilePicture'), UserController.uploadProfilePicture);

module.exports = router;