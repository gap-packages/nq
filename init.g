#############################################################################
##
#W    init.g               share package 'nq'                   Werner Nickel
##
##    @(#)$Id$
##

RequirePackage( "polycyc" );

##
##    Announce the package version and test for the existence of the binary.
DeclarePackage("nq","1.3",
  function()
    local path,file;
    # test for existence of the compiled binary
    path := DirectoriesPackagePrograms("nq");
    file := Filename(path,"nq");
    if file = fail then
        Info(InfoWarning,1,
             "Package ``nq'': The executable program is not compiled");
    fi;
    return true; ## file<>fail;
end );

# install the documentation
DeclarePackageAutoDocumentation( "nq", "doc" );

