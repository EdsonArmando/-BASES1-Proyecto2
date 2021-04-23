CREATE DATABASE Proyecto2Bases;
use Proyecto2Bases;
#Carga 1
create table Carga1(
	INVENTO varchar(100),
    INVENTOR varchar(100),
    PROFESIONAL_ASIGANDO_AL_INVENTO varchar(100),
    EL_PROFESIONAL_ES_JEFE_DEL_AREA varchar(100),
    FECHA_CONTRATO_PROFESIONAL varchar(100),
    SALARIO integer,
    COMISION integer,
    AREA_INVEST_DEL_PROF varchar(100),
    RANKING integer,
    ANIO_DEL_INVENTO integer,
    PAIS_DEL_INVENTO varchar(100),
    PAIS_DEL_INVENTOR varchar(100),
    REGION_DEL_PAIS varchar(100),
    CAPITAL varchar(100),
    POBLACION_DEL_PAIS integer,
    AREA_EN_KM2 integer,
    FRONTERA_CON varchar(100),
    NORTE CHAR(1),
    SUR CHAR(1),
    ESTE CHAR(1),
    OESTE CHAR(1)
);
#Cargar datos a tabla temporalCargoa2
LOAD DATA LOCAL INFILE 'C:\\compiladores2\\CargaP-I.csv' INTO TABLE Carga1 FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;
#Carga 2
create table Carga2(
	NOMBRE_ENCUESTA varchar(140),
    PREGUNTA varchar(250),
    RESPUESTAS_POSIBLES varchar(80),
    RESPUESTA_CORRECTA varchar(80),
    PAIS varchar(80),
    RESPUESTA_PAIS CHAR(1)
);
#Cargar datos a tabla temporalCargoa2
LOAD DATA LOCAL INFILE 'C:\\compiladores2\\CargaP-II.csv' INTO TABLE Carga2 FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;
#carga3
create table Carga3(
	NOMBRE_REGION varchar(80),
    REGION_PADRE varchar(90)
);
#Cargar datos a tabla carga3
LOAD DATA LOCAL INFILE 'C:\\compiladores2\\CargaP-III.csv' INTO TABLE Carga3 FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;