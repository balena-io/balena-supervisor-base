#!/bin/bash

set -o errexit

BUILD_DIR='/home/builder/tmp'

case "$ARCH" in
'amd64')
	export TARGET_MACHINE='generic-x86-64'
;;
'i386')
	export TARGET_MACHINE='generic-x86'
;;
'rpi')
	export TARGET_MACHINE='generic-armv6'
;;
'armv7hf')
	export TARGET_MACHINE='generic-armv7hf'
;;
'armel')
	export TARGET_MACHINE='generic-armv5'
;;
'aarch64')
	export TARGET_MACHINE='generic-armv8'
;;
'i386-nlp')
	export TARGET_MACHINE='i386-nlp'
;;
esac

export SOURCE_DIR=/yocto/resin-board
export DEST_DIR=/dest
export SHARED_DOWNLOADS=/yocto/shared-downloads
export SHARED_SSTATE=/yocto/shared-sstate
# Make sure shared directories are in place
mkdir -p $SHARED_DOWNLOADS
mkdir -p $SHARED_SSTATE
mkdir -p $DEST_DIR

groupadd -g "$BUILDER_GID" builder
useradd -m -u "$BUILDER_UID" -g "$BUILDER_GID" builder
sudo -H -E -u builder \
	/bin/bash -c "mkdir -p $BUILD_DIR \
	&& cp -r $SOURCE_DIR/* $BUILD_DIR/ \
	&& cd $BUILD_DIR \
	&& TEMPLATECONF=$BUILD_DIR/build-samples/ source oe-core/oe-init-build-env build \
	&& BB_ENV_EXTRAWHITE=\"\$BB_ENV_EXTRAWHITE DL_DIR SSTATE_DIR\" DL_DIR=$SHARED_DOWNLOADS SSTATE_DIR=$SHARED_SSTATE MACHINE=$TARGET_MACHINE bitbake core-image-minimal"
cp $BUILD_DIR/build/tmp-glibc/deploy/images/$TARGET_MACHINE/core-image-minimal-$TARGET_MACHINE.tar.gz $DEST_DIR/rootfs.tar.gz
