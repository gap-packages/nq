##############################################################################
##
#A  nq.gd                   Oktober 2002                         Werner Nickel
##
##  This file contains the declaration part of the interface to my NQ program.


DeclareGlobalFunction( "NqReadOutput" );
DeclareGlobalFunction( "NqStringFpGroup" );
DeclareGlobalFunction( "NqStringExpTrees" );
DeclareGlobalFunction( "NqInitFromTheLeftCollector" );
DeclareGlobalFunction( "NqPcpGroupByCollector" );
DeclareGlobalFunction( "NqPcpElementByWord" );
DeclareGlobalFunction( "NqBuildManual" );

DeclareGlobalFunction( "NilpotentEngelQuotient" );

DeclareGlobalVariable( "NqGlobalVariables" );
DeclareGlobalVariable( "NqDefaultOptions" );
DeclareGlobalVariable( "NqOneTimeOptions" );
DeclareGlobalVariable( "NqRuntime" );

DeclareOperation( "LowerCentralFactors", [ IsObject, IsPosInt ] );

DeclareOperation( "NilpotentQuotient", 
        [ IsObject, IsPosInt ] );

DeclareOperation( "NilpotentQuotientIdentical", 
        [ IsObject, IsObject, IsPosInt ] );


DeclareOperation( "NqEpimorphismNilpotentQuotient", 
        [ IsObject, IsPosInt ] );
