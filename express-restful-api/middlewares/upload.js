//middlewares/uploads.js

const multer = require('multer');

// Define storage for the uploaded files
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname);
  }
});



// Initialize multer with the storage options and file filter
const upload = multer({
  storage: storage,
  limits: { fileSize: 10000000 }, // Limit file size to 10MB
  onError: function (err, next) {
    console.error('Multer error:', err);
    next(err);
  }
}).array('images', 10); // Allow up to 10 images to be uploaded

module.exports = upload;
