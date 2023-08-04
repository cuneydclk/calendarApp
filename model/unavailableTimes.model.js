// unavailableTimesModel.js
const mongoose = require('mongoose');

const db = require('../config/db');

const { Schema } = mongoose;

const unavailableTimesSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  startDate: {
    type: Date,
    required: true,
  },
  endDate: {
    type: Date,
    required: true,
  },
});

const UnavailableTimesModel = db.model('UnavailableTimes', unavailableTimesSchema);

module.exports = UnavailableTimesModel;
