
 function Authen(user,pass,connectDB) {
    if(user == '' && pass !== '') {

        let querySrt = `CALL check_access(${user,pass})`
        connectDB.query(querySrt,(err,dbResp,dields) => {
            // if(err) throw err
            console.log(typeof dbResp)
            dbReturn = dbResp
         })
    }else{
        console.log('not ok')
    
    }
}

module.exports = Authen