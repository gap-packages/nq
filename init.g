#############################################################################
##
#W    init.g               share package 'nq'                   Werner Nickel
##
##    @(#)$Id$
##

##
##    Announce the package version and test for the existence of the package 
##    polycyclic and the binary.
##
DeclarePackage( "nq", "2.0",

  function()
    local path;

    is_available := TestPackageAvailability( "GAPDoc", "" );
    if is_available = fail then
        Info( InfoWarning, 1, 
              "Loading the nq package: GAPDoc not available" );
    elif is_available <> true then
        HideGlobalVariables( "BANNER" );
        BANNER := false;
        RequirePackage( "gapdoc" );
        UnhideGlobalVariables( "BANNER" );
    fi;

    is_available := TestPackageAvailability( "polycyclic", "1.0" );
    if is_available = fail then
        Info( InfoWarning, 1, 
              "Loading the nq package: package polycyclic must be available" );
        return fail;
    elif is_available <> true then
        HideGlobalVariables( "BANNER" );
        BANNER := false;
        RequirePackage( "polycyclic" );
        UnhideGlobalVariables( "BANNER" );
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
