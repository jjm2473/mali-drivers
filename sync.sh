#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: sync.sh {UPSTREAM_SOURCE_DIR}" >&2
	exit 1
fi

if ! [ -d "$1" ]; then
	echo "$1 does not existed or not a dir" >&2
	exit 1
fi

UPSTREAM_SOURCE_DIR="${1}"
if ! [ "$UPSTREAM_SOURCE_DIR" = "/" ]; then
	UPSTREAM_SOURCE_DIR="${UPSTREAM_SOURCE_DIR%%/}"
fi

[ -d "$UPSTREAM_SOURCE_DIR/drivers/gpu/arm" ] || {
	echo "$UPSTREAM_SOURCE_DIR does not contain drivers/gpu/arm" >&2
	exit 1
}

rm -rf drivers/gpu/arm include/uapi/gpu/arm
mkdir -p drivers/gpu/arm include/uapi/gpu/arm

echo "copy drivers/gpu/arm include/uapi/gpu/arm"
cp -a "$UPSTREAM_SOURCE_DIR/drivers/gpu/arm" drivers/gpu/
cp -a "$UPSTREAM_SOURCE_DIR/include/uapi/gpu/arm" include/uapi/gpu/
rm -rf drivers/gpu/arm/valhall include/uapi/gpu/arm/valhall
rm -f drivers/gpu/arm/bifrost/mali_csffw.bin

find include -type f | grep -v -e '^include/compat/' -e '^include/uapi/gpu/arm/' | xargs -n1 sh -c 'echo "copy $0" ; cp -a "'"$UPSTREAM_SOURCE_DIR"'/$0" "$0"'
