#############################################################################
##
#W    read.g               share package 'nq'                   Werner Nickel
##
##    @(#)$Id$
##

##
##    Read the actual code.  See if we have the package 'polycyclic' or
##    not.  We need at least version 1.0.
##
ReadPkg("nq", "gap/nq.gd");

if TestPackageAvailability( "polycyclic", "1.0" ) <> fail then

    ReadPkg("nq", "gap/nqpcp.gi");

else
    Info( InfoWarning, 1, 
          "Share package ``polycyc'' not available" );
    Info( InfoWarning, 1, 
          "    Loading reduced interface to ANU NQ" );

    ReadPkg("nq", "gap/nqrest.gi");
fi;

ReadPkg("nq", "gap/nq.gi");
