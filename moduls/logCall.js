let mysql = require('mysql2')

function logCall(reqBody,res){
    dbConnection = mysql.createConnection({
        user:'root',
        password:'password',
        host:'backend-mysql-1',
        port:'3306',
        database:'convoiLourd'
    })
    dbConnection.query(`CALL check_access("${reqBody.name_user}","${reqBody.pass_user}")`,(err,dbRes,dields) => {
        // console.log(dbRes)
        dataToEnv=dbRes[0][0].usuario
        res.end(JSON.stringify(dataToEnv))
    })
   
}

module.exports = logCall
