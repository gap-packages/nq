##############################################################################
##
#A  nq.gd                       Mai  1999                        Werner Nickel
##
##  This file contains the interface to my NQ program.


DeclareGlobalFunction( "NqReadOutput" );
DeclareGlobalFunction( "NqStringFpGroup" );
DeclareGlobalFunction( "NqStringExpTrees" );
DeclareGlobalFunction( "NqInitFromTheLeftCollector" );
DeclareGlobalFunction( "NqPcpGroupByCollector" );
DeclareGlobalFunction( "NqPcpElementByWord" );

DeclareGlobalVariable( "NqGlobalVariables" );
DeclareGlobalVariable( "NqDefaultOptions" );
DeclareGlobalVariable( "NqRuntime" );

DeclareOperation( "LowerCentralFactors", [ IsObject, IsPosInt ] );

DeclareOperation( "NilpotentQuotient", 
        [ IsObject, IsPosInt ] );

DeclareOperation( "NilpotentQuotientIdentical", 
        [ IsObject, IsObject, IsPosInt ] );

DeclareOperation( "NilpotentEngelQuotient", 
        [ IsObject, IsPosInt, IsPosInt ] );

DeclareOperation( "NqEpimorphismNilpotentQuotient", 
        [ IsObject, IsPosInt ] );
