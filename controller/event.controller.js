const EventService = require("../services/event.service"); 

exports.saveEvent = async(req, res, next)=>{

    try{
        const {userID, eventTitle, startTime, finishTime} = req.body;

        const successRes = await EventService.saveEvent(userID, eventTitle, startTime, finishTime);
        

        res.json({status:true, success:"Event saved succesfully"});
    }catch(error){
        throw error
    }
}
exports.getEventId = async (req, res, next) => {
    try {
        const { userID, startTime } = req.query;
    
        if (!email || !startTime) {
        return res.status(400).json({ status: false, error: "userID and startTime are required" });
        }
    
        const eventId = await EventService.getEventId(userID, startTime);
    
        if (!eventId) {
        return res.status(404).json({ status: false, error: "Event not found" });
        }
    
        res.json({ status: true, eventId });
    } catch (error) {
        throw error;
    }
}

exports.getAllEventsByUserID = async (req, res, next) => {
    try {
    const { userID } = req.query;

    if (!userID) {
        return res
        .status(400)
        .json({ status: false, error: "userID is required" });
    }

    const events = await EventService.getAllEventsByUserID(userID);

    res.json({ status: true, events });
    } catch (error) {
    throw error;
    }
}
    
