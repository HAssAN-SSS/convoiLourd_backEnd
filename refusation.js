let mysql = require('mysql2')
let refusationCall = require('./refusationCall')

function refusation(req,res){

    let reqBody = ''
    
    req.on('data',(chunk) => {
        reqBody += chunk.toString()
    })
    req.on('end',() => {

        reqBody = JSON.parse(reqBody) 
        if (reqBody){
            console.log('validate',reqBody )
           refusationCall(reqBody,res)

        }else{

        }
        
    })
}
module.exports = refusation
 