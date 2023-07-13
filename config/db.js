const mongoose = require('mongoose');


const connection = mongoose.createConnection('mongodb+srv://admin:<password>@atlascluster.1jdpdew.mongodb.net/?retryWrites=true&w=majority').on('open', ()=>{
console.log("MangoDb connected");

}).on('error', ()=> {
    console.log("Mongo Db error");
});

module.exports = connection;