const WorkingHoursModel = require('../model/workingHours.model');

class WorkingHoursService {
    static async saveHours(userId, dayOfWeek, startTime, endTime) {
        try {
            // Check if the working hours entry exists for the user on the given day
            let workingHours = await WorkingHoursModel.findOne({ userId, dayOfWeek });

            if (!workingHours) {
                workingHours = new WorkingHoursModel({ userId, dayOfWeek, startTime, endTime });
            } else {
                workingHours.startTime = startTime;
                workingHours.endTime = endTime;
            }
            
            return await workingHours.save();
        } catch (error) {
            throw error;
        }
    }

    static async getHours(userId) {
        try {
            
            return await WorkingHoursModel.find({ userId });
        } catch (error) {
            throw error;
        }
    }

    static async getAllUserIds() {
        try {
            const distinctUserIds = await WorkingHoursModel.distinct('userId');
            return distinctUserIds;
        } catch (error) {
            throw error;
        }
    }
}

module.exports = WorkingHoursService;
