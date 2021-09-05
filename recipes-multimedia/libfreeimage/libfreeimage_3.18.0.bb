
LICENSE = "GPLv2 & GPLv3 & FreeImage-Public-1.0"

LIC_FILES_CHKSUM = "\
  file://license-fi.txt;md5=8e1438cab62c8f655288588dc43daaf6 \
  file://license-gplv2.txt;md5=1fbed70be9d970d3da399f33dae9cc51 \
  file://license-gplv3.txt;md5=b5c176c43d7fb06bf6dd56e79c490f5b \
"

NO_GENERIC_LICENSE[FreeImage-Public-1.0] = "license-fi.txt"

LICENSE_${PN} = "FreeImage-Public-1.0"

PR = "r0"

SRC_URI = "${SOURCEFORGE_MIRROR}/freeimage/FreeImage3180.zip"
SRC_URI[md5sum] = "f8ba138a3be233a3eed9c456e42e2578"
SRC_URI[sha256sum] = "f41379682f9ada94ea7b34fe86bf9ee00935a3147be41b6569c9605a53e438fd"

S = "${WORKDIR}/FreeImage"

# Remove undefined reference to png_init_filter_functions_neon issue
# For aarch64 platform
TARGET_CFLAGS += "-DPNG_ARM_NEON_OPT=0"
INSANE_SKIP_${PN} += "already-stripped"

do_configure() {
  sed -i -e /ldconfig/d \
         -e s/'*.so'/'*.so.*'/g \
         -e s/'ln -sf $(VERLIBNAME)'/'ln -sf $(SHAREDLIB)'/g \
         -e s/'lib$(TARGET)-$(VER_MAJOR).$(VER_MINOR).so'/'lib$(TARGET).so.$(VER_MAJOR).$(VER_MINOR)'/g \
  ${S}/Makefile.gnu
}

do_install() {
  install -d ${D}${libdir} ${D}${includedir}
  oe_runmake INCDIR="${D}${includedir}" INSTALLDIR="${D}${libdir}" install
}
