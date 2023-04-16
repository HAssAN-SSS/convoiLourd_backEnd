CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';


GRANT ALL PRIVILEGES ON *.* TO 'newuser'@'localhost';
-- !^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^refused^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

DROP PROCEDURE IF EXISTS refused;
CREATE PROCEDURE refused(in iduser VARCHAR(100))
BEGIN

    

    SELECT demande.id_demande,demande.id_demande AS iddmd,name_user,lname_user,(SELECT societe_user FROM demande 
                                                                                            JOIN process
                                                                                            ON process.id_demande = demande.id_demande
                                                                                            JOIN user
                                                                                            ON user.id_user = process.id_user
                                                                                            WHERE type_process = 'register' AND demande.id_demande = iddmd) AS societe_user,
    date_demande,operation,date_operation FROM demande
    JOIN process
    ON process.id_demande = demande.id_demande
    JOIN user
    ON user.id_user = process.id_user
    WHERE (type_process = 'refuse' AND user.id_user = iduser) OR (type_process = 'refuse_m' AND user.id_user = iduser);
END

call refused('2')

-- !^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^refused^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

--    ?========================================================To_Do====================================================

DROP PROCEDURE IF EXISTS to_do;
CREATE PROCEDURE to_do(IN id varchar(100),IN role VARCHAR(15),IN sideActuel VARCHAR(15))
BEGIN
    IF role = 'tme'
    THEN
        SELECT demande.id_demande,name_user,lname_user,societe_user,date_demande,operation,date_operation FROM demande
        JOIN process
        ON process.id_demande = demande.id_demande
        JOIN user
        ON user.id_user = process.id_user
        WHERE etap = 'register' AND type_process = 'register' ORDER BY date_process DESC ;

    ELSEIF role = 'capt'
    THEN
        SELECT demande.id_demande,name_user,lname_user,societe_user,date_demande,operation,date_operation FROM demande
        JOIN process
        ON process.id_demande = demande.id_demande
        JOIN user
        ON user.id_user = process.id_user
        WHERE (etap = 'v-tme' AND type_process = 'register') OR (etap = 'refuse_m' AND type_process = 'register') ORDER BY date_process DESC ;

    ELSEIF role = 'd_tech'
    THEN
        SELECT demande.id_demande,name_user,lname_user,societe_user,date_demande,operation,date_operation FROM demande
        JOIN process
        ON process.id_demande = demande.id_demande
        JOIN user
        ON user.id_user = process.id_user
        WHERE etap = 'v-capt' AND type_process = 'register' ORDER BY date_process DESC ;

    ELSEIF role = 'exploi'
    THEN
        SELECT demande.id_demande,name_user,lname_user,societe_user,date_demande,operation,date_operation FROM demande
        JOIN process
        ON process.id_demande = demande.id_demande
        JOIN user
        ON user.id_user = process.id_user
        WHERE etap = 'v-d_tech' AND type_process = 'register' ORDER BY date_process DESC ;
    
    ELSEIF role = 'terr'
    THEN
        SELECT demande.id_demande,name_user,lname_user,societe_user,date_demande,operation,date_operation FROM demande
        JOIN process
        ON process.id_demande = demande.id_demande
        JOIN user
        ON user.id_user = process.id_user
        WHERE etap = 'v-exploi' AND type_process = 'register' ORDER BY date_process DESC ;

    ELSEIF role = 'client'
    THEN
        CALL client(id,role,sideActuel);

    END IF;
    END

   CALL to_do('4','client','start')
--    ?========================================================To_Do====================================================


   DROP PROCEDURE IF EXISTS refuse;
CREATE PROCEDURE refuse(in iduser VARCHAR(100))
BEGIN
    SELECT demande.id_demande,name_user,lname_user,societe_user,date_demande,operation,date_operation FROM demande
    JOIN process
    ON process.id_demande = demande.id_demande
    JOIN user
    ON user.id_user = process.id_user
    WHERE type_process = 'refuse' AND user.id_user = iduser;
END

call refuse('1')


