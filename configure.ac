dnl ##
dnl ## Process this file with autoconf to produce a configure script.
dnl ##
AC_PREREQ([2.68])
AC_INIT([ANU Nilpotent Quotient Program], m4_esyscmd([tr -d '\n' < VERSION]), [https://github.com/gap-packages/nq/issues], [nq], [http://gap-packages.github.io/nq/])
AC_CONFIG_SRCDIR([src/nq.c])
AC_CONFIG_HEADER(src/config.h:src/config.hin)
AC_CONFIG_AUX_DIR([cnf])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([1.11 -Wall foreign subdir-objects])
AM_SILENT_RULES([yes])
AM_MAINTAINER_MODE

dnl
dnl Setup libtool (for interfacing with GAP kernel extension)
dnl
LT_PREREQ([2.4.2])
LT_INIT

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
