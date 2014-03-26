#############################################################################
##  
##  PackageInfo.g                  NQ                           Werner Nickel
##  
##  Based on Frank Lübeck's template for PackageInfo.g.
##  

SetPackageInfo( rec(

PackageName := "nq",
Subtitle := "Nilpotent Quotients of Finitely Presented Groups",
Version := "2.4dev",
Date    := "12/01/2012",
##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "2.4dev">
##  <!ENTITY RELEASEDATE "12 January 2012">
##  <#/GAPDoc>

Persons := [
  rec( LastName      := "Horn",
       FirstNames    := "Max",
       IsAuthor      := false,
       IsMaintainer  := true,
       Email         := "max.horn@math.uni-giessen.de",
       WWWHome       := "http://www.quendi.de/math.php",
       PostalAddress := Concatenation( "AG Algebra\n",
                                       "Mathematisches Institut\n",
                                       "Justus-Liebig-Universität Gießen\n",
                                       "Arndtstraße 2\n",
                                       "35392 Gießen\n",
                                       "Germany" ),
       Place         := "Gießen, Germany",
       Institution   := "Justus-Liebig-Universität Gießen"
     ),

  rec( LastName      := "Nickel",
       FirstNames    := "Werner",
       IsAuthor      := true,
       IsMaintainer  := false,
       # MH: Werner rarely (if at all) replies to emails sent to this
       # old email address. To discourage users from sending bug reports
       # there, I have disabled it here.
       #Email         := "nickel@mathematik.tu-darmstadt.de",
       WWWHome       := "http://www.mathematik.tu-darmstadt.de/~nickel/",
     )

],

Status         := "accepted",
CommunicatedBy := "Joachim Neubüser (RWTH Aachen)",
AcceptDate     := "01/2003",

PackageWWWHome := "http://www.icm.tu-bs.de/ag_algebra/software/NQ/",

ArchiveFormats := ".tar.gz .tar.bz2",
ArchiveURL     := Concatenation( ~.PackageWWWHome, "nq-", ~.Version ),
README_URL     := Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

AbstractHTML   := Concatenation( 
  "This package provides access to the ANU nilpotent quotient ",
  "program for computing nilpotent factor groups of finitely ",
  "presented groups."
  ),

                  
PackageDoc := rec(
  BookName  := "nq",
  ArchiveURLSubset := [ "doc" ],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Nilpotent Quotient Algorithm",
  Autoload  := false
),

Dependencies := rec(
  GAP                    := ">= 4.4",
  NeededOtherPackages    := [ ["polycyclic", "1.0"] ],
  SuggestedOtherPackages := [ ["GAPDoc", "1.3"] ],
  ExternalConditions     := [ "needs a UNIX system with C-compiler",
                              "needs GNU multiple precision library" ]
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

BannerString     := Concatenation(
  "Loading nq ", ~.Version, " (Nilpotent Quotient Algorithm)\n",
  "  by Werner Nickel\n",
  "  maintained by Max Horn (max.horn@math.uni-giessen.de)\n"
  ),

Autoload := false,

TestFile := "gap/nq.tst",

Keywords := [
  "nilpotent quotient algorithm",
  "nilpotent presentations",
  "finitely presented groups",
  "finite presentations   ",
  "commutators",
  "lower central series",
  "identical relations",
  "expression trees",
  "nilpotent Engel groups",
  "right and left Engel elements",
  "computational"
  ],

AutoDoc := rec(
    TitlePage := rec(
        Copyright := "&copyright; 1992-2007 Werner Nickel.",
        Acknowledgements := "\
            The author of ANU NQ is Werner Nickel.\
            \
            <P/>The development of this program was started while the\
            author was supported by an Australian National University PhD\
            scholarship and an Overseas Postgraduate Research Scholarship.\
            \
            <P/>Further development of this program was done with support from the\
            DFG-Schwerpunkt-Projekt \"`Algorithmische Zahlentheorie und Algebra\"'.\
            \
            <P/>Since then, maintenance of ANU NQ has been taken over by Max Horn. All\
            credit for creating ANU NQ still goes to Werner Nickel as sole author.\
            However, bug reports and other  inquiries should be sent to Max  Horn.\
            \
            <P/>The following are the original acknowledgements by Werner Nickel.\
            \
            <P/>Over the years a number of people have made useful suggestions\
            that found their way into the code:  Mike Newman, Michael\
            Vaughan-Lee, Joachim Neubüser, Charles Sims.\
            \
            <P/>Thanks to Volkmar Felsch and Joachim Neubüser for their careful\
            examination of the package prior to its release for GAP 4.\
            \
            <P/>This documentation was prepared with the <Package>GAPDoc</Package>\
            package by Frank Lübeck and Max Neunhöffer.",
        Subtitle := "\
            A &GAP; 4 Package<Br/>\
            computing nilpotent factor groups of finitely presented groups<Br/>\
            <Br/>\
            Based on the ANU Nilpotent Quotient Program",
        # HACK: We don't want a TitleComment, for now the best we can do is show an empty one
        TitleComment := "",
    ),
),

));
