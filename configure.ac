dnl ##
dnl ## Process this file with autoconf to produce a configure script.
dnl ##
AC_PREREQ([2.68])
AC_INIT([ANU Nilpotent Quotient Program],
        m4_normalize(m4_include([VERSION])),
        [https://github.com/gap-packages/nq/issues],
        [nq],
        [https://gap-packages.github.io/nq/])
AC_CONFIG_SRCDIR([src/nq.c])
AC_CONFIG_HEADERS(src/config.h:src/config.hin)
AC_CONFIG_AUX_DIR([cnf])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([1.11 -Wall foreign subdir-objects no-dist])
AM_SILENT_RULES([yes])

dnl For developer builds, maintainer mode is enabled by default. But for
dnl releases, the `.release` script changes this to "disabled by default".
dnl This avoids troubles during packaging, in particular when the GAP team
dnl repackages the source archive. Users can re-enable it by passing
dnl `--enable-maintainer-mode` to configure.
AM_MAINTAINER_MODE([enable])

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

FIND_GAP

dnl ##
dnl ## Checks for typedefs, structures, and compiler characteristics.
dnl ##
AC_TYPE_LONG_LONG_INT

dnl ##
dnl ## Checks for library functions.
dnl ##
AC_CHECK_FUNCS([getrusage])

dnl ##
dnl ## Finally, generate the Makefiles and output everything
dnl ##
AC_CONFIG_FILES([Makefile examples/Makefile])
AC_OUTPUT
