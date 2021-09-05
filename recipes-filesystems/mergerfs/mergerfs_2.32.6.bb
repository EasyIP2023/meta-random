
SUMMARY = "Mergerfs union filesystem"
DESCRIPTION = "mergerfs is a union filesystem geared towards simplifying storage and management of files across numerous commodity storage devices"

LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8edc8effbabde5b1c0835c3235a15b0e"

PR = "r0"

SRC_URI = "https://github.com/trapexit/mergerfs/releases/download/${PV}/${BPN}-${PV}.tar.gz"
SRC_URI[md5sum] = "9a09fb370803de2cec0d9b2ffa07156f"
SRC_URI[sha256sum] = "4e28a4d58bfe7bc07d5bd71a736e2e246f1fbbf48e90289c3d0b504a1288fc21"

S = "${WORKDIR}/${PN}-${PV}"

PREFIXDIR = "/usr/local"

INSANE_SKIP_${PN} += "already-stripped"

EXTRA_OEMAKE = "\
  'PREFIX=${D}${PREFIXDIR}' \
  'SBINDIR=${D}${base_sbindir}' \
  'STRIP=${TARGET_PREFIX}strip' \
"

TARGET_CC_ARCH += "${TARGET_LINK_HASH_STYLE}"

do_configure() {
  sed -i -e "s:STRIP     =:STRIP     ?=:g" \
         -e "s:PREFIX        =:PREFIX        ?=:g" \
  ${S}/Makefile

  sed -i -e "s:SBINDIR       =:SBINDIR       ?=:g" \
         -e "s:PREFIX        =:PREFIX        ?=:g" \
         -e 's:strip --strip-all:${TARGET_PREFIX}strip --strip-all:g' \
  ${S}/libfuse/Makefile
}

do_install() {
  install -d ${D}${PREFIXDIR} ${D}${base_sbindir}
  oe_runmake install
}

FILES_${PN} += "\
  ${base_sbindir} \
  ${PREFIXDIR} \
"
