const EventService = require("../services/event.service"); 

exports.saveEvent = async(req, res, next)=>{

    try{
        const {email, eventTitle, startTime, finishTime} = req.body;

        const successRes = await EventService.saveEvent(email, eventTitle, startTime, finishTime);

        // Extract the eventID from the savedEvent result
        const eventID = successRes._id;

        res.json({status:true, success:"Event saved succesfully" , eventID});
    }catch(error){
        throw error
    }
}