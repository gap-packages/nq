#
# Generate the manual using AutoDoc
#
LoadPackage("AutoDoc", "2014.03.04");

SetPackagePath("nq", ".");
AutoDoc("nq" :
    scaffold := rec(
        bib := "nqbib.xml",
        includes := [
            "intro.xml",
            "general.xml",
            "functions.xml",
            "examples.xml",
            "install.xml",
        ],
        appendix := [ "cli.xml" ],
    )
);

PrintTo("VERSION", PackageInfo("nq")[1].Version);

QUIT;
