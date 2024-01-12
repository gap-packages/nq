#############################################################################
##
##  PackageInfo.g                  NQ                           Werner Nickel
##
##  Based on Frank Lübeck's template for PackageInfo.g.
##

SetPackageInfo( rec(

PackageName := "nq",
Subtitle := "Nilpotent Quotients of Finitely Presented Groups",
Version := "2.5.11",
Date    := "12/01/2024", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec( LastName      := "Horn",
       FirstNames    := "Max",
       IsAuthor      := false,
       IsMaintainer  := true,
       Email         := "mhorn@rptu.de",
       WWWHome       := "https://www.quendi.de/math",
       PostalAddress := Concatenation(
                          "Fachbereich Mathematik\n",
                          "RPTU Kaiserslautern-Landau\n",
                          "Gottlieb-Daimler-Straße 48\n",
                          "67663 Kaiserslautern\n",
                          "Germany" ),
       Place         := "Kaiserslautern, Germany",
       Institution   := "RPTU Kaiserslautern-Landau"
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

PackageWWWHome := "https://gap-packages.github.io/nq/",
README_URL     := Concatenation(~.PackageWWWHome, "README.md"),
PackageInfoURL := Concatenation(~.PackageWWWHome, "PackageInfo.g"),
ArchiveURL     := Concatenation("https://github.com/gap-packages/nq/",
                                "releases/download/v", ~.Version,
                                "/nq-", ~.Version),
ArchiveFormats := ".tar.gz .tar.bz2",
SourceRepository := rec(
  Type := "git",
  URL := "https://github.com/gap-packages/nq"
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
AbstractHTML   := Concatenation(
  "This package provides access to the ANU nilpotent quotient ",
  "program for computing nilpotent factor groups of finitely ",
  "presented groups."
  ),


PackageDoc := rec(
  BookName  := "nq",
  ArchiveURLSubset := [ "doc" ],
  HTMLStart := "doc/chap0_mj.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Nilpotent Quotient Algorithm",
),

Dependencies := rec(
  GAP                    := ">= 4.9",
  NeededOtherPackages    := [ ["polycyclic", "2.11"] ],
  SuggestedOtherPackages := [  ],
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
  "  maintained by Max Horn (mhorn@rptu.de)\n"
  ),

TestFile := "tst/testall.g",

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
        Copyright := """
            <Index>License</Index>
            &copyright; 1992-2007 Werner Nickel<P/>
            The &nq; package is free software;
            you can redistribute it and/or modify it under the terms of the
            <URL Text="GNU General Public License">https://www.fsf.org/licenses/gpl.html</URL>
            as published by the Free Software Foundation; either version 2 of the License,
            or (at your option) any later version.""",
        Acknowledgements := """
            The author of ANU NQ is Werner Nickel.

            <P/>The development of this program was started while the
            author was supported by an Australian National University PhD
            scholarship and an Overseas Postgraduate Research Scholarship.

            <P/>Further development of this program was done with support from the
            DFG-Schwerpunkt-Projekt <Q>Algorithmische Zahlentheorie und Algebra</Q>.

            <P/>Since then, maintenance of ANU NQ has been taken over by Max Horn. All
            credit for creating ANU NQ still goes to Werner Nickel as sole author.
            However, bug reports and other inquiries should be sent to Max Horn.

            <P/>The following are the original acknowledgements by Werner Nickel.

            <P/>Over the years a number of people have made useful suggestions
            that found their way into the code:  Mike Newman, Michael
            Vaughan-Lee, Joachim Neubüser, Charles Sims.

            <P/>Thanks to Volkmar Felsch and Joachim Neubüser for their careful
            examination of the package prior to its release for GAP 4.

            <P/>This documentation was prepared with the <Package>GAPDoc</Package>
            package by Frank Lübeck and Max Neunhöffer.""",
    ),
),

));
