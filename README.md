# PROBLEMA DEL VIAJERO FLOJO PERO AMBICIOSO

Autor:
- Jose Ignacio Palma (13-11044)

***********************************************************

Datos adicionales:
- Lenguajes de Programación
- Universidad Simon Bolivar
- Trimestre Enero - Marzo 2018

******************************************************************************************************

### Descripción:

Se trata de una pequeña variación del algoritmo Floyd Warshall en el que ahora no solo encontraremos
la ruta más corta para un camino determinado sino que además maximizaremos la obtención de algo en
particular

### Implementación:

Desarrollado en lenguaje FORTRAN 95, el cual nos proporciono un rápido y fácil manejo matricial. 
En esencia el algoritmo es el mismo, solo que ahora para reconstruir un camino y obtener vertices
intermedios entre rutas no basta con que el costo sea minimo sino que también se debe obtener el 
maximo beneficio en comparación con las otras rutas minimas.

### Entrada:

La estructura de los archivos de texto a usar para representar los grafos, es la siguiente:

	```
	6
	1
	5
	1 2 1 2
	1 4 1 1
	2 3 0 1
	2 5 0 1
	3 5 0 2
	3 6 0 0
	4 5 0 1
	4 3 0 0
	end
	```

La entrada se representa mediante un archivo de texto. La primera línea contiene el número de nodos del grafo, la segunda línea el nodo inicio del recorrido, y la tercera el nodo final del recorrido. El resto de líneas corresponden a la cantidad de arcos del grafo, con la siguiente estructura:

	```
	x y z w : 
						
	x y : Arco (x->y)					
	z   : Cantidad de anillos del arco					
	w   : Costo de ir del nodo x al nodo y
	```
