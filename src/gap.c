/*****************************************************************************
**
**    gap.c                           NQ                       Werner Nickel
**                                         Werner.Nickel@math.rwth-aachen.de
*/

#include "nq.h"

void	printGapWord( w )
word	w;

{       int nrc = 30;      /* something has already been printed */

	if( w == (word)0 || w->g == EOW ) {
	    printf( "One(F)" );
	    return;
	}
	
	while( w->g != EOW ) {
	    if( w->g > 0 ) {
                nrc += printf( "NqF.%d", w->g );
		if( w->e != (exp)1 )
#ifdef LONGLONG
		    nrc += printf( "^%Ld", w->e );
#else
		    nrc += printf( "^%d", w->e );
#endif
	    }
	    else {
                nrc += printf( "NqF.%d", -w->g );
#ifdef LONGLONG
		nrc += printf( "^%Ld", -w->e );
#else
		nrc += printf( "^%d", -w->e );
#endif
	    }
	    w++;
	    if( w->g != EOW ) { 
              putchar( '*' ); 
              nrc++;

              /*
              **  Insert a line break, because GAP can't take lines that
              **  are too long.
              */
              if( nrc > 70 ) { printf( "\\\n  " ); nrc = 0; }
            }
              
	}
}


void	PrintGapPcPres() {

	gen	g;
	long	i, j;

        /*
        **  Commands that create the appropriate free group and the
        **  collector. 
        */
	printf( "NqF := FreeGroup( %d );\n", NrPcGens+NrCenGens );
        printf( "NqCollector := FromTheLeftCollector( NqF );\n" );
	for( i = 1; i <= NrPcGens+NrCenGens; i++ )
            if( Exponent[i] != (exp)0 ) {
                printf( "SetRelativeOrder( NqCollector, %d, ", i );
#               ifdef LONGLONG
                    printf( "%Ld", Exponent[i] );
#               else
                    printf( "%d", Exponent[i] );
#               endif
                printf( " );\n" );
            }

        /*
        **  Print the power relations.
        */
	for( i = 1; i <= NrPcGens+NrCenGens; i++ )
	    if( Exponent[i] != (exp)0 && 
                Power[i] != (word)0 && Power[i]->g != EOW ) {
                printf( "SetPower( NqCollector, %d, ", i );
                printGapWord( Power[i] );
                printf( " );\n" );
            }

        /*
        **  Print the conjugate relations.
        */
	for( j = 1; j <= NrPcGens; j++ ) {
	    i = 1;
	    while( i < j && Wt(i) + Wt(j) <= Class + (NrCenGens==0?0:1) ) {
              /*
                printf( "Print( %d, \" \", %d, \"\\n\" );\n", j, i );
              */
		/* print Conjugate[j][i] */
                printf( "SetConjugate( NqCollector, %d, %d, ", j, i );
		printGapWord( Conjugate[j][i] );
                printf( " );\n" );
		if( 0 && Exponent[i] == (exp)0 ) {
                    printf( "SetConjugate( NqCollector, %d, %d, ", j, -i );
		    printGapWord( Conjugate[j][-i] );
                    printf( " );\n" );
		}
		if( 0 && Exponent[j] == (exp)0 ) {
                    printf( "SetConjugate( NqCollector, %d, %d, ", -j, i );
		    printGapWord( Conjugate[-j][i] );
                    printf( " );\n" );
		}
		if( 0 && Exponent[i] + Exponent[j] == (exp)0 ) {
                    printf( "SetConjugate( NqCollector, %d, %d, ", -j, -i );
		    printGapWord( Conjugate[-j][-i], 'A' );
                    printf( " );\n" );
		}
		i++;
	    }
	}

        /*
        **  Print the epimorphism.  It is sufficient to list the images.
        */
        printf( "NqImages := [\n" );
        for( i = 1; i <= NumberOfGens(); i++ ) {
            printGapWord( Epimorphism( i ) );
            printf( ",\n" );
        }
        printf( "];\n" );

	printf( "NqClass := %d;\n", Class );
	printf( "NqRanks := [ " );
	for( i = 1; i <= Class; i++ ) printf( " %d,", Dimension[i] );
	printf( "];\n" );
}

void	printGapList( w )
word	w;

