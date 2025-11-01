
/*Para la realización del ejercicio utilizaremos la base de datos sakila .
 Se utiliza para realizar consultas y análisis de datos en el contexto de una tienda de alquiler de películas.
 

OBSERVACIONES:
Se ha añadido en ocasiones, más información al SELECT en las consultas, para una mayor claridad y legibilidad del resultado.

En todos los casos se han ordenado las consultas según el criterio que pudiera resultar más lógico, se ha prescindido del ASC por entenderse por defecto.

Se han utilizado alias en todas las consultas. Se han utilizado comillas invertidas para evitar problemas con el uso de acentos.
Por consistencia en el uso de alias, se han utilizado comillas invertidas para todos los alias, aunque no tengan acentos.

No se aplica normalización de mayúsculas o minúsculas porque MySQL no es sensible a ello en las consultas.

Se han planteado algunas consultas de dos formas distintas para una mayor consolidación en el dominio de consultas.

Se ha utilizado en la primera consulta un LIMIT y un OFFSET para aclarar su funcionamiento y no estar repitiendo LIMIT de forma constante en cada consulta para ver sólo un número limitado de primeros registros.
 */



/* DESARROLLO DEL EJERCICIO 

Partimos de una base de datos ya creada, pero en el caso de que no hubiera estado creada, hubiésemos empezado con:

CREATE DATABASE sakila o con CREATE DATABASE IF NOT EXISTS sakila 

posteriormente hubiésemos procedido a crear las tablas o insertar los datos correspondientes. 
*/

USE sakila;  

/* CONSULTA 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados.
*/

-- 1ª FORMA. Utilizar DISTINCT como forma más sencilla
SELECT DISTINCT f.title AS `nombre_película`  -- títulos sin duplicados 
FROM film AS f
ORDER BY f.title;    -- ordenado alfabéticamente

-- Podríamos utilizar también LIMIT y OFFSET simplemente por manejar su uso:
SELECT DISTINCT f.title AS `nombre_película`  
FROM film AS f
ORDER BY f.title   
LIMIT 10 OFFSET 3;   -- aquí veríamos 10 registros, saltando los 3 primeros 




/* CONSULTA 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
 */

SELECT f.title AS `nombre_película`, f.rating AS `clasificación`  -- le añadimos también la clasificación 
FROM film f
WHERE rating = 'PG-13'
ORDER BY f.title;  -- ordenados alfabéticamente




/* CONSULTA 3. Encuentra el título y la descripción de todas las películas que contengan la cadena de caracteres "amazing" en su descripción.  */

-- 1ª FORMA. Utilizando LIKE y el operador %
SELECT f.title AS `nombre_película`, f.description AS `descripción`
FROM film f
WHERE f.description LIKE '%amazing%'               -- % % busca en cualquier posición
ORDER BY f.title;    -- ordenados alfabéticamente

-- 2ª FORMA. Utilizando REGEXP
SELECT f.title AS `nombre_película`, f.description AS `descripción`
FROM film f
WHERE f.description REGEXP 'amazing'
ORDER BY f.title;




/* CONSULTA 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. */
SELECT f.title AS `nombre_película` , f.length AS `duración`   -- Se añade duración, para mayor contexto a la visualización del resultado
FROM film f
WHERE f.length > 120
ORDER BY f.title;  -- orden alfabético




/*CONSULTA 5. Recupera los nombres y apellidos de todos los actores. */
-- Utilizamos concat para unificar nombre y apellidos en una sola columna
SELECT CONCAT(a.first_name, ' ', a.last_name) AS `nombre_completo`, a.actor_id   -- añadimos actor_id para una identificación más completa 
FROM actor a
ORDER BY a.last_name, a.first_name; -- Se ordena primero por apellido, y en caso de igualdad de apellido, se usa el nombre como criterio de ordenación.




/*CONSULTA 6. Encuentra el nombre y apellidos de los actores que tengan "Gibson" en su apellido. */
-- Esta consulta la planteamos de dos formas:

