#!/bin/bash

set -e

KERNEL_VERSION=$1
VERSION_REGEX="linux-image-(unsigned-)?$KERNEL_VERSION-([0-9]+)-generic_$KERNEL_VERSION-[0-9]+\.([0-9]+)_amd64.deb"

if [[ $KERNEL_VERSION =~ [0-9]\.[0-9]+\.[0-9]+ ]]; then
    echo "Installing kernel version $KERNEL_VERSION"
else
    echo "Invalid kernel version (${KERNEL_VERSION}) entered.  Should be X.X.X format"
    exit 1
fi

VERSION_BASE_URL="https://kernel.ubuntu.com/~kernel-ppa/mainline/v${KERNEL_VERSION}/"

KERNEL_IMAGE_FILENAME=$(curl "${VERSION_BASE_URL}" 2>/dev/null | grep -m 1 -o -E "${VERSION_REGEX}" | head -1)

[[ $KERNEL_IMAGE_FILENAME =~ $VERSION_REGEX ]]

KERNEL_VERSION_NUMERIC=${BASH_REMATCH[2]}
KERNEL_BUILD_DATE=${BASH_REMATCH[3]}

DOWNLOAD_DIR="/tmp/kernel/${KERNEL_VERSION}/"

mkdir -p "${DOWNLOAD_DIR}"

LINUX_HEADERS_URL="${VERSION_BASE_URL}linux-headers-${KERNEL_VERSION}-${KERNEL_VERSION_NUMERIC}_${KERNEL_VERSION}-${KERNEL_VERSION_NUMERIC}.${KERNEL_BUILD_DATE}_all.deb"
LINUX_HEADERS_GENERIC_URL="${VERSION_BASE_URL}linux-headers-${KERNEL_VERSION}-${KERNEL_VERSION_NUMERIC}-generic_${KERNEL_VERSION}-${KERNEL_VERSION_NUMERIC}.${KERNEL_BUILD_DATE}_amd64.deb"
LINUX_IMAGE_GENERIC_URL="${VERSION_BASE_URL}${KERNEL_IMAGE_FILENAME}"
LINUX_MODULES_GENERIC_URL="${VERSION_BASE_URL}linux-modules-${KERNEL_VERSION}-${KERNEL_VERSION_NUMERIC}-generic_${KERNEL_VERSION}-${KERNEL_VERSION_NUMERIC}.${KERNEL_BUILD_DATE}_amd64.deb"

echo "Downloading Headers"
curl "${LINUX_HEADERS_URL}" -o "${DOWNLOAD_DIR}/headers.deb"
echo "Downloading Headers Generic"
curl "${LINUX_HEADERS_GENERIC_URL}" -o "${DOWNLOAD_DIR}/headers-generic.deb"
echo "Downloading Image"
curl "${LINUX_IMAGE_GENERIC_URL}" -o "${DOWNLOAD_DIR}/image.deb"
echo "Downloading Modules Generic"
curl "${LINUX_MODULES_GENERIC_URL}" -o "${DOWNLOAD_DIR}/modules-generic.deb"

sudo dpkg -i "${DOWNLOAD_DIR}/headers.deb" "${DOWNLOAD_DIR}/headers-generic.deb" "${DOWNLOAD_DIR}/image.deb" "${DOWNLOAD_DIR}/modules-generic.deb"

BOOT_PARTITION=$(mount | grep -E '(/boot) ' | awk '{print $1}')
[[ $BOOT_PARTITION =~ (/dev/.+)n[0-9]+p[0-9]+ ]]
BOOT_DEVICE="${BASH_REMATCH[1]}"

sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader=ubuntu --boot-directory=/boot/efi/EFI/Ubuntu --recheck "${BOOT_DEVICE}"
sudo grub-mkconfig --output=/boot/efi/EFI/Ubuntu/grub/grub.cfg
sudo update-initramfs -ck all
