CREATE DATABASE Proyecto2BasesLocal;
use Proyecto2BasesLocal;
SET GLOBAL local_infile=true;
#Carga 1
create table Carga1(
	INVENTO varchar(100),
    INVENTOR varchar(100),
    PROFESIONAL_ASIGANDO_AL_INVENTO varchar(100),
    EL_PROFESIONAL_ES_JEFE_DEL_AREA varchar(100),
    FECHA_CONTRATO_PROFESIONAL varchar(100),
    SALARIO int,
    COMISION int,
    AREA_INVEST_DEL_PROF varchar(100),
    RANKING int,
    ANIO_DEL_INVENTO int,
    PAIS_DEL_INVENTO varchar(100),
    PAIS_DEL_INVENTOR varchar(100),
    REGION_DEL_PAIS varchar(100),
    CAPITAL varchar(100),
    POBLACION_DEL_PAIS int,
    AREA_EN_KM2 int,
    FRONTERA_CON varchar(100),
    NORTE CHAR(1),
    SUR CHAR(1),
    ESTE CHAR(1),
    OESTE CHAR(1)
);
#Cargar datos a tabla temporalCarga1
LOAD DATA INFILE 'C:\\compiladores2\\CargaP-I.csv' INTO TABLE Carga1 FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;
#Carga 2
create table Carga2(
	NOMBRE_ENCUESTA varchar(140),
    PREGUNTA varchar(250),
    RESPUESTAS_POSIBLES varchar(80),
    RESPUESTA_CORRECTA varchar(80),
    PAIS varchar(80),
    RESPUESTA_PAIS CHAR(1)
);
#Cargar datos a tabla temporalCarga2
LOAD DATA  INFILE 'C:\\compiladores2\\CargaP-II.csv' INTO TABLE Carga2 FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;
#carga3
create table Carga3(
	NOMBRE_REGION varchar(80),
    REGION_PADRE varchar(90)
);
#Cargar datos a tabla carga3
LOAD DATA  INFILE 'C:\\compiladores2\\CargaP-III.csv' INTO TABLE Carga3 FIELDS TERMINATED BY ';' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;
#Creacion del ER
#Tabla Region
#ALTER TABLE encuesta AUTO_INCREMENT = 1; 
#truncate table region
create table Region(
	id int not null primary key AUTO_INCREMENT,
    nombre varchar(100),
    id_region int
);
ALTER TABLE Region
ADD FOREIGN KEY (id_region) REFERENCES Region(id);
#Inserts a la Tabla Region
insert Region(nombre)
select carga3.nombre_region
from carga3;
#Insertando las Regiones Padres
#SET FOREIGN_KEY_CHECKS=0;
update Region as r
inner join (
	select carga3.nombre_region as nombre,region.id as id
	from carga3
	left join region on carga3.region_padre = region.nombre	
) as temp on temp.nombre= r.nombre
set r.id_region = ifnull(temp.id,0);
#Tabla Pais
create table Pais(
	idPais int not null primary key AUTO_INCREMENT,
    nombre varchar(100),
    poblacion int,
    area int,
    capital varchar(100),
    id_region int not null,
    FOREIGN KEY (id_region) REFERENCES Region(id)
);
#Insert Paises
insert Pais(nombre,poblacion,area,capital,id_region)
select c.pais_del_inventor, c.POBLACION_DEL_PAIS,c.AREA_EN_KM2,c.capital,r.id
from carga1 as c, Region as r
where c.pais_del_inventor <>'' and c.REGION_DEL_PAIS = r.nombre
group by c.pais_del_inventor ;
#Tabla Frontera
create table Frontera(
	idFrontera int not null primary key AUTO_INCREMENT,
    norte char(1),
    sur char(1),
    este char(1),
    oeste char(1),
    idPais1 int,
    idPais2 int,
    FOREIGN KEY (idPais1) REFERENCES Pais(idPais),
    FOREIGN KEY (idPais2) REFERENCES Pais(idPais)
);
#Insertar datos Frontera
insert Frontera(norte,sur,este,oeste,idpais1,idpais2)
select temp.norte,temp.sur,temp.este,temp.oeste,p.idpais,p2.idpais
from(
	select c.pais_del_inventor as Pais1,c.frontera_con as Pais2,c.norte,c.sur,c.este,c.oeste
	from carga1 as c
	group by c.pais_del_inventor,c.frontera_con
)as temp
left join pais as p on temp.pais1 = p.nombre
left join pais as p2 on temp.pais2 = p2.nombre
 ;
 #Tabla Frontera
