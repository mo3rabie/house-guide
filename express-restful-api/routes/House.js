// routes/HouseRoutes.js

const express = require('express');
const router = express.Router();
const { validateHouse } = require('../util/HouseValidator');
const { handleValidationError } = require('../middlewares/HouseMiddlewareValidator');
const HouseController = require('../controllers/HouseController');
const upload = require('../middlewares/upload');
const AuthMiddleware = require('../middlewares/AuthMiddleware');

router.use(handleValidationError); // Error handling middleware

router.post('/',AuthMiddleware,upload,validateHouse,HouseController.createHouse);
router.get('/', HouseController.getAllHouses);
router.get('/:id', HouseController.getHouseById);
router.delete('/:id', HouseController.deleteHouseById);
router.get('/searchHouse/:address', HouseController.searchHouseByAddress);
router.get('/owner/:ownerId', HouseController.getHouseByOwnerId);


module.exports = router;
