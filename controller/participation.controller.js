const ParticipationService = require('../services/participation.service');

exports.saveParticipation = async (req, res, next) => {
  try {
    const { userID, eventID } = req.body;

    const savedParticipation = await ParticipationService.saveParticipation(userID, eventID);

    res.json({ status: true, success : "savedParticipation"});
  } catch (error) {
    throw error;
  }
}

exports.getUnapprovedUsers = async (req, res, next) => {
  try {
    const { eventID } = req.params;

    const unapprovedUsers = await ParticipationService.getUnapprovedUsers(eventID);

    res.json({ status: true, unapprovedUsers });
  } catch (error) {
    throw error;
  }
}
