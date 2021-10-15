# Original can be found here
# https://github.com/openembedded/openembedded/blob/master/recipes/netpbm/netpbm_10.28.bb

DESCRIPTION = "Netpbm is a toolkit for manipulation of graphic images, including\
conversion of images between a variety of different formats.  There\
are over 220 separate tools in the package including converters for\
about 100 graphics formats."
HOMEPAGE = "http://netpbm.sourceforge.net"
SECTION = "console/utils"

LICENSE = "GPLv2 & LGPLv2"
LIC_FILES_CHKSUM = "\
  file://doc/GPL_LICENSE.txt;md5=079b27cd65c86dbc1b6997ffde902735 \
  file://doc/lgpl_v21.txt;md5=7fbc338309ac38fefcd64b04bb903e34 \
"

PR = "r0"

BBCLASSEXTEND = "native"

# NOTE: individual command line utilities are covered by different
# licenses.  The compiled and linked command line utilties are
# subject to the licenses of the libraries they use too - including
# libpng libz, IJG, and libtiff licenses
DEPENDS = "jpeg zlib libpng libxml2 tiff libx11 flex-native"
RDEPENDS_${PN} = "\
  perl \
	perl-module-cwd \
	perl-module-english \
	perl-module-fcntl \
	perl-module-file-basename \
	perl-module-file-spec \
	perl-module-getopt-long \
	perl-module-strict \
"

# these should not be required, they are here because the perl
# module dependencies are currently incorrect:
RDEPENDS_${PN} += "perl-module-exporter-heavy"
RDEPENDS_${PN} += "perl-module-file-spec-unix"

# Files where taken from and updated:
#   * https://github.com/openembedded/openembedded/blob/master/recipes/netpbm/netpbm-10.28/Makefile.config
#   * https://github.com/openembedded/openembedded/blob/master/recipes/netpbm/files/oeendiangen
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SVN_MODULE = "super_stable"
SRC_URI = "\
  svn://svn.code.sf.net/p/netpbm/code;module=${SVN_MODULE};protocol=svn;rev=r4129 \
  file://libgnuhash.patch \
  file://ppmtojpeg.patch \
  file://config.mk \
  file://oeendiangen \
"

S = "${WORKDIR}/${SVN_MODULE}"

# Remove format security warnings
SECURITY_CFLAGS_pn-${PN} = "${SECURITY_STACK_PROTECTOR} ${SECURITY_PIE_CFLAGS}"

PARALLEL_MAKE = ""

EXTRA_OEMAKE = "'ENDIANGEN=${S}/buildtools/oeendiangen' 'TARGET_LD=${LD}'"

do_patch() {
  mv ${WORKDIR}/libgnuhash.patch ${S}
  mv ${WORKDIR}/ppmtojpeg.patch ${S}

  cd ${S}
  patch -p0 < libgnuhash.patch
  patch -p0 < ppmtojpeg.patch
}

do_configure() {
	install -c -m 644 ${WORKDIR}/config.mk ${S}
	# The following stops the host endiangen program being run and uses
	# the target endian.h header instead.
	install -c -m 755 ${WORKDIR}/oeendiangen ${S}/buildtools
}

do_compile() {
	# need all to get the static library too
	oe_runmake all default
}

do_install() {
	# netpbm makes its own installation package, which must then be
	# installed to form the dummy installation for ipkg
	rm -rf ${WORKDIR}/netpbm-package
	oe_runmake package pkgdir=${WORKDIR}/netpbm-package
	# now install the stuff from the package into ${D}
	for d in ${WORKDIR}/netpbm-package/*
	do
		# following will cause an error if used
		case "$d" in
		*/README)	;;
		*/VERSION)	;;
		*/pkginfo)	;;
		*/bin)		install -d ${D}${bindir}
				cp -pPR "$d"/* ${D}${bindir}
				rm ${D}${bindir}/doc.url;;
		*/include)	install -d ${D}${includedir}
				cp -pPR "$d"/* ${D}${includedir};;
		*/link|*/lib)	install -d ${D}${libdir}
				cp -pPR "$d"/* ${D}${libdir};;
		*/man*)		install -d ${D}${mandir}
				cp -pPR "$d"/* ${D}${mandir};;
		*/misc)		install -d ${D}${datadir}/netpbm
				cp -pPR "$d"/* ${D}${datadir}/netpbm;;
    */web)		install -d ${D}${datadir}/web
				cp -pPR "$d"/* ${D}${datadir}/web;;
    */pkgconfig_template)
      install -d ${D}${libdir}/pkgconfig/
      sed "/^@/d
        s!@VERSION@!$(<'${WORKDIR}/netpbm-package/VERSION')!
        s!@LINKDIR@!${libdir}!
        s!@INCLUDEDIR@!${includedir}!
        " "$d" >${D}${libdir}/pkgconfig/netpbm.pc
        chmod 755 ${D}${libdir}/pkgconfig/netpbm.pc;;
		*/config_template)
				install -d ${D}${bindir}
				sed "/^@/d
					s!@VERSION@!$(<'${WORKDIR}/netpbm-package/VERSION')!
					s!@DATADIR@!${datadir}/netpbm!
					s!@LIBDIR@!${libdir}!
					s!@LINKDIR@!${libdir}!
					s!@INCLUDEDIR@!${includedir}!
					s!@BINDIR@!${bindir}!
					" "$d" >${D}${bindir}/netpbm-config
				chmod 755 ${D}${bindir}/netpbm-config;;
		*)		echo "netpbm-package/$d: unknown item" >&2
				exit 1;;
		esac
	done
}

FILES_${PN} += "\
  /usr/share/ \
"
