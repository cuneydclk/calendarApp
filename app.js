const  express = require('express');
const body_parser = require('body-parser');
const cors = require('cors');
const userRouter = require("./routers/user.router");
const eventRouter = require("./routers/event.routers");
const participationRouter = require("./routers/participation.routers")
const workingHoursRouter = require('./routers/workingHours.router');
const unavailableTimesRouter = require('./routers/unavailableTimes.router');

const app = express();

app.use(cors());

app.use(body_parser.json());


app.use('/', participationRouter);
app.use('/', userRouter);
app.use('/', eventRouter);
app.use('/', workingHoursRouter);
app.use('/', unavailableTimesRouter);

module.exports = app;
