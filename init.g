#############################################################################
##
#W    init.g               share package 'nq'                   Werner Nickel
##
##    @(#)$Id$
##

if IsList( TestPackageAvailability( "gapdoc", "0.99" ) ) then
  OLD_BANNER := BANNER; MakeReadWriteGlobal( "BANNER" ); BANNER := false;
  RequirePackage( "gapdoc" );
  BANNER := OLD_BANNER; MakeReadOnlyGlobal( "BANNER" );
else
    Error( "GAPDoc not available" );
fi;

if TestPackageAvailability( "polycyclic", "1.0" ) <> fail then
    RequirePackage( "polycyclic" );
else
    Error( "polycyclic not available" );
fi;

##
##    Announce the package version and test for the existence of the binary.
##
DeclarePackage( "nq", "2.0",

  function()
    local path;

    # test for existence of the compiled binary
    path := DirectoriesPackagePrograms( "nq" );

    if Filename( path, "nq" ) = fail then
        Info( InfoWarning, 1,
              "Package ``nq'': The executable program is not available" );
        return fail;
    fi;

    return true;
end );

# install the documentation
DeclarePackageDocumentation( "nq", "doc", "ANU NQ", 
        "Computation of nilpotent quotients" );
