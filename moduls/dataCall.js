let mysql = require('mysql2')

function DataCall(reqBody,res){
    dbConnection = mysql.createConnection({
        user:'newuser',
        password:'password',
        host:'localhost',
        database:'convoiLourd'
    })
    dbConnection.query(`CALL check_access("${reqBody.name_user}","${reqBody.pass_user}")`,(err,dbRes,dields) => {
        console.log(JSON.stringify(dbRes))
        dataToEnv=dbRes[0][0].usuario
        res.end(JSON.stringify(dataToEnv))
    })
   
}

module.exports = DataCall
