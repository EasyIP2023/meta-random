SUMMARY = "STM32 Firmware Loader"
DESCRIPTION = "STM32 Firmware Loader used to burn .bin firmware images to STM32 microcontrollers using the built-in serial bootloader"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://MIT-LICENSE;md5=8107a433b1217fef4b995b1236bdb217"

PR = "r0"

SRC_URI = "git://git@github.com/jsnyder/stm32ld;protocol=https;branch=master"
SRCREV = "8295f4d642bb742243ca18d8c9acd003ccb188e7"

PV = "git+${SRCREV}"

S = "${WORKDIR}/git"

EXTRA_OEMAKE = "-e"

do_compile() {
  oe_runmake
}

do_install() {
  install -d ${D}${bindir}
  install -m 0755 ${S}/${PN} ${D}${bindir}
}
