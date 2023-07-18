const ParticipationModel = require('../model/participation.model');
const UserModel = require('../model/user.model');

class ParticipationService {
  static async getUnapprovedUsers(eventID) {
    try {
      // Find all participations for the given eventID with isApproved set to false
      const unapprovedParticipations = await ParticipationModel.find({
        eventID,
        isApproved: false,
      });

      // Get the userIDs of the unapproved participations
      const unapprovedUserIDs = unapprovedParticipations.map(
        participation => participation.userID
      );

      // Find the unapproved users based on their IDs
      const unapprovedUsers = await UserModel.find({
        _id: { $in: unapprovedUserIDs },
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

