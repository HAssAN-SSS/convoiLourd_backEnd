let mysql = require('mysql2')

function refusationCall(reqBody,res){
    dbConnection = mysql.createConnection({
        user:'root',
        password:'password',
        host:'backend-mysql-1',
        port:'3306',
        database:'convoiLourd'
    })
    dbConnection.query(`CALL refusation("${reqBody.id_user}","${reqBody.id_demande}","${reqBody.role}")`, (err,dbRes,dields) => {
        console.log(( 'validate:', dbRes))
        console.log(err)
        // dataToEnv=dbRes[0][0].usuario
        res.end(JSON.stringify(dbRes[0]))
    })
   
}

module.exports = refusationCall
