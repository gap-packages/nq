##############################################################################
##
#A  nq.gi                       Mai  1999                        Werner Nickel
##
##  This file contains the interface to my NQ program.


#############################################################################
##
#F  NqUsage() . . . . . . . . . . . . . . . show usage of 'NilpotentQuotient'
##
InstallGlobalFunction( NqUsage,
function()
    return Error("usage: NilpotentQuotient( <file>|<fpgroup> [,<class>] )");
end );

#############################################################################
##
#F  NqGlobalVariables . . . . .  declare the global variables in this package
##
NqGlobalVariables := [ "NqLowerCentralFactors",   ##  factors of the LCS
                       "NqF",                     ##  the free group of the
                                                  ##  collector
                       "NqCollector",             ##  the collector
                       "NqImages" ];              ##  the epimorphism

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
        true, [ IsFpGroup, IsPosInt ], 0,
function( G, cl )
    local   nq,  pres,  input,  str,  output,  ret,  coll;

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
    
    coll := NqReadOutput( InputTextString( str ) ).Collector;
    SetFeatureObj( coll, IsConfluent, true );
    return coll;
end );

InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group, keep output file",
        true, [ IsString, IsFpGroup, IsPosInt ], 0,
function( outfile, G, cl )
    local   nq,  pres,  input,  str,  output,  ret,  coll;

    nq      := Filename( DirectoriesPackagePrograms( "nq") , "nq" );

    pres   := NqStringFpGroup( G );
    input  := InputTextString( pres );

    str    := "";
    output := OutputTextFile( outfile, false );

    ##  nq -g -p infile cl < /dev/null > output 
    ret    := Process( DirectoryCurrent(),        ## executing directory
                      nq,                         ## executable
                      input,                      ## input  stream
                      output,                     ## output stream
                      [ "-g", "-p", String(cl) ] ); 
                                                  ## command line arguments
    CloseStream( output );
    CloseStream( input  );

    coll := NqReadOutput( InputTextFile( outfile ) ).Collector;
    SetFeatureObj( coll, IsConfluent, true );
    return coll;
end );

InstallMethod( NilpotentQuotient,
        "of a finitely presented group on file",
        true, [ IsString, IsPosInt ], 0,
function( infile, cl )
    local   outfile,  output,  nq,  ret,  result,  coll;

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
    
    result := NqReadOutput( InputTextFile( outfile ) );

    RemoveFile( outfile );

    coll := result.Collector;
    SetFeatureObj( coll, IsConfluent, true );
    return coll;
end );


InstallOtherMethod( NilpotentQuotient,
        "of a finitely presented group on file, keep output file",
        true, [ IsString, IsString, IsPosInt ], 0,
function( outfile, infile, cl )
    local   nq,  output,  ret,  coll;

    ##  Check if <infile> exists and is readable and if <outfile> can be
    ##  written.

    nq      := Filename( DirectoriesPackagePrograms( "nq" ) , "nq" );

    output := OutputTextFile( outfile, true );
    ret    := Process( DirectoryCurrent(),         ## executing directory
                       nq,                         ## executable
                       InputTextNone(),            ## input  stream
                       output,                     ## output stream
                       [ "-g", "-p", infile, String(cl) ] );
                                                   ## command line arguments
    CloseStream( output );

    coll := NqReadOutput( InputTextFile( outfile ) ).Collector;
    SetFeatureObj( coll, IsConfluent, true );
    return coll;
end );

InstallMethod( NqEpimorphismNilpotentQuotient,
        "of a finitely presented group",
        true,
        [ IsFpGroup, IsPosInt ], 0, 
function( G, cl )
    local   nq,  pres,  input,  str,  output,  ret,  result,  F,  
            fgens,  A,  gens,  images,  phi;

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
    
    result := NqReadOutput( InputTextString( str ) );

    ##  First we construct the group from the collector
    F     := result.F;
    fgens := GeneratorsOfGroup( F );

    A    := PcpGroupByCollector( result.Collector );
    gens := GeneratorsOfGroup( A );

    images := List( result.Images, w->MappedWord( w, fgens, gens ) );

    phi := GroupHomomorphismByImages( G, A, GeneratorsOfGroup( G ), images );

    SetIsSurjective( phi, true );

    return phi;
end );

