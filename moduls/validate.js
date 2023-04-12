let mysql = require('mysql2')
let validateCall = require('./validateCall')

function validate(req,res){

    let reqBody = ''
    
    req.on('data',(chunk) => {
        reqBody += chunk.toString()
    })
    req.on('end',() => {

        reqBody = JSON.parse(reqBody) 
        if (reqBody){
            console.log('validate',reqBody )
           validateCall(reqBody,res)

        }else{

        }
        
    })
}
module.exports = validate
 