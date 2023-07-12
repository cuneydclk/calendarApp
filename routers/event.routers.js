const router = require('express').Router();
const EventController = require("../controller/event.controller");

router.post('/saveevent', EventController.saveEvent);

module.exports = router;