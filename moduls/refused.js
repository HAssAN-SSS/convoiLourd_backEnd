let refusedCall = require('./refusedCall')

function refused(req,res){

    let reqBody = ''
    
    req.on('data',(chunk) => {
        reqBody += chunk.toString()
    })
    req.on('end',() => {

        reqBody = JSON.parse(reqBody) 

        if (reqBody){

            refusedCall(reqBody,res)

        }else{

        }
        
    })
}
module.exports = refused
