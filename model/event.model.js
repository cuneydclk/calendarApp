const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const eventSchema = new Schema({
  userID: {
    type: Schema.Types.ObjectId,
    ref: 'User',
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
  isApproved: {
    type: Boolean,
    default: false,
  },
});

const EventModel = db.model('event', eventSchema);

module.exports = EventModel;