-- ===============================================================done============================
DROP PROCEDURE IF EXISTS Done;
CREATE PROCEDURE Done(IN id varchar(100),IN role VARCHAR(15))
BEGIN
    IF role = 'tme'
    THEN
        SELECT demande.id_demande,name_user,lname_user,societe_user,date_demande,operation,date_operation FROM demande
        JOIN process
        ON process.id_demande = demande.id_demande
        JOIN user
        ON user.id_user = process.id_user
        WHERE user.id_user  = id AND type_process = 'v-tme' ORDER BY date_process DESC ;

    ELSEIF role = 'capt'
    THEN
        SELECT demande.id_demande,name_user,lname_user,societe_user,date_demande,operation,date_operation FROM demande
        JOIN process
        ON process.id_demande = demande.id_demande
        JOIN user
        ON user.id_user = process.id_user
        WHERE user.id_user  = id AND type_process = 'v-capt' ORDER BY date_process DESC ;

    ELSEIF role = 'd_tech'
    THEN
        SELECT demande.id_demande,name_user,lname_user,societe_user,date_demande,operation,date_operation FROM demande
        JOIN process
        ON process.id_demande = demande.id_demande
        JOIN user
        ON user.id_user = process.id_user
        WHERE user.id_user  = id AND type_process = 'v-d_tech' ORDER BY date_process DESC ;

    ELSEIF role = 'exploi'
    THEN
        SELECT demande.id_demande,name_user,lname_user,societe_user,date_demande,operation,date_operation FROM demande
        JOIN process
        ON process.id_demande = demande.id_demande
        JOIN user
        ON user.id_user = process.id_user
        WHERE user.id_user  = id AND type_process = 'v-exploi' ORDER BY date_process DESC ;
    
    ELSEIF role = 'terr'
    THEN
        SELECT demande.id_demande,name_user,lname_user,societe_user,date_demande,operation,date_operation FROM demande
        JOIN process
        ON process.id_demande = demande.id_demande
        JOIN user
        ON user.id_user = process.id_user
        WHERE user.id_user  = id AND type_process = 'v-terr' ORDER BY date_process DESC ;

    END IF;
    END

CALL Done('2','tme')





-- ==================================================validate===================================
 
DROP PROCEDURE IF EXISTS validate;
CREATE PROCEDURE validate(IN idUser VARCHAR(100),IN idDemande VARCHAR(100),IN userRole VARCHAR(20))
BEGIN
    DECLARE pretandetRole VARCHAR(20);

    SELECT role INTO pretandetRole FROM user
    WHERE id_user = idUser;

    IF pretandetRole = userRole

        THEN 
            IF pretandetRole = 'tme'
                THEN UPDATE demande SET etap = 'v-tme'
                WHERE id_demande = idDemande;

                INSERT INTO process(type_process,id_user,id_demande)
                VALUES ('v-tme',idUser,idDemande);

            ELSEIF pretandetRole = 'capt'
                THEN UPDATE demande SET etap = 'v-capt'
                WHERE id_demande = idDemande;

                INSERT INTO process(type_process,id_user,id_demande)
                VALUES ('v-capt',idUser,idDemande);

            ELSEIF pretandetRole = 'd_tech'
                THEN UPDATE demande SET etap = 'v-d_tech'
                WHERE id_demande = idDemande;

                INSERT INTO process(type_process,id_user,id_demande)
                VALUES ('v-d_tech',idUser,idDemande);

            ELSEIF pretandetRole = 'exploi'
                THEN UPDATE demande SET etap = 'v-exploi'
                WHERE id_demande = idDemande;

                INSERT INTO process(type_process,id_user,id_demande)
                VALUES ('v-exploi',idUser,idDemande);

            ELSEIF pretandetRole = 'terr'
                THEN UPDATE demande SET etap = 'cloture'
                WHERE id_demande = idDemande;

                INSERT INTO process(type_process,id_user,id_demande)
                VALUES ('cloture',idUser,idDemande);
            END IF;
        
        SELECT 'valido' AS access;

        ELSE SELECT 'usuario no tiene access' AS access;
        
        END IF;
END


CALL validate('2','4','tme')
-- ?==================================================validate===================================
-- !==================================================refusation===================================



DROP PROCEDURE IF EXISTS refusation;
CREATE PROCEDURE refusation(IN idUser VARCHAR(100),IN idDemande VARCHAR(100),IN userRole VARCHAR(20))
BEGIN
    DECLARE pretandetRole VARCHAR(20);

    SELECT role INTO pretandetRole FROM user
    WHERE id_user = idUser;

    IF pretandetRole = userRole

        THEN 
            IF pretandetRole = 'tme'
                THEN UPDATE demande SET etap = 'refuse'
                WHERE id_demande = idDemande;

                INSERT INTO process(type_process,id_user,id_demande)
                VALUES ('refuse',idUser,idDemande);

            ELSEIF pretandetRole = 'capt'
                THEN UPDATE demande SET etap = 'refuse'
                WHERE id_demande = idDemande;

                INSERT INTO process(type_process,id_user,id_demande)
                VALUES ('refuse',idUser,idDemande);

            ELSEIF pretandetRole = 'd_tech'
                THEN UPDATE demande SET etap = 'refuse_m'
                WHERE id_demande = idDemande;

                INSERT INTO process(type_process,id_user,id_demande)
                VALUES ('refuse_m',idUser,idDemande);

            ELSEIF pretandetRole = 'exploi'
                THEN UPDATE demande SET etap = 'refuse_m'
                WHERE id_demande = idDemande;

                INSERT INTO process(type_process,id_user,id_demande)
                VALUES ('refuse_m',idUser,idDemande);

            ELSEIF pretandetRole = 'terr'
                THEN UPDATE demande SET etap = 'refuse_m'
                WHERE id_demande = idDemande;

                INSERT INTO process(type_process,id_user,id_demande)
                VALUES ('refuse_m',idUser,idDemande);
            END IF;
        
        SELECT 'valido' AS access;

        ELSE SELECT 'usuario no tiene access' AS access;
        
        END IF;
