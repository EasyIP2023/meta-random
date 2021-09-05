# https://github.com/openembedded/meta-openembedded/blob/master/meta-multimedia/recipes-multimedia/x265/x265_3.2.1.bb
# A Modified version of the x265 recipe that should contain support for arm platform

SUMMARY = "H.265/HEVC video encoder"
DESCRIPTION = "A free software library and application for encoding video streams into the H.265/HEVC format."
HOMEPAGE = "http://www.videolan.org/developers/x265.html"

LICENSE = "GPLv2"
LICENSE_FLAGS = "commercial"
LIC_FILES_CHKSUM = "file://COPYING;md5=c9e0427bc58f129f99728c62d4ad4091"

DEPENDS = "nasm-native gnutls zlib libpcre"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

# Similar patch can found
# https://archlinuxarm.org/packages/aarch64/x265/files/arm.patch
SRC_URI = "\
  git://git@github.com/videolan/${BPN}.git;protocol=https;branch=master;tag=${PV} \
  file://00001-arm.patch \
"

S = "${WORKDIR}/git"

OECMAKE_SOURCEPATH = "${WORKDIR}/git/source"

inherit lib_package pkgconfig cmake

EXTRA_OECMAKE_append_x86 = " -DENABLE_ASSEMBLY=OFF"

AS[unexport] = "1"

COMPATIBLE_HOST = '(arm|aarch64|x86_64|i.86).*-linux'
