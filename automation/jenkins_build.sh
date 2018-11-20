#!/bin/bash

set -ex

BUILD_CONTAINER_NAME=yocto-build-$$

print_help() {
	echo -e "Script options:\n\
	\t\t -a | --arch\n\
	\t\t\t (mandatory) Architecture to build for. This is a mandatory argument\n
	\t\t -t | --tag\n\
	\t\t\t (mandatory) Image tag to build. This is a mandatory argument. When it's master, an additional vX.Y.Z tag will be pushed.\n
	\t\t --shared-dir\n\
	\t\t\t (mandatory) Directory where to store shared downloads and shared sstate.\n
	\t\t --preserve-container\n\
	\t\t\t (optional) Do not delete the yocto build docker container when it exits.\n\
	\t\t --push\n\
	\t\t\t (optional) Push the built image.\n\
\t\t\t\t Default is to build the image but not push it.\n"
}

cleanup() {
	echo "[INFO] $0: Cleanup."

	# Stop docker container
	echo "[INFO] $0: Cleaning up yocto-build container."
	docker stop $BUILD_CONTAINER_NAME 2> /dev/null || true
	docker rm --volumes $BUILD_CONTAINER_NAME 2> /dev/null || true

	if [ "$1" = "fail" ]; then
		exit 1
	fi
}
trap 'cleanup fail' SIGINT SIGTERM

rootdir="$( cd "$( dirname "$0" )" && pwd )/../"
WORKSPACE=${WORKSPACE:-$rootdir}
REMOVE_CONTAINER="--rm"
PUSH="false"

# process script arguments
args_number="$#"
while [[ $# -ge 1 ]]; do
	arg=$1
	case $arg in
		-h|--help)
			print_help
			exit 0
			;;
		-a|--arch)
			if [ -z "$2" ]; then
				echo "-a|--arch argument needs an architecture name"
				exit 1
			fi
			ARCH="$2"
			;;
		-t|--tag)
			if [ -z "$2" ]; then
				echo "-t|--tag argument needs a tag name"
				exit 1
			fi
			TAG="$2"
			;;
		--shared-dir)
			if [ -z "$2" ]; then
				echo "--shared-dir needs directory name where to store shared downloads and sstate data"
				exit 1
			fi
			JENKINS_PERSISTENT_WORKDIR="$2"
			;;
		--preserve-container)
			REMOVE_CONTAINER=""
			;;
		--push)
			PUSH="true"
			;;
	esac
	shift
done

JENKINS_DL_DIR=$JENKINS_PERSISTENT_WORKDIR/shared-downloads
JENKINS_SSTATE_DIR=$JENKINS_PERSISTENT_WORKDIR/$ARCH/sstate

# Sanity checks
if [ -z "$ARCH" ] || [ -z "$JENKINS_PERSISTENT_WORKDIR" ]; then
	echo -e "\n[ERROR] You are missing one of these arguments:\n
\t -a <ARCH>\n
\t --shared-dir <PERSISTENT_WORKDIR>\n
Run with -h or --help for a complete list of arguments.\n"
	exit 1
fi

# Make sure shared directories are in place
mkdir -p $JENKINS_DL_DIR
mkdir -p $JENKINS_SSTATE_DIR

# Run build
docker stop $BUILD_CONTAINER_NAME 2> /dev/null || true
docker rm --volumes $BUILD_CONTAINER_NAME 2> /dev/null || true

docker run ${REMOVE_CONTAINER} \
    -v $WORKSPACE:/yocto/resin-board \
    -v $WORKSPACE/out:/dest \
    -v $JENKINS_DL_DIR:/yocto/shared-downloads \
    -v $JENKINS_SSTATE_DIR:/yocto/shared-sstate \
    -e BUILDER_UID=$(id -u) \
    -e BUILDER_GID=$(id -g) \
    -e ARCH=$ARCH \
    --name $BUILD_CONTAINER_NAME \
    resin/yocto-build-env \
    bash -ex /yocto/resin-board/build.sh

docker build -t balena/$ARCH-supervisor-base:$TAG $WORKSPACE

if [ "$PUSH" = "true" ]; then
	docker push balena/$ARCH-supervisor-base:$TAG

	VERSION_TAG=v$(jq --raw-output .version package.json)
	GIT_TAG=$(git describe --tags | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' || echo "")
	echo "git tag is '$GIT_TAG' and package.json version is '$VERSION_TAG'"
	if [ "${VERSION_TAG}" = "${GIT_TAG}" ]; then
		docker tag balena/$ARCH-supervisor-base:$TAG balena/$ARCH-supervisor-base:$VERSION_TAG
		docker push balena/$ARCH-supervisor-base:$VERSION_TAG
	fi
fi
