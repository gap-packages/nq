if not IsBound(InfoNQ2)  then InfoNQ2 := Ignore;  fi;


#############################################################################
##
#V  NqLowerCentralSeries  . . . . . . . . . . . . . . . . .   global variable
##
NqLowerCentralSeries := [];


#############################################################################
##
#F  NqElementaryDivisors( <M> ) . . . . . . . . . . . . . elementary divisors
##
##  The function 'ElementaryDivisorsMat' only returns the non-zero elementary
##  divisors  of a Matrix. Here the zeroes are  added  in  order  to  make it
##  easier to recognize  the  isomorphism type of the abelian group presented
##  by  the  integer  matrix. At  the  same time strip  1's from the  list of
##  elementary divisors.
##
NqElementaryDivisors := function( M )
    local   ed,  i;

    ed := ElementaryDivisorsMat( M );
    ed := Concatenation( ed, List( [Length(ed)+1..Length(M[1])], x->0 ) );
    i := 1;
    while i <= Length(ed) and ed[i] = 1  do i := i+1;  od;
    ed := Sublist( ed, [i..Length(ed)] );

    return ed;

end;


#############################################################################
##
#E  Emacs . . . . . . . . . . . . . . . . . . . . . . . local emacs variables
##
## Local Variables:
## mode:           outline
## outline-regexp: "#F\\|#V\\|#E"
## eval:           (hide-body)
## End:
##