{       int nrc = 30;      /* something has already been printed */

	if( w == (word)0 || w->g == EOW ) { printf( "[]" ); return; }
	
	printf( "[ " );
	while( w->g != EOW ) {
	    if( w->g > 0 ) {
                nrc += printf( " %d,", w->g );
#               ifdef LONGLONG
                nrc += printf( " %Ld,", w->e );
#               else
		nrc += printf( " %d,", w->e );
#               endif
            }
            else {
                nrc += printf( " %d,", -w->g );
#               ifdef LONGLONG
                nrc += printf( " %Ld,", -w->e );
#               else
                nrc += printf( " %d,", -w->e );
#               endif
            }
            w++;
	    /* Avoid long lines, because GAP can't read them. */
            if( w->g != EOW && nrc > 70 ) { printf( "\\\n  " ); nrc = 0; }
        }
	printf( " ]" );
}

void printConjugates ( conj )
word **conj;

{
}

void    PrintRawGapPcPres() {

        gen     g;
        long    i, j;
	long    cl;

        /*
        **  Output the number of generators first and their relative
        **  orders.  
        */
        printf( "NqNrGens :=  %d;\n", NrPcGens+NrCenGens );
        printf( "NqRelOrders := [ " );
        for( i = 1; i <= NrPcGens+NrCenGens; i++ ) {
#               ifdef LONGLONG
                    printf( "%Ld,", Exponent[i] );
#               else
                    printf( "%d,", Exponent[i] );
#               endif
        }
        printf( " ];\n" );

        /*
        **  Print the power relations.
        */
        printf( "NqPowers := [];\n" );
        for( i = 1; i <= NrPcGens+NrCenGens; i++ )
            if( Exponent[i] != (exp)0 && 
                Power[i] != (word)0 && Power[i]->g != EOW ) {
                printf( "NqPower[ %d ] := ", i );
                printGapList( Power[i] );
                printf( ";\n" );
            }

        /*
        **  Print the conjugate relations.
        */
	cl = Class + (NrCenGens==0 ? 0 : 1);
	printf( "NqConj := [];\n" );
        for( j = 1; j <= NrPcGens; j++ ) {
	    printf( "NqConj[ %d ] := [];\n", j );
            for( i = 1; i < j && Wt(i) + Wt(j) <= cl; i++ ) {
                /* print Conjugate[j][i] */
                printf( "NqConj[ %d ][ %d ] := ", j, i );
                printGapList( Conjugate[j][i] );
                printf( ";\n" );
	    }
	}

	printf( "NqConjI := [];\n" );
        for( j = 1; j <= NrPcGens; j++ ) {
	    printf( "NqConjI[ %d ] := [];\n", j );
            for( i = 1; i < j && Wt(i) + Wt(j) <= cl; i++ ) {
	      if( Exponent[i] == (exp)0 ) {
                printf( "NqConjI[ %d ][ %d ] := ", j, i );
                printGapList( Conjugate[j][-i] );
                printf( ";\n" );
	      }
	    }
	}

	printf( "NqIConj := [];\n" );
        for( j = 1; j <= NrPcGens; j++ ) {
	    printf( "NqIConj[ %d ] := [];\n", j );
            for( i = 1; i < j && Wt(i) + Wt(j) <= cl; i++ ) {
	      if( Exponent[j] == (exp)0 ) {
                printf( "NqIConj[ %d ][ %d ] := ", j, i );
                printGapList( Conjugate[-j][i] );
                printf( ";\n" );
	      }
	    }
	}

	printf( "NqIConjI := [];\n" );
        for( j = 1; j <= NrPcGens; j++ ) {
	    printf( "NqIConjI[ %d ] := [];\n", j );
            for( i = 1; i < j && Wt(i) + Wt(j) <= cl; i++ ) {
	      if( Exponent[i] + Exponent[j] == (exp)0 ) {
                printf( "NqIConjI[ %d ][ %d ] := ", j, i );
                printGapList( Conjugate[-j][-i] );
                printf( ";\n" );
	      }
	    }
	}

        /*
        **  Print the epimorphism.  It is sufficient to list the images.
        */
        printf( "NqImages := [\n" );
        for( i = 1; i <= NumberOfGens(); i++ ) {
            printGapList( Epimorphism( i ) );
            printf( ",\n" );
        }
        printf( "];\n" );

        printf( "NqClass := %d;\n", Class );
        printf( "NqRanks := [ " );
        for( i = 1; i <= Class; i++ ) printf( " %d,", Dimension[i] );
        printf( "];\n" );
}
