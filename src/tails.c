/*****************************************************************************
**
**    tails.c                         NQ                       Werner Nickel
**                                         Werner.Nickel@math.rwth-aachen.de
*/


#include "nq.h"

int	tail_cba( c, b, a, ev )
gen	c, b, a;
expvec	*ev;

{	int	i, l = 0;
	expvec	ev1, ev2;

	/* (c b) a */
	ev1 = ExpVecWord( Generators[c] );
	Collect( ev1, Generators[b], (exp)1 );
	Collect( ev1, Generators[a], (exp)1 );

	/* c (b a) = c a b^a */
	ev2 = ExpVecWord( Generators[c] );
	Collect( ev2, Generators[a], (exp)1 );
	Collect( ev2, Conjugate[b][a], (exp)1 );

	for( i = 1; i <= NrPcGens+NrCenGens; i++ ) 
	    if( (ev1[i] -= ev2[i]) != 0 ) {
		if( i <= NrPcGens )
printf( "Warning : This is not a tail in tail_cba( %d, %d, %d )\n", c, b, a );
		l++;
	    }

	free( ev2 );
	*ev = ev1;
	return l;
}

int	tail_cbb( c, b, ev )
gen	c, b;
expvec	*ev;

{	int	i, l = 0;
	expvec	ev1;

	/* (c b^-1) b */
	ev1 = ExpVecWord( Generators[c] );
	Collect( ev1, Generators[ b], (exp)1 );
	Collect( ev1, Generators[-b], (exp)1 );
	ev1[ c ] -= 1;

	for( i = 1; i <= NrPcGens+NrCenGens; i++ )
	    if( (ev1[i] = -ev1[i]) != 0 ) {
		if( i <= NrPcGens )
printf( "Warning : This is not a tail in tail_cbb( %d, %d )\n", c, b );
		l++;
	    }

	*ev = ev1;
	return l;
}

int	tail_ccb( c, b, ev )
gen	c, b;
expvec	*ev;

{	int	i, l = 0;
	expvec	ev1;

	/* c^-1 (c b) = c^-1 b c^b */
	ev1 = ExpVecWord( Generators[c] );
	Collect( ev1, Generators[b], (exp)1 );
	Collect( ev1, Conjugate[-c][b], (exp)1 );
	ev1[abs(b)] -= sgn(b);

	for( i = 1; i <= NrPcGens+NrCenGens; i++ )
	    if( (ev1[i] = -ev1[i]) != 0 ) {
		if( i <= NrPcGens )
printf( "Warning : This is not a tail in tail_cca( %d, %d )\n", c, b );
		l++;
	    }

	*ev = ev1;
	return l;
}

Tail( n, m )
gen	n, m;

{	long	lw, lt;
	expvec	t;
	word	w;

        if( n == 4 && m == 3 )
          1;

	if( n > 0 )
	     if( m > 0 ) lt = tail_cba( n,Definition[m].h,Definition[m].g,&t);
	     else	 lt = tail_cbb( n, m, &t );
	else lt = tail_ccb(  n,  m, &t );

	lw = WordLength( Conjugate[n][m] );
	w  = (word)Allocate( (lt+lw+1)*sizeof(gpower) );

	WordCopy( Conjugate[n][m], w );
	WordCopyExpVec( t, w+lw );
	free( t );
	if( Conjugate[n][m] != Generators[n] ) free( Conjugate[n][m] );
	Conjugate[n][m] = w;
}

/*
**    The next nilpotency class to be calculated is Class+1. Therefore
**    commutators of weight Class+1, which are currently trivial, will
**    get tails.
*/
Tails() {

        int	*Dim = Dimension;
	long	b, c, i, j, time;
	long	m, M, n, N;

	if( Verbose ) time = RunTime();

	N  = NrPcGens;
	for( c = Class; c >= 1; c-- ) {
	    n  = N;
	    M  = 1;
	    for( b = 1; b <= c-b+1; b++ ) {
		/* tails for comutators [ <c-b+1>, <b> ] */
		for( j = Dim[c-b+1]; j >= 1; j-- ) {
		    m = M;
		    for( i = 1; n > m && i <= Dim[b]; i++ ) {
			if( b != 1 )
			    Tail(  n,  m );    
			if( Exponent[m] == (exp)0 )
			    Tail(  n, -m );
			if( Exponent[n] == (exp)0 )
			    Tail( -n,  m );
			if( Exponent[m]+Exponent[n] == (exp)0 )
			    Tail( -n, -m );
			m++;
		    }
		    n--;
		}
		M += Dim[b];
	    }
	    N  -= Dim[c];
	}

	if( Verbose )
	    printf("#    Computed tails (%d msec).\n",RunTime()-time);
}
