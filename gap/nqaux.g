#############################################################################
##
#W  nqaux.g                  GAP4 Package `NQ'                  Werner Nickel
##
#H  @(#)$Id$
##
##  This file contains auxiliary functions for the NQ package.
##

#############################################################################
##
#F  BuildNQManual( ) . . . . . . . . . . . . . . . . . . . build the manual
##
##  This function builds the manual of the NQ package in the file formats
##  &LaTeX;, DVI, Postscript, PDF and HTML.
##
##  This is done using the GAPDoc package by Frank L\"ubeck and
##  Max Neunh\"offer.
##
BuildNQManual := function ( )

  local  Manual, NqDir;

  NqDir := Concatenation( DIRECTORIES_LIBRARY.pkg[1]![1], "nq/" );
  MakeGAPDocDoc( Concatenation( NqDir, "doc/" ), "nqnew",
                 [ "nq.bib" ], "nq", "../../../" );
end;
MakeReadOnlyGlobal( "BuildNQManual" );

#############################################################################
##
#E  nqaux.g . . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
