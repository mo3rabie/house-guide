
const multer = require('multer'); // Add multer for file uploads

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname);
  }
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 10000000 // Limit file size to 10MB
  },
  fileFilter: function (req, file, cb) {
    checkFileType(file, cb);
  }
}).array('images', 10); // Allow up to 10 images to be uploaded

function checkFileType(file, cb) {
  // Allowed file extensions
  const filetypes = /jpeg|jpg|png|gif/;

  // Check file extension
  const extname = filetypes.test(file.originalname.toLowerCase());

  // Check mime type
  const mimetype = filetypes.test(file.mimetype);

  if (mimetype && extname) {
    return cb(null, true);
  } else {
    cb('Error: Images only!');
  }
}

module.exports = upload;