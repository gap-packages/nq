##############################################################################
##
#A  nq.gd                       Mai  1999                        Werner Nickel
##
##  This file contains the interface to my NQ program.


DeclareGlobalFunction( "NqUsage" );
DeclareGlobalFunction( "NqReadOutput" );
DeclareGlobalFunction( "NqStringFpGroup" );
DeclareGlobalFunction( "NqInitFromTheLeftCollector" );
DeclareGlobalFunction( "NqPcpGroupByCollector" );
DeclareGlobalFunction( "NqPcpElementByWord" );

DeclareOperation( "LowerCentralFactors", [ IsObject, IsPosInt ] );

DeclareOperation( "NilpotentQuotient", 
        [ IsObject, IsPosInt ] );

DeclareOperation( "NilpotentEngelQuotient", 
        [ IsObject, IsPosInt, IsPosInt ] );

DeclareOperation( "NqEpimorphismNilpotentQuotient", 
        [ IsObject, IsPosInt ] );
