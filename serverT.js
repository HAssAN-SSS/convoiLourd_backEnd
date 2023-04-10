let http = require('http')
let mysql = require('mysql2')
let Login = require('./moduls/login')
let todo = require('./moduls/todo')
let demande = require('./moduls/demande')
let serrver = http.createServer((req,res) => {
    if(req.url === '/login') {
       userIn = Login(req,res)
       console.log(userIn)
       res.writeHead(200,{
        'Content-Type':'application/json',
        'Access-Control-Allow-Origin':'*',
        'Access-Control-Allow-Methods': 'POST, GET, DELETE, PUT, OPTION '
       })
    //    res.end(JSON.stringify({name:'lola'}))
    }
    else if (req.url === '/todo') {
        userIn = todo(req,res)
       console.log(userIn)
       res.writeHead(200,{
        'Content-Type':'application/json',
        'Access-Control-Allow-Origin':'*',
        'Access-Control-Allow-Methods': 'POST, GET, DELETE, PUT, OPTION '
       })
    }
    else if (req.url === '/demande') {
        userIn = demande(req,res)
       console.log(userIn)
       res.writeHead(200,{
        'Content-Type':'application/json',
        'Access-Control-Allow-Origin':'*',
        'Access-Control-Allow-Methods': 'POST, GET, DELETE, PUT, OPTION '
       })
    }
})

serrver.listen(3001,() => {
    console.log('serverT work ')
})