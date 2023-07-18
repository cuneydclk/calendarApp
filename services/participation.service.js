const ParticipationModel = require('../model/participation.model');
const UserModel = require('../model/user.model');

class ParticipationService {
  static async getUnapprovedUsers(eventID) {
    try {
      // Find all participations for the given eventID
      const participations = await ParticipationModel.find({ eventID });

      // Get the IDs of all approved participants
      const approvedUserIDs = participations
        .filter(participation => participation.isApproved)
        .map(participation => participation.userID);

      // Find users who haven't been approved (based on their IDs)
      const unapprovedUsers = await UserModel.find({
        _id: { $nin: approvedUserIDs },
      });

      return unapprovedUsers;
    } catch (error) {
      throw error;
    }
  }

  static async saveParticipation(userID, eventID) {
    try {
      const newParticipation = new ParticipationModel({
        userID,
        eventID,
        isApproved: false,
      });

      return await newParticipation.save();
    } catch (error) {
      throw error;
    }
  }
}

module.exports = ParticipationService;

