#############################################################################
##
#A  nqrest.gi                   Mai  1999                       Werner Nickel
##
##  This file contains dummy functions for the interface to the share package
##  ``polycyc''.


#############################################################################
##
#F  NqInitFromTheLeftCollector  . . . . . . . . . initialise an ftl collector
##
InstallGlobalFunction( NqInitFromTheLeftCollector,
function( nqrec )
    local   ftl,  g,  rel;

    Error( "This function is only available if the share package",
           "``polycyc'' is installed." );

end );

#############################################################################
##
#F  NqPcpGroupByCollector . . . . . . . . . pcp group from collector, set lcs
##
InstallGlobalFunction( NqPcpGroupByCollector,
function( coll, nqrec )

    Error( "This function is only available if the share package",
           "``polycyc'' is installed." );

end );


#############################################################################
##
#F  NqPcpElementByWord  . . . . . .  pcp element from generator exponent list
##
InstallGlobalFunction( NqPcpElementByWord, x->Ignore(x) );
