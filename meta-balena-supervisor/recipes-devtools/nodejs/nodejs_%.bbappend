FILESEXTRAPATHS_append := ":${TOPDIR}/../meta-nodejs/recipes-devtools/${PN}/files"
GYP_DEFINES_append_i386-nlp = " v8_target_arch='x87' "
