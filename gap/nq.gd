##############################################################################
##
#A  nq.gd                   Oktober 2002                         Werner Nickel
##
##  This file contains the declaration part of the interface to my NQ program.
##

DeclareGlobalFunction( "NqReadOutput" );
DeclareGlobalFunction( "NqStringFpGroup" );
DeclareGlobalFunction( "NqStringExpTrees" );
DeclareGlobalFunction( "NqInitFromTheLeftCollector" );
DeclareGlobalFunction( "NqPcpGroupByCollector" );
DeclareGlobalFunction( "NqPcpGroupByNqOutput" );
DeclareGlobalFunction( "NqPcpElementByWord" );
DeclareGlobalFunction( "NqElementaryDivisors" );
DeclareGlobalFunction( "NqEpimorphismByNqOutput" );

DeclareGlobalFunction( "NilpotentEngelQuotient" );
DeclareGlobalFunction( "LowerCentralFactors" );


DeclareOperation( "NilpotentQuotient", 
        [ IsObject, IsPosInt ] );

DeclareOperation( "NilpotentQuotientIdentical", 
        [ IsObject, IsObject, IsPosInt ] );

DeclareOperation( "NqEpimorphismNilpotentQuotient", 
        [ IsObject, IsPosInt ] );

DeclareInfoClass( "InfoNQ" );
