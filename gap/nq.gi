##############################################################################
##
#A  nq.gi                       Mai  1999                        Werner Nickel
##
##  This file contains the interface to my NQ program.
##

#############################################################################
##
#F  NqUsage() . . . . . . . . . . . . . . . show usage of 'NilpotentQuotient'
##
InstallGlobalFunction( NqUsage, function()

  return Error("usage: NilpotentQuotient( <file>|<fpgroup> [,<class>] )");

end );



#############################################################################
##
#F  NqGlobalVariables . . . . .  declare the global variables in this package
##
NqGlobalVariables := [ "NqLowerCentralFactors",   ##  factors of the LCS
                       "NqNrGenerators",
                       "NqClass",
                       "NqRanks",
                       "NqRelativeOrders",
                       "NqImages",                ##  the epimorphism
                       "NqPowers",
                       "NqConjugates",
                     ];

for var in NqGlobalVariables do
    if not IsBoundGlobal( var ) then
        var := "to be used by the nq share package";
    fi;
od;

#############################################################################
##
#F  NqReadOutput  . . . . . . . . . . . . . .  read output from nq standalone
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
    
    return result;

end );


#############################################################################
##
#F  NqInitFromTheLeftCollector  . . . . . . . . . initialise an ftl collector
##
InstallGlobalFunction( NqInitFromTheLeftCollector,
function( nqrec )
    local   ftl,  g,  rel;

    ftl := FromTheLeftCollector( nqrec.NrGenerators );

    for g in [1..nqrec.NrGenerators] do
        SetRelativeOrder( ftl, g, nqrec.RelativeOrders[ g ] );
    od;

    for rel in nqrec.Powers do
        SetPower( ftl, rel[1], rel{[2..Length(rel)]}  );
    od;

    for rel in nqrec.Conjugates do
        SetConjugate( ftl, rel[1], rel[2], rel{[3..Length(rel)]}  );
    od;

    SetFeatureObj( ftl, IsConfluent, true );
    UpdatePolycyclicCollector( ftl );

    return ftl;

end );

#############################################################################
##
#F  NqPcpGroupByCollector . . . . . . . . . pcp group from collector, set lcs
##
InstallGlobalFunction( NqPcpGroupByCollector,
function( coll, nqrec )
    local   G,  gens,  ranks,  lcs,  a,  z,  r;

    G := PcpGroupByCollectorNC( coll );
    gens := GeneratorsOfGroup( G );

    ranks := nqrec.Ranks;
    lcs   := [ G ];

    a     := 1; 
    z     := nqrec.NrGenerators;
    for r in ranks do
        a := a + r;
        Add( lcs, Subgroup( G, gens{[a..z]} ) );
    od;

    SetLowerCentralSeriesOfGroup( G, lcs );
    SetIsNilpotentGroup( G, true );

    return G;
end );



#############################################################################
##
#F  NqStringFpGroup( <fp> ) . . . . . . .  finitely presented group to string
##

