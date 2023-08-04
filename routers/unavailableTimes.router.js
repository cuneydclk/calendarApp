const router = require('express').Router();
const UnavailableTimesController = require('../controller/unavailableTimes.controller');

router.post('/saveMeeting', UnavailableTimesController.saveMeeting);
router.get('/getTime', UnavailableTimesController.getTime);

module.exports = router;
