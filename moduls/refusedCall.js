let mysql = require('mysql2')

function refusedCall(reqBody,res){
    dbConnection = mysql.createConnection({
        user:'root',
        password:'password',
        host:'127.0.0.1',
        port:'3306',
        database:'convoiLourd'
    })
    dbConnection.query(`CALL refused("${reqBody.id_user}")`,(err,dbRes,dields) => {
        console.log((reqBody.id_user))
        // dataToEnv=dbRes[0][0].usuario
        res.end(JSON.stringify(dbRes[0]))
    })
   
}

module.exports = refusedCall