/*****************************************************************************
**
**    addgen.c                        NQ                       Werner Nickel
**                                         Werner.Nickel@math.rwth-aachen.de
*/

#include "nq.h"

/*
**    Add new/pseudo generators to the power conjugate presentation.
*/
void	AddGenerators() {

	long	t;
	int	c, i, j, l, G;
	word	w;
	
	if( Verbose ) t = RunTime();

	G = NrPcGens;

	G += ExtendEpim();

	/* Firstly mark all definitions in the pc-presentation. */
	for( j = Dimension[1]+1; j <= NrPcGens; j++ )
	    Conjugate[ Definition[j].h ][ Definition[j].g ] =
	        (word)((unsigned long)
		    (Conjugate[Definition[j].h][Definition[j].g]) | 0x1);

	/* Secondly new generators are defined. */
	/* Powers */
	for( j = 1; j <= NrPcGens; j++ )
	    if( Exponent[j] != 0 ) {
		G++;
		l = 0;
		if( Power[j] != (word)0 ) l = WordLength( Power[ j ] );
		w = (word)malloc( (l+2)*sizeof(gpower) );
		if( Power[j] != (word)0 ) WordCopy( Power[ j ], w );
		w[l].g   = G;   w[l].e   = 1;
		w[l+1].g = EOW; w[l+1].e = 0;
		if( Power[ j ] != (word)0 ) free( Power[ j ] );
		Power[ j ] = w;
                if( Verbose ) {
                  printf( "#    generator %d = ", G );
                      printGen( j, 'A' );
                      printf( "^%d\n", Exponent[j] );
                }
	    }

	/* Conjugates */
	/* New/pseudo generators are only defined for commutators of the
	** form [x,1], the rest is computed in Tails(). */
	for( j = 1; j <= NrPcGens; j++ )
	    for( i = 1; i <= min(j-1,Dimension[1]); i++ )
		if( !((unsigned long)(Conjugate[j][i]) & 0x1) ) {
		    G++;
		    l = WordLength( Conjugate[ j ][ i ] );
		    w = (word)malloc( (l+2)*sizeof(gpower) );
		    WordCopy( Conjugate[j][i], w );
		    w[l].g   = G;   w[l].e   = 1;
		    w[l+1].g = EOW; w[l+1].e = 0;
		    if( Conjugate[j][i] != Generators[j] )
			free( Conjugate[j][i] );
		    Conjugate[j][i] = w;
                    if( Verbose ) {
                      printf( "#    generator %d = [", G );
                      printGen( j, 'A' );
                      printf( ", " );
                      printGen( i, 'A' );
                      printf( "]\n" );
                    }
		}

	if( G == NrPcGens ) {
	    printf( "Warning : no new generators in addGenerators()\n" );
	    return;
	}

	/* Thirdly remove the marks from the definitions.*/
	for( j = Dimension[1]+1; j <= NrPcGens; j++ )
	    Conjugate[Definition[j].h][Definition[j].g] =
	        (word)((unsigned long)
		    (Conjugate[Definition[j].h][Definition[j].g]) & ~0x1);

	/* Fourthly enlarge the necessary arrays, so that the collector
	   works. */
	Weight = (int *)realloc( Weight, (G+1)*sizeof(long) );
	if( Weight == (int *)0 ) {
	    perror( "addGenerators(), Weight" );
	    exit( 2 );
	}
	for( i = NrPcGens+1; i <= G; i++ ) Weight[i] = Class+1;

	Exponent = (exp*)realloc( Exponent, (G+1)*sizeof(exp) );
	if( Exponent == (exp*)0 ) {
	    perror( "addGenerators(), Exponent" );
	    exit( 2 );
	}
	for( i = NrPcGens+1; i <= G; i++ ) Exponent[i] = 0;

	NrCenGens = G - NrPcGens;

	/* We change the entries in Commute[]. A generator of weight c
	** did commute with all generators of weight Class-c. From here
	** on it will only commute with generators of weight Class-c+1
	** since new generators of weight Class+1 have been introduced.
	*/
	Commute = (gen*)realloc( Commute, (G+1)*sizeof(gen) );
	if( Commute == (gen*)0 ) {
	    perror( "addGenerators(), Commute" );
	    exit( 2 );
	}
	l = 1;
	G = NrPcGens;
	for( c = 1; 2*c <= Class+1; c++ ) {
	    for( i = 1; i <= Dimension[c]; i++, l++ )
		Commute[l] = G;
	    G -= Dimension[ Class-c+1 ];
	}
	for( ; l <= NrPcGens+NrCenGens; l++ ) Commute[l] = l;

	if( Verbose )
	    printf("#    Added new/pseudo generators (%d msec).\n",RunTime()-t);
}
