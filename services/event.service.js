const EventModel = require('../model/event.model');

class EventService {

  static async saveEvent(userID, eventTitle, startTime, finishTime) {
    try {
      const createEvent = new EventModel({ userID, eventTitle, startTime, finishTime });
      return await createEvent.save();
    } catch (error) {
      throw error;
    }
  }

  static async getEventId(userID, startTime) {
    try {
      const event = await EventModel.findOne({ userID, startTime }).select('_id');
      return event ? event._id : null;
    } catch (error) {
      throw error;
    }
  }
  
  static async getAllEventsByUserID(userID) {
    try {
      const events = await EventModel.find({ userID });
      return events;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = EventService;
