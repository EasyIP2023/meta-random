LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=5b2c53b113bbcc0036c9903d4c8e7c8d"

PR = "r0"

SRC_URI = "https://github.com/git-lfs/git-lfs/releases/download/v${PV}/${BPN}-v${PV}.tar.gz"
SRC_URI[md5sum] = "502d702888ae0c6fc07792cd13bcc321"
SRC_URI[sha256sum] = "f8bd7a06e61e47417eb54c3a0db809ea864a9322629b5544b78661edab17b950"

DEPENDS = "go-cross-${TUNE_PKGARCH}"

S = "${WORKDIR}/${PN}-${PV}"

TARGET_LDFLAGS_pn-${PN} = "${TARGET_LINK_HASH_STYLE}"
SECURITY_LDFLAGS_pn-${PN} = ""

# Skip make clean step
CLEANBROKEN = "1"

INSANE_SKIP_${PN} += "already-stripped"

def get_arch(d):
  if d.getVar("TARGET_ARCH", True) == "aarch64":
    return "arm64"
  elif d.getVar("TARGET_ARCH", True) == "arm":
    return "arm"
  else:
    return "none"

# List of Go (Golang) GOOS and GOARCH
# https://gist.github.com/asukakenji/f15ba7e588ac42795f421b48b8aede63
do_install() {
  install -d ${D}${bindir}
  oe_runmake GOARCH="${@get_arch(d)}" GOOS="linux"
  install -m 0755 ${S}/bin/${PN} ${D}${bindir}
}
