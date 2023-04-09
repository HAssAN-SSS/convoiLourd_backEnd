let mysql = require('mysql2')
let todoCall = require('./todoCall')

function todo(req,res){

    let reqBody = ''
    
    req.on('data',(chunk) => {
        reqBody += chunk.toString()
    })
    req.on('end',() => {

        console.log('reqBody : '+reqBody)
        
        reqBody = JSON.parse(reqBody) 
        console.log('typof reqBody : '+typeof reqBody)

        if (reqBody && reqBody.name_user !== '' && reqBody.pass_user !== ''){

           todoCall(reqBody,res)

        }else{

        }
        
    })
}
module.exports = todo