-- 1ª FORMA. Buscamos exactamente el apellido Gibson en la descripción
SELECT a.first_name AS `nombre`, a.last_name AS `apellidos`, a.actor_id  -- añadimos actor_id para identificación más completa
FROM actor a
WHERE a.last_name = 'Gibson'        
ORDER BY a.last_name, a.first_name; 

-- 2ª FORMA. Utilizamos CONCAT y además utilizamos LIKE y el operador % para que nos devuelva Gibson aunque sea un apellido compuesto
SELECT CONCAT(a.first_name, ' ', a.last_name) AS `nombre_completo`, a.actor_id
FROM actor a
WHERE a.last_name LIKE '%Gibson%'
ORDER BY a.last_name, a.first_name;




/* CONSULTA 7. Encuentra los nombres y apellidos de los actores que tengan un actor_id entre 10 y 20. */
SELECT CONCAT(a.first_name, ' ', a.last_name) AS `nombre_completo`, a.actor_id  -- ponemos en el select actor_id porque lo vemos interesante para su identificación completa
FROM actor a
WHERE a.actor_id BETWEEN 10 AND 20
ORDER BY a.actor_id;    -- en este caso ordenamos por id del actor




/* CONSULTA 8. Encuentra el título de las películas en la tabla `film` que no sean ni "R" ni "PG-13" en cuanto a su clasificación.*/
SELECT f.title AS `nombre_película`, f.film_id  -- ponemos en el select el id porque lo vemos interesante para una identificación de la película más completa
FROM film f
WHERE f.rating NOT IN ('R', 'PG-13')
ORDER BY f.title;       -- orden alfabético




/* CONSULTA 9. Encuentra la cantidad total de películas en cada clasificación de la tabla `film` y muestra la clasificación junto con el recuento.*/
SELECT f.rating AS `clasificación`, COUNT(*) AS `total_películas`  -- total_peliculas es columna resultado de aplicar una función de agregación a todas las filas
FROM film f
GROUP BY f.rating  -- agrupamos por categoría clasificación 
ORDER BY f.rating;  -- ordenamos alfabéticamente por rating 

-- NOTA: Podríamos utilizar COUNT(f.film_id) y nos devolvería lo mismo porque al ser una id ,es clave primaria y no tiene valores nulos. Igualmente cuenta todas las filas.




/* CONSULTA 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas. */
-- Primero visualizamos las tablas que se utilizarán 
-- Visualizamos las tablas que vamos a utilizar:
SELECT * FROM customer;    -- clientes 
SELECT * FROM rental;       -- alquileres
SELECT * FROM inventory;    -- inventario de películas de cada tienda
SELECT * FROM film;         -- películas

-- NOTAS:
-- customer no nexo de unión directo con film
-- rental no tiene nexión de unión directo con film
-- rental y customer se unen a través de customer_id   
-- rental e inventory se unen a través de inventory_id
-- inventory y film se unen a través de film_id 


SELECT c.customer_id, c.first_name AS `nombre`, c.last_name AS `apellido`, COUNT(r.rental_id) AS `total_películas_alquiladas` -- contamos por rental_id (uno por película)
FROM customer c
INNER JOIN rental r                -- queremos correspondencia entre ambas tablas (si no hay coincidencias, no se devuelve resultado)
ON c.customer_id = r.customer_id
GROUP BY c.customer_id            -- al agrupar por id, no es necesario incluir nombre o apellido en el group by
ORDER BY c.last_name, c.first_name;

-- NOTA: Si queremos incluir a los clientes que no han alquilado nada, usaríamos un LEFT JOIN.




/*CONSULTA 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres. */
-- Primero visualizamos las tablas necesarias:
SELECT * FROM rental;
SELECT * FROM category;
SELECT * FROM inventory;
SELECT * FROM film_category;

-- NOTAS:
-- Necesitamos conectar las tablas category y rental que no tienen nexo de unión directo entre ellas.
-- category se une con film_category a través de category_id.
-- film_category se une con inventory a través de film_id.
-- inventory se une con rental a través de inventory_id.

