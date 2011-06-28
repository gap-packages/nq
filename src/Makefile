##############################################################################
##
##    Makefile                      NQ                         Werner Nickel
##
##    $Id$
##

CC=gcc
#OPTS = -g -pg $(COPTS)
OPTS = -O3 $(COPTS)
CFLAGS = $(OPTS) -DVERSION='"2.0 January 2003"'

OBJ = consistency.o pc.o relations.o word.o system.o time.o \
      addgen.o tails.o eliminate.o engel.o glimt.o instances.o \
      presentation.o mem.o pcarith.o collect.o combicol.o trmetab.o gap.o

nq : nq.o $(OBJ)
	$(CC) $(CFLAGS) nq.o $(OBJ) -L$(GNU_MP_LIB) -o nq -lgmp

glimt.o: glimt.c
	$(CC) $(CFLAGS) -I$(GNU_MP_INC) -c glimt.c
clean :
	rm -f *.o nq *~

spotless : clean
	rm -f config.h
