/*****************************************************************************
**
**    collect.c                       NQ                       Werner Nickel
**                                                    werner@pell.anu.edu.au
**
**    Copyright 1993                            Mathematics Research Section
**                                           School of Mathematical Sciences 
**                                            Australian National University
*/


#include "pc.h"
#include "pcarith.h"
#include "macro.h"

static	Error( str )
char	*str;

{	printf( "Error in Collect():\n        %s\n", str );
	exit( 7 );
}

/*
**    Collection from the left needs 4 stacks during the collection.
**
**    The word stack containes conjugates of generators, that were created
**        by moving a generator through the exponent vector to its correct
**        place or it containes powers of generators.
**    The word exponent stack containes the exponent of the corresponding
**        word in the word stack.
**    The generator stack containes the current position in the corresponding
**        word in the word stack.
**    The generator exponent stack containes the exponent of the generator
**        determined by the corrsponding entry in the generator stack.
**
**    The maximum number of elements on each stack is determined by the macro
**    STACKHEIGHT.
*/

#define STACKHEIGHT	(1 << 10)

static	word	WordStack[STACKHEIGHT];
static	exp	WordExpStack[STACKHEIGHT];
static	word   	GenStack[STACKHEIGHT];
static	exp	GenExpStack[STACKHEIGHT];

int	Collect( lhs, rhs, e )
expvec	lhs;
word	rhs;
exp	e;

{	word	*ws  = WordStack;
	exp	*wes = WordExpStack;
	word   	*gs  = GenStack;
	exp	*ges = GenExpStack;
	word	**C  = Conjugate;
	word	*P   = Power;
	gen	g, h;
	gen	ag;
	int	sp = 0;

	ws[ sp ] = rhs;
	gs[ sp ] = rhs;
	wes[ sp ] = e;
	ges[ sp ] = rhs->e;

	while( sp >= 0 )
	    if( (g = gs[ sp ]->g) != EOW ) {
		ag = abs( g );
		if( g < 0 && Exponent[-g] != 0 ) 
		    Error( "Inverse of a generator with power relation" );
		e = (ag == Commute[ag]) ? gs[ sp ]->e : 1;
		if( (ges[ sp ] -= e) == 0 ) {
		    /* The power of the generator g will have been moved
		       completely to its correct position after this
		       collection step. Therefore advance the generator
		       pointer. */
		    gs[ sp ]++; ges[ sp ] = gs[ sp ]->e;
		}
		/* Now move the generator g to its correct position
		   in the exponent vector lhs. */
		for( h = Commute[ag]; h > ag; h-- )
		    if( lhs[h] != 0 ) {
			if( ++sp == STACKHEIGHT )
			    Error( "Out of stack space" );
			if( lhs[ h ] > 0 ) {
			    gs[ sp ]  = ws[ sp ] = C[ h ][ g ];
			    wes[ sp ] = lhs[h]; lhs[ h ] = 0;
			    ges[ sp ] = gs[ sp ]->e;
			}
			else {
			    gs[ sp ]  = ws[ sp ] = C[ -h ][ g ];
			    wes[ sp ] = -lhs[h]; lhs[ h ] = 0;
			    ges[ sp ] = gs[ sp ]->e;
			}
		    }
		lhs[ ag ] += e * sgn(g);
	        if ( ((lhs[ag] << 1) >> 1) != lhs[ag] )
		    Error("Possible overflow" );
		if( Exponent[ag] != 0 )
		    while( lhs[ag] >= Exponent[ag] ) {
			if( (rhs = P[ ag ]) != (word)0 ) {
			    if( ++sp == STACKHEIGHT )
				Error( "Out of stack space" );
			    gs[ sp ] = ws[ sp ] = rhs;
			    wes[ sp ] = 1;
			    ges[ sp ] = gs[ sp ]->e;
			}
			lhs[ ag ] -= Exponent[ ag ];
			if ( ((lhs[ag] << 1) >> 1) != lhs[ag] )
			    return 1;;
		    }
	    }
	    else {
		/* the top word on the stack has been examined completely,
		   now check if its exponent is zero. */
		if( --wes[ sp ] == 0 ) {
		    /* All powers of this word have been treated, so
		       we have to move down in the stack. */
		       sp--;
		}
		else {
		    gs[ sp ] = ws[ sp ];
		    ges[ sp ] = gs[ sp ]->e;
		}
	    }

	return 0;
}

