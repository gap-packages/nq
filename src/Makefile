##############################################################################
##
##    Makefile                      NQ                         Werner Nickel
##                                         Werner.Nickel@math.rwth-aachen.de
##

##    The follwoing two line define the name of the GNU multiple precision
##    library (GNULIB) and the directory that contains the corresponding
##    include files (GNUINC).
GNULIB = /usr/local/lib/libmp.a
GNUINC = /usr/local/include

CFLAGS = -g -O -I$(GNUINC) -DVERSION='"1.1d, 18 May 1994"'

OBJ = consistency.o pc.o relations.o word.o system.o \
      addgen.o tails.o eliminate.o engel.o glimt.o \
      presentation.o mem.o pcarith.o collect.o

nq : nq.o $(OBJ) $(GNULIB)
	$(CC) $(CFLAGS) nq.o $(OBJ) $(GNULIB) -o nq

clean :
	rm -f *.o nq *~
