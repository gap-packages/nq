##############################################################################
##
#A  nq.g                        17 Mai  1994                     Werner Nickel
##
##  This file contains the interface to my NQ program.  GAP 3.4 does not have
##  the ability to handle infinite polycyclic groups in terms of a polycyclic
##  presentation.   Therefore the  only  information  obtained  from  the  NQ
##  standalone is the structure of the factors in the lower central series of
##  the given group.
##    
if not IsBound(InfoNQ2)  then InfoNQ2 := Ignore;  fi;


#############################################################################
##
#V  NqLowerCentralSeries  . . . . . . . . . . . . . . . . .  globale variable
##
NqLowerCentralSeries := [];


#############################################################################
##
#F  NqElementaryDivisors( <M> )	. . . . . . . . . . . . . elementary divisors
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
#F  NqUsage() . . . . . . . . . . . . . . . show usage of 'NilpotentQuotient'
##
NqUsage := function()
    return Error("usage: NilpotentQuotient( <file>|<fpgroup> [,<class>] )");
end;
	

#############################################################################
##
#F  NqPresPrintToFile( <file>, <fp> ) . . . . . .  print presentation to file
##
##  Print a finite presentation in NQ format.
##
NqPresPrintToFile := function( file, fp )
    local   i,  gens,  rel,  size;

    # print presentation to file using generators "x1" ... "xn"
    PrintTo( file, "< " );
    if 0 < Length(fp.generators)  then
        gens := WordList( Length(fp.generators), "x" );
	AppendTo( file, gens[1] );
    fi;
    for i  in [2..Length(fp.generators)]  do
	AppendTo( file, ", ", gens[i] );
    od;
    AppendTo( file, " |\n    " );
    if IsBound(fp.relators)  then
        if 0 < Length(fp.relators)  then
            rel := MappedWord( fp.relators[1], fp.generators, gens );
            AppendTo( file, rel );
	fi;
	for i  in [2..Length(fp.relators)]  do
            rel := MappedWord( fp.relators[i], fp.generators, gens );
	    AppendTo( file, ",\n    ", rel );
	od;
    fi;
    AppendTo( file, "\n>\n" );

end;


#############################################################################
##
#F  NilpotentQuotient( <F>, <class> ) . . . . . . . nilpotent quotient of <F>
##
##  The interface to the NQ standalone.
##
NilpotentQuotient := function( arg )
    local   cl,  cmd,  name,   res;

    if not Length(arg) in [1,2]  then NqUsage();  fi;

    cl := 0;
    if Length(arg) = 2 then
	cl := arg[2];
	if not IsInt(cl) or cl < 1  then return NqUsage();  fi;
    fi;

    if IsRec( arg[1] ) then
	name := TmpName();
	NqPresPrintToFile( name, arg[1] );
    elif IsString( arg[1] ) then
	name := arg[1];
    else
	return NqUsage();
    fi;
    res := TmpName();

    if InfoNQ2 = Print  then
        cmd := ConcatenationString( "-v -g ", name, " " );
    else
        cmd := ConcatenationString( "-g ", name, " " );
    fi;
    if cl <> 0 then
 	cmd := ConcatenationString( cmd, String(cl) );
    fi;
    cmd := ConcatenationString( cmd, " > ", res );

    Unbind( NqLowerCentralSeries );
    ExecPkg( "nq", "bin/nq", cmd, "." );

##
##  If this function is not used as a share library package use the
##  following line instead of the one above.
##
##  Exec( ConcatenationString( "nq ", cmd ) );
##

    Read( res );
    if IsRec(arg[1])  then
        Exec( ConcatenationString( "rm -f ", name, " ", res ) );
    else
	Exec( ConcatenationString( "rm -f ", res ) );
    fi;

    return List( NqLowerCentralSeries, x->NqElementaryDivisors(x) );

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
