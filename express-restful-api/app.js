// app.js
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();

// Middleware
app.use(bodyParser.json());

// Routes
const indexRoute = require('./routes/index');
const authRoute = require('./routes/auth');

app.use('/', indexRoute);
app.use('/auth', authRoute);

// Connect to MongoDB
mongoose.connect(process.env.MONGODB_URI);

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});