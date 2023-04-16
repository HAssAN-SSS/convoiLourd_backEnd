let mysql = require('mysql2')

function logCall(reqBody,res){
    dbConnection = mysql.createConnection({
        user:'root',
        password:'password',
        host:'127.0.0.1',
        port:'3306',
        database:'convoiLourd'
    })
    dbConnection.query(`CALL check_access("${reqBody.name_user}","${reqBody.pass_user}")`,(err,dbRes,dields) => {
        console.log(JSON.stringify(dbRes))
        dataToEnv=dbRes[0][0].usuario
        res.end(JSON.stringify(dataToEnv))
        console.log(err)
    })
   
}

module.exports = logCall