SELECT ca.name AS `categoría`, COUNT(r.rental_id) AS `total_películas_alquiladas`    -- utilizamos rental_id para el count
FROM category ca
INNER JOIN film_category fc 
ON ca.category_id = fc.category_id
INNER JOIN inventory i 
ON fc.film_id = i.film_id
INNER JOIN rental r 
ON i.inventory_id = r.inventory_id
GROUP BY ca.category_id   -- podríamos agrupar por ca.name puesto que el nombre de cada categoría también es único 
ORDER BY ca.name;  -- orden alfabético por nombe de categoría




/*CONSULTA 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla `film` y muestra la clasificación junto con el promedio de duración. */
SELECT f.rating AS `Clasificación`, ROUND(AVG(f.length), 2) AS `promedio_duración`    --  redondeamos el promedio a dos decimales
FROM film f
GROUP BY f.rating
ORDER BY f.rating ASC;  -- orden alfabético por clasificación




/* CONSULTA 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love". */
-- Visualizamos las tablas que vamos a utilizar:
SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM film;

-- NOTAS:
-- Tenemos que conectar las tablas actor y film que no tienen un nexo de conexión directo.
-- actor tiene nexo de unión con film_actor a través de actor_id.
-- film_actor tiene nexo de unión con film a través de film_id.

-- 1ª FORMA. Con INNER JOIN
SELECT CONCAT(a.first_name, ' ', a.last_name) AS `nombre_completo` , a.actor_id  -- concat y añadimos id para identificación más completa
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
INNER JOIN film f 
ON fa.film_id = f.film_id
WHERE f.title = 'Indian Love'
ORDER BY a.last_name, a.first_name;  -- orden alfabético por apellido y si coinciden, por nombre

-- 2ª FORMA. Utilizando SUBCONSULTA
SELECT CONCAT(a.first_name, ' ', a.last_name) AS `nombre_completo`, a.actor_id
FROM actor a
WHERE a.actor_id IN (
    SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film f 
    ON fa.film_id = f.film_id
    WHERE f.title = 'Indian Love'
)
ORDER BY a.last_name, a.first_name;

-- La subconsulta obtiene los actor_id de los actores que han participado en la película  "Indian Love".
-- La consulta principal usa esos actor_id obtenidos, para a su vez sacar los nombres completos y el id de los actores.




/*CONSULTA 14. Muestra el título de todas las películas que contengan la cadena de caracteres "dog" o "cat" en su descripción. */

-- 1ª FORMA. Utilizando LIKE y operador %
SELECT f.title AS `nombre_película`
FROM film f
WHERE f.description LIKE '%dog%'   -- operadores delante y detrás de la palabra para buscar en cualquier posición
   OR f.description LIKE '%cat%'
ORDER BY f.title;  -- orden alfabético 

-- 2ª FORMA. Utilizando REGEXP
SELECT f.title AS `nombre_película`
FROM film f
WHERE f.description REGEXP 'dog|cat'  -- "dog" o "cat" 
ORDER BY f.title;                  




/* CONSULTA 15. Hay algún actor o actriz que no aparezca en ninguna película en la tabla `film_actor`. */
SELECT * FROM actor;
SELECT * FROM film_actor;

-- NOTA: Las tablas actor y film_actor tiene como nexo de unión actor_id.

SELECT CONCAT(a.first_name, ' ', a.last_name) AS `nombre_completo`, a.actor_id   -- nombre y apellidos junto con id para identificación más completa
FROM actor a
LEFT JOIN film_actor fa              -- incluye todos los actores aunque no aparezcan en películas
ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL            -- filtramos para ver si hay nulos en la tabla de film_actor (actores que no aparecen en películas)
ORDER BY a.last_name, a.first_name;  -- orden alfabético por apellido y después por nombre





/* CONSULTA 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010. */

SELECT f.title AS `nombre_película`, f.release_year AS `año`
FROM film f
WHERE f.release_year BETWEEN 2005 AND 2010     -- se incluyen los dos extremos 
ORDER BY f.release_year ASC, f.title ASC;  --  estamos ordenando por año y donde coincide el año, se ordena alfabéticamente
LIMIT 15; -- ponemos un LIMIT para observar los primeros resultados




/* CONSULTA 17. Encuentra el título de todas las películas que son de la misma categoría que "Family". */
-- Visualizamos las tablas que vamos a utilizar:
SELECT * FROM film;
SELECT * FROM film_category;
SELECT * FROM category;

