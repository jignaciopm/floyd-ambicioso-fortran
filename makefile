COMPILADOR = gfortran
FLAGS = -o

all: floydWAmbicioso

# ************ Compilación de programas ************
floydWAmbicioso : floydWAmbicioso.f95
	$(COMPILADOR) $(FLAGS) floydWAmbicioso floydWAmbicioso.f95

# ************ Limpieza ************
clean :
	-rm ./*~
	-rm floydWAmbicioso