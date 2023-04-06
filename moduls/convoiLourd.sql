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


     SELECT id_user,role INTO id,roleOut FROM user WHERE (name_user = username AND pass_user = passo);

     SELECT COUNT(version) INTO authenCount FROM authentification WHERE id_user = id;
  
     INSERT INTO authentification(id_user) VALUES (id);

     SELECT version INTO versionA FROM authentification WHERE (id_user = 1) ORDER BY date_authen_in DESC LIMIT 1;

     IF id IS NOT NULL AND roleOut IS NOT NULL THEN SELECT JSON_OBJECT( "id",id,"role",roleOut,"version",versionA,"authenCount",authenCount) AS usuario;
     else SELECT 'not acess' AS usuario;
     END IF;

END

DELIMITER ;

 
SELECT @keyObj;
call check_access('aziz','123',;
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