-- NOTAS:
-- film y category no tienen conexión directa.
-- film_category y film se unen a través de film_id.
-- category y film_category se unen a través de category_id.

-- 1ªFORMA. Utilizando INNER JOIN
SELECT f.title AS `título_película`
FROM film f
INNER JOIN film_category fc 
ON f.film_id = fc.film_id
INNER JOIN category c 
ON fc.category_id = c.category_id
WHERE c.name = 'Family'
ORDER BY f.title;  -- orden alfabético por título

-- 2ª FORMA. Utilizando una SUBCONSULTA
SELECT f.title AS `título_película`
FROM film f
WHERE f.film_id IN (
    SELECT fc.film_id
    FROM film_category fc
    INNER JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Family'
)
ORDER BY f.title;

-- La subconsulta genera una lista de film_id correspondientes a películas de la categoría Family.
-- La consulta principal utiliza esos film_id para devolver los títulos de las películas.




/* CONSULTA 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas. */
-- Visualizamos las tablas que vamos a utilizar:
SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM film;

-- NOTA:
-- Las tablas actor y film no tienen nexo de conexión directo.
-- actor se une con film_actor a través de  actor_id.
-- film_actor se une con film a través de film_id.

SELECT CONCAT(a.first_name, ' ', a.last_name) AS `nombre_completo`, a.actor_id  -- incluye id para una identificación más completa
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id               -- Agrupa por actor paracontar cuántas películas tiene cada uno
HAVING COUNT(fa.film_id) > 10     -- recuento de películas mayor que 10
ORDER BY a.last_name, a.first_name;  -- orden alfabético por apellido y después por nombre





/* CONSULTA 19. Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla `film`. */

SELECT f.title AS `nombre_película`, f.length AS `duración`   -- incluímos length en el select para una visualización más completa
FROM film f
WHERE f.rating = 'R' AND f.length > 120
ORDER BY f.title ASC;  -- orden alfabético por título



/* CONSULTA 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración. */
-- Visualizamos las tablas a utilizar:
SELECT * FROM category;
SELECT * FROM film_category;
SELECT * FROM film;

-- NOTAS:
-- category y film no tiene nexo directo de unión.
-- category y film_category se unen a través de category_id.
-- film_category y film se unen a través de film_id.

SELECT c.name AS `categoría`, ROUND(AVG(f.length), 2) AS `promedio_duración`  -- redondeamos a dos decimales
FROM category c
INNER JOIN film_category fc 
ON c.category_id = fc.category_id
INNER JOIN film f 
ON fc.film_id = f.film_id
GROUP BY c.category_id                    -- agrupamos por categoría_id que es única y buscamos las que sean mayor a 120 minutos
HAVING AVG(f.length) > 120                      
ORDER BY c.name;          -- orden alfabético por categoría





/* CONSULTA 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado. */
-- Visualizamos las tablas que vamos a utilizar:
SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM film;

-- actor y film no tiene conexión directa.
-- actor y film_actor se unen a través de actor_id.
-- film_actor y film se unen a través de film_id.

SELECT CONCAT(a.first_name, ' ', a.last_name) AS `nombre_completo`, a.actor_id, COUNT(fa.film_id) AS `total_peliculas`   -- añadimos actor_id para identificación más completa
FROM actor a
INNER JOIN film_actor fa 
ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
HAVING COUNT(fa.film_id) >= 5
ORDER BY a.last_name, a.first_name;  -- orden alfabético




/* CONSULTA 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días.
 Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. */
-- Visualizamos las tablas que vamos a utilizar:
SELECT * FROM film;
 SELECT * FROM inventory;
 SELECT * FROM rental;
 
 -- NOTAS:
 -- Tenemos que relacionar film con rental que no tienen conexión directa.
 -- film se une con inventory a través de film_id.
 -- inventory se une con rental a través de inventory_id.

