let mysql = require('mysql2')

function demandeCall(reqBody,res){
    dbConnection = mysql.createConnection({
        user:'newuser',
        password:'password',
        host:'localhost',
        database:'convoiLourd'
    })
    dbConnection.query(`CALL demande("${reqBody.id_demande}")`,(err,dbRes,dields) => {
        console.log('demandeCall:',({itineraire:dbRes[0][0],
            vehicule:dbRes[1][0]}))
        // dataToEnv=dbRes[0][0].usuario
        res.end(JSON.stringify({itineraire:dbRes[0][0],
                                vehicule:dbRes[1][0]}))
    })
   
}

module.exports = demandeCall