const mongoose = require('mongoose');


const connection = mongoose.createConnection('mongodb://127.0.0.1:27017/calendar').on('open', ()=>{
console.log("MangoDb connected");

}).on('error', ()=> {
    console.log("Mongo Db error");
});

module.exports = connection;