/*****************************************************************************
**
**    gap.c                           NQ                       Werner Nickel
**                                         Werner.Nickel@math.rwth-aachen.de
*/

#include "nq.h"

void	printGapWord( w )
word	w;

{	if( w == (word)0 || w->g == EOW ) {
	    printf( "One(F)" );
	    return;
	}
	
	while( w->g != EOW ) {
	    if( w->g > 0 ) {
                printf( "F.%d", w->g );
		if( w->e != 1 )
		    printf( "^%d", w->e );
	    }
	    else {
                printf( "F.%d", -w->g );
		printf( "^%d",  -w->e );
	    }
	    w++;
	    if( w->g != EOW ) putchar( '*' );
	}
}


void	PrintGapPcPres() {

	gen	g;
	long	i, j;

        /*
        **  Commands that create the appropriate free group and the
        **  collector. 
        */
	printf( "F := FreeGroup( %d );\n", NrPcGens+NrCenGens );
        printf( "dt := DeepThoughtCollector( F, [ " );
	for( i = 1; i <= NrPcGens+NrCenGens; i++ )
            printf( "%d, ", Exponent[i] );
        printf( " ] );\n" );

        /*
        **  Set the power relations.
        */
	for( i = 1; i <= NrPcGens+NrCenGens; i++ )
	    if( Exponent[i] != (exp)0 && 
                Power[i] != (word)0 && Power[i]->g != EOW ) {
                printf( "SetPower( dt, %d, ", i );
                printGapWord( Power[i] );
                printf( " );\n" );
            }

        /*
        **  Set the conjugate relations.
        */
	for( j = 1; j <= NrPcGens; j++ ) {
	    i = 1;
	    while( i < j && Wt(i) + Wt(j) <= Class + (NrCenGens==0?0:1) ) {
		/* print Conjugate[j][i] */
                printf( "SetConjugate( dt, %d, %d, ", j, i );
		printGapWord( Conjugate[j][i] );
                printf( " );\n" );
		if( Exponent[i] == (exp)0 ) {
                    printf( "SetConjugate( dt, %d, %d, ", j, -i );
		    printGapWord( Conjugate[j][-i] );
                    printf( " );\n" );
		}
		if( 0 && Exponent[j] == (exp)0 ) {
                    printf( "SetConjugate( dt, %d, %d, ", -j, i );
		    printGapWord( Conjugate[-j][i] );
                    printf( " );\n" );
		}
		if( 0 && Exponent[i] + Exponent[j] == (exp)0 ) {
                    printf( "SetConjugate( dt, %d, %d, ", -j, -i );
		    printGapWord( Conjugate[-j][-i], 'A' );
                    printf( " );\n" );
		}
		i++;
	    }
	}

	printf( "\n#    Class : %d\n", Class );
	printf( "#    Nr of generators of each class :" );
	for( i = 1; i <= Class; i++ ) printf( " %d", Dimension[i] );
	printf( "\n" );
}
