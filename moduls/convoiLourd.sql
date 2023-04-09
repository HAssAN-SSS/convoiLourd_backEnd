-- Active: 1680373483637@@127.0.0.1@3306@convoiLourd
ALTER TABLE authentification
MODIFY date_authen_in DATETIME DEFAULT NOW();



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

 
SELECT @keyObj;
call check_access('aziz','123');
SELECT @key




UPDATE user set name_user = 'aziz' WHERE id_user = 1;






DROP PROCEDURE IF EXISTS check_access;

DELIMITER $$
CREATE PROCEDURE check_access(
    IN username VARCHAR(50),
    IN passo VARCHAR(50),
    OUT keyO VARCHAR(100)
)
BEGIN
    DECLARE id VARCHAR(50);
    DECLARE roleOut VARCHAR(15);

    SELECT id_user, role INTO id, roleOut FROM user WHERE (name_user = username AND pass_user = passo);

    IF id IS NOT NULL AND roleOut IS NOT NULL THEN 
        SET keyO = CONCAT('{ "id": "', id, '", "role": "', roleOut, '" }');
    ELSE 
        SET keyO = 'not access';
    END IF;

END

DELIMITER ;


ALTER TABLE user 
ADD COLUMN lname_user VARCHAR(40);


TRUNCATE TABLE process;

ALTER TABLE process
DROP FOREIGN KEY fk_user_01;

ALTER TABLE authentification
ADD CONSTRAINT fk_user FOREIGN KEY(id_user) REFERENCES user(id_user);

INSERT INTO user(id_user,name_user,lname_user,pass_user,email_user,role,tel_user,societe_user)

ALTER TABLE demande
MODIFY date_demande DATETIME DEFAULT now();



-- ?===========================todoCall=============================

DROP PROCEDURE IF EXISTS todo;

DELIMITER $$

CREATE Procedure todo(IN id INT,IN role VARCHAR(15))
BEGIN
    DECLARE etaps INT;
    IF role = 'tme'  
        THEN 

            SELECT COUNT(*) AS etapa,demande.id_demande, date_demande, date_operation, operation 
            FROM demande
            JOIN process ON process.id_demande = demande.id_demande
            WHERE type_process = 'regester' AND 
            GROUP BY demande.id_demande;


    ELSEIF role = 'capt' THEN SELECT demande.id_demande,date_demande,date_operation,operation FROM demande
                            JOIN process
                            ON process.id_demande = demande.id_demande
                            WHERE type_process = 'v-tme';

    ELSEIF role = 'd-tech' THEN SELECT demande.id_demande,date_demande,date_operation,operation FROM demande
                            JOIN process
                            ON process.id_demande = demande.id_demande
                            WHERE type_process = 'v-capt';

    ELSEIF role = 'expl' THEN SELECT demande.id_demande,date_demande,date_operation,operation FROM demande
                            JOIN process
                            ON process.id_demande = demande.id_demande
                            WHERE type_process = 'v-d-tech';

    ELSE SELECT demande.id_demande,date_demande,date_operation,operation FROM demande
                            JOIN process
                            ON process.id_demande = demande.id_demande
                            WHERE type_process = 'v-expl';
    END IF;
END

DELIMITER ;

CALL todo('2','tme');


SELECT demande.id_demande,date_demande,date_operation,operation FROM demande
JOIN process
ON process.id_demande = demande.id_demande
WHERE type_process = 'regester';




SELECT demande.id_demande,id_process,date_process FROM demande
JOIN process
ON demande.id_demande = process.id_demande
WHERE type_process = 'regester'
ORDER BY date_process  DESC;


--=============================donCall

DROP PROCEDURE IF EXISTS todo;

DELIMITER $$

CREATE Procedure todo(IN id INT,IN role VARCHAR(15))
BEGIN

    IF role = 'client' THEN SELECT demande.id_demande,date_demande,date_operation,operation FROM demande
                            JOIN process
                            ON process.id_demande = demande.id_demande
                            WHERE type_process = 'regester';

    ELSEIF role = 'tme' THEN SELECT demande.id_demande,date_demande,date_operation,operation FROM demande
                            JOIN process
                            ON process.id_demande = demande.id_demande
                            WHERE type_process = 'v-tme';

    ELSEIF role = 'capt' THEN SELECT demande.id_demande,date_demande,date_operation,operation FROM demande
                            JOIN process
                            ON process.id_demande = demande.id_demande
                            WHERE type_process = 'v-capt';

    ELSEIF role = 'd-tech' THEN SELECT demande.id_demande,date_demande,date_operation,operation FROM demande
                            JOIN process
                            ON process.id_demande = demande.id_demande
                            WHERE type_process = 'v-d-tech';

    ELSEIF role = 'expl' THEN SELECT demande.id_demande,date_demande,date_operation,operation FROM demande
                            JOIN process
                            ON process.id_demande = demande.id_demande
                            WHERE type_process = 'v-expl';

    ELSE SELECT demande.id_demande,date_demande,date_operation,operation FROM demande
                            JOIN process
                            ON process.id_demande = demande.id_demande
                            WHERE type_process = 'cloture';
    END IF;
