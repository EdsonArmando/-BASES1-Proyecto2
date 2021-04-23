use Proyecto2Bases;
/*
-------------Global------------
use Proyecto2Bases;
-------------Local------------
use Proyecto2BasesLocal;
*/
/*
Consulta 1
Desplegar cada profesional, y el número de inventos que tiene asignados
ordenados de mayor a menor.
*/
select p.nombre as Profesional, count(*) as Total
from profesional as p, asigna_invento as a
where a.idProfesional = p.idProfesional
group by a.idProfesional
order by total desc;
/*
Consulta 2
Desplegar los países de cada continente y el número de preguntas que han
contestado decualquier encuesta.Si hay países que no han contestado
ninguna encuesta, igual debe aparecer su nombre el la lista
*/
select p.nombre as Pais,r.nombre as Region ,count(rp.idpais) as Respuestas
from region as r
inner join Pais as p on p.id_region = r.id
left join pais_respuesta as rp on rp.idpais = p.idpais
group by p.nombre
order by pais
;
/*
Consulta 3
Desplegar todos los países que no tengan ningún inventor y que no tengan
ninguna frontera con otro país ordenados por su área.
*/
select p.nombre , p.area
from Pais as p
left join Inventor as iv on p.idpais = iv.idpais
inner join frontera as f on f.idpais1 = p.idpais
where iv.nombre is null and f.idpais2 is null
group by p.nombre , iv.nombre
order by p.area desc;
/*
Consulta 4
Desplegar el nombre de cada jefe seguido de todos sus subalternos, para
todos los profesionales ordenados por el jefe alfabéticamente.
*/
select temp.area, temp.Subalterno, p2.nombre as Jefe
from(
	select a.nombre as Area,p.nombre as Subalterno,a.idjefe as idJefe
	from area as a
	inner join profesional_area as pa on pa.idarea = a.idarea
	inner join Profesional as p on p.idprofesional = pa.idProfesional
)temp
inner join Profesional as p2 on temp.idjefe = p2.idProfesional
order by jefe asc;
/*Consulta 5
Desplegar todos los profesionales, y su salario cuyo salario es mayor al
promedio del salario de los profesionales en su misma área.
*/
select p.nombre,p.salario,temp1.area,temp1.promedio
from (
	select a.idarea as id, a.nombre as area, avg(p.salario) as Promedio
	from Profesional as p
	inner join profesional_area as pa on pa.idprofesional = p.idProfesional
	inner join area as a on a.idarea = pa.idarea
	group by a.nombre
)temp1,Profesional as p
inner join profesional_area as pr on pr.idProfesional = p.idProfesional
where  temp1.id = pr.idArea and p.salario > temp1.promedio
order by p.nombre asc;
/*
Consulta 6
Desplegar los nombres de los países que han contestado encuestas, ordenados
del país que más aciertos ha tenido hasta el que menos aciertos ha tenido
*/
select temp1.pais, count(temp1.pais) as Total
from (
	select p.nombre as pais,re.idRespuesta as respuesta,pre.idPregunta as pregunta
	from pais as p
	inner join pais_respuesta as pr on pr.idpais = p.idpais
	inner join respuesta as re on re.idrespuesta = pr.idrespuesta
	inner join Pregunta as pre on pre.idpregunta = re.idPregunta
	group by p.nombre,re.respuesta,pre.pregunta

)temp1,
respuesta_correcta as co
where co.idrespuesta = temp1.respuesta and co.idpregunta = temp1.pregunta
group by temp1.pais
order by total desc;
/*
Consulta 7
Desplegar los inventos documentados por todos los profesionales expertos en
Óptica.
*/
select inv.nombre,inv.anio,pro.nombre
from invento as inv
inner join asigna_invento as ai on ai.idInvento = inv.idInvento
join Profesional as pro on pro.idProfesional = ai.idProfesional
where ai.idProfesional in (
	select p.idProfesional
	from profesional as p
	inner join profesional_area as po on po.idProfesional = p.idProfesional
	inner join area as a on a.idarea = po.idArea
	where a.nombre = 'Óptica'
);
/*
Consulta 8
Desplegar la suma del área de todos los países agrupados por la inicial de su
nombre.
*/
select temp1.inicial,sum(temp1.area) as Total
from(
	select SUBSTRING(pais.nombre, 1, 1) as Inicial, pais.area as Area
	from pais
)temp1
group by temp1.inicial
order by temp1.inicial asc
;
/*
Consulta 9
	Desplegar todos los inventores y sus inventos cuyo nombre del inventor inicie
	con las letras BE.
*/
select iv.nombre as Invento,it.nombre as Inventor
from invento as iv
inner join inventado as inv on inv.idInvento = iv.idinvento
inner join Inventor as it on it.idInventor = inv.idInventor
WHERE SUBSTRING(it.nombre, 1, 2) = 'BE';
/*
Consulta 10
Desplegar el nombre de todos los inventores que Inicien con B y terminen con r o
con n que tengan inventos del siglo 19
*/
Select it.nombre, iv.nombre,iv.anio
from invento as iv
inner join inventado as inv on inv.idInvento = iv.idinvento
inner join inventor as it on it.idInventor = inv.idInventor
WHERE it.nombre LIKE 'B%' AND (it.nombre LIKE '%R' OR it.nombre LIKE '%N') AND iv.anio < 1901 AND iv.anio > 1800; 
;
/*
Consulta 11
Desplegar el nombre del país y el área de todos los países que tienen mas
de siete fronteras ordenarlos por el de mayor área,
*/
select temp1.Pais,temp1.Area,temp1.Total as Fronteras
from (
	select p.nombre as Pais,count(p.nombre) Total,p.area as Area
	from pais as p
	inner join Frontera as fr on fr.idPais2 = p.idpais
	group by p.nombre
)temp1
where temp1.Total > 7
order by temp1.Area desc
;
/* 
Consulta 12
Desplegar todos los inventos de cuatro letras que inicien con L
*/
select inv.nombre
from invento as inv
WHERE inv.nombre LIKE 'L___';select * from invento;
/*
Consulta 13
Desplegar el nombre del profesional, su salario, su comisión y el total de salario
(sueldo mas comisión) de todos los profesionales con comisión mayor que el 25%
de su salario.
*/
select p.nombre,p.salario,p.comision, (p.salario + p.comision) as TotalSalario
from profesional as p
where p.comision > (p.salario * .25);

