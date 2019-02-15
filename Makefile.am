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

nq_LDFLAGS = $(GAP_LDFLAGS)
nq_LDADD = $(GAP_LIBS)
nq_CPPFLAGS = $(GAP_CPPFLAGS)

#CFLAGS += -O3 -Wuninitialized
#CFLAGS += $(ABI_CFLAGS) 

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


all-local: nq
	$(mkdir_p) $(top_srcdir)/$(BINARCHDIR)
	cp nq $(abs_top_srcdir)/$(BINARCHDIR)
	@echo "SUCCESS!"

clean-local:
	(cd examples; make clean)
	(cd doc && rm -f *.aux *.bbl *.blg *.brf *.idx *.ilg *.ind *.log *.out *.pnr *.tex *.toc)
	(cd doc && rm -f test/nqman.tst test/diffs)

distclean-local:
	(cd examples; make distclean)
	rm -rf bin/*

doc:
	(echo 'Read("makedoc.g");' | $(GAPROOT)/bin/gap.sh -A -q)

.PHONY: doc
