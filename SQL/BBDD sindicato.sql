SET AUTOCOMMIT = 1;
DROP DATABASE BBDD_Sindicato ;
CREATE DATABASE IF NOT EXISTS BBDD_Sindicato ;
USE BBDD_Sindicato ;

-- CREACION DE TABLAS

CREATE TABLE IF NOT EXISTS Provincias (
	  Id_Provincia INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY
    , Provincia VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Tipo_Instalaciones (
	  Id_Tipo_Instalacion INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY
    , Tipo_Instalacion VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Instalaciones (
	  Id_Instalacion 	INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY
    , Id_Tipo_Instalacion INT NOT NULL
    , Nombre_Instalacion VARCHAR(100) NOT NULL UNIQUE
    , Id_Provincia INT NOT NULL
    , Ciudad VARCHAR (50)
    , Direccion VARCHAR (80) NOT NULL
    , Telefono CHAR (10) NOT NULL
    , Telefono_2 CHAR (10)
    , FOREIGN KEY (Id_Tipo_Instalacion)
		REFERENCES Tipo_Instalaciones(Id_Tipo_Instalacion)
        -- Solo queremos que se actualice el tipo de instalacion; Si se borra el tipo de instalacion aun queremos la info previa --
		ON UPDATE CASCADE 
	, FOREIGN KEY (Id_Provincia)
		REFERENCES Provincias(Id_Provincia)
			-- Idem comentario anterior; Queremos mantener la informacion hasta actualizarlo
            ON UPDATE CASCADE 
);

CREATE TABLE IF NOT EXISTS Empresas (
	  Id_Empresa INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY
    , Nombre_Empresa VARCHAR (100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Seccionales (
	  Id_Seccional INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY
    , Nombre_Seccional VARCHAR (100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Empresas_Y_Seccionales (
	  Id_Seccional INT NOT NULL
    , Id_Empresa INT NOT NULL UNIQUE 
    , FOREIGN KEY (Id_Seccional)
		REFERENCES Seccionales(Id_Seccional)
		-- Idem comentario anterior; Queremos mantener la informacion hasta actualizarlo
        ON UPDATE CASCADE
    , FOREIGN KEY (Id_Empresa)
		REFERENCES Empresas(Id_Empresa)
		-- Idem comentario anterior; Queremos mantener la informacion hasta actualizarlo
        ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Tipo_Documento (
	  Id_Tipo_Documento INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY
    , Tipo VARCHAR (50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Estados (
	  Id_Estado INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY
	, Estado VARCHAR (50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Afiliados (
	  Id_Afiliado INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY
    , Apellido_Afiliado VARCHAR (50) NOT NULL
    , Nombre_Afiliado VARCHAR(50) NOT NULL
    , Id_Seccional INT NOT NULL
    , Fecha_Alta DATE NOT NULL -- DEFAULT CURRENT_DATE | Encontre cómo poner current_date de default pero debo poner "triggers" --
    , Id_Tipo_Documento INT NOT NULL
    , Nro_Documento VARCHAR (12) NOT NULL
    , Id_Estado INT NOT NULL DEFAULT 1
    , Fecha_Baja DATE
    , FOREIGN KEY (Id_Seccional)
		REFERENCES Seccionales(Id_Seccional)
			-- Idem comentario anterior; Queremos mantener la informacion hasta actualizarlo
            ON UPDATE CASCADE 
	, FOREIGN KEY (Id_Tipo_Documento)
		REFERENCES Tipo_Documento(Id_Tipo_Documento)
			-- Idem comentario anterior; Queremos mantener la informacion hasta actualizarlo
            ON UPDATE CASCADE
	, FOREIGN KEY (Id_Estado)
		REFERENCES Estados(Id_Estado)
			-- Idem comentario anterior; Queremos mantener la informacion hasta actualizarlo
            ON UPDATE CASCADE 
);

CREATE TABLE IF NOT EXISTS Reservas (
	  Id_Reserva INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY
	, Id_Afiliado INT NOT NULL
    , Fecha_Registro DATE NOT NULL
    , Fecha_Reserva DATE NOT NULL
    , Id_Instalacion INT NOT NULL
    , FOREIGN KEY (Id_Afiliado)
		REFERENCES Afiliados(Id_Afiliado)
			-- Idem comentario anterior; Queremos mantener la informacion hasta actualizarlo
            ON UPDATE CASCADE 
	, FOREIGN KEY (Id_Instalacion)
		REFERENCES Instalaciones(Id_Instalacion)
			-- Idem comentario anterior; Queremos mantener la informacion hasta actualizarlo
            ON UPDATE CASCADE 
);

CREATE TABLE IF NOT EXISTS Log_Ops_Tipos (
-- Tabla utilizada para normaliar los tipos de operaciones realizadas en los triggers
	  Id_Tipo_Ops INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY
    , Tipo_Operacion VARCHAR(20) UNIQUE NOT NULL 
);

CREATE TABLE IF NOT EXISTS AUX_Afiliados (
-- Tabla espejo para registrar modificaciones en los afiliados
	  Id_Op INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY
    , Id_Tipo_Ops INT
    , Usuario VARCHAR(100)
    , Fecha DATE
    , Hora TIME
	, Id_Afiliado INT
    , Apellido_Afiliado VARCHAR (50)
    , Nombre_Afiliado VARCHAR(50)
    , Id_Seccional INT
    , Fecha_Alta DATE NOT NULL -- DEFAULT CURRENT_DATE | Encontre cómo poner current_date de default pero debo poner "triggers" --
    , Id_Tipo_Documento INT
    , Nro_Documento VARCHAR (12)
    , Id_Estado INT
    , Fecha_Baja DATE
    , FOREIGN KEY (Id_Tipo_Ops)
		REFERENCES Log_Ops_Tipos(Id_Tipo_Ops)
			ON UPDATE CASCADE
         
);

CREATE TABLE IF NOT EXISTS AUX_Reservas (
-- Idem anterior con reservas
	  Id_Op INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY
    , Id_Tipo_Ops INT
    , Usuario VARCHAR(100)
    , Fecha DATE
    , Hora TIME
    , Id_Reserva INT
	, Id_Afiliado INT
    , Fecha_Registro DATE
    , Fecha_Reserva DATE
    , Id_Instalacion INT
	, FOREIGN KEY (Id_Tipo_Ops)
		REFERENCES Log_Ops_Tipos(Id_Tipo_Ops)
			ON UPDATE CASCADE
);

-- INSERCION DE DATOS


-- Segun listadao oficial de provincias. Por simplicidad, en el nombre de Tierra del Fuego se omitieron la Antartida e Islas del Atlantico Sur
INSERT INTO
	Provincias 	(Provincia)
	VALUES
				('Buenos Aires')
		, 		('Ciudad Autónoma de Buenos Aires')
		, 		('Catamarca')
		, 		('Chaco')
		, 		('Chubut')
		, 		('Córdoba')
		, 		('Corrientes')
		, 		('Entre Ríos')
		, 		('Formosa')
		, 		('Jujuy')
		, 		('La Pampa')
		, 		('La Rioja')
		, 		('Mendoza')
		, 		('Misiones')
		, 		('Neuquén')
		, 		('Río Negro')
		, 		('Salta')
		, 		('San Juan')
		, 		('San Luis')
		, 		('Santa Cruz')
		, 		('Santa Fe')
		, 		('Santiago del Estero')
		, 		('Tierra del Fuego')
		, 		('Tucumán')
;

-- Salvo por camping y salon, los tipos de instalaciones son inventados para realizar el ejercicio        
INSERT INTO 
	Tipo_Instalaciones	(Tipo_Instalacion)
    VALUES
						('Camping')
        ,				('Salon')
        ,				('Gimnasio')
        ,				('Pileta')
;
        
INSERT INTO
	Instalaciones ( Id_Tipo_Instalacion , Nombre_Instalacion , Id_Provincia , Ciudad , Direccion , Telefono )
    VALUES
				  (1 , 'Camping Trabajadores Unidos de la Informacion', 1, 'San Isidro', 'Calle Inventada 123', 1150944320)
		,		  (1 , 'Camping Unidos por SQL', 1, 'Lujan', 'Circuito Costanero 123', 2941234567)
        ,		  (2 , 'Salon Sindicato T.U.I.', 2, 'Monserrat', 'Peru 455', 1166600666)
        ,		  (2 , 'Salon Espacio Usos Multiples', 2, 'Retiro', 'Juncal 656', 1123232323)
        ,		  (3 , 'Gimnasio TABLAS FUERTES', 2, 'Palermo', 'Cabrera 3700', 1190909090)
		,		  (4 , 'Natatorio DATA LAKE', 2, 'Palermo', 'Cabrera 3713', 1190909091)
;

INSERT INTO
	Empresas (Nombre_Empresa)
    VALUES
			 ('DDBB Inc. Ltd.')
		,	 ('Bases de Datos Relacionales Intl.')
        ,	 ('Sistemas de Informacion Relacionales')
        ,	 ('Grupo Ciudad Gotica')
        ,	 ('BBDD Automachines')
        ,	 ('BI Matix')
        ,	 ('Sistemas Futuros SRL')
        ,	 ('Conexion Data SA')
;

INSERT INTO 
	Seccionales (Nombre_Seccional)
    VALUES
				('Zona Norte Argentino')
        ,		('Zona Centro')
        ,		('Zona Cuyo')
        ,		('Zona Gran Buenos Aires y CABA')
        ,		('Zona Patagonica')
;

INSERT INTO
	Empresas_Y_Seccionales  (Id_Seccional, Id_Empresa)
    VALUES  
							(1,1)
        ,   				(2,2)
        ,					(3,3)
        ,					(4,4)
        ,					(4,5)
        ,					(4,6)
        ,					(5,7)
        ,					(5,8)
;

-- Segun documentos validos para votar, pasaporte y documentos nacionales extranjeros (para simplicidad del ejericio se omiten DNIs extranjeros)
INSERT INTO Tipo_Documento  (Tipo)
	VALUES
							('Libreta Cívica')
        ,                   ('Libreta de Enrolamiento')
        ,                   ('DNI Libreta Verde')
        ,                   ('DNI Libreta Celeste')
        ,                   ('DNI Tarjeta')
        ,					('Pasaporte')
;

INSERT INTO Estados (Estado)
	VALUES
					('Activo')
		,			('Jubilado')
		,			('Adherente')
		,			('Despedido')
		,			('Fallecido')
		,			('Expulsado')
;

INSERT INTO Afiliados (Apellido_Afiliado, Nombre_Afiliado, Id_Seccional, Fecha_Alta, Id_Tipo_Documento, Nro_Documento, Id_Estado, Fecha_Baja)
	VALUES
					  ('Diaz','Bruno',1,'1993-3-31',5,24545444,1,NULL)
        ,             ('Kent','Clark',2,'1993-2-22',5,23333333,1,NULL)
        ,             ('Guason','El',3,'1993-4-22',5,22334444,6,'1993-5-10') -- Expulsado por mala conducta
        ,             ('Maravilla','Mujer',4,'1993-2-22',5,21343545,1,NULL)
        ,             ('Verde','Linterna',4,'1993-3-31',6, 'AAC263222',3,NULL)
        ,             ('Xavier','Charles',4,'1993-3-31',1,152232,2,NULL)
        ,             ('Neto','Mag',5,'1993-3-31',2,1133424,4,'2002-4-22') -- Despedido por robar cobre
        ,             ('Stark','Tony',5,'2002-1-23',3,22093093,5,'2019-4-26')
;

INSERT INTO Reservas 	(Id_Afiliado, Fecha_Registro, Fecha_Reserva, Id_Instalacion)
	VALUES
						(1, '2022-2-22','2022-8-29',3)
        ,               (2, '2022-3-11','2022-3-23',2)
        ,               (4, '2022-4-13','2022-4-29',4)
        ,               (5, '2022-5-22','2022-5-25',5)
        ,               (6, '2022-5-28','2022-6-22',6)
        ,               (8, '2022-6-1','2022-6-15',1)
        
;


-- VISTAS


-- Vista con informacion completa de los afiliados (ej. no se muestra el Id_Tipo_Documento, sino el tipo directamente)
CREATE OR REPLACE VIEW V_Afiliados AS
	(SELECT
		Id_Afiliado, Apellido_Afiliado, Nombre_Afiliado, s.Nombre_Seccional, Fecha_Alta, t.Tipo, Nro_Documento, e.Estado, Fecha_Baja
	FROM Afiliados a 
		JOIN tipo_documento t ON a.Id_Tipo_Documento = t.Id_Tipo_Documento
        JOIN estados e		  ON a.Id_Estado = e.Id_Estado
        JOIN Seccionales s    ON a.Id_Seccional = s.Id_Seccional)
;

INSERT INTO
	Log_ops_Tipos (Tipo_Operacion)
    VALUES
		  ('INSERT')
        , ('UPDATE')
        , ('DELETE')
;

-- Idem anterior para reservas. Se muestra informacion completa de las mismas
CREATE OR REPLACE VIEW V_Reservas AS
	(SELECT
		Id_Reserva, Id_Afiliado, Fecha_Registro, Fecha_Reserva, r.Id_Instalacion, i.Nombre_Instalacion, p.Provincia, i.Ciudad, i.Direccion
	FROM reservas r
 		JOIN Instalaciones i
			ON r.Id_Instalacion = i.Id_Instalacion
		JOIN Provincias p 
			ON i.Id_Provincia = p.Id_Provincia)
;

-- Idem anterior para instalaciones
CREATE OR REPLACE VIEW V_Instalaciones AS
	(SELECT
		Id_Instalacion, t.Tipo_Instalacion, Nombre_Instalacion, p.Provincia, Ciudad, Direccion, Telefono, Telefono_2
	FROM Instalaciones i
		JOIN Tipo_Instalaciones t ON t.Id_Tipo_Instalacion = i.Id_Tipo_Instalacion
        JOIN Provincias p	  	  ON p.Id_Provincia = i.Id_Provincia)
;

-- Idem anterior para la tabla relacional Empresas_Y_Seccionales, permite ver los nombres de las mismas.
-- Se mantienen los codigos de empresas y seccionales para futura referencias
CREATE OR REPLACE VIEW V_Empresas_Y_Seccionales AS
	(SELECT 
		eys.Id_Seccional, s.Nombre_Seccional, e.Nombre_Empresa, eys.Id_Empresa
		FROM Empresas_Y_Seccionales eys
			JOIN Seccionales s  ON eys.Id_Seccional =  s.Id_Seccional
            JOIN Empresas e		ON eys.Id_Empresa = e.Id_Empresa)
; 

-- Permite ver instalaciones disponibles en la fecha de hoy, vista a desarrollar para permitir cambiar el dia de busqueda
CREATE OR REPLACE VIEW V_Ins_Disp_HOY AS
	(SELECT 
	
		i.Id_Instalacion, t.Tipo_Instalacion, i.Nombre_Instalacion, p.Provincia, i.Ciudad, i.Direccion, i.Telefono, i.Telefono_2
    
	FROM Instalaciones i
		JOIN Reservas    		r ON i.Id_Instalacion      = r.Id_Instalacion
		JOIN Provincias  	 	p ON i.Id_Provincia        = p.Id_Provincia
		JOIN tipo_instalaciones t ON i.Id_Tipo_Instalacion = t.Id_Tipo_Instalacion
    
	WHERE r.Fecha_Reserva NOT IN (
									SELECT Fecha_Reserva 
									FROM V_Reservas
									WHERE Fecha_Reserva = DATE(CURRENT_TIMESTAMP) -- a cambiar por una fecha eligida en el futuro
		)
    )
    ;


-- FUNCIONES

-- Permite saber si una fecha esta disponible. Para utilizar en las reservas.
-- Por ej, se puede usar en la tabla de reservas para saber que instalaciones estan disponibles en una fecha particular
DELIMITER $$
CREATE FUNCTION Ins_Disponibles ( Fecha_Reserva DATE ,Fecha_Buscada DATE)
RETURNS BOOLEAN
NO SQL
BEGIN
	RETURN IF( Fecha_Reserva = Fecha_Buscada, FALSE, TRUE) ;
END $$
DELIMITER ;

-- Tiempo_Activo: Calcula la cantidad de dias activo de un afiliado
-- Calcula un DATEDIFF() entra la fecha actual y una fecha deseada
DELIMITER $$
CREATE FUNCTION Tiempo_Activo( Fecha_Alta DATE)
RETURNS INT
NO SQL
BEGIN
	DECLARE Hoy DATE ;
    DECLARE Dias INT ;
    SET Hoy = DATE(CURRENT_TIMESTAMP) ;
	SET Dias = DATEDIFF(Hoy, Fecha_Alta) ;
    RETURN Dias ;
END $$
DELIMITER ;

-- Devuelve Id del afiliado con estado activo con el mayor tiempo afiliado en una seccional en partciular
DELIMITER $$
CREATE FUNCTION Mas_Antiguo_Seccional (Seccional_Param INT)
RETURNS INT
READS SQL DATA
BEGIN
	DECLARE Id_Buscado INT;
	SET Id_Buscado =(
					SELECT Id_Afiliado 
					FROM Afiliados a
					WHERE a.fecha_alta = (
										SELECT MIN(fecha_alta)
										FROM   Afiliados 
										WHERE  Id_Seccional = Seccional_Param
                                        AND	   Id_Estado    = 1 -- Equivale a Activo
										 )
										AND	   Id_Seccional = Seccional_Param -- Aunque parezca redundante, es necesaria esta
																		      -- condicion. Podrian haber dos MIN(fecha_alta)
																			  -- el mismo dia en dos seccionales diferentes										
					);
	RETURN Id_Buscado;              
END $$
DELIMITER ;


-- Stored Procedures


DELIMITER $$
CREATE PROCEDURE Afiliados_Ordenados (IN Campo CHAR(20), IN Dir ENUM('ASC','DESC'))
-- Parametros: 		Campo-> Campo elegido como criterio de orden
--             		Dir---> Direccion ascendente o descendente
-- Devuelve  : 		Tabla de afiliados ordenados segun un campo de criterio ascendente o descendentemente
BEGIN
	IF Campo <> '' THEN
		SET @ORDEN = CONCAT ('ORDER BY ', Campo);
    ELSE 
		SET @ORDEN = '';
	END IF;
    
    IF Dir <> '' THEN
		SET @Direccion = Dir;
	ELSE
		SET @Direccion = '';
    END IF;
    
	SET @CLAUSULA = CONCAT (' SELECT * FROM BBDD_SINDICATO.AFILIADOS ',@ORDEN, ' ', @Direccion);
    PREPARE querySQL FROM @CLAUSULA;
    EXECUTE QUERYSQL;
    DEALLOCATE PREPARE QUERYSQL;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE Insert_Afiliado
-- Inserta un nuevo afiliado, Fecha_Baja no se inserta
								(
								  IN Apellido_Afiliado2 VARCHAR(50) 
								, IN Nombre_Afiliado2 	VARCHAR(50)
                                , IN Id_Seccional2 		INT
                                , IN Fecha_Alta2		DATE
                                , IN Id_Tipo_Documento2	INT
                                , IN Nro_Documento2		VARCHAR(12)
                                , IN Id_Estado2			INT
								)

BEGIN
	INSERT INTO Afiliados (Apellido_Afiliado, Nombre_Afiliado, Id_Seccional, Fecha_Alta, Id_Tipo_Documento, Nro_Documento, Id_Estado)
		VALUES (
									  Apellido_Afiliado2
									, Nombre_Afiliado2
									, Id_Seccional2 	
									, Fecha_Alta2		
									, Id_Tipo_Documento2
									, Nro_Documento2	
									, Id_Estado2	
										
									);
END $$

DELIMITER ;


-- Tiggers | Se incluyen las tablas auxiliares e insercion de datos si fueran necesarias


CREATE TRIGGER LOG_INSERT_AFILIADOS
-- Trigger para registrar adicion de un afiliado
AFTER INSERT ON Afiliados
FOR EACH ROW
INSERT INTO AUX_Afiliados (
							Id_Tipo_Ops, Usuario          , Fecha          , Hora
						  , Id_Afiliado, Apellido_Afiliado, Nombre_Afiliado, Id_Seccional
                          , Fecha_Alta , Id_Tipo_Documento, Nro_Documento  , Id_Estado
                          , Fecha_Baja )
VALUES
                          ( -- EL num 1 es el codigo para INSERT en la tabla Log_Ops_Tipos
						1,  SESSION_USER()       , CURDATE()          , CURTIME()       , NEW.Id_Afiliado      
                        ,   NEW.Apellido_Afiliado, NEW.Nombre_Afiliado, NEW.Id_Seccional, NEW.Fecha_Alta
                        ,   NEW.Id_Tipo_Documento, NEW.Nro_Documento  , NEW.Id_Estado   , NEW.Fecha_Baja )
;

CREATE TRIGGER LOG_UPDATE_AFILIADOS
-- Trigger para registrar modificacion de datos de un afiliado
AFTER UPDATE ON Afiliados
FOR EACH ROW
INSERT INTO AUX_Afiliados (
							Id_Tipo_Ops , Usuario          , Fecha          , Hora 
						  , Id_Afiliado , Apellido_Afiliado, Nombre_Afiliado, Id_Seccional
                          , Fecha_Alta  , Id_Tipo_Documento, Nro_Documento  , Id_Estado
                          , Fecha_Baja )
VALUES
                          ( -- EL num 2 es el codigo para UPDATE en la tabla Log_Ops_Tipos
						2,  SESSION_USER()       , CURDATE()          , CURTIME()       , NEW.Id_Afiliado
                        ,   NEW.Apellido_Afiliado, NEW.Nombre_Afiliado, NEW.Id_Seccional, NEW.Fecha_Alta
                        ,   NEW.Id_Tipo_Documento, NEW.Nro_Documento  , NEW.Id_Estado   , NEW.Fecha_Baja )
;

CREATE TRIGGER LOG_DELETE_AFILIADOS
-- Trigger para registrar eliminacion de un afiliado
BEFORE DELETE ON Afiliados
FOR EACH ROW
INSERT INTO AUX_Afiliados (
							Id_Tipo_Ops , Usuario          , Fecha          , Hora 
						  , Id_Afiliado , Apellido_Afiliado, Nombre_Afiliado, Id_Seccional
                          , Fecha_Alta  , Id_Tipo_Documento, Nro_Documento  , Id_Estado
                          , Fecha_Baja )
                          
VALUES
                          ( -- EL num 3 es el codigo para DELETE en la tabla Log_Ops_Tipos
						3,  SESSION_USER()     , CURDATE()          , CURTIME()       , OLD.Id_Afiliado           
                        , OLD.Apellido_Afiliado, OLD.Nombre_Afiliado, OLD.Id_Seccional, OLD.Fecha_Alta  
                        , OLD.Id_Tipo_Documento, OLD.Nro_Documento  , OLD.Id_Estado   , OLD.Fecha_Baja 
                        )
;

CREATE TRIGGER LOG_INSERT_RESERVAS
-- Trigger para registrar adicion de una reserva
AFTER INSERT ON Reservas
FOR EACH ROW
INSERT INTO AUX_Reservas (
							Id_Tipo_Ops, Usuario   , Fecha         , Hora
						  , Id_Reserva ,Id_Afiliado, Fecha_Registro, Fecha_Reserva
                          , Id_Instalacion
						 )
VALUES
						 ( -- EL num 1 es el codigo para INSERT en la tabla Log_Ops_Tipos
						1,  SESSION_USER(), CURDATE()           , CURTIME()        , NEW.Id_Reserva
                        , NEW.Id_Afiliado ,   NEW.Fecha_Registro, NEW.Fecha_Reserva, NEW.Id_Instalacion
						 )
;

CREATE TRIGGER LOG_UPDATE_RESERVAS
-- Trigger para registrar modificacion de datos de una reserva
AFTER UPDATE ON Reservas
FOR EACH ROW
INSERT INTO AUX_Reservas (
							Id_Tipo_Ops, Usuario   , Fecha         , Hora
						  , Id_Reserva ,Id_Afiliado, Fecha_Registro, Fecha_Reserva
                          , Id_Instalacion
						 )
VALUES
						 ( -- EL num 2 es el codigo para UPDATE en la tabla Log_Ops_Tipos
						2,  SESSION_USER(), CURDATE()           , CURTIME()        , NEW.Id_Reserva
                        , NEW.Id_Afiliado ,   NEW.Fecha_Registro, NEW.Fecha_Reserva, NEW.Id_Instalacion
						 )
;

CREATE TRIGGER LOG_DELETE_RESERVAS
-- Trigger para registrar eliminacion de una reserva
BEFORE DELETE ON Reservas
FOR EACH ROW
INSERT INTO AUX_Reservas (
							Id_Tipo_Ops, Usuario   , Fecha         , Hora
						  , Id_Reserva ,Id_Afiliado, Fecha_Registro, Fecha_Reserva
                          , Id_Instalacion
						 )
VALUES
						 ( -- EL num 3 es el codigo para UPDATE en la tabla Log_Ops_Tipos
						3,  SESSION_USER(), CURDATE()           , CURTIME()        , OLD.Id_Reserva
                        , OLD.Id_Afiliado ,   OLD.Fecha_Registro, OLD.Fecha_Reserva, OLD.Id_Instalacion
						 )
;


-- USUARIOS

DROP USER 'data.entry@localhost';
DROP USER 'lector@localhost';

-- Crea usuario 'lector', el cual solo tiene permisos de SELECT en todas las tablas
-- a fin de poder consultar informacion, pero NO insertar o manipularla
CREATE USER 'lector@localhost';

-- Crea usuario 'data.entry', el cual tiene permisos de SELECT UPDATE e INSERT en todas las tablas
-- para poder insertar y manipular informacion en las mismas
CREATE USER 'data.entry@localhost';


-- Otorga los permisos necesarios al usuario 'data.entry' para poder insertar y manipular informacion
GRANT SELECT, UPDATE, INSERT ON *.* TO 'data.entry@localhost';

-- Otorga los permisos necesarios al usuario 'lector' para poder, unicamente, consultar informacion
GRANT SELECT ON *.* TO 'lector@localhost';


-- TCL | Notese que se agrega un SP para facilitar el ingreso de reservas


SET AUTOCOMMIT = 0;

CALL Afiliados_Ordenados ('Id_Afiliado','DESC'); -- utilizamos el sp creado visualizar afiliados
START TRANSACTION;
CALL INSERT_AFILIADO ('Roel','Juan','5','2022-9-19',1,37363746,1);  -- utilizamos el sp creado para insercion de 3 afiliados
CALL INSERT_AFILIADO ('Rambo','Jhon','2','2022-9-19',1,32347586,1);
CALL INSERT_AFILIADO ('Poe','Edgar Allan','4','2022-9-19',1,18394489,1);
COMMIT;

CALL Afiliados_Ordenados ('Id_Afiliado','DESC'); -- vemos los cambios
-- ROLLBACK; -- queda comentario, como la tabla tiene pocas entries dejamos los cambios

-- Creamos un nuevo SP para ingresar reservas
DELIMITER $$
CREATE PROCEDURE Insert_Reserva
-- Inserta una nueva reserva
								(
								  IN Id_Afiliado2 INT
								, IN Fecha_Registro2 DATE
                                , IN Fecha_Reserva2 DATE
                                , IN Id_Instalacion2 INT
								)

BEGIN
	INSERT INTO Reservas (Id_Afiliado, Fecha_Registro, Fecha_Reserva, Id_Instalacion)
		VALUES  (					
								
								  Id_Afiliado2
								, Fecha_Registro2
                                , Fecha_Reserva2
                                , Id_Instalacion2
                                
								);
END $$

DELIMITER ;

START TRANSACTION; -- Insertamos 8 reservas, divididas en 2 lotes
CALL Insert_Reserva ( 1, '2022-9-19', '2022-12-24', 4);
CALL Insert_Reserva ( 2, '2022-9-10', '2022-12-31', 3);
CALL Insert_Reserva ( 9, '2022-9-10', '2022-12-31', 2);
CALL Insert_Reserva ( 10, '2022-9-10', '2022-11-20', 3);
SAVEPOINT lote_1;
CALL Insert_Reserva ( 4, '2022-9-21', '2022-9-21', 1);
CALL Insert_Reserva ( 4, '2022-9-21', '2022-9-28', 3);
CALL Insert_Reserva ( 4, '2022-9-21', '2022-10-5', 3);
CALL Insert_Reserva ( 6, '2022-9-10', '2024-1-1', 5);
SAVEPOINT lote_2;

RELEASE SAVEPOINT lote_1; -- borramos el savepoint de lote_1

COMMIT; -- agregamos las reservas para tener mas datos en la tabla

SELECT * FROM V_Reservas ORDER BY Fecha_Registro DESC; -- mostramos el resultado de agregar las reservas

-- Devolvemos el autocommit a valor default!
SET AUTOCOMMIT = 1;
