#!/bin/bash

# HOST_DIR = host dir
# BOARD_DIR = board specific dir
# BUILD_DIR = base dir/build
# BINARIES_DIR = images dir
# TARGET_DIR = target dir
# BATOCERA_BINARIES_DIR = batocera binaries sub directory

HOST_DIR=$1
BOARD_DIR=$2
BUILD_DIR=$3
BINARIES_DIR=$4
TARGET_DIR=$5
BATOCERA_BINARIES_DIR=$6

mkdir -p "${BATOCERA_BINARIES_DIR}/boot/boot"     || exit 1
mkdir -p "${BATOCERA_BINARIES_DIR}/boot/extlinux" || exit 1

cp "${BINARIES_DIR}/zImage"          "${BATOCERA_BINARIES_DIR}/boot/boot/linux"           || exit 1
cp "${BINARIES_DIR}/modules"         "${BATOCERA_BINARIES_DIR}/boot/boot/modules.update"  || exit 1
cp "${BINARIES_DIR}/firmware"        "${BATOCERA_BINARIES_DIR}/boot/boot/firmware.update" || exit 1
cp "${BINARIES_DIR}/rescue"          "${BATOCERA_BINARIES_DIR}/boot/boot/rescue.update"   || exit 1
cp "${BINARIES_DIR}/initrd.lz4"      "${BATOCERA_BINARIES_DIR}/boot/boot/"                || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs" "${BATOCERA_BINARIES_DIR}/boot/boot/batocera.update" || exit 1

for DTB in rk3128-powkiddy-a13-rev-ab.dtb rk3128-powkiddy-a12-rev-c.dtb rk3128-powkiddy-a12-rev-d.dtb
do
	cp "${BINARIES_DIR}/${DTB}" "${BATOCERA_BINARIES_DIR}/boot/boot/" || exit 1
done

cp "${BOARD_DIR}/boot/extlinux.conf"    "${BATOCERA_BINARIES_DIR}/boot/extlinux/" || exit 1

exit 0
