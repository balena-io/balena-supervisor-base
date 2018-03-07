DESCRIPTION = "nodeJS Evented I/O for V8 JavaScript"
HOMEPAGE = "http://nodejs.org"
LICENSE = "MIT & BSD & Artistic-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e4d35c6120f175e1fbe5ff908b1cf2d6"

FILESEXTRAPATHS_prepend := "${TOPDIR}/../meta-oe/meta-oe/recipes-devtools/nodejs/nodejs:"
require ${TOPDIR}/../meta-oe/meta-oe/recipes-devtools/nodejs/nodejs_8.9.4.bb

SRC_URI[md5sum] = "e729aa13d06c35301150de6a876607fb"
SRC_URI[sha256sum] = "b17071109238295b9f363b768afdff97a9f386203d4f080c91847ce76d4f7e93"
