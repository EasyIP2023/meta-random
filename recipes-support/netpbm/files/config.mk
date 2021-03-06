# This is the configuration file for OpenEmbedded
# It is a generic file for *all* architectures supported by
# OpenEmbedded.
#
# This is a make file inclusion, to be included in all the Netpbm make
# files.

# This file is meant to contain variable settings that customize the
# build for a particular target system configuration.

# The distribution contains the file Makefile.config.in.  You edit
# Makefile.config.in in ways relevant to your particular environment
# to create Makefile.config.  The "configure" program will do this
# for you in simple cases.

# Some of the variables that the including make file must set for this
# file to work:
#
#  SRCDIR: The directory at the top of the Netpbm source tree.  Note that
#  this is typically a relative directory, and it must be relative to the
#  make file that includes this file.

DEFAULT_TARGET = merge

# Fiasco has some special requirements that make it fail to compile on
# some systems, and since it isn't very important, just set this to "N"
# and skip it on those systems unless you want to debug it and fix it.
# OpenBSD:
#BUILD_FIASCO = N
BUILD_FIASCO = Y

# The following are commands for the build process to use.  These values
# do not get built into anything.

# The C compiler (including macro preprocessor)
#CC = gcc

# The linker.
LD = $(CC)

#If the linker identified above is a compiler that invokes a linker
#(as in 'cc foo.o -o foo'), set LINKERISCOMPILER.  The main difference is
#that we expect a compiler to take linker options in the '-Wl,-opt1,val1'
#syntax whereas the actual linker would take '-opt1 val1'.
LINKERISCOMPILER=Y

#LINKER_CAN_DO_EXPLICIT_LIBRARY means the linker specified above can
#take a library as just another link object argument, as in 'ld
#pnmtojpeg.o /usr/local/lib/libjpeg.so ...'  as opposed to requiring a
#-l option as in 'ld pnmtojpeg.o -L/usr/local/lib -l jpeg'.
#This variable controls how 'libopt' gets built.  Note that with some
#linkers, you can specify a shared library explicitly, but then it has
#to live in that exact place at run time.  That's not good enough for us.
LINKER_CAN_DO_EXPLICIT_LIBRARY=Y

# This is the name of the header file that declares the types
# uint32_t, etc.  This name is used as #include $(INTTYPES_H)  .
# Set to null if the types come automatically without including anything.
INTTYPES_H = <inttypes.h>

# HAVE_INT64 tells whether, assuming you include the header indicated by
# INTTYPES_H, you have the int64_t type and related stuff.  (If you don't
# the build will omit certain code that does 64 bit computations).
HAVE_INT64 = Y

# CC and LD are for building the Netpbm programs, which are not necessarily
# intended to run on the same system on which Make is running.  But when we
# build a build tool such as Libopt, it is meant to run only on the same
# system on which the Make is running.  The variables below define programs
# to use to compile and link build tools.
CC_FOR_BUILD = $(BUILD_CC)
LD_FOR_BUILD = $(BUILD_CC)
CFLAGS_FOR_BUILD = $(CFLAGS_CONFIG)
LDFLAGS_FOR_BUILD = $(LDFLAGS)

#CC_FOR_BUILD = $(CC)
#LD_FOR_BUILD = $(LD)
#CFLAGS_FOR_BUILD = $(CFLAGS_CONFIG)
#LDFLAGS_FOR_BUILD = $(LDFLAGS)

# MAKE is set automatically by Make to what was used to invoke Make.

INSTALL = install

# STRIPFLAG is the option you pass to the above install program to make it
# strip unnecessary information out of binaries.
STRIPFLAG =

SYMLINK = ln -s

#MANPAGE_FORMAT is "nroff" or "cat".  It determines in what format the
#pointer man pages are installed (ready to nroff, or ready to cat).
#A pointer man pages is just a single-paragraph pages that tells you there is
#no man page for the program, to look at the HTML documentation instead.
MANPAGE_FORMAT = nroff

LEX = flex

# EXE is a suffix that the linker puts on any executable it generates.
# In cygwin, this is .exe and most programs deal with its existence without
# us having to know about it.  Some don't though, so set this:
EXE =

# linker options.

# Linker options for created Netpbm shared libraries.

# Here, $(SONAME) resolves to the soname for the shared library being created.
# The following are gcc options.  This works on GNU libc systems.
LDSHLIB = -shared -fpic -Wl,-soname,$(SONAME)

