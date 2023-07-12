const EventModel = require('../model/event.model')

class EventService{

    static async saveEvent(email, eventTitle, startTime, finishTime){


        try{
            const createEvent = new EventModel({email, eventTitle, startTime, finishTime});
            return await createEvent.save();
        }catch(error){
            throw error;

        }

    }


}

module.exports = EventService;