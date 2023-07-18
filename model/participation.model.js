const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const participationSchema = new Schema({
  userID: {
    type: String,
    required: true,
  },
  eventID: {
    type: String,
    required: true,
  },
  isApproved: {
    type: Boolean,
    default: false,
  },
});

const ParticipationModel = db.model('participation', participationSchema);

module.exports = ParticipationModel;
