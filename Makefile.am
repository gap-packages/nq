ACLOCAL_AMFLAGS = -I m4

BINARCHDIR = bin/$(GAPARCH)

bin_PROGRAMS = nq

nq_SOURCES = \
    src/addgen.c \
    src/collect.c \
    src/combicol.c \
    src/consistency.c \
    src/eliminate.c \
    src/engel.c \
    src/gap.c \
    src/glimt.c \
    src/instances.c \
    src/mem.c \
    src/nq.c \
    src/pc.c \
    src/pcarith.c \
    src/presentation.c \
    src/relations.c \
    src/system.c \
    src/tails.c \
    src/time.c \
    src/trmetab.c \
    src/word.c

nq_LDFLAGS = $(GMP_LDFLAGS)
nq_LDADD = $(GMP_LIBS)
nq_CPPFLAGS = $(GMP_CPPFLAGS)

#CFLAGS += -O3 -Wuninitialized

nq_CFLAGS = \
 -Wall \
 -Wpointer-arith\
 -Wcast-qual\
 -Wshadow\
 -Wwrite-strings\
 -W\
 -Wc++-compat\
 -Wold-style-definition\
 -Wmissing-prototypes\
 -Wstrict-prototypes\
 -pedantic\
 -Wno-unused-parameter\
 -Wno-long-long
#  -Wno-conversion\
#  -Wno-missing-field-initializers\
#  -Wno-sign-compare \
# -Werror


all-local: nq$(EXEEXT)
	$(mkdir_p) $(top_srcdir)/$(BINARCHDIR)
	rm -f $(abs_top_srcdir)/$(BINARCHDIR)/nq$(EXEEXT)
	cp nq$(EXEEXT) $(abs_top_srcdir)/$(BINARCHDIR)
	@echo "SUCCESS!"

clean-local:
	rm -f examples/G?.tst examples/G?.old *~
	(cd doc && rm -f *.aux *.bbl *.blg *.brf *.idx *.ilg *.ind *.log *.out *.pnr *.tex *.toc)
	(cd doc && rm -f test/nqman.tst test/diffs)
	rm -rf $(top_srcdir)/$(BINARCHDIR)

doc:
	$(GAP) -A --quitonbreak -b -q < makedoc.g

check:
	(cd examples; make)

test:
	(cd examples; make)

.PHONY: check doc test
