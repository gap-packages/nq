/*****************************************************************************
**
**    glimt.c                         NQ                       Werner Nickel
**                                                    werner@pell.anu.edu.au
**
**    Copyright 1993                            Mathematics Research Section
**                                           School of Mathematical Sciences 
**                                            Australian National University
*/


#include "nq.h"

#undef min

/*
**    This module uses the arbitrary precision integer package mp.
*/
#include "mp.h"

/*
**    Define the data type for large integers and vectors of large integers.
*/
typedef MINT    *large;
typedef large   *lvec;

/*
**    The variable 'Matrix' contains the pointer to the integer matrix.
**    The variable 'Heads' contains the pointer to an array whose i-th
**    component contains the position of the first non-zero entry in
**    i-th row of Matrix[]. The variable changedMatrix indicates whether
**    the integer matrix changed during the reduction of an integer
**    vector.
*/
lvec     *Matrix = NULL;
long     *Heads;
static   long     changedMatrix = 0;

/*
**    The number of rows and columns in the integer matrix are stored in
**    the following two variables.
*/
long     NrRows = 0;
long     NrCols = 0;

/*
**    Take the time spend in this package.
*/
static  long Time = 0;

/*
**    Set a flag if the integer matrix is the identity.
**    This can be used as an early stopping criterion.
*/
int     EarlyStop;

large   ltom( n )
int     n;

{       char    x[20];
        large   l;

        if( abs(n) >= 1<<15 ) {
                sprintf( x, "%x", abs(n) );
                l = xtom( x );
                if( n < 0 ) l->size = -l->size;
                return l;
        }
        else    return itom( n );
}

static
void    printEv( ev )
expvec  ev;

{       long    i;

        for( i = 1; i <= NrPcGens+NrCenGens; i++ )
            printf( "%2d ", ev[i] );
}

void    freeExpVecs( M )
expvec  *M;

{       long    i;

        for( i = 0; i < NrRows; i++ ) free( M[i] );
        free(M);

        NrRows = NrCols = 0;
}

void    freeVector( v )
lvec    v;

{       long    i;

        for( i = 1; i <= NrCols; i++ ) mfree( v[i] );
        free( v );
}

void    freeMatrix() {

        long    i;

        for( i = 0; i < NrRows; i++ ) freeVector( Matrix[i] );
        free(Matrix);
        Matrix = NULL;
}

void    printVector( v )
lvec    v;

{       long    i;

        for( i = 1; i <= NrCols; i++ )
            if( v[i]->size == 0 )
                    printf( " 0" );
            else    printf( " %d", sgn(v[i]->size)*v[i]->d[0] );

        printf( "\n" );
}

long survivingCols( M, surviving )
expvec *M;
long   *surviving;
{
    long nrSurv = 0, h = 1, i;

    for( i = 0; i < NrRows; i++ ) {
        for( ; h < Heads[i]; h++ ) surviving[nrSurv++] = h;
        if( M[i][h] != 1 )         surviving[nrSurv++] = h;
        h++;
    }
    for( ; h <= NrCols; h++ ) surviving[nrSurv++] = h;
    return nrSurv;
}

void    outputMatrix( M )
expvec  *M;

{       long    i, j, nrSurv, *surviving;
        char    outputName[128];
        FILE    *fp;

        if( strlen(InputFile) > 100 )
            sprintf( outputName, "NqOut.abinv.%d", Class+1 );
	else
	    sprintf( outputName, "%s.abinv.%d", InputFile, Class+1 );
        if( (fp=fopen( outputName, "w" )) == NULL ) {
            perror( outputName );
            fprintf( stderr,
                     "relation matrix for class %d not written\n", Class+1 );
        }

        if( M == (expvec*)0 ) {
            fprintf( fp, "0\n" );
            fclose( fp );
            return;
        }

        surviving = (long *)Allocate( NrCols * sizeof(long) );
        nrSurv = survivingCols( M, surviving );

        fprintf( fp, "%d    # Number of colums\n", nrSurv );
        for( i = 0; i < NrRows; i++ ) {
            if( M[i][Heads[i]] != 1 ) {
                for( j = 0; j < nrSurv; j++ )
                    fprintf( fp, " %d", M[i][surviving[j]] );
                fprintf( fp, "\n" );
            }
        }

        Free( surviving );
        fclose( fp );
}

void    printGapMatrix( M )
expvec  *M;

