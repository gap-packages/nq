/****************************************************************************
**
**    genexp.h                        PC                       Werner Nickel
**                                         Werner.Nickel@math.rwth-aachen.de
**
**
**    A generator is a positive integer. The inverse of a generator is
**    denoted by its negative.
**
**    The exponent of a generator is a short integer. The exponent of
**    a generator or its inverses is always positive. The exponent
**    vector is the sequence of exponents corresponding to a normed
**    word. The entries in an exponent vector can be negative.
**
**    A word is a generator exponent string terminated by 0.
*/
#ifndef GENEXP_INCLUDED
#define GENEXP_INCLUDED

typedef	short	gen;

typedef	long	exp;
typedef exp	*expvec;

#define EOW	((gen)0)

struct  gpower {
	gen	g;	/* the generator */
	exp	e;	/* its exponent  */
};
typedef struct gpower	gpower;

typedef	gpower	*word;
#endif