# LDRELOC is the command to combine two .o files (relocateable object files)
# into a single .o file that can later be linked into something else.  NONE
# means no such command is available.
LDRELOC = $(TARGET_LD) --reloc

# On older systems, you have to make shared libraries out of position
# independent code, so you need -fpic or fPIC here.  (The rule is: if
# -fpic works, use it.  If it bombs, go to fPIC).  On newer systems,
# it isn't necessary, but can save real memory at the expense of
# execution speed.  Without position independent code, the library
# loader may have to patch addresses into the executable text.  On an
# older system, this would cause a program crash because the loader
# would be writing into read-only shared memory.  But on newer
# systems, the system silently creates a private mapping of the page
# or segment being modified (the "copy on write" phenomenon).  So it
# needs its own private real page frame.  In one experiment, A second
# copy of Pbmtext used 16K less real memory when built with -fpic than
# when built without.  2001.06.02.

# We have seen -fPIC required on IA64 and AMD64 machines (GNU
# compiler/linker).  Build-time linking fails without it.  I don't
# know why -- history seems to be repeating itself.  2005.02.23.

CFLAGS_SHLIB = -fpic

# SHLIB_CLIB is the link option to include the C library in a shared library,
# normally "-lc".  On typical systems, this serves no purpose.  On some,
# though, it causes information about which C library to use to be recorded
# in the shared library and thus choose the correct library among several or
# avoid using an incompatible one.  But on some systems, the link fails.
# On 2002.09.30, "John H. DuBois III" <spcecdt@armory.com> reports that on
# SCO OpenServer, he gets the following error message with -lc:
#
#  -lc; relocations referenced  ;  from file(s) /usr/ccs/lib/libc.so(random.o);
#   fatal error: relocations remain against allocatable but non-writable
#   section: ; .text

SHLIB_CLIB =

# On some systems you have to build into an executable the list of
# directories where its dynamically linked libraries can be found at
# run time.  This is typically done with a -R or -rpath linker
# option.  Even on systems that don't require it, you might prefer to do
# that rather than set up environment variables or configuration files
# to tell the system where the libraries are.  A "Y" here means to put
# the directory information in the executable at link time.
NEED_RUNTIME_PATH = Y

# RPATHOPTNAME is the option you use on the link command to specify
# a runtime search path for a shared library.  It is meaningless unless
# NEED_RUNTIME_PATH is Y.
RPATHOPTNAME = -rpath

# The following variables tell where your various libraries on which
# Netpbm depends live.  The LIBxxx variable is a full file
# specification of the link library (not necessarily the library used
# at run time).  e.g. "/usr/local/lib/graphics/libpng.so".  It usually
# doesn't matter if the library prefix and suffix are right -- you can
# use "lib" and ".so" or ".a" regardless of what your system actually
# uses because these just turn into "-L" and "-l" linker options
# anyway.  ".a" implies a static library for some purposes, though.
# If you don't have the library in question, use a value of NONE for
# LIBxxx and the build will simply skip the programs that require that
# library.  If the library is in your linker's (or the Netpbm build's)
# default search path, leave off the directory part, e.g. "libpng.so".

# The xxxHDR_DIR variable is the directory in which the interface
# headers for the library live (e.g. /usr/include).  If they are in your
# compiler's default search path, set this variable to null.

# This is where the Netpbm shared libraries will reside when Netpbm is
# fully installed.  In some configurations, the Netpbm builder builds
# this information into the Netpbm executables.  This does NOT affect
# where the Netpbm installer installs the libraries.  A null value
# means the libraries are in a default search path used by the runtime
# library loader.
NETPBMLIB_RUNTIME_PATH = $(libdir)
#NETPBMLIB_RUNTIME_PATH = /usr/lib/netpbm

# The TIFF library.  See above.  If you want to build the tiff
# converters, you must have the tiff library already installed.

TIFFLIB = libtiff.so
TIFFHDR_DIR =

# Some TIFF libraries do Jpeg and/or Z (flate) compression and thus any
# program linked with the TIFF library needs a Jpeg and/or Z library.
# Some TIFF libraries have such library statically linked in, but others
# need it to be dynamically linked at program load time.
# Make this 'N' if youf TIFF library doesn't need such dynamic linking.
# As of 2005.01, the most usual build of the TIFF library appears to require
# both.
TIFFLIB_NEEDS_JPEG = Y
TIFFLIB_NEEDS_Z = Y