END

DELIMITER ;




DROP PROCEDURE IF EXISTS todo;

DELIMITER $$

CREATE Procedure todo(IN id INT,IN role VARCHAR(15))
BEGIN


END


SELECT COUNT(*) AS etaps FROM demande
            JOIN process ON process.id_demande = demande.id_demande
            GROUP BY demande.id_demande
           ;

DROP VIEW IF EXISTS tme_todo;
CREATE VIEW tme_todo AS
SELECT COUNT(*) AS etaps,demande.id_demande FROM demande
            JOIN process ON process.id_demande = demande.id_demande
            GROUP BY demande.id_demande
           ;
SELECT * from tme_todo
WHERE etaps = 1 ;


TRUNCATE demande;

ALTER TABLE demande
ADD COLUMN etap VARCHAR(30);




-- !=================================TRABAJO DURO==========

DROP PROCEDURE IF EXISTS to_do;
CREATE PROCEDURE to_do(IN id varchar(100),IN role VARCHAR(15))
BEGIN
    IF role = 'tme' 
        THEN SELECT id_demande AS dmd,(SELECT name_user AS client from `user`
                                    JOIN process
                                    ON process.id_user = user.id_user
                                    JOIN demande
                                    ON demande.id_demande = process.id_demande
                                    WHERE dmd = demande.id_demande) AS client_name,

                                    (SELECT societe_user AS societe from `user`
                                    JOIN process
                                    ON process.id_user = user.id_user
                                    JOIN demande
                                    ON demande.id_demande = process.id_demande
                                    WHERE dmd = demande.id_demande) AS 'societe_client',date_demande,date_operation,operation,point_sortie


                                    
                                    
                                    FROM demande
                                    WHERE etap = 'regester';
    ELSEIF role = 'capt' 
        THEN SELECT id_demande AS dmd,(SELECT name_user AS client from `user`
                                    JOIN process
                                    ON process.id_user = user.id_user
                                    JOIN demande
                                    ON demande.id_demande = process.id_demande
                                    WHERE dmd = demande.id_demande) AS client_name,

                                    (SELECT societe_user AS societe from `user`
                                    JOIN process
                                    ON process.id_user = user.id_user
                                    JOIN demande
                                    ON demande.id_demande = process.id_demande
                                    WHERE dmd = demande.id_demande) AS 'societe_client',date_demande,date_operation,operation,point_sortie


                                    
                                    
                                    FROM demande
                                    WHERE etap = 'v-tme';
    ELSEIF role = 'd_tech' 
        THEN SELECT id_demande AS dmd,(SELECT name_user AS client from `user`
                                    JOIN process
                                    ON process.id_user = user.id_user
                                    JOIN demande
                                    ON demande.id_demande = process.id_demande
                                    WHERE dmd = demande.id_demande) AS client_name,

                                    (SELECT societe_user AS societe from `user`
                                    JOIN process
                                    ON process.id_user = user.id_user
                                    JOIN demande
                                    ON demande.id_demande = process.id_demande
                                    WHERE dmd = demande.id_demande) AS 'societe_client',date_demande,date_operation,operation,point_sortie


                                    
                                    
                                    FROM demande
                                    WHERE etap = 'v-capt';
    ELSEIF role = 'exploi' 
        THEN SELECT id_demande AS dmd,(SELECT name_user AS client from `user`
                                    JOIN process
                                    ON process.id_user = user.id_user
                                    JOIN demande
                                    ON demande.id_demande = process.id_demande
                                    WHERE dmd = demande.id_demande) AS client_name,

                                    (SELECT societe_user AS societe from `user`
                                    JOIN process
                                    ON process.id_user = user.id_user
                                    JOIN demande
                                    ON demande.id_demande = process.id_demande
                                    WHERE dmd = demande.id_demande) AS 'societe_client',date_demande,date_operation,operation,point_sortie


                                    
                                    
                                    FROM demande
                                    WHERE etap = 'v-d_tech';
    ELSEIF role = 'terr' 
        THEN SELECT id_demande AS dmd,(SELECT name_user AS client from `user`
                                    JOIN process
                                    ON process.id_user = user.id_user
                                    JOIN demande
                                    ON demande.id_demande = process.id_demande
                                    WHERE dmd = demande.id_demande) AS client_name,

                                    (SELECT societe_user AS societe from `user`
                                    JOIN process
                                    ON process.id_user = user.id_user
                                    JOIN demande
                                    ON demande.id_demande = process.id_demande
                                    WHERE dmd = demande.id_demande) AS 'societe_client',date_demande,date_operation,operation,point_sortie


                                    
                                    
                                    FROM demande
                                    WHERE etap = 'v-exploi';
    END IF;
END


CALL to_do('2','tme');




