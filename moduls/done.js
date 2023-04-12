const doneCall = require('./doneCall')

function done(req,res){

    let reqBody = ''
    
    req.on('data',(chunk) => {
        reqBody += chunk.toString()
    })
    req.on('end',() => {

        reqBody = JSON.parse(reqBody) 

        if (reqBody){

            doneCall(reqBody,res)

        }else{

        }
        
    })
}
module.exports = done
