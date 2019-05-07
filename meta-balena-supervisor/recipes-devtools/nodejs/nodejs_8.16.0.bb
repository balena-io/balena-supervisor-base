require recipes-devtools/nodejs/nodejs_8.12.0.bb

SRC_URI[md5sum] = "3c340a1599aa60bd920dc7e153bc1e4a"
SRC_URI[sha256sum] = "3515e8e01568a5dc4dff3d91a76ebc6724f5fa2fbb58b4b0c5da7b178a2f7340"

FILESEXTRAPATHS_append := ":${THISDIR}/../../../meta-openembedded/meta-oe/recipes-devtools/nodejs/nodejs"
