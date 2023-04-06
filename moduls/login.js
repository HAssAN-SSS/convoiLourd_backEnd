let mysql = require('mysql2')
let DataCall = require('./dataCall')
module.exports = Login
function Login(req,res){

    let reqBody = ''
    
    req.on('data',(chunk) => {
        reqBody += chunk.toString()
    })
    req.on('end',() => {

        console.log('reqBody : '+reqBody)
        
        reqBody = JSON.parse(reqBody) 
        console.log('typof reqBody : '+typeof reqBody)

        if (reqBody && reqBody.name_user !== '' && reqBody.pass_user !== ''){

            DataCall(reqBody,res)

        }else{

        }
        
    })
}
