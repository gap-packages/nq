dnl ##
dnl ## Process this file with autoconf to produce a configure script.
dnl ##
AC_PREREQ([2.68])
AC_INIT([ANU Nilpotent Quotient Program], m4_esyscmd([tr -d '\n' < VERSION]), [https://github.com/gap-system/nq/issues], [nq])
AC_CONFIG_SRCDIR([src/nq.c])
AC_CONFIG_HEADER(src/config.h:src/config.hin)
AC_CONFIG_AUX_DIR([cnf])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([1.11 -Wall foreign subdir-objects])
AM_SILENT_RULES([yes])
AM_MAINTAINER_MODE

dnl ##
dnl ## C is the language
dnl ##
AC_LANG([C])

dnl ##
dnl ## Checks for programs.
dnl ##
AC_PROG_AWK
AC_PROG_CC
AC_PROG_MAKE_SET
AC_PROG_MKDIR_P
AC_PROG_SED

dnl ##
dnl ## Checks for system header files.
dnl ##
AC_CHECK_HEADERS([stdlib.h string.h sys/time.h])


dnl ##
dnl ## Locate the GAP root dir
dnl ##

# HACK: We used to support --with-gap-root, but this got renamed to
# --with-gaproot for compatibility with other packages (io, orb, cvec,
# ...). But existing build scripts may use the old name, so we translate
# it to the new name here.
# Note: configure warns if --with-gap-root is used, calling
# it an unrecognized option.
if test "${with_gaproot+set}" != set; then :
  if test "${with_gap_root+set}" = set; then :
    with_gaproot=$with_gap_root
  fi
fi

AC_FIND_GAP


dnl ##
dnl ## Check whether to use 32bit or 64bit ABI
dnl ##
AC_CHECK_SIZEOF(void *, 4)

AC_ARG_VAR(ABI, [Set this equal to 32 or 64 to build nq
		 in 32- or 64-bit mode. The default value
		 for this option is determined by testing the behaviour of your
		 compiler, so should be 32 on a 32-bit system and 64 on one
		 which is 64-bit.])

AC_MSG_CHECKING([ABI bit size])
if test "x$ABI" = "x" ;  then
  if test $ac_cv_sizeof_void_p = 8; then
    ABI="64"
  else
    ABI="32"
  fi
  ABI_CFLAGS=""
elif test "$ABI" = "64"; then
  if test $ac_cv_sizeof_void_p = 4; then
    AC_MSG_ERROR([ ABI=64 cannot be used on a 32-bit system.
                   Please replace this value with 32 and retry configure.
                   If you think this error is wrong, email
                   support@gap-system.org with full details.])
  else
    ABI_CFLAGS="-m64"
  fi
elif test "$ABI" = "32"; then
  ABI_CFLAGS="-m32"
else
  AC_MSG_ERROR([ $ABI is not a supported value for ABI. Please use ABI=64
                 or 32, or leave it unset.])
fi

AC_MSG_RESULT([$ABI])

AC_SUBST(ABI)
AC_SUBST(ABI_CFLAGS)

dnl ##
dnl ## Check for GMP
dnl ## If the user specified a specific GMP, try to use that.
dnl ## Otherwise, first try to use the GMP provided by GAP, or
dnl ## any GMP version installed globally by the user.
dnl ##

GMP_CPPFLAGS=
GMP_LIBS=

AC_ARG_WITH([gmp],
	[AS_HELP_STRING([--with-gmp=PATH],
	  [ Use GMP library.
        If the argument you supply is "yes" or <empty>, then the version of GMP bundled with GAP will be used (default).
        If the argument is "system" that means the library is reachable with the standard
        search path "/usr" or "/usr/local".
        Otherwise you give the <path> to the directory which contains the library.
        [[default=yes]]
    ])],
  [], [ with_gmp=yes ]
)

if test "x$with_gmp" = "xno" ; then
	AC_MSG_ERROR([GMP is required, cannot build without it])
elif test "x$with_gmp" = "xsystem" ; then
	# Try using system GMP
	GMP_CPPFLAGS=""
	GMP_LIBS="-lgmp"
else
	# Try using static linked GMP in the specified location
	if test "x$with_gmp" = "xyes" ; then
		# Try to use GAP's GMP, if available
		GMP_HOME="$GAPROOT/bin/$GAPARCH/extern/gmp"
	else
		GMP_HOME="$with_gmp"
	fi;
	if test -d ${GMP_HOME}/include && test -f ${GMP_HOME}/lib/libgmp.a ; then
		GMP_CPPFLAGS="-I${GMP_HOME}/include"
		GMP_LIBS="${GMP_HOME}/lib/libgmp.a"
	elif test "x$with_gmp" = "xyes" ; then
		# fallback to trying system wide GMP
		GMP_CPPFLAGS=""
		GMP_LIBS="-lgmp"
	else
		AC_MSG_ERROR([Could not locate libgmp.a in the specified location])
	fi
fi;

nq_save_CPPFLAGS="$CPPFLAGS"
CPPFLAGS="$CPPFLAGS $GMP_CPPFLAGS"
nq_save_LIBS="$LIBS"
LIBS="$LIBS $GMP_LIBS"

AC_CHECK_HEADER( [gmp.h],
	[
	# TODO: Disable linker check for now: It causes problems on Linux, because
	# libgmp.a is in the linker command line before the test C file. On the long
	# run, this should be re-enabled, though perhaps in a different form.
	AC_MSG_CHECKING([whether linking against GMP works])
	AC_TRY_LINK(
		[#include <gmp.h>],
		[__gmpz_init(0);] ,
		[AC_MSG_RESULT([yes])],
		[AC_MSG_ERROR([no])]
		)
	],
	[ AC_MSG_ERROR([Could not locate the GMP include file gmp.h.]) ]
	)

# restore FLAGS
CPPFLAGS="$nq_save_CPPFLAGS"
LIBS="$nq_save_LIBS"

AC_SUBST(GMP_CPPFLAGS)
AC_SUBST(GMP_LIBS)


dnl ##
dnl ## Checks for typedefs, structures, and compiler characteristics.
dnl ##
AC_TYPE_LONG_LONG_INT

dnl ##
dnl ## Checks for library functions.
dnl ##
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_CHECK_FUNCS([sbrk getrusage])

dnl ##
dnl ## Finally, generate the Makefiles and output everything
dnl ##
AC_CONFIG_FILES([Makefile examples/Makefile])
AC_OUTPUT
