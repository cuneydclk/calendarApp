const router = require('express').Router();
const WorkingHoursController = require('../controller/workingHours.controller');

router.post('/saveHours', WorkingHoursController.saveHours);
router.get('/getHours', WorkingHoursController.getHours);
router.get('/getAllUserIds', WorkingHoursController.getAllUserIds);

module.exports = router;
