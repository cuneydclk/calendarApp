const EventService = require("../services/event.service"); 

exports.saveEvent = async(req, res, next)=>{

    try{
        const {email, eventTitle, startTime, finishTime} = req.body;

        const successRes = await EventService.saveEvent(email, eventTitle, startTime, finishTime);

        res.json({status:true, success:"Event saved succesfully" });
    }catch(error){
        throw error
    }
}