create table Inventor(
	idInventor int not null primary key AUTO_INCREMENT,
    nombre varchar(100),
    idPais int,
    FOREIGN KEY (idPais) REFERENCES Pais(idPais)
);
#Insertar datos a la tabla Inventor los que no estan con coma
insert Inventor(nombre,idpais)
select c1.inventor,p.idpais
from carga1 as c1
left join pais as p on p.nombre = c1.pais_del_invento
WHERE c1.inventor not LIKE '%,%' 
group by c1.inventor;
#Insertar los que tienen coma 1 Fila
insert Inventor(nombre,idpais)
select temp1.inventor1,temp1.id
from(
	select p.idpais as Id,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',1)),',',-1) AS Inventor1,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',2)),',',-1) AS Inventor2,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',3)),',',-1) AS Inventor3
	from carga1 as c1
	left join pais as p on p.nombre = c1.pais_del_invento
	WHERE c1.inventor LIKE '%,%' 
	group by c1.inventor
)temp1;
#Insertar los que tienen coma 2 Fila
insert Inventor(nombre,idpais)
select temp1.inventor2,temp1.id
from(
	select p.idpais as Id,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',1)),',',-1) AS Inventor1,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',2)),',',-1) AS Inventor2,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',3)),',',-1) AS Inventor3
	from carga1 as c1
	left join pais as p on p.nombre = c1.pais_del_invento
	WHERE c1.inventor LIKE '%,%' 
	group by c1.inventor
)temp1;
#Insertar los que tienen coma 3 Fila
insert Inventor(nombre,idpais)
select temp1.inventor3,temp1.id
from(
	select p.idpais as Id,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',1)),',',-1) AS Inventor1,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',2)),',',-1) AS Inventor2,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',3)),',',-1) AS Inventor3
	from carga1 as c1
	left join pais as p on p.nombre = c1.pais_del_invento
	WHERE c1.inventor LIKE '%,%' 
	group by c1.inventor
)temp1
where temp1.inventor2 <> temp1.inventor3;
#Tabla Invento
create table Invento(
	idInvento int not null primary key AUTO_INCREMENT,
    nombre varchar(100),
    anio int,
    idPais int,
    FOREIGN KEY (idPais) REFERENCES Pais(idPais)
);
#Inserts a la tabla Invento 
Insert Invento(nombre,anio,idpais)
select c.Invento,c.anio_del_invento,p.idpais
from carga1 as c
inner join pais as p on p.nombre = c.pais_del_invento
where c.invento <> ''
group by c.Invento,c.pais_del_invento;
#Tabla Inventado
create table Inventado(
	idInventado int not null primary key AUTO_INCREMENT,
    idInventor int,
    idInvento int,
    FOREIGN KEY (idInventor) REFERENCES Inventor(idInventor),
    FOREIGN KEY (idInvento) REFERENCES Invento(idInvento)
);
#Inserts a la tabla Inventado los que no tienen coma
Insert Inventado(idInventor,idInvento)
select i.idInventor,inv.idInvento
from carga1 as c
INNER JOIN Inventor as i on i.nombre = c.Inventor
INNER JOIN Invento as inv on inv.nombre = c.Invento
WHERE c.inventor not LIKE '%,%' 
group by c.Invento,c.Inventor;
#Insert de los que tiene coma Los de la Fila 1
Insert Inventado(idInventor,idInvento)
select i.idInventor,inv.idInvento
from(
	select c1.Invento as Invento,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',1)),',',-1) AS Inventor1,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',2)),',',-1) AS Inventor2,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',3)),',',-1) AS Inventor3
	from carga1 as c1
	WHERE c1.inventor LIKE '%,%' 
	group by c1.inventor,c1.Invento
)temp1
INNER JOIN Inventor as i on i.nombre = temp1.inventor1
INNER JOIN Invento as inv on inv.nombre = temp1.Invento;
#Insert de los que tiene coma Los de la Fila 2
Insert Inventado(idInventor,idInvento)
select i.idInventor,inv.idInvento
from(
	select c1.Invento as Invento,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',1)),',',-1) AS Inventor1,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',2)),',',-1) AS Inventor2,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',3)),',',-1) AS Inventor3
	from carga1 as c1
	WHERE c1.inventor LIKE '%,%' 
	group by c1.inventor,c1.Invento
)temp1
INNER JOIN Inventor as i on i.nombre = temp1.inventor2
INNER JOIN Invento as inv on inv.nombre = temp1.Invento;
#Insert de los que tiene coma Los de la Fila 3
Insert Inventado(idInventor,idInvento)
select i.idInventor,inv.idInvento
from(
	select c1.Invento as Invento,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',1)),',',-1) AS Inventor1,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',2)),',',-1) AS Inventor2,SUBSTRING_INDEX((SUBSTRING_INDEX(c1.inventor,',',3)),',',-1) AS Inventor3
	from carga1 as c1
	WHERE c1.inventor LIKE '%,%' 
	group by c1.inventor,c1.Invento
)temp1
INNER JOIN Inventor as i on i.nombre = temp1.inventor3
INNER JOIN Invento as inv on inv.nombre = temp1.Invento
where temp1.inventor2 <> temp1.inventor3;
#Tabla Prfesional
create table Profesional(
	idProfesional int not null primary key AUTO_INCREMENT,
    nombre varchar(100),
    salario int,
    comision int,
    fecha_contrato varchar(100) 
);
#Inserts a la tabla Profesional
insert Profesional(nombre,salario,comision,fecha_contrato)
select c.PROFESIONAL_ASIGANDO_AL_INVENTO,c.SALARIO,c.comision,c.FECHA_CONTRATO_PROFESIONAL
from carga1 as c
where c.PROFESIONAL_ASIGANDO_AL_INVENTO <> ''
group by c.PROFESIONAL_ASIGANDO_AL_INVENTO;
#Tabla Asigna_Invento
create table Asigna_Invento(
	Asigna_Invento int not null primary key AUTO_INCREMENT,
    idProfesional int,
    idInvento int,
    FOREIGN KEY (idProfesional) REFERENCES Profesional(idProfesional),
    FOREIGN KEY (idInvento) REFERENCES Invento(idInvento)
);
#Inserts a la tabla Asigna_Invento
insert Asigna_Invento(idProfesional,idInvento)
select pr.idProfesional,iv.idInvento
from carga1 as c
left join Invento as iv on iv.nombre = c.Invento
left join Profesional as pr on pr.nombre = c.PROFESIONAL_ASIGANDO_AL_INVENTO
group by  c.Invento, c.PROFESIONAL_ASIGANDO_AL_INVENTO;
#Tabla Area
create table Area(
	idArea int not null primary key AUTO_INCREMENT,
    nombre varchar(100),
    ranking int,
    Descripcion varchar(100),
    idJefe int,
    FOREIGN KEY (idJefe) REFERENCES Profesional(idProfesional)
);
#insert a la tabla Area
insert Area(nombre,ranking)
select c.area_invest_del_PROF,c.ranking
from carga1 as c
where c.area_invest_del_PROF <> ''
group by c.area_invest_del_PROF;
insert into Area(nombre,ranking) values ('TODAS',0);
#Insertando los Jefes SET SQL_SAFE_UPDATES = 0;
update Area as a
inner join(
	select p.idProfesional as id,c.PROFESIONAL_ASIGANDO_AL_INVENTO, c.EL_PROFESIONAL_ES_JEFE_DEL_AREA as Area
	from carga1 as c
	inner join Profesional as p on p.nombre = c.PROFESIONAL_ASIGANDO_AL_INVENTO
	where c.EL_PROFESIONAL_ES_JEFE_DEL_AREA <> ''
	group by c.PROFESIONAL_ASIGANDO_AL_INVENTO, c.EL_PROFESIONAL_ES_JEFE_DEL_AREA
)as temp on temp.area= a.nombre
set a.idJefe = ifnull(temp.id,0);
#Tabla Profesional_Area
create table Profesional_Area(
	Profesional_Area int not null primary key AUTO_INCREMENT,
    idProfesional int,
    idArea int,
    FOREIGN KEY (idProfesional) REFERENCES Profesional(idProfesional),
    FOREIGN KEY (idArea) REFERENCES Area(idArea)
);
#Inserts en la tabla Profesional_Area
insert Profesional_Area(idProfesional,idArea)
select p.idProfesional,a.idarea
from carga1 as c
inner join Profesional as p on p.nombre = c.PROFESIONAL_ASIGANDO_AL_INVENTO
inner join area as a on a.nombre = c.AREA_INVEST_DEL_PROF
where c.PROFESIONAL_ASIGANDO_AL_INVENTO <> ''
group by c.PROFESIONAL_ASIGANDO_AL_INVENTO , c.AREA_INVEST_DEL_PROF;
#Tabla Encuesta
create table Encuesta(
	idEncuesta int not null primary key AUTO_INCREMENT,
    nombre varchar(100)
);
#Inserts a la tabla Encuesta
insert Encuesta(nombre) 
select c.NOMBRE_ENCUESTA
from carga2 as c
group by  c.NOMBRE_ENCUESTA;
#Tabla Pregunta
create table Pregunta(
	idPregunta int not null primary key AUTO_INCREMENT,
    pregunta varchar(250),
    idEncuesta int,
    foreign key (idEncuesta) references Encuesta(idEncuesta)
);
#Inserts a la tabla Pregunta 
insert Pregunta(pregunta,idEncuesta)
select c.PREGUNTA,e.idEncuesta
from carga2 as c
inner join Encuesta as e on e.nombre = c.NOMBRE_ENCUESTA
group by c.PREGUNTA;
#Tabla Respuesta
create table Respuesta(
	idRespuesta int not null primary key AUTO_INCREMENT,
    respuesta varchar(250),
    letra char(1),    
    idPregunta int,
    foreign key (idPregunta) references Pregunta(idPregunta)
);
#inserts a la tabla Respuesta
#Respuestas Posibles 
Insert Respuesta(respuesta,letra,idPregunta)
select c.RESPUESTAS_POSIBLES, SUBSTRING_INDEX(c.RESPUESTAS_POSIBLES,'.',1) as Letra, p.idPregunta
from carga2 as c
inner join Pregunta as p on p.pregunta = c.pregunta
group by c.RESPUESTAS_POSIBLES,c.pregunta;
#Tabla Pais_Respuesta 
create table Pais_Respuesta(
	Pais_Respuesta int not null primary key AUTO_INCREMENT,
    idPais int,
    idRespuesta int,
    FOREIGN KEY (idPais) REFERENCES Pais(idPais),
    FOREIGN KEY (idRespuesta) REFERENCES Respuesta(idRespuesta)
);
#Inserts a la tabla Pais_Respuesta
Insert Pais_Respuesta(idpais,idRespuesta)
select p.idpais, temp3.idrespuesta
from(
	select trim(c2.pais) as pais,temp2.id as idRespuesta
	from carga2 as c2,(
	select r.idRespuesta as id, r.letra, p.pregunta
	from respuesta r
	inner join Pregunta as p on r.idPregunta = p.idpregunta
)temp2
where temp2.letra = c2.respuesta_pais and temp2.pregunta = c2.pregunta
)temp3
inner join Pais as p on p.nombre = temp3.pais
;
#Tabla Respuesta_Correcta
create table Respuesta_Correcta(
	Respuesta_Correcta int not null primary key AUTO_INCREMENT,
    idPregunta int,
    idRespuesta int,
    FOREIGN KEY (idPregunta) REFERENCES Pregunta(idPregunta),
    FOREIGN KEY (idRespuesta) REFERENCES Respuesta(idRespuesta)
);
#Inserts a la tabla Respuesta_Correcta
insert Respuesta_Correcta(idPregunta,idRespuesta)
select p.idpregunta,r.idrespuesta
from carga2 as c
left join respuesta as r on r.respuesta = c.respuesta_correcta
inner join pregunta as p on p.pregunta = c.pregunta
group by c.respuesta_correcta, c.pregunta;