# The JPEG library.  See above.  If you want to build the jpeg
# converters you must have the jpeg library already installed.

# Tiff files can use JPEG compression, so the Tiff library can reference
# the JPEG library.  If your Tiff library references a dynamic JPEG
# library, you must specify at least JPEGLIB here, or the Tiff
# converters will not build.  Note that your Tiff library may have the
# JPEG stuff statically linked in, in which case you won't need
# JPEGLIB in order to build the Tiff converters.

JPEGLIB = libjpeg.so
JPEGHDR_DIR =

# The PNG library.  See above.  If you want to build the PNG
# converters you must have the PNG library already installed.

# The PNG library, by convention starting around April 2002, gets installed
# with names that include a version number, such as libpng10.a and header
# files in /usr/include/libpng10.
# option.
PNGLIB = libpng.so
PNGHDR_DIR =
PNGVER =

# The zlib compression library.  See above.  You need it to build
# anything that needs the PNG library (see above).  If you selected
# NONE for the PNG library, it doesn't matter what you specify here --
# it won't get used.
ZLIB = libz.so
ZHDR_DIR =

# The JBIG lossless image compression library (aka JBIG-KIT):
JBIGLIB = $(INTERNAL_JBIGLIB)
# $(BUILDDIR)/converter/other/jbig/libjbig.a
JBIGHDR_DIR = $(INTERNAL_JBIGHDR_DIR)
# $(SRCDIR)/converter/other/jbig/libjbig/include/

# The Jasper JPEG-2000 image compression library (aka JasPer):
JASPERLIB = $(INTERNAL_JASPERLIB)
JASPERHDR_DIR = $(INTERNAL_JASPERHDR_DIR)
# JASPERDEPLIBS is the libraries (-l options or file names) on which
# The Jasper library depends -- i.e. what you have to link into any
# executable that links in the Jasper library.
JASPERDEPLIBS =
#JASPERDEPLIBS = -ljpeg

# And the Utah Raster Toolkit (aka URT aka RLE) library:
URTLIB = $(BUILDDIR)/urt/librle.a
URTHDR_DIR = $(SRCDIR)/urt

# The X11 library has facilities for talking to an X Window System
# server.  It is required by Pamx.

X11LIB = libx11.so
X11HDR_DIR =

# The Linux SVGA library (Svgalib) is a facility for displaying graphics
# on the Linux console.  It is required by Ppmsvgalib.
LINUXSVGALIB = NONE
LINUXSVGAHDR_DIR =

# If you don't want any network functions, set OMIT_NETWORK to "y".
# The only thing that requires network functions is the option in
# ppmtompeg to run it on multiple computers simultaneously.  On some
# systems network functions don't work or we haven't figured out how to
# make them work, or they just aren't worth the effort.
OMIT_NETWORK =

# These are -l options to link in the network libraries.  Often, these are
# built into the standard C library, so this can be null.  This is irrelevant
# if OMIT_NETWORK is "y".
NETWORKLD =

VMS =
#VMS:
#VMS = yes

# DONT_HAVE_PROCESS_MGMT is Y if this system doesn't have the usual
# Unix process management stuff - fork, wait, etc.  N for a regular Unix
# system.
DONT_HAVE_PROCESS_MGMT = N

# The following variables are used only by 'make install' (and the
# variants of it).  Paths here don't, for example, get built into any
# programs.

# This is where everything goes when you do 'make package', unless you
# override it by setting 'pkgdir' on the Make command line.
PKGDIR_DEFAULT = /tmp/netpbm

# This is where test results are written when you do 'make check', unless
# you override it by setting 'resultdir' on the Make command line.
RESULTDIR_DEFAULT = /tmp/netpbm-test

# Subdirectory of the package directory ($(pkgdir)) in which man pages
# go.
PKGMANDIR = man

# File permissions for installed files.
# Note that on some systems (e.g. Solaris), 'install' can't use the
# mnemonic permissions - you have to use octal.

# binaries (pbmmake, etc)
INSTALL_PERM_BIN =  755       # u=rwx,go=rx
# shared libraries (libpbm.so, etc)
INSTALL_PERM_LIBD = 755       # u=rwx,go=rx
# static libraries (libpbm.a, etc)
INSTALL_PERM_LIBS = 644       # u=rw,go=r
# header files (pbm.h, etc)
INSTALL_PERM_HDR =  644       # u=rw,go=r
# man pages (pbmmake.1, etc)
INSTALL_PERM_MAN =  644       # u=rw,go=r
# data files (pnmtopalm color maps, etc)
INSTALL_PERM_DATA = 644       # u=rw,go=r

