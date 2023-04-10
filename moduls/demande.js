let mysql = require('mysql2')
let demandeCall = require('./demandeCall')
function demande(req,res){

    let reqBody = ''
    
    req.on('data',(chunk) => {
        reqBody += chunk.toString()
    })
    req.on('end',() => {

        console.log('reqBody : '+reqBody)
        
        reqBody = JSON.parse(reqBody) 
        console.log('typof reqBody : '+typeof reqBody)

        if (reqBody){

           demandeCall(reqBody,res)

        }else{

        }
        
    })
}
module.exports = demande
