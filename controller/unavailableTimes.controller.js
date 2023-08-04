const UnavailableTimesService = require('../services/unavailableTimes.service');

class UnavailableTimesController {
    static async saveMeeting(req, res) {
        try {
            const { userId, startDate, endDate } = req.body;
            await UnavailableTimesService.saveMeeting(userId, startDate, endDate);
            res.status(200).json({ message: 'Meeting time saved successfully.' });
        } catch (error) {
            res.status(500).json({ error: 'Failed to save meeting time.' });
        }
    }

    static async    getTime(req, res) {
        try {
            const { userId } = req.query;
            const unavailableTimes = await UnavailableTimesService.getTime(userId);
            res.status(200).json(unavailableTimes);
        } catch (error) {
            res.status(500).json({ error: 'Failed to get unavailable times.' });
        }
    }
}

module.exports = UnavailableTimesController;