InstallGlobalFunction( NqStringFpGroup,
function( G )
    local   F,  fgens,  V,  vgens,  str,  g,  r;

    F     := FreeGroupOfFpGroup( G );
    fgens := GeneratorsOfGroup( F );
    
    V     := FreeGroup( Length( fgens ), "x" );
    vgens := GeneratorsOfGroup( V );
    
    str := "";
    Append( str, "< " );
    
    for g in vgens do
	Append( str, String( g ) );
        Append( str, ", " );
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
#F  NilpotentQuotient( <F>, <class> ) . . . . . . . nilpotent quotient of <F>
##
##  The interface to the NQ standalone.  
##
##  This should produce a quotient system and not a collector.
##
InstallMethod( NilpotentQuotient,
        "of a finitely presented group",
        true,
        [ IsFpGroup, IsPosInt ], 
        0,
function( G, cl )
    local   nq,  pres,  input,  str,  output,  ret,  nqrec,  coll;

    nq      := Filename( DirectoriesPackagePrograms( "nq") , "nq" );

    pres   := NqStringFpGroup( G );
    input  := InputTextString( pres );
    str    := "";
    output := OutputTextString( str, true );

    ##  nq -g -p cl < input > output 
    ret    := Process( DirectoryCurrent(),        ## executing directory
                      nq,                         ## executable
                      input,                      ## input  stream
                      output,                     ## output stream
                      [ "-g", "-p", String(cl) ] );
                                                  ## command line arguments
    CloseStream( output );
    CloseStream( input  );
    
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
    local   nq,  pres,  input,  output,  ret,  nqrec,  coll;

    nq      := Filename( DirectoriesPackagePrograms( "nq") , "nq" );

    pres   := NqStringFpGroup( G );
    input  := InputTextString( pres );

    output := OutputTextFile( outfile, false );

    ##  nq -g -p infile cl < /dev/null > output 
    ret    := Process( DirectoryCurrent(),        ## executing directory
                       nq,                        ## executable
                       input,                     ## input  stream
                       output,                    ## output stream
                       [ "-g", "-p", String(cl) ] ); 
                                                  ## command line arguments
    CloseStream( output );
    CloseStream( input  );

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
    local   outfile,  output,  nq,  ret,  nqrec,  coll;

    ##  Check if <infile> exists and is readable

    outfile := TmpName();
    output  := OutputTextFile( outfile, false );
    nq      := Filename( DirectoriesPackagePrograms( "nq") , "nq" );

    ##  nq -g -p infile cl < /dev/null > output 
    ret     := Process( DirectoryCurrent(),        ## executing directory
                       nq,                         ## executable
                       InputTextNone(),            ## input  stream
                       output,                     ## output stream
                       [ "-g", "-p", infile, String(cl) ] );
                                                   ## command line arguments
    CloseStream( output );
    
    nqrec := NqReadOutput( InputTextFile( outfile ) );

    RemoveFile( outfile );

    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );


InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group on file, keep output file",
        true, 
        [ IsString, IsString, IsPosInt ], 
        0,
function( outfile, infile, cl )
    local   nq,  output,  ret,  nqrec,  coll;

    ##  Check if <infile> exists and is readable and if <outfile> can be
    ##  written.

    nq      := Filename( DirectoriesPackagePrograms( "nq" ) , "nq" );

    output := OutputTextFile( outfile, false );
    ret    := Process( DirectoryCurrent(),         ## executing directory
                       nq,                         ## executable
                       InputTextNone(),            ## input  stream
                       output,                     ## output stream
                       [ "-g", "-p", infile, String(cl) ] );
                                                   ## command line arguments
    CloseStream( output );

    nqrec := NqReadOutput( InputTextFile( outfile ) );
    coll  := NqInitFromTheLeftCollector( nqrec );

    return NqPcpGroupByCollector( coll, nqrec );
end );

InstallMethod( NqEpimorphismNilpotentQuotient,
        "of a finitely presented group",
        true,
        [ IsFpGroup, IsPosInt ], 
        0, 
function( G, cl )
    local   nq,  pres,  input,  str,  output,  ret,  nqrec,  coll,  A,  
            gens,  images,  phi;

    nq      := Filename( DirectoriesPackagePrograms( "nq") , "nq" );

    pres   := NqStringFpGroup( G );
    input  := InputTextString( pres );
    str    := "";
    output := OutputTextString( str, true );
    ret    := Process( DirectoryCurrent(),        ## executing directory
                      nq,                         ## executable
                      input,                      ## input  stream
                      output,                     ## output stream
                      [ "-g", "-p", String(cl) ] );
                                                  ## command line arguments
    CloseStream( output );
    CloseStream( input  );
    
    nqrec := NqReadOutput( InputTextString( str ) );

    ##  First we construct the group from the collector
    coll := NqInitFromTheLeftCollector( nqrec );
    A    := NqPcpGroupByCollector( coll, nqrec );
    gens := GeneratorsOfGroup( A );

    ##  Now we set up the epimorphism
    images := List( nqrec, Images, w->PcpElementByWord( coll, w ) );
    phi := GroupHomomorphismByImages( G, A, GeneratorsOfGroup( G ), images );

    SetIsSurjective( phi, true );

    return phi;
end );

