#############################################################################
##
#W    init.g               share package 'nq'                   Werner Nickel
##
##    @(#)$Id$
##

if TestPackageAvailability( "polycyclic", "1.0" ) <> fail then
    RequirePackage( "polycyclic" );
fi;

##
##    Announce the package version and test for the existence of the binary.

DeclarePackage( "nq", "1.3",

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
#DeclarePackageDocumentation( "nq", "doc" );

