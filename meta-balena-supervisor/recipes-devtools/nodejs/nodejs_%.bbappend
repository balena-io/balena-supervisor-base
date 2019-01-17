GYP_DEFINES_append_i386-nlp = " v8_target_arch='x87' "

DEPENDS_remove = "icu"
ARCHFLAGS_append=" --with-intl=none"

PACKAGES_remove = "${PN}-npm"
FILES_${PN}-npm = ""
RDEPENDS_${PN}-npm = ""
