FILESEXTRAPATHS_append := ":${THISDIR}/${PN}"
SRC_URI += "file://no-gobject-introspection.patch"

do_configure_prepend() {
    # We deactivate gobject-introspection but the bbclass insists to copy this
    # m4 file. Let's give it something to copy.
    touch ${STAGING_DIR_TARGET}/${datadir}/aclocal/introspection.m4
}
