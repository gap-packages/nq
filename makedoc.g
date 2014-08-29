#
# Generate the manual using AutoDoc
#
LoadPackage("AutoDoc", "2014.03.04");

SetPackagePath("nq", ".");
AutoDoc("nq" : scaffold := rec( MainPage := false ) );

PrintTo("VERSION", PackageInfo("nq")[1].Version);

QUIT;
