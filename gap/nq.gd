##############################################################################
##
#A  nq.gd                       Mai  1999                        Werner Nickel
##
##  This file contains the interface to my NQ program.


DeclareGlobalFunction( "NqUsage" );
DeclareGlobalFunction( "NqReadOutput" );
DeclareGlobalFunction( "NqStringFpGroup" );

DeclareOperation( "NilpotentQuotient", [ IsObject, IsPosInt ] );
DeclareOperation( "NqEpimorphismNilpotentQuotient", [ IsObject, IsPosInt ] );
