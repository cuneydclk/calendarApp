const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const eventSchema = new Schema({
  email: {
    type: String,
    lowercase: true,
    required: true,
  },
  eventTitle: {
    type: String,
    required: true,
  },
  startTime: {
    type: Date,
    required: true,
  },
  finishTime: {
    type: Date,
    required: true,
  },
});

const EventModel = db.model('event', eventSchema);

module.exports = EventModel;
