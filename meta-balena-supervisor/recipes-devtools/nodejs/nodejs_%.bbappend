GYP_DEFINES_append_i386-nlp = " v8_target_arch='x87' "
FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"
SRC_URI_append = " \
    file://0001-dns-add-verbatim-option-to-dns.lookup.patch \
    "