{       long    i, j, first, nrSurv, *surviving;

        if( M == (expvec*)0 ) {
            printf( "[\n[" );
            for( j = 1; j <= NrCenGens; j++ ) {
                printf( " 0" );
                if( j < NrCenGens ) putchar( ',' );
            }
            printf( " ]\n],\n" );
            return;
        }

        surviving = (long *)Allocate( NrCols * sizeof(long) );
        nrSurv = survivingCols( M, surviving );

        if( nrSurv == 0 ) { Free( surviving ); return; }

        printf( "[\n" );
        for( i = 0, first = 1; i < NrRows; i++ ) {
            if( M[i][Heads[i]] != 1 ) {
                if( !first ) printf( ",\n" );
                else         first = 0;
                printf( "[" );
                for( j = 0; j < nrSurv; j++ ) {
                    printf( " %d", M[i][surviving[j]] );
                    if( j < nrSurv ) putchar( ',' );
                }
                printf( "]" );
            }
        }
        if( first ) {
            printf( "[" );
            for( j = 0; j < nrSurv-1; j++ ) printf( " 0," );
            printf( " 0]\n" );
        }
        printf( "]," );
        putchar( '\n' );

        Free( surviving );
}

/*
**    Print the contents of Matrix[]. This routine only prints the
**    first component of each large integer.
*/
void    printMatrix() {

        long    i, j;

        printf( " heads   vectors\n" );
        for( i = 0; i < NrRows; i++ ) {
            printf( "    %d   ", Heads[i] );
            for( j = 1; j <= NrCols; j++ )
                if( Matrix[i][j]->size == 0 )
                        printf( " 0" );
                else    printf( " %d", sgn(Matrix[i][j]->size)
                                          *Matrix[i][j]->d[0] );
            putchar( '\n' );
        }
}

/*
**    MatrixToExpVec() converts the contents of Matrix[] to a list of
**    exponent vectors which can be used easily by the elimination
**    routines. It also checks that the integers are not bigger than 2^15.
**    If this is the case it prints a warning and aborts.
*/
expvec  *MatrixToExpVecs() {

        long    c, i, j, k;
        large   m;
        expvec  *M;

        if( NrRows == 0 ) {
                freeMatrix();
                TimeOutOff();
                if( Gap ) printGapMatrix( (expvec*)0 );
                if( AbelianInv ) outputMatrix( (expvec*)0 );
                TimeOutOn();
                return (expvec*)0;
        }

        M = (expvec*)malloc( NrRows*sizeof(expvec) );
        if( M == NULL ) { perror( "MatrixToExpVecs(), M" ); exit( 2 ); }

        /* Convert. */
        for( i = 0; i < NrRows; i++ ) {
            M[i] = (expvec)calloc( NrCols+1, sizeof(exp) );
            if( M[i] == NULL ) { perror("MatrixToExpVecs(), M[]"); exit(2); }
            for( j = Heads[i]; j <= NrCols; j++ ) {
                m = Matrix[i][j];
                if( abs(m->size) > 1 ) {
                    printf( "Warning, Exponent larger than 2^15.\n" );
                    exit( 4 );
                }
                if( m->size == 0 ) M[i][j] = 0;
                else M[i][j] = m->size * m->d[0];
            }
            freeVector( Matrix[i] );
        }

        /* Make all entries except the head entries negative. */
        for( i = 0; i < NrRows; i++ )
            for( j = i-1; j >= 0; j-- )
                if( abs( M[j][ Heads[i] ]) >= M[i][ Heads[i] ] ||
                    M[j][ Heads[i] ] > 0 ) {
                    c = M[j][ Heads[i] ] / M[i][ Heads[i] ];
                    if( M[j][ Heads[i] ] > 0 &&
                        M[j][ Heads[i] ] % M[i][ Heads[i] ] != 0 ) c++;
                    for( k = Heads[i]; k <= NrCols; k++ )
                        M[j][k] -= c * M[i][k];
                }

        free( Matrix ); Matrix = (lvec *)0;

        if( Verbose )
            printf("#    Time spent on the integer matrix: %d msec.\n",Time);

        TimeOutOff();
        if( Gap ) printGapMatrix( M );
        if( AbelianInv ) outputMatrix( M );
        TimeOutOn();
        return M;
}

/*
**    The following routines perform operations with vectors :
**
**    vNeg()  negates each entry of the vector v starting at v[a].
**    vSub()  subtracts a multiple of the vector w from the vector v.
**            The scalar w is multiplied with is v[a]/w[a], so that
**            the entry v[a] after the subtraction is smaller than
**            w[a].
**    vSubOnce()  subtracts the vector w from the vector v.
*/
void    vNeg( v, a )
lvec    v;
long    a;

{       while( a <= NrCols ) { v[a]->size = -v[a]->size; a++; }    }

void    vSubOnce( v, w, a )
lvec    v, w;
long    a;

{       while( a <= NrCols ) { msub( v[a], w[a], v[a] ); a++; }    }

void    vSub( v, w, a )
lvec    v, w;
long    a;

