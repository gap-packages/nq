#############################################################################
##  
##  PkgInfo.g                      NQ                           Werner Nickel
##  
##  Based on Frank Lübeck's template for PkgInfo.g.
##  

SetPackageInfo( rec(

PkgName := "nq",
Version := "2.0",
Date    := "15/01/2003",

Persons := [
  rec(
  LastName      := "Nickel",
  FirstNames    := "Werner",
  IsAuthor      := true,
  IsMaintainer  := true,
  Email         := "nickel@mathematik.tu-darmstadt.de",
  WWWHome       := "http://www.mathematik.tu-darmstadt.de/~nickel",
  PostalAddress := Concatenation( "Fachbereich Mathematik, AG2 \n",
                                  "TU Darmstadt\n",
                                  "Schlossgartenstr. 7\n",
                                  "64289 Darmstadt\n",
                                  "Germany" ),
  Place         := "Darmstadt, Germany",
  Institution   := "Fachbereich Mathematik, TU Darmstadt"
  )
],

Status         := "accepted",
CommunicatedBy := "Joachim Neubüser (RWTH Aachen)",
AcceptDate     := "01/2003",

PackageWWWHome := 
        "http://www.mathematik.tu-darmstadt.de/~nickel/software/nq/",

ArchiveFormats := ".tar.gz",
ArchiveURL     := Concatenation( ~.PackageWWWHome, "software/nq/nq" ),
README_URL     := Concatenation( ~.PackageWWWHome, "README" ),
PkgInfoURL     := Concatenation( ~.PackageWWWHome, "PkgInfo.g" );

AbstractHTML   := Concatenation( 
               "This package provides access to the ANU nilpotent quotient ",
               "program for computing nilpotent factor groups of finitely ",
               "presented groups." );

                  
##  If not all of the archive formats mentioned above are provided, these 
##  can be produced at the GAP side. Therefore it is necessary to know which
##  files of the package distribution are text files which should be unpacked
##  with operating system specific line breaks. There are the following 
##  possibilities to specify the text files:
##  
##    - specify below a component 'TextFiles' which is a list of names of the 
##      text files, relative to the package root directory (e.g., "lib/bla.g")
##    - specify below a component 'BinaryFiles' as list of names, then all other
##      files are taken as text files.
##    - if no 'TextFiles' or 'BinaryFiles' are given and a .zoo archive is
##      provided, then the files in that archive with a "!TEXT!" comment are
##      taken as text files
##    - otherwise: exactly the files with names matching the regular expression
##      ".*\(\.txt\|\.gi\|\.gd\|\.g\|\.c\|\.h\|\.htm\|\.html\|\.xml\|\.tex\|\.six\|\.bib\|\.tst\|README.*\|INSTALL.*\|Makefile\)"
##      are taken as text files
##  
##  (Remark: Just providing a .tar.gz file will often result in useful
##  archives)
##  
##  These entries are *optional*.
#TextFiles := ["init.g", ......],
#BinaryFiles := ["doc/manual.dvi", ......],

##  On the GAP Website there is an online version of all manuals in the
##  GAP distribution. To handle the documentation of a package it is
##  necessary to have:
##     - an archive containing the package documentation (in at least one 
##       of HTML or PDF-format, preferably both formats)
##     - the start file of the HTML documentation (if provided), *relative to
##       package root*
##     - the PDF-file (if provided) *relative to the package root*
##  For links to other package manuals or the GAP manuals one can assume 
##  relative paths as in a standard GAP installation. 
##  Also, provide the information which is currently given in your packages 
##  init.g file in the command DeclarePackage(Auto)Documentation
##  (for future simplification of the package loading mechanism).
##  
##  Please, don't include unnecessary files (.log, .aux, .dvi, .ps, ...) in
##  the provided documentation archive.
##  
# in case of several help books give a list of such records here:
PackageDoc := rec(
  BookName  := "nq",
  Archive   := Concatenation( ~.PackageWWWHome, "nq.tar.gz" );
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Nilpotent Quotient Algorithm",
  AutoLoad  := false
),

Dependencies := rec(
  GAP                    := ">= 4.2",
  NeededOtherPackages    := [ ["polycyclic", ">= 1.0"] ],
  SuggestedOtherPackages := [ ["GAPDoc", ">= 0.99"] ],
  ExternalConditions     := [ "needs a UNIX system with C-compiler" ]
),

AvailabilityTest := function()
    local   path;
    
    # test for existence of the compiled binary
    path := DirectoriesPackagePrograms( "nq" );

    if Filename( path, "nq" ) = fail then
        Info( InfoWarning, 1,
              "Package ``nq'': The executable program is not available" );
        return fail;
    fi;
    return true;
end,

Autoload := false,

##  *Optional*, but recommended: path relative to package root to a file which 
##  contains as many tests of the package functionality as sensible.
#TestFile := "tst/testall.g",

Keywords := ["nilpotent quotient", "finitely presented group"],

));


