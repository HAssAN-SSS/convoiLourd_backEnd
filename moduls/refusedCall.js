let mysql = require('mysql2')

function refusedCall(reqBody,res){
    dbConnection = mysql.createConnection({
        user:'newuser',
        password:'password',
        host:'localhost',
        database:'convoiLourd'
    })
    dbConnection.query(`CALL refuse("${reqBody.id_user}")`,(err,dbRes,dields) => {
        console.log((reqBody.id_user))
        // dataToEnv=dbRes[0][0].usuario
        res.end(JSON.stringify(dbRes[0]))
    })
   
}

module.exports = refusedCall