const mongoose = require('mongoose');

const db = require('../config/db');

const { Schema } = mongoose;

const workingHoursSchema = new Schema({
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  dayOfWeek: {
    type: Number,
    required: true,
  },
  startTime: {
    type: String,
    required: true,
  },
  endTime: {
    type: String,
    required: true,
  },
});

const WorkingHoursModel = db.model('WorkingHours', workingHoursSchema);

module.exports = WorkingHoursModel;
