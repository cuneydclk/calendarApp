const router = require('express').Router();
const EventController = require("../controller/event.controller");

router.post('/saveevent', EventController.saveEvent);
router.get('/geteventId', EventController.getEventId);
router.get('/events/user/:userID', EventController.getEventsByUserID);
module.exports = router;