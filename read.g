#############################################################################
##
#W    read.g               share package 'nq'                   Werner Nickel
##
##    @(#)$Id$
##

##
##    Read the actual code.  When this file is read, it has been tried to
##    load ``polycyc''.  Therefore we can use RequirePackage() to check if
##    ``polycyc'' is available.
##
ReadPkg("nq", "gap/nq.gd");

if RequirePackage( "polycyc" ) = true then

    ReadPkg("nq", "gap/nqpcp.gi");

else
    Info( InfoWarning, 1, 
          "Share package ``polycyc'' not available" );
    Info( InfoWarning, 1, 
          "    Loading reduced interface to ANU NQ" );

    ReadPkg("nq", "gap/nqrest.gi");
fi;

ReadPkg("nq", "gap/nq.gi");
