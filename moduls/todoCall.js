let mysql = require('mysql2')

function todoCall(reqBody,res){
    dbConnection = mysql.createConnection({
        user:'newuser',
        password:'password',
        host:'localhost',
        database:'convoiLourd'
    })
    dbConnection.query(`CALL to_do("${reqBody.id_user}","${reqBody.role}")`,async (err,dbRes,dields) => {
        console.log(( 'todo', dbRes))
        // dataToEnv=dbRes[0][0].usuario
        res.end(JSON.stringify(dbRes[0]))
    })
   
}

module.exports = todoCall
