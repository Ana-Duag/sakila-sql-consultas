
ANÁLISIS DE LA BASE DE DATOS SAKILA

Descripción

Realizado por Ana Pilar Dueñas Agudo, este README contiene la información general de un conjunto de consultas SQL aplicadas a la base de datos Sakila, que simula una tienda de alquiler de películas.

El objetivo es realizar análisis de datos sobre películas, actores, clientes, categorías y alquileres.

Todas las consultas están documentadas y organizadas en el archivo: consultas_sakila_ana.sql.

Antes de comenzar a desarrollar las consultas en SQL, se ha clonado el repositorio, usando los comandos básicos de git: git clone + URL, git status, git add -A, git commit - m, git push.


Base de Datos

La base de datos Sakila incluye las siguientes tablas principales con las que se ha trabajado:


film	         Información sobre películas

actor	         Datos de actores

film_actor	     Relación entre películas y actores

category	     Categorías de películas

film_category	 Relación entre películas y categorías

customer	     Información de clientes

rental	         Registro de alquileres

inventory	     Inventario de películas disponibles por tienda



Instalación y Ejecución

La base de datos ya está creada, por lo que solo es necesario seleccionarla:

USE sakila;


Después se ejecuta el archivo SQL con todas las consultas.



Observaciones

Se trabaja con queries básicas y avanzadas.

Uso de funciones y cláusulas GROUP BY, WHERE, HAVING.

Dominio de joins y combinaciones (INNER JOIN, LEFT JOIN).

Uso de subconsultas y subconsultas correlacionadas.

Manejo de UNION y UNION ALL.


Algunas consultas se han planteado de más de una forma, con el objetivo de trabajar con diferentes métodos de resolución.

Todas las consultas están documentadas y ordenadas para mejor legibilidad.

Este proyecto no modifica la base de datos Sakila, ya que únicamente se realizan consultas, no se crean tablas ni se insertan datos.
