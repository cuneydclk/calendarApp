const router = require('express').Router();
const UserController = require("../controller/user.controller");

router.post('/registration', UserController.register);
router.post('/login', UserController.login);
router.get('/getUserId', UserController.getUserIdByEmail);
router.get('/getemail', UserController.getEmailByUserId);
module.exports = router;