END

CALL refusation('2','5','tme')
--!--------------------------------------------------------------refusation----------------------------------------------
--!-------------------------------------------------------------check_access-----------------------------------------------
DROP PROCEDURE IF EXISTS check_access;
DELIMITER $$
CREATE PROCEDURE check_access(in username VARCHAR(50),in passo VARCHAR(50))
BEGIN
    DECLARE id VARCHAR(50);
    DECLARE roleOut VARCHAR(15);
    DECLARE versionA VARCHAR(100);
    DECLARE authenCount VARCHAR(100);
    DECLARE nameout VARCHAR(40);
    DECLARE lname VARCHAR(40);
    


     SELECT id_user,role,name_user,lname_user INTO id,roleOut,nameout,lname FROM user WHERE (name_user = username AND pass_user = passo);

  
     INSERT INTO authentification(id_user) VALUES (id);

     SELECT COUNT(version) INTO authenCount FROM authentification WHERE (id_user = id AND date_authen_out IS NULL);

     SELECT version INTO versionA FROM authentification WHERE (id_user = id) ORDER BY date_authen_in DESC LIMIT 1;

     IF id IS NOT NULL AND roleOut IS NOT NULL THEN SELECT JSON_OBJECT( "id",id,"role",roleOut,"version",versionA,"authenCount",authenCount,"lname",lname,"name",nameout) AS usuario;
     else SELECT 'not access' AS usuario;
     END IF;

END

DELIMITER ;
call check_access('aziz','123');
--!-------------------------------------------------------------check_access-----------------------------------------------
-- ?==================================================deamnde===============================
DROP PROCEDURE IF EXISTS demande;
CREATE PROCEDURE demande(in idDemande int, in idUser int)
BEGIN

    SELECT itineraire.id_iti,capacite,largeure,geometry_iti,flux FROM demande
    JOIN itineraire
    ON itineraire.id_demande = demande.id_demande
    WHERE demande.id_demande = idDemande;

    SELECT vehicule.matricule,espace_essieux,essieux,hauteur,poid,longueur,vehicule.largeur FROM demande
    JOIN vehicule
    ON vehicule.id_demande = demande.id_demande
    WHERE demande.id_demande = idDemande;

    SELECT demande.id_demande,demande.id_demande AS iddmd,(SELECT date_process FROM demande
                                                            JOIN process
                                                                ON process.id_demande = demande.id_demande
                                                                JOIN user 
                                                                ON user.id_user = process.id_user
                                                                WHERE user.id_user = idUser AND demande.id_demande = iddmd ORDER BY date_operation DESC LIMIT 1) AS myDateOpt
    ,date_demande,date_operation,point_sortie,operation,fichier,name_user,lname_user,societe_user,tel_user,email_user,role,etap FROM demande
    JOIN process
    ON process.id_demande = demande.id_demande
    JOIN user 
    ON user.id_user = process.id_user
    WHERE demande.id_demande = idDemande AND type_process = 'register';
END

CALL demande(2,3)

-- =================================================client=====================

DROP PROCEDURE IF EXISTS `client`;
CREATE PROCEDURE client(IN idClient VARCHAR(40),IN roleClient VARCHAR(15),IN sideActuel VARCHAR(15))
BEGIN
    DECLARE pretendet_role VARCHAR(40);
    SELECT role INTO pretendet_role FROM `user`
    WHERE id_user = idClient ;
    IF pretendet_role = roleClient
    THEN 
        -------------------------------Demandes
        IF (sideActuel = 'Demandes' OR sideActuel = 'start')
        THEN 
            SELECT demande.id_demande,date_demande,operation,date_operation,etap FROM demande
            JOIN process
            ON demande.id_demande = process.id_demande
            JOIN user
            ON process.id_user = user.id_user
            WHERE type_process = 'register' AND user.id_user = idClient;
        -------------------------------Demandes
        ------------------------------Accepted
        elseif sideActuel = 'Accepted'
        THEN
            SELECT demande.id_demande,date_demande,operation,date_operation,etap FROM demande
            JOIN process
            ON demande.id_demande = process.id_demande
            JOIN user
            ON process.id_user = user.id_user
            WHERE type_process = 'register' AND user.id_user = idClient AND etap = 'cloture';
        ------------------------------Accepted
        ------------------------------Refused
        elseif sideActuel = 'Refused_'
        THEN
            SELECT demande.id_demande,date_demande,operation,date_operation,etap FROM demande
            JOIN process
            ON demande.id_demande = process.id_demande
            JOIN user
            ON process.id_user = user.id_user
            WHERE type_process = 'register' AND user.id_user = idClient AND etap = 'refuse';
        ------------------------------Refused
        END IF;
    END IF;



END 
CALL client('4','client','start')
-- =================================================client=====================







