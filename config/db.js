const mongoose = require('mongoose');


const connection = mongoose.createConnection('mongodb+srv://admin:<1234>@atlascluster.1jdpdew.mongodb.net/?retryWrites=true&w=majority').on('open', ()=>{
console.log("MangoDb connected");

}).on('error', ()=> {
    console.log("Mongo Db error");
});

module.exports = connection;