-- 1ª FORMA. UTILIZANDO UNA SUBCONSULTA
SELECT f.title AS `nombre_película`, f.film_id
FROM film f
WHERE f.film_id IN (
    SELECT i.film_id
    FROM inventory i
    INNER JOIN rental r ON i.inventory_id = r.inventory_id
    WHERE DATEDIFF(r.return_date, r.rental_date) > 5  -- duración mayor a 5 días
)
ORDER BY f.title;  -- orden alfabético

-- DATEDIFF diferencia entre fecha en que el cliente devolvió y alquiló película. Se obtienen los días que estuvo alquilada. 
-- LA subconsulta identifica todas las películas alquiladas más de 5 días.
-- La consulta principal toma los film_id y muestra los títulos y film_id de las películas correspondientes, ordenadas alfabéticamente.



-- 2ª FORMA. UTILIZANDO JOIN SIN SUBCONSULTA
SELECT DISTINCT f.title AS `nombre_película`, f.film_id
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
INNER JOIN rental r 
ON i.inventory_id = r.inventory_id
WHERE DATEDIFF(r.return_date, r.rental_date) > 5
ORDER BY f.title;



/* CONSULTA 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/
-- Visualizamos las tablas que vamos a utilizar:
SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM film_category;
SELECT * FROM category;

-- NOTAS:
-- Queremos relacionar las tablas actor y category  que no tienen conexión directa.
-- actor y film_actor se unen a través de actor_id.
-- film_actor y film_category se unen a través de film_id.
-- film_category y category se unen a través de category_id.

-- 1ª FORMA.  CON NOT IN
SELECT CONCAT(a.first_name, ' ', a.last_name) AS `nombre_completo`, a.actor_id  -- incluímos actor_id para una identificación más completa
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    INNER JOIN film_category fc 
    ON fa.film_id = fc.film_id
    INNER JOIN category c 
    ON fc.category_id = c.category_id
    WHERE c.name = 'Horror'
)
ORDER BY a.last_name, a.first_name;  -- orden alfabético

-- Con la subconsulta buscamos todos los actor_id que si han actuado en películas de la categoría ¨"Horror"
-- Con la consulta principal seleccionamos los actores cuyo actor_id no está en esa lista y por tanto no han actuado en ninguna película de categoría "Horror".



-- 2ª FORMA. CON NOT EXISTS
SELECT CONCAT(a.first_name, ' ', a.last_name) AS `nombre_completo`, a.actor_id
FROM actor a
WHERE NOT EXISTS (
    SELECT 1          -- se puede poner otro valor
    FROM film_actor fa
    INNER JOIN film_category fc 
    ON fa.film_id = fc.film_id
    INNER JOIN category c 
    ON fc.category_id = c.category_id
    WHERE c.name = 'Horror' AND fa.actor_id = a.actor_id
)
ORDER BY a.last_name, a.first_name;  -- orden alfabético

-- La subconsulta busca películas de Horror en las que aparece el actor actual. 
-- En este caso, NOT EXISTS solo devuelve al actor si no existen coincidencias 




/* CONSULTA 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla `film`. */
-- Visualizamos las tablas que vamos a utilizar:
SELECT * FROM film;
SELECT * FROM film_category;
SELECT * FROM category;

-- Queremos relacionar las tablas film y category que no tienen una conexión directa.
-- film y film_category se unen a través de film_id.
-- film_category y category se unen a través de category_id.


-- 1ª FORMA. CON INNER JOIN ENTRE TABLAS
SELECT f.title AS `nombre_película`, f.length AS `duración`
FROM film f
INNER JOIN film_category fc
ON f.film_id = fc.film_id
INNER JOIN category c
ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180
ORDER BY f.title ASC;         -- orden alfabético por título


-- 2ª FORMA. UTILIZANDO UNA SUBCONSULTA
SELECT f.title AS `nombre_película`, f.length AS `duración`
FROM film f
WHERE f.film_id IN (
    SELECT fc.film_id
    FROM film_category fc
    INNER JOIN category c 
    ON fc.category_id = c.category_id
    WHERE c.name = 'Comedy'
)
AND f.length > 180
ORDER BY f.title ASC;  -- orden alfabético por título

-- La subconsulta identifica todas las películas de la categoría Comedy.
-- La consulta principal  filtra solo esas películas que además duren más de 180 minutos.



