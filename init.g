#############################################################################
##
#W    init.g               share package 'nq'                   Werner Nickel
##
##    @(#)$Id$
##

if TestPackageAvailability( "GAPDoc", "" ) <> fail then
    HideGlobalVariables( "BANNER" );
    BANNER := false;
    RequirePackage( "gapdoc" );
    UnhideGlobalVariables( "BANNER" );
else
    Info( InfoWarning, 1, "GAPDoc not available" );
fi;

##
##    Announce the package version and test for the existence of the package 
##    polycyclic and the binary.
##
DeclarePackage( "nq", "2.0",

  function()
    local path;

    if TestPackageAvailability( "polycyclic", "1.0" ) <> fail then
        RequirePackage( "polycyclic" );
    else
        Info( InfoWarning, 1, "polycyclic not available" );
        return fail;
    fi;

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
