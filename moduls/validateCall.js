let mysql = require('mysql2')

function validateCall(reqBody,res){
    dbConnection = mysql.createConnection({
        user:'newuser',
        password:'password',
        host:'localhost',
        database:'convoiLourd'
    })
    dbConnection.query(`CALL validate("${reqBody.id_user}","${reqBody.id_demande}","${reqBody.role}")`, (err,dbRes,dields) => {
        console.log(( 'validate:', dbRes))
        console.log(err)
        // dataToEnv=dbRes[0][0].usuario
        res.end(JSON.stringify(dbRes[0]))
    })
   
}

module.exports = validateCall
