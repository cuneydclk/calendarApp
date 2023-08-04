const UnavailableTimesModel = require('../model/unavailableTimes.model');

class UnavailableTimesService {
    static async saveMeeting(userId, startDate, endDate) {
        try {
            // Check if the unavailable times entry exists for the user at the given time
            let unavailableTimes = await UnavailableTimesModel.findOne({ userId, startDate, endDate });

            if (!unavailableTimes) {
                unavailableTimes = new UnavailableTimesModel({ userId, startDate, endDate });
            }

            return await unavailableTimes.save();
        } catch (error) {
            throw error;
        }
    }

    static async getTime(userId) {
        try {
            return await UnavailableTimesModel.find({ userId });
        } catch (error) {
            throw error;
        }
    }
}

module.exports = UnavailableTimesService;
