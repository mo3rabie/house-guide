// app.js
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();

// Middleware
app.use(bodyParser.json());

// Routes
const indexRoute = require('./routes/Index');
const authRoute = require('./routes/Auth');
const userRoute = require('./routes/User');
const houseRoute = require('./routes/House');

app.use('/', indexRoute);
app.use('/api', authRoute);
app.use('/api/user', userRoute); 
app.use('/api/house', houseRoute);

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI).then(() => console.log('MongoDB connected'))
.catch(err => console.log(err));

// Start the server
const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});