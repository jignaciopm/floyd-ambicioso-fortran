! EL PROBLEMA DEL HOMBRE FLOJO PERO AMBICIOSO
!
! Descripcion: Se representa el problema mediante un grafo (archivo.txt)
! 			   en donde la primera linea contiene el numero de nodos del 
!              grafo, la segunda linea el nodo inicio del recorrido, y la 
!              tercer el nodo final del recorrido. El resto de lineas 
!              corresponden a la cantidad de arcos del grafo, con la
!              siguiente estructura:
!
!			   x y z w : 
!						x y : Arco (x->y)
!						z   : Cantidad de anillos del arco
!						w   : Costo de ir del nodo x al nodo y 
!
! 			   Ejemplo: grafo.txt 
!			   
!			   El archivo debe terminar con un 'end'.
!			   ********* EL GRAFO ES DIRIGIDO *********
!
! Universidad Simon Bolivar, Lenguajes de Programacion
! Autor: Jose Ignacio Palma (13-11044)

program floydWAmbicioso
	! DECLARACIONES:
	! Un arreglo o matriz puede ser asignable (ALLOCATABLE), es decir, se le puede asignar 
	! almacenamiento de memoria durante la ejecucion.
	integer, ALLOCATABLE :: adyacencia(:,:), pesoF(:,:), verticeIntermedio(:,:), maxAnillos(:,:), ruta(:)
	integer :: x, y, w, z, n
	integer :: inicio, fin, pos = 1, ierror, minCos, maxAni, totalAnillos = 0
	character (len=80) :: str, path

	WRITE(*,*) "Introduzca el nombre/ruta del fichero (.txt): "
	READ(*,*) path

	! Abrimos el archio que contiene la estructura del problema
	OPEN(unit=10,file=path)

	! Leemos del archivo abierto y verificamos si hay algun error:
	! De haber algun error, reportamos y detenemos la ejecucion
	READ (unit=10, fmt="(a)", IOSTAT=ierror), str
	if (ierror /= 0) THEN
		WRITE(*,*) "*********************************************************************" 
		WRITE(*,*) "ARCHIVO NO ENCONTRADO: Error al abrir el fichero. Intente de nuevo..."
		WRITE(*,*) "*********************************************************************"
		stop
	endif

	! Escribimos el string de la linea leida en un integer
	READ (unit=str, fmt=*), n

	! Una vez conocido el numero de nodos del grafo (n),
	! asignamos las dimensiones de nuestras matrices
	allocate(adyacencia(n,n))
	allocate(verticeIntermedio(n,n))
	allocate(pesoF(n,n))
	allocate(maxAnillos(n,n))
	! Como maximo se podra tener una ruta de tamano
	! n(n-1) pues se trata de un grafo dirigido
	allocate(ruta(n*(n-1)))

	! Inicializamos todas nuestras matrices como corresponda
    do i=1,n
        do j = 1,n
            adyacencia(i, j) = 0
            verticeIntermedio(i, j) = 0
            if (i == j) THEN
            	pesoF(i, j) = 0
            	maxAnillos(i,j) = 0
            else
            	! huge proporciona la maxima
            	! representancion de un tipo dado
            	pesoF(i, j) = huge(integer)
            	maxAnillos(i,j) = -1
            endif
        end do
    end do

    ! Leemos la siguiente linea del fichero
    ! y lo guardamos el un entero
    READ (unit=10, fmt="(a)"), str
	READ (unit=str, fmt=*), inicio

	! Leemos la siguiente linea del fichero
    ! y lo guardamos el un entero
	READ (unit=10, fmt="(a)"), str
	READ (unit=str, fmt=*), fin

	! **********************************
	! Ciclo infinito para leer el resto
	! del archivo.
	! 
	! Como todo archivo debe terminar con
	! un 'end', al leerlo salimos del
	! ciclo con un 'exit'
	! **********************************
	do
    	READ (unit=10, fmt="(a)"), str
    	if (str == "end" .or. str == "END") exit
    	READ (unit=str, fmt=*), x, y, z, w

    	! Verificamos que en cada arco,
    	! los nodos no superen el numero de nodos
    	! del grafo, si sucede, abortamos.
    	if (x <= n .and. y <= n) THEN

    		if (x /= y) THEN
    			adyacencia(x, y) = 1
    			maxAnillos(x,y) = z

    			! El costo de cada arco,
    			! no puede ser superior al 'inf'
    			! representado mediante 'huge',
    			! si sucede, abortamos.
    			if (w < huge(integer)) THEN
    				pesoF(x,y) = w
    			else
    				WRITE(*,*) "******************************************************************************" 
		    		WRITE(*,*) "COSTO NO PERMITIDO: El costo del arco no puede ser 'inf'. Intente de nuevo..."
		    		WRITE(*,*) "******************************************************************************"
		    		stop 
    			endif 

    		else
    			WRITE(*,*) "***********************************************************************" 
	    		WRITE(*,*) "CAMINO NO PERMITIDO: Arco x -> x no esta permitido. Intente de nuevo..."
	    		WRITE(*,*) "***********************************************************************"
	    		stop 
    		endif

    	else
    		WRITE(*,*) "***********************************************************************" 
    		WRITE(*,*) "NODO EXCEDIDO: No puede exceder el numero de nodos. Intente de nuevo..."
    		WRITE(*,*) "***********************************************************************" 
    		stop
    	endif

	enddo
	
	! *************************************
	! ALGORITMO FLOYD-WARSHALL-AMBICIOSO
	! *************************************
	!
	! Se busca el camino mas corto pero
	! si existen varios se escoge el que
	! contenga la mayor cantidad de anillos
	! *************************************	
	do k=1,n
		do i=1,n
			if (i /= k .and. pesoF(i,k) < huge(integer) .and. maxAnillos(i,k) > -1) THEN
				do j=1,n
		            if (i /= k .and. j /= k .and. pesoF(k,j) < huge(integer) .and. maxAnillos(k,j) > -1) THEN
		            	minCos = min(pesoF(i,j),pesoF(i,k)+pesoF(k,j))
		            	maxAni = max(maxAnillos(i,j),maxAnillos(i,k)+maxAnillos(k,j))
						if ( (pesoF(i,k)+pesoF(k,j) == minCos) .and. (maxAnillos(i,k)+maxAnillos(k,j) == maxAni) ) THEN
							verticeIntermedio(i,j) = k
			            endif
			            pesoF(i,j) = minCos
			            maxAnillos(i,j) = maxAni
				    endif
		        enddo
		    endif
	    enddo
	enddo

	! *************************************
	! RECCONSTRUCCION DE LA RUTA OPTIMA
	! *************************************
	!
	! Se van opteniendo los nodos hasta
	! encontrar en verticeIntermedio que la
	! posicion vale 0. La reconstruccion es
	! a la inversa.
	! *************************************
	ruta(pos) = fin
	pos = pos + 1
	do 
		fin = verticeIntermedio(inicio,fin)
		if (fin == 0) THEN
			ruta(pos) = inicio
		else
			ruta(pos) = fin
			pos = pos + 1
			if (verticeIntermedio(inicio,fin) == 0) THEN
				ruta(pos) = inicio
				pos = pos + 1
				exit
			endif
		endif
		
	enddo

	! ***********************************************
	! OPTENCION DE LA POSICION FINAL DONDE HAYA NODOS
	! ***********************************************
	!
	! Se van opteniendo los nodos hasta
	! encontrar que la ruta ha llegado al nodo inicio
	! ***********************************************
	do i=1,size(ruta)
		if (ruta(i) == inicio) THEN
			pos = i
			exit
		endif
	enddo

	! ******************************
	! TOTAL DE ANILLOS RECOLECTADOS
	! ******************************
	!
	! Mediante la ruta optima se
	! calcula el total de anillos
	! RECOLECTADOS
	! ******************************
	do i = pos, 1, -1
		if (i /= 1) THEN
			totalAnillos = totalAnillos + maxAnillos(ruta(i),ruta(i-1))
		else
			exit
		endif
	enddo

	WRITE(*,*) "Ruta mas corta con mas anillos: ",(ruta(i), i = pos, 1, -1)
	WRITE(*,*) "Anillos recuperados: ",totalAnillos

end program floydWAmbicioso