/*
**    Solve the equation   u x = v   for x.
*/
word	Solve( u, v )
word	u, v;

{	word	x;
	gpower  y[2];
	gen	g;
	long	lv, lx;
	exp	ev;
	expvec	uvec;
	
	y[1].g = EOW; y[1].e = 0;

	uvec = (expvec)calloc( (NrPcGens+NrCenGens+1), sizeof(exp) );
	if( uvec == NULL ) {
	    perror( "Solve(), uvec" );
	    exit( 2 );
	}

	x = (word)malloc( (NrPcGens+NrCenGens+1)*sizeof(gpower) );
	if( x == NULL ) {
	    perror( "Solve(), x" );
	    exit( 2 );
	}

	Collect( uvec, u, 1 );

	for( lv = lx = 0, g = 1; g <= NrPcGens+NrCenGens; g++ ) {
	    if( v[lv].g == g )       ev =  v[ lv++ ].e;
	    else if( v[lv].g == -g ) ev = -v[ lv++ ].e;
	    else                     ev = 0;

	    if( ev != uvec[g] ) {
		if( ev > uvec[g] ) {	        /* ev - uvec[g] > 0 */
		    y[0].g = x[lx].g  = g;
		    y[0].e = x[lx++].e = ev - uvec[g];
		}
		else if( Exponent[g] != 0 ) {  /* ev - uvec[g] < 0 */
		    y[0].g = x[lx].g  = g;
		    y[0].e = x[lx++].e = ev - uvec[g] + Exponent[g];
		}
		else {
		    y[0].g = x[lx].g   = -g;
		    y[0].e = x[lx++].e = uvec[g] - ev;
		}
		if( Collect( uvec, y, 1 ) ) {
		    Free( x );
		    Free( uvec );
		    return (word)0;
		}
	    }
	}

	Free( uvec );

	x[lx].g = EOW;
	x[lx++].e = 0;

	x = (word)realloc( x, lx*sizeof(gpower) );
	if( x == NULL ) {
	    perror( "Solve(), x (resize)" );
	    exit( 2 );
	}
	return x;
}

word	Invert( u )
word	u;

{	gpower	id;

	id.g = EOW;
	id.e = (exp)0;
	return Solve( u, &id );
}

word	Multiply( u, v )
word	u, v;

{	expvec	ev;
	word	w;

	ev = (expvec)Allocate( (NrPcGens+NrCenGens+1)*sizeof(exp) );

	if( Collect( ev, u, 1 ) || Collect( ev, v, 1 ) ) {
	    Free( ev );
	    return (word)0;
	}

	w = WordExpVec( ev );
	Free( ev );

	return w;
}

word	Exponentiate( u, n )
word	u;
int	n;

{	word	v;
	expvec	ev;
	int	copied_u = 0;

	if( n < 0 ) {
	    if( (u = Invert( u )) == (word)0 ) return (word)0;
		copied_u = 1;
		n = -n;
	}

	ev = (expvec)Allocate( (NrPcGens+NrCenGens+1)*sizeof(exp) );

	while( n > 0 ) {
	    if( n % 2 )
		if( Collect( ev, u, 1 ) ) {
		    if( copied_u ) Free( u );
		    Free( ev );
		    return (word)0;
		}
	    n /= 2;
	    if( n > 0 ) {
		if( (v = Multiply( u, u )) == (word)0 ) {
		    if( copied_u ) Free( u );
		    Free( ev );
		    return (word)0;
		}
		if( copied_u ) Free( u );
		u = v;
		copied_u = 1;
	    }
	}

	if( copied_u ) Free( u );
	u = WordExpVec( ev );
	Free( ev );
	return u;
}

word	Commutator( v, w )
word	v, w;

{	expvec	ev;
	word	vw, wv, vwvw;

	ev = ExpVecWord( v );
	if( Collect( ev, w, 1 ) ) {
	    Free( ev );
	    return (word)0;
	}
	vw = WordExpVec( ev );
	Free( ev );

	ev = ExpVecWord( w );
	if( Collect( ev, v, 1 ) ) {
	    Free( ev );
	    Free( vw );
	    return (word)0;
	}
	wv = WordExpVec( ev );
	Free( ev );

	vwvw = Solve( wv, vw );
	Free( vw );
	Free( wv );

	return vwvw;
}