{       large    s, t;

        if( v[a]->size != 0 ) {
            s = itom(0); t = itom(0);
            mdiv( v[a], w[a], s, t );
            if( s->size != 0 )
                while( a <= NrCols ) {
                    mult( s, w[a], t );
                    msub( v[a], t, v[a] );
                    a++;
                }
            mfree(s); mfree(t);
        }
}

void    lastReduce() {

        long    i, j;

        /* Reduce all the head columns. */
        for( i = 0; i < NrRows; i++ )
            for( j = i-1; j >= 0; j-- )
                vSub( Matrix[j], Matrix[i], Heads[i] );
}

/*
**    vReduce() reduces the vector v against the vectors in Matrix[].
*/
lvec    vReduce( v, h )
lvec    v;
long    h;

{       long    i;
        lvec    w;

        for( i = 0; i < NrRows && Heads[i] <= h; i++ ) {
            if( Heads[i] == h ) {
                while( v[h]->size != 0 && Matrix[i][h]->size != 0  ) {
                    vSub( v, Matrix[i], h );
                    if( v[h]->size != 0 ) {
			changedMatrix = 1;
			vSub( Matrix[i], v, h );
		    }
                }
                if( v[h]->size != 0 ) { /* v replaces th i-th row. */
                    if( v[h]->size < 0 ) vNeg( v, h );
                    w = Matrix[i]; Matrix[i] = v; v = w;
                }
                while( h <= NrCols && v[h]->size == 0 ) h++;
                if( h > NrCols ) { lastReduce(); freeVector( v ); return NULL; }
            }
        }
        return v;
}

int     addRow( ev )
expvec  ev;

{       long    h, i, t;
        lvec    v;
        
        /* Initialize Matrix[] and Heads[] on the first call. */
        if( Matrix == NULL ) {
            EarlyStop = 0;
            Time = 0;
            if( (Matrix = (lvec*)malloc( 200 * sizeof(lvec) )) == NULL ) {
                perror( "addRow, Matrix " );
                exit( 2 );
            }
            if( (Heads = (long*)malloc( 200 * sizeof(long) )) == NULL ) {
                perror( "addRow, Heads " );
                exit( 2 );
            }
            NrCols = NrCenGens;
        }

	changedMatrix = 0;

        /* Check if the first NrPcGens entries in the exponent vector
        ** are zero. */
        for( i = 1; i <= NrPcGens; i++ )
            if( ev[i] != 0 ) {
                printf( "Warning, exponent vector is not a tail.\n" );
                printEv( ev );
                break;
            }

        /* Find the head, i.e. the first non-zero entry, of ev. */
        for( h = 0, i = 1; i <= NrCols; i++ )
            if( ev[NrPcGens+i] != 0 ) { h = i; break; }

        /* If ev is the null vector, free it and return. */
        if( h == 0 ) { free(ev); return 0; }

        if( Verbose ) t = RunTime();

        /* Copy the last NrCenGens entries of ev and free it. */
        v = (lvec)malloc( (NrCols+1)*sizeof(large) );
        if( v == NULL ) { perror( "addRow(), v" ); exit( 2 ); }
        for( i = 1; i <= NrCols; i++ )
                v[i] = ltom( ev[NrPcGens+i] );
        free( ev );

        if( (v = vReduce( v, h )) != NULL ) {
	    changedMatrix = 1;
            if( NrRows % 200 == 0 ) {
                Matrix = (lvec*)realloc( Matrix, (NrRows+200) * sizeof(lvec) );
                if( Matrix == NULL ) {
                    perror( "addRow(), Matrix" );
                    exit( 2 );
                }
                Heads = (long*)realloc( Heads, (NrRows+200) * sizeof(long) );
                if( Heads == NULL ) {
                    perror( "addRow(), Heads" );
                    exit( 2 );
                }
            }
            /* Insert ev such that Heads[] is in increasing order. */
            while( h <= NrCols && v[h]->size == 0 ) h++;
            if( v[h]->size < 0 ) vNeg( v, h );
            for( i = NrRows; i > 0; i-- )
                if( Heads[i-1] > h ) {
                    Matrix[i] = Matrix[i-1];
                    Heads[i] = Heads[i-1];
            }
            else        break;
            /* Insert. */
            Matrix[ i ] = v;
            Heads[ i ] = h;
            NrRows++;
            lastReduce();
        }

        /* Check if Matrix[] is the identity matrix. */
        if( NrRows == NrCenGens ) {
            for( i = 0; i < NrRows; i++ ) 
                if( Matrix[i][Heads[i]]->size != 1 ||
                    Matrix[i][Heads[i]]->d[0] != 1 ) break;
            if( i == NrRows ) EarlyStop = 1;
        }
        if( Verbose ) {
            Time += RunTime()-t;
            if( EarlyStop )
                printf( "#    Integer matrix is the identity.\n" );
        }
	return changedMatrix;
}
