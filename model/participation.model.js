const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const participationSchema = new Schema({
  userID: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  eventID: {
    type: Schema.Types.ObjectId,
    ref: 'Event',
    required: true,
  },
  isApproved: {
    type: Boolean,
    default: false,
  },
});

const ParticipationModel = db.model('participation', participationSchema);

module.exports = ParticipationModel;
