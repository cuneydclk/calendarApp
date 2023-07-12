const express = require('express');
const mongoose = require('mongoose');

// Connect to MongoDB
mongoose.connect('mongodb://localhost/datesDB', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Create a schema for dates
const dateSchema = new mongoose.Schema({
  date: {
    type: Date,
    required: true,
  },
});

// Create a model for dates
const DateModel = mongoose.model('Date', dateSchema);

// Create Express app
const app = express();

// Define a route to get all dates
app.get('/dates', async (req, res) => {
  try {
    // Retrieve all dates from the database
    const dates = await DateModel.find();
    res.json(dates);
  } catch (error) {
    res.status(500).json({ error: 'Failed to retrieve dates' });
  }
});

// Start the server
const port = 3000;
app.listen(port, () => {
  console.log(`Server is listening on port ${port}`);
});
