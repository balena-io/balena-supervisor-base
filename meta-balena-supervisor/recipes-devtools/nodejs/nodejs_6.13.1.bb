SRC_URI_append = " file://0001-dns-add-verbatim-option-to-dns.lookup.patch"

# Be able to find the following inc file
FILESEXTRAPATHS_append := ":${THISDIR}/../../../meta-nodejs/recipes-devtools/${PN}/files"
require ${TOPDIR}/../meta-nodejs/recipes-devtools/nodejs/nodejs_6.inc

# nodejs 6 doesn't compile with openssl 1.1.x so use the openssl10 dependency
PACKAGECONFIG[openssl] = "--shared-openssl,,openssl10,"

INC_PR = "r1"

LIC_FILES_CHKSUM = "file://LICENSE;md5=14152103612601231d62308345463670"

SRC_URI[src.md5sum] = "4113198ff275c0a83f1170d8d5e7243f"
SRC_URI[src.sha256sum] = "649374430815aaf425b7b60621a9b7b072a1584cebc676d3cbf0ee4b9bbd94ee"
