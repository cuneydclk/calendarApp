const WorkingHoursService = require('../services/workingHours.service');

class WorkingHoursController {
    static async saveHours(req, res) {
        try {
            const { userId, dayOfWeek, startTime, endTime } = req.body;
            await WorkingHoursService.saveHours(userId, dayOfWeek, startTime, endTime);
            res.status(200).json({ message: 'Working hours saved successfully.' });
        } catch (error) {
            console.log("Error saving working hours:", error);
            res.status(500).json({ error: 'Failed to save working hours.'});
        }
    }

    static async getHours(req, res) {
        try {
            const { userId } = req.query;
            const workingHours = await WorkingHoursService.getHours(userId);
            res.status(200).json(workingHours);
        } catch (error) {
            console.error("Error saving working hours:", error);
            res.status(500).json({ error: 'Failed to save working hours.' });
        }
        
    }

    static async getAllUserIds(req, res) {
        try {
            const userIds = await WorkingHoursService.getAllUserIds();
            res.status(200).json(userIds);
        } catch (error) {
            console.error("Error getting user IDs:", error);
            res.status(500).json({ error: 'Failed to get user IDs.' });
        }
    }
}

module.exports = WorkingHoursController;
