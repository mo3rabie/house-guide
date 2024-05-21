// app.js
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
require('dotenv').config();
const path = require('path');

const app = express();

// Static Folder
app.use(express.static(path.join(__dirname,"uploads")));
app.use(express.static(path.join(__dirname,"uploads/profiles")));

// Middleware
app.use(bodyParser.json());

// Routes
const indexRoute = require('./routes/Index');
const authRoute = require('./routes/Auth');
const userRoute = require('./routes/User');
const houseRoute = require('./routes/House');
const ChatRoute = require('./routes/Chat');

app.use('/', indexRoute);
app.use('/api', authRoute);
app.use('/api/user', userRoute); 
app.use('/api/house', houseRoute);
app.use('/api', ChatRoute);

// Connect to MongoDB

mongoose.connect(process.env.MONGODB_URI).then(() => {
  console.log('Connected to MongoDB');
}).catch(err => {
  console.error('Error connecting to MongoDB', err);
});


// Start the server
const PORT = process.env.PORT || 4000;
app.listen(PORT,'192.168.43.114', () => {
  console.log(`Server is running on port ${PORT}`);
});