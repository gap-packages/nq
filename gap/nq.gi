##############################################################################
##
#A  nq.gi                     Oktober 2002                       Werner Nickel
##
##  This file contains the interface to my NQ program.
##

#############################################################################
##
#F  NqBuildManual( ) . . . . . . . . . . . . . . . . . . . . build the manual
##
##  This function builds the manual of the NQ package in the file formats
##  &LaTeX;, DVI, Postscript, PDF and HTML.
##
##  This is done using the GAPDoc package by Frank L\"ubeck and
##  Max Neunh\"offer.
##
InstallGlobalFunction( NqBuildManual,
function ( ) local  NqDir;

  ##  We take the first package directory.  In most cases this is the one 
  ##  loaded by RequirePackage().
  NqDir := DirectoriesPackageLibrary( "nq", "gap" )[1];

  MakeGAPDocDoc( Filename( NqDir, "../doc/" ), "nqnew",
                 [ "nq.bib" ], "nq", "../../../" );
end );

#############################################################################
##
#V  NqRuntime . . . . . . . . . . reports the run time used by the nq program
##
##  Initialize the runtime variable.
##
MakeReadWriteGlobal( "NqRuntime" );
NqRuntime := 0;
MakeReadOnlyGlobal( "NqRuntime" );

#############################################################################
##
#V  NqDefaultOptions. . . . . . . . . . .  default options for the nq program
##
##  The default options are:
##      -g      Produce GAP output including a GAP readable presentation of
##              the nilpotent quotient
##      -p      do not print the pc-presentation of the nilpotent quotient
##      -C      use the combinatorial collector
##      -s      check only instances with semigroup words - this is only
##              relevant if one of the Engel options is used
##
InstallValue( NqDefaultOptions,  [ "-g", "-p", "-C", "-s" ] );

#############################################################################
##
#V  NqOneTimeOptions . . . . . . . . . .  one time options for the nq program
##
##  This variable can be used to pass a list of option to the next call of
##  the nq program.
MakeReadWriteGlobal( "NqOneTimeOptions" );
NqOneTimeOptions := [];

#############################################################################
##
#F  NqCallANU_NQ . . . . . . . . . . . the function that calls the nq program
##
NqCallANU_NQ := function( input, output, options )
    local   nq,  ret;

    nq      := Filename( DirectoriesPackagePrograms( "nq") , "nq" );
    options := Concatenation( NqDefaultOptions, NqOneTimeOptions, options );

    NqOneTimeOptions := [];

##  The following Print statement should be converted to an info statement
##
##    Print( "##  Calling ANU NQ with: ", options, "\n", input![2], "\n" );

    ret    := Process( DirectoryCurrent(),        ## executing directory
                      nq,                         ## executable
                      input,                      ## input  stream
                      output,                     ## output stream
                      options );                  ## command line arguments

##  Dito.
##    Print( "##  ANU NQ returns ", ret, "\n" );

    CloseStream( input );
    CloseStream( output );
end;


#############################################################################
##
#F  NqGlobalVariables . . global variables to communicate with the nq program
##
InstallValue( NqGlobalVariables,
        [ "NqLowerCentralFactors",   ##  factors of the LCS
          "NqNrGenerators",
          "NqClass",
          "NqRanks",
          "NqRelativeOrders",
          "NqImages",                ##  the epimorphism
          "NqPowers",
          "NqConjugates",
          "NqRuntime",
          ] );

#############################################################################
##
#F  NqReadOutput  . . . . . . . . . . . . . . . . read output from nq program
##
InstallGlobalFunction( NqReadOutput,
function( stream )
    local   var,  result,  n;

    for var in NqGlobalVariables do
        HideGlobalVariables( var );
    od;

    Read( stream );

    result := rec();

    for var in NqGlobalVariables do
        n := Length(var);
        if IsBoundGlobal( var ) then
            result.(var{[3..n]}) := ValueGlobal( var );
        else
            result.(var{[3..n]}) := fail;
        fi;
    od;

    for var in NqGlobalVariables do
        UnhideGlobalVariables( var );
    od;
    
    MakeReadWriteGlobal( "NqRuntime" );
    NqRuntime := result.Runtime;
    MakeReadOnlyGlobal( "NqRuntime" );

    return result;

end );


#############################################################################
##
#F  NqStringFpGroup( <fp> ) . . . . . . .  finitely presented group to string
##
InstallGlobalFunction( NqStringFpGroup,
function( arg )
    local   G,  idgens,  F,  fgens,  V,  vgens,  str,  i,  r;

    G      := arg[1];
    idgens := [];
    if Length(arg) = 2 then
        idgens := arg[2];
    fi;

    F     := FreeGroupOfFpGroup( G );
    fgens := GeneratorsOfGroup( F );

    if not IsSubset( fgens, idgens ) then
        Error( "identical generators are not a subset of free generators" );
    fi;

    if Length( fgens ) = 0 then
        # Produce a dummy presentation, since NQ cannot handle presentations
        # without generators.

        str := "< x | x >\n";
        return str;
    fi;

    V     := FreeGroup( Length( fgens ), "x" );
    vgens := GeneratorsOfGroup( V );
    
    str := "";
    Append( str, "< " );
    
    for i in [1..Length(vgens)] do
	Append( str, String( vgens[i] ) );
        if i = Length(fgens)-Length(idgens) then
            ##  Insert seperator between free and identical generators.
            Append( str, "; " );
        else
            Append( str, ", " );
        fi;
    od;
    Unbind( str[ Length(str) ] );
    Unbind( str[ Length(str) ] );

    Append( str, " |\n" );

    for r in RelatorsOfFpGroup( G ) do
        Append( str, "    " );
        Append( str, String( MappedWord( r, fgens, vgens ) ) );
        Append( str, ",\n" );
    od;
    if str[ Length(str)-1 ] = ',' then
        Unbind( str[ Length(str) ] );
        Unbind( str[ Length(str) ] );
    fi;
        
    Append( str, "\n>\n" );
    return str;
end );

#############################################################################
##
#F  NqStringExpTrees( <fp> ) . . . . . . . . . . . expression trees to string
##
InstallGlobalFunction( NqStringExpTrees,
function( arg )
    local   G,  idgens,  fgens,  str,  g,  r;

    G      := arg[1];
    idgens := [];
    if Length(arg) = 2 then
        idgens := arg[2];
    fi;

    fgens := G.generators;

    if not IsSubset( fgens, idgens ) then
        Error( "identical generators are not a subset of free generators" );
    fi;
    fgens := Difference( fgens, idgens );

    if Length( fgens ) = 0 then
        # Produce a dummy presentation, since NQ cannot handle presentations
        # without generators.

        str := "< x | x >\n";
        return str;
    fi;

    str := "";
    Append( str, "< " );
    
    for g in fgens do
	Append( str, String( g ) );
        Append( str, ", " );
    od;
    Unbind( str[ Length(str) ] );
    Unbind( str[ Length(str) ] );
    Append( str, "; " );
    for g in idgens do
	Append( str, String( g ) );
        Append( str, ", " );
    od;
    Unbind( str[ Length(str) ] );
    Unbind( str[ Length(str) ] );

    Append( str, " |\n" );

    for r in G.relations do
        Append( str, "    " );
        Append( str, String( r ) );
        Append( str, ",\n" );
    od;
    if str[ Length(str)-1 ] = ',' then
        Unbind( str[ Length(str) ] );
        Unbind( str[ Length(str) ] );
    fi;
        
    Append( str, "\n>\n" );
    return str;
end );


#############################################################################
##
#F  NilpotentQuotient( <F>, <class> ) . . . . . . . nilpotent quotient of <F>
##
##  The interface to the NQ standalone.  
##
##  The operation has methods for the following arguments:
##
##                 fp-group
##     outfile     fp-group
##                 fp-group      ident-gens
##     outfile     fp-group      ident-gens
##                 fp-group                   class
##     outfile     fp-group                   class
##                 fp-group      ident-gens   class
##     outfile     fp-group      ident-gens   class
##                 infile
##     outfile     infile
##                 infile                     class
##     outfile     infile                     class
##
##  This should produce a quotient system and not a pcp group.
##
InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group",
        true,
        [ IsFpGroup ], 
        0,
function( G )
    local   pres,  input,  str,  output,  options,  nqrec,  coll;

    input   := InputTextString( NqStringFpGroup( G ) );
    str     := "";
    output  := OutputTextString( str, true );
    options := [ ];

    NqCallANU_NQ( input, output, options );
    
    nqrec := NqReadOutput( InputTextString( str ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group, keep output file",
        true, 
        [ IsString, IsFpGroup ], 
        0,
function( outfile, G )
    local   input,  output,  options,  nqrec,  coll;

    input   := InputTextString( NqStringFpGroup( G ) );
    output  := OutputTextFile( outfile, false );
    options := [ ]; 

    NqCallANU_NQ( input, output, options );

    nqrec := NqReadOutput( InputTextFile( outfile ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group on file",
        true,
        [ IsString ], 
        0,
function( infile )
    local   input,  str,  output,  options,  nqrec,  coll;

    input   := InputTextFile( infile );
    str     := "";
    output  := OutputTextString( str, true );
    options := [ ];

    NqCallANU_NQ( input, output, options );

    nqrec := NqReadOutput( InputTextString( str ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group on file, keep output file",
        true, 
        [ IsString, IsString ], 
        0,
function( outfile, infile )
    local   input,  output,  options,  nqrec,  coll;

    input   := InputTextFile( infile );
    output  := OutputTextFile( outfile, false );
    options := [ infile ];

    NqCallANU_NQ( input, output, options );

    nqrec := NqReadOutput( InputTextFile( outfile ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group",
        true,
        [ IsRecord ], 
        0,
function( G )
    local   pres,  input,  str,  output,  options,  nqrec,  coll;

    input   := InputTextString( NqStringExpTrees( G ) );
    str     := "";
    output  := OutputTextString( str, true );
    options := [ ];

    NqCallANU_NQ( input, output, options );
    
    nqrec := NqReadOutput( InputTextString( str ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group with identical relations",
        true,
        [ IsFpGroup, IsList ], 
        0,
function( G, idgens )
    local   pres,  input,  str,  output,  options,  nqrec,  coll;

    input   := InputTextString( NqStringFpGroup( G, idgens ) );
    str     := "";
    output  := OutputTextString( str, true );
    options := [ ];

    NqCallANU_NQ( input, output, options );
    
    nqrec := NqReadOutput( InputTextString( str ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group with identical relations",
        true,
        [ IsRecord, IsList ], 
        0,
function( G, idgens )
    local   pres,  input,  str,  output,  options,  nqrec,  coll;

    input   := InputTextString( NqStringExpTrees( G, idgens ) );
    str     := "";
    output  := OutputTextString( str, true );
    options := [ ];

    NqCallANU_NQ( input, output, options );
    
    nqrec := NqReadOutput( InputTextString( str ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallMethod( NilpotentQuotient,
        "of a finitely presented group",
        true,
        [ IsFpGroup, IsPosInt ], 
        0,
function( G, cl )
    local   pres,  input,  str,  output,  options,  nqrec,  coll;

    input   := InputTextString( NqStringFpGroup( G ) );
    str     := "";
    output  := OutputTextString( str, true );
    options := [ String(cl) ];

    NqCallANU_NQ( input, output, options );
    
    nqrec := NqReadOutput( InputTextString( str ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group, keep output file",
        true, 
        [ IsString, IsFpGroup, IsPosInt ], 
        0,
function( outfile, G, cl )
    local   input,  output,  options,  nqrec,  coll;

    input   := InputTextString( NqStringFpGroup( G ) );
    output  := OutputTextFile( outfile, false );
    options := [ String(cl) ]; 

    NqCallANU_NQ( input, output, options );

    nqrec := NqReadOutput( InputTextFile( outfile ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallMethod( NilpotentQuotient,
        "of a finitely presented group on file",
        true,
        [ IsString, IsPosInt ], 
        0,
function( infile, cl )
    local   input,  str,  output,  options,  nqrec,  coll;

    input   := InputTextFile( infile );
    str     := "";
    output  := OutputTextString( str, true );
    options := [ String(cl) ];

    NqCallANU_NQ( input, output, options );

    nqrec := NqReadOutput( InputTextString( str ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group on file, keep output file",
        true, 
        [ IsString, IsString, IsPosInt ], 
        0,
function( outfile, infile, cl )
    local   input,  output,  options,  nqrec,  coll;

    input   := InputTextFile( infile );
    output  := OutputTextFile( outfile, false );
    options := [ infile, String(cl) ];

    NqCallANU_NQ( input, output, options );

    nqrec := NqReadOutput( InputTextFile( outfile ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallMethod( NilpotentQuotient,
        "of a finitely presented group",
        true,
        [ IsRecord, IsPosInt ], 
        0,
function( G, cl )
    local   pres,  input,  str,  output,  options,  nqrec,  coll;

    input   := InputTextString( NqStringExpTrees( G ) );
    str     := "";
    output  := OutputTextString( str, true );
    options := [ String(cl) ];

    NqCallANU_NQ( input, output, options );
    
    nqrec := NqReadOutput( InputTextString( str ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group with identical relations",
        true,
        [ IsFpGroup, IsList, IsPosInt ], 
        0,
function( G, idgens, cl )
    local   pres,  input,  str,  output,  options,  nqrec,  coll;

    input   := InputTextString( NqStringFpGroup( G, idgens ) );
    str     := "";
    output  := OutputTextString( str, true );
    options := [ String(cl) ];

    NqCallANU_NQ( input, output, options );
    
    nqrec := NqReadOutput( InputTextString( str ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group with identical relations",
        true,
        [ IsRecord, IsList, IsPosInt ], 
        0,
function( G, idgens, cl )
    local   pres,  input,  str,  output,  options,  nqrec,  coll;

    input   := InputTextString( NqStringExpTrees( G, idgens ) );
    str     := "";
    output  := OutputTextString( str, true );
    options := [ String(cl) ];

    NqCallANU_NQ( input, output, options );
    
    nqrec := NqReadOutput( InputTextString( str ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );




#############################################################################
##
#F  NqEpimorphismNilpotentQuotient
##
##
InstallMethod( NqEpimorphismNilpotentQuotient,
        "of a finitely presented group",
        true,
        [ IsFpGroup, IsPosInt ], 
        0, 
function( G, cl )
    local   nq,  pres,  input,  str,  output,  options,  ret,  nqrec,  
            coll,  A,  gens,  images,  phi;

    nq      := Filename( DirectoriesPackagePrograms( "nq") , "nq" );

    pres    := NqStringFpGroup( G );
    input   := InputTextString( pres );
    str     := "";
    output  := OutputTextString( str, true );
    options := [ String(cl) ];

    ret    := Process( DirectoryCurrent(),        ## executing directory
                      nq,                         ## executable
                      input,                      ## input  stream
                      output,                     ## output stream
                      options );                  ## command line arguments
    CloseStream( output );
    CloseStream( input  );
    
    nqrec := NqReadOutput( InputTextString( str ) );

    ##  First we construct the group from the collector
    coll := NqInitFromTheLeftCollector( nqrec );
    A    := NqPcpGroupByCollector( coll, nqrec );
    gens := GeneratorsOfGroup( A );

    ##  Now we set up the epimorphism
    images := List( nqrec.Images, w->NqPcpElementByWord( coll, w ) );
    phi := GroupHomomorphismByImages( G, A, GeneratorsOfGroup( G ), images );

    SetIsSurjective( phi, true );

    return phi;
end );

InstallMethod( LowerCentralFactors,
        "of a finitely presented group",
        true,
        [ IsFpGroup, IsPosInt ], 
        0, 
function( G, cl )
    local   nq,  pres,  input,  str,  output,  options,  ret,  nqrec,  
            eds,  M,  ed;

    pres    := NqStringFpGroup( G );
    input   := InputTextString( pres );
    str     := "";
    output  := OutputTextString( str, true );
    options := [ String(cl) ];

    NqCallANU_NQ( input, output, options );
    
    nqrec := NqReadOutput( InputTextString( str ) );

    eds := [];
    for M in nqrec.LowerCentralFactors do
        ed := ElementaryDivisorsMat( M );
        ed := Concatenation( ed, List( [Length(ed)+1..Length(M[1])], x->0 ) );
        ed := ed{[ PositionNot( ed, 1 ) .. Length(ed) ]};
        Add( eds, ed );
    od;
    return eds;
end );

#############################################################################
##
#F  NilpotentEngelQuotient( <F>, <engel>, <class> ) . . . . . Engel nq of <F>
##
InstallGlobalFunction( NilpotentEngelQuotient,
function( arg )
    local   n,  i;

    ## The first integer is the Engel parameter.
    n := First( arg, IsInt );
    i := Position( arg, n );

    arg := Concatenation( arg{[1..i-1]}, arg{[i+1..Length(arg)]} );

    NqOneTimeOptions := [ "-e", String(n) ];
    return CallFuncList( NilpotentQuotient, arg );
end );
    
