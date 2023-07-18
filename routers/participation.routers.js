const router = require('express').Router();
const ParticipationController = require('../controller/participation.controller');



// Route for saving a participation record
router.post('/participations', ParticipationController.saveParticipation);

// Route for retrieving unapproved users for a specific event
router.get('/events/:eventID/unapproved-users', ParticipationController.getUnapprovedUsers);

module.exports = router;