/*
 Consulta 14
Desplegar cada encuesta y el número de países que las han contestado,
ordenadas de mayora menor
*/
select temp1.Encuesta,count(temp1.pais) as Total
from(
	select e.nombre as Encuesta, pi.nombre as Pais,count(pi.nombre) as Total
	from encuesta as e,Pregunta as p,Respuesta as r,pais_respuesta as pa,pais as pi
	where e.idEncuesta = p.idEncuesta and p.idPregunta = r.idPregunta and r.idRespuesta = pa.idRespuesta and pi.idpais = pa.idpais
	group by pi.nombre
	order by total desc
)temp1
group by temp1.encuesta
;
/*
Consulta 15
Desplegar los países cuya población sea mayor a la población de los
países centroamericanos juntos.   '24323000'
*/
select p.nombre,p.poblacion,temp1.total
from pais as p,(
	select sum(p.poblacion) as Total
	from pais as p
	inner join  region as r on r.id = p.id_region
	where r.nombre = 'Centro America'
	group by r.nombre
)temp1
where p.poblacion > temp1.total
order by p.poblacion desc;
/*
Consulta 16
Desplegar todos los Jefes de cada profesional que no este en el mismo
departamento que el del profesional que atiende al inventor Pasteur.
*/
select p.nombre as Profesional, a.nombre as Area, p2.nombre as Jefe
from (
	select iv.nombre as Inventor , p.Nombre as Porfesional, a.nombre as Area
	from asigna_invento as ai 
	inner join Profesional as p on ai.idProfesional = p.idProfesional
	inner join Invento as i on ai.idInvento = i.idInvento
	inner join Inventado as inv on inv.idInvento = i.idInvento
	inner join Inventor as iv on inv.idInventor = iv.idInventor
	inner join profesional_area as pro on pro.idProfesional = p.idProfesional
	inner join area as a on pro.idArea = a.idArea
	where iv.nombre = 'Pasteur'
)temp1,profesional as p
inner join profesional_area as po on p.idProfesional = po.idprofesional
inner join Area as a on a.idArea = po.idArea
inner join Profesional as p2 on p2.idProfesional = a.idjefe
where temp1.area <> a.nombre
order by a.nombre desc;
/*
Consulta 17
Desplegar el nombre de todos los inventos inventados el mismo año que BENZ
invento algún invento.
*/
select inve.nombre as Invento, inve.anio as Anio
from invento as inve
where inve.anio = (
	select it.anio as Anio
	from inventado as inv
	inner join inventor as i on i.idInventor = inv.idinventor
	inner join Invento as it on it.idInvento = inv.idInvento
	where i.nombre = 'BENZ'
);
/*
Consulta 18
Desplegar los nombres y el número de habitantes de todas las islas que
tiene un área mayor o igual al área de Japón
*/
select p.nombre,p.poblacion,p.area,temp1.area as AreaJapon
from (select p.area from pais as p where p.nombre = 'japon') as temp1,frontera as f
inner join pais as p on p.idpais = f.idPais1
where f.idpais2 is null and p.area >= (
	select p.area
	from pais as p
	where p.nombre = 'japon'
) and p.nombre <> 'japon';
/*
Consulta 19
Desplegar todos los países con el nombre de cada país con el cual tiene una
frontera.
*/
select p2.nombre as Pais, p.nombre as FronteraCon,count(p.nombre) as Cantidad
from pais as p
inner join frontera as f on f.idpais2 = p.idpais
inner join pais as p2 on f.idpais1 = p2.idPais
where f.idpais2 is not null
group by pais,FronteraCon;
/*
Consulta 20
Desplegar el nombre del profesional su salario y su comisión de los empleados
cuyo salario es mayor que el doble de su comisión.
*/
select p.nombre as Profesional , p.salario as Salario, p.comision as Comision
from profesional as p
WHERE P.salario > P.comision * 2;