const EventModel = require('../model/event.model');

class EventService {

  static async saveEvent(email, eventTitle, startTime, finishTime) {
    try {
      const createEvent = new EventModel({ email, eventTitle, startTime, finishTime });
      return await createEvent.save();
    } catch (error) {
      throw error;
    }
  }

  static async getEventId(email, startTime) {
    try {
      const event = await EventModel.findOne({ email, startTime }).select('_id');
      return event ? event._id : null;
    } catch (error) {
      throw error;
    }
  }
}

module.exports = EventService;