# Specify the suffix that want the man pages to have.

SUFFIXMANUALS1 = 1
SUFFIXMANUALS3 = 3
SUFFIXMANUALS5 = 5

#NETPBMLIBTYPE tells the kind of libraries that will get built to hold the
#Netpbm library functions.  The value is used only in make file tests.
# "unixshared" means a unix-style shared library, typically named like
# libxyz.so.2.3
NETPBMLIBTYPE = unixshared
# "unixstatic" means a unix-style static library, (like libxyz.a)
#NETPBMLIBTYPE = unixstatic
# "dll" means a Windows DLL shared library
#NETPBMLIBTYPE = dll
# "dylib" means a Darwin/Mac OS shared library
#NETPBMLIBTYPE = dylib

#NETPBMLIBSUFFIX is the suffix used on whatever kind of library is
#selected above.  All this is used for is to construct library names.
#The make files never examine the actual value.
NETPBMLIBSUFFIX = so

# "a" is the suffix for unix-style static libraries.  It is also
# traditionally used for shared libraries on AIX.  The Visual Age C
# manual says sometimes .so works on AIX, and GNU software for AIX
# 5.1.0 does indeed use it.  In our experiments, it works fine if you
# name the library file explicitly on the link, but isn't in the -l
# search order.  If you name the library explicitly on the link, the
# library must live in exactly the same position at run time, so we
# can't use that.  Therefore, you cannot build both static and shared
# libraries with AIX.  You have to choose.
#NETPBMLIBSUFFIX = a
# For HP-UX shared libraries:
#NETPBMLIBSUFFIX = sl
# Darwin/Mac OS shared library:
#NETPBMLIBSUFFIX = dylib
# Windows shared library:
#NETPBMLIBSUFFIX = dll

#STATICLIB_TOO is "y" to signify that you want a static library built
#and installed in addition to whatever library type you specified by
#NETPBMLIBTYPE.  If NETPBMLIBTYPE specified a static library,
#STATICLIB_TOO simply has no effect.
STATICLIB_TOO = y
#STATICLIB_TOO = n

#STATICLIBSUFFIX is the suffix that static libraries have.  It's
#meaningless if you aren't building static libraries.
STATICLIBSUFFIX = a

#SHLIBPREFIXLIST is a blank-delimited list of prefixes that a filename
#of a shared library may have on this system.  Traditionally, it's
#just "lib", as in libc or libnetpbm.  On Windows, though, varying
#prefixes are used when multiple alternative forms of a library are
#available.  The first prefix in this list is what we use to name the
#Netpbm shared libraries.
#
# This variable controls how 'libopt' gets built.
#
SHLIBPREFIXLIST = lib

NETPBMSHLIBPREFIX = $(firstword $(SHLIBPREFIXLIST))

#DLLVER is used to version the DLLs built on cygwin or other
#windowsish platforms.  We can't add this to LIBROOT, or we'd
#version the static libs (which is bad).  We can't add this
#at the end of the name (like unix does with so numbers) because
#windows will only load dlls whose name ends in "dll".  So,
#we have this variable, which becomes the end of the library "root" name
#for DLLs only.
#
# This variable controls how 'libopt' gets built.
#
DLLVER =
#Cygwin
#DLLVER = $(NETPBM_MAJOR_RELEASE)

#NETPBM_DOCURL is the URL of the main documentation page for Netpbm.
#This is a directory which contains a file for each Netpbm program,
#library, and file type.  E.g. The documentation for jpegtopnm might be in
#http://netpbm.sourceforge.net/doc/jpegtopnm.html .  This value gets
#installed in the man pages (which say no more than to read the webpage)
#and in the Webman netpbm.url file.
NETPBM_DOCURL = http://netpbm.sourceforge.net/doc/
#For a system with no web access, but a local copy of the doc:
#NETPBM_DOCURL = file:/usr/doc/netpbm/

# RGB_DB_PATH is where Netpbm looks for the color database when the RGBDEF
# environment variable is not set.  See pm_config_in.h for details.
RGB_DB_PATH = /usr/share/netpbm/rgb.txt:/usr/lib/X11/rgb.txt:/usr/share/X11/rgb.txt:/usr/X11R6/lib/X11/rgb.txt
