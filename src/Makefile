##############################################################################
##
##    Makefile                      NQ                         Werner Nickel
##                                         Werner.Nickel@math.rwth-aachen.de
##

##    The follwoing two line define the name of the GNU multiple precision
##    library (GNULIB) and the directory that contains the corresponding
##    include files (GNUINC).
GNULIB =  /home/werner/Source/gmp-2.0.2/libmp.a \
	  /home/werner/Source/gmp-2.0.2/libgmp.a 
GNUINC = /home/werner/Source/gmp-2.0.2/

CC=gcc
OPTS = -g -O3 
CFLAGS = $(OPTS) -I$(GNUINC) -DVERSION='"1.1e, 04 Aug 1994"'

OBJ = consistency.o pc.o relations.o word.o system.o \
      addgen.o tails.o eliminate.o engel.o glimt.o \
      presentation.o mem.o pcarith.o collect.o trmetab.o

nq : nq.o $(OBJ) $(GNULIB)
	$(CC) $(CFLAGS) nq.o $(OBJ) $(GNULIB) -o nq

clean :
	rm -f *.o nq *~
