##############################################################################
##
##    Makefile                      NQ                         Werner Nickel
##                                                   werner@dcs.st-and.ac.uk
##

##    The  following two  lines define   the directory  with the GNU  multiple
##    precision library  (GNULIB)     and the directory     that  contains the
##    corresponding include files (GNUINC).
GNULIB = /home/nickel/gmp-2.0.2
GNUINC = $(GNULIB)

##    GNU cc has the integer data type long long.  It can be used for
##    exponents of words by setting the variable LONGLONG to -DLONGLONG.
LONGLONG = -DLONGLONG


GNULIBS = $(GNULIB)/libmp.a $(GNULIB)/libgmp.a 

CC=gcc
OPTS = -g -O3 $(LONGLONG) $(COPTS)
CFLAGS = $(OPTS) -I$(GNUINC) -DVERSION='"1.2, 11 March 1998"'

OBJ = consistency.o pc.o relations.o word.o system.o \
      addgen.o tails.o eliminate.o engel.o glimt.o \
      presentation.o mem.o pcarith.o collect.o trmetab.o gap.o

nq : nq.o $(OBJ) $(GNULIBS)
	$(CC) $(CFLAGS) nq.o $(OBJ) $(GNULIBS) -o nq

clean :
	rm -f *.o nq *~
