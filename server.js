let http = require('http')
let mysql = require('mysql2')
let Authen = require('./authen')
const { json } = require('stream/consumers')
var id
var role
var latifa ='latifa'
let dbReturn
 let connectDB = mysql.createConnection({
    host:'localhost',
    user:'newuser',
    password:'password',
    database:'convoiLourd'
 })
 connectDB.connect((err) => {
    if (err ) throw err;
    console.log('success data connect')
 })
 connectDB.query('SELECT * FROM user',(err,dbResp,dields) => {
    if(err) throw err
    console.log(dbResp)
    dbReturn = dbResp
})

let server = http.createServer((req,res) => {
     let paraenv
    if(req.url === '/'){
         res.writeHead(200,{
             'Content_type':'apllication/json',
             'Access-Control-Allow-Origin':'*',
             'Access-Control-Allow-Methods': 'POST, GET, DELETE, PUT, OPTION ',
             
            })
            // ?------read the body of teh request
            let body = '';
            req.on('data', (chunk) => {
            body += chunk.toString();
            });
            req.on('end', () => {
            console.log('Request body:', body);
            let user = JSON.parse(body)
            // ?==========================================
            // Authen(user.name_user,user.pass_user,connectDB)
            // console.log(dbReturn)
        
            });
        // res.end(JSON.stringify({'name':'bravo'}))
        // authen============
        let connectAuthen = mysql.createConnection(
            {
                host:'localhost',
                user:'newuser',
                password:'password',
                database:'convoiLourd'
            }
            )
            connectAuthen.query("call check_access('aziz','123');",(err,dbResp,dields) => {
                // if(err) throw err

                console.log( dbResp[0][0])
                dbReturn = dbResp.toString()
                id = dbResp[0][0].checked.id
                // console.log(JSON.parse(dbReturn))
                role = dbResp[0][0].checked.role
                
                objjjj=JSON.parse(dbResp[0][0].checked)
                
                // console.log(paraenv)
                //    console.log(dbResp[0][0].keyO);
                res.end(JSON.stringify( objjjj))
            })
            connectAuthen.end()
            
        }
    
})

server.listen(3001 ,() => {
    console.log('active serve')
})
connectDB.end()
console.log(latifa)

function authenServe() {
    let server = http.createServer((req,res) =>{
        res.writeHead(200,{
            'Content_type':'apllication/json',
            'Access-Control-Allow-Origin':'*',
            'Access-Control-Allow-Methods': 'POST, GET, DELETE, PUT, OPTION ',
            
           })
           let body
        req.on('data',(chunk) => {
            body =+ chunk.toString()
        })
    })
}