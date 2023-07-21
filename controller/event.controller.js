const EventService = require("../services/event.service"); 

exports.saveEvent = async(req, res, next)=>{

    try{
        const {email, eventTitle, startTime, finishTime} = req.body;

        const successRes = await EventService.saveEvent(email, eventTitle, startTime, finishTime);
        

        res.json({status:true, success:"Event saved succesfully"});
    }catch(error){
        throw error
    };

exports.getEventId = async (req, res, next) => {
    try {
        const { email, startTime } = req.query;
    
        if (!email || !startTime) {
        return res.status(400).json({ status: false, error: "email and startTime are required" });
        }
    
        const eventId = await EventService.getEventId(email, startTime);
    
        if (!eventId) {
        return res.status(404).json({ status: false, error: "Event not found" });
        }
    
        res.json({ status: true, eventId });
    } catch (error) {
        throw error;
    }
    }
}