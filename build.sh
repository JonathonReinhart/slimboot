#!/bin/bash

shopt -s extglob
set -e

BUILDDIR="build"
WORKDIR="$BUILDDIR/initrd"
IMAGE="$BUILDDIR/initrd-1.img"

rm -rf $BUILDDIR
mkdir -p $BUILDDIR

mkdir -p $WORKDIR
mkdir -p $WORKDIR/bin
mkdir -p $WORKDIR/sbin
mkdir -p $WORKDIR/usr/bin
mkdir -p $WORKDIR/usr/sbin

# Copy all static files from initrd
cp -r initrd/* $WORKDIR/

# Build sample app
gcc -o $WORKDIR/bin/hello -Wall -Werror -static hello.c

# Install busybox
busybox=$(which busybox)
if [[ -z $busybox ]]; then
    echo "busybox not found"
    exit 1
fi
if [[ $(file $busybox) != *"statically linked"* ]]; then
    echo "busybox is not statically linked"
    exit 1
fi
cp /usr/bin/busybox $WORKDIR/bin/busybox
(
    cd $WORKDIR
    for path in $(bin/busybox --list-full); do
        if [[ ! -e $path ]]; then
            ln -s "/bin/busybox" $path
        fi
    done
)

# Init
# TODO: For some reason, on my current kernel, `init` needs to be at the root;
# /sbin/init doesn't work and init= seems to be ignored.
(cd $WORKDIR && ln -s "/bin/busybox" init)


# Kernel modules
COPY_MODS=(
    kernel/net/vmw_vsock/vsock.ko
    kernel/net/vmw_vsock/vsock_diag.ko
    kernel/net/vmw_vsock/vmw_vsock_virtio_transport_common.ko
    kernel/net/vmw_vsock/vmw_vsock_virtio_transport.ko
    #kernel/drivers/virtio/virtio.ko
    kernel/drivers/virtio/virtio_pci.ko
    kernel/drivers/virtio/virtio_pci_legacy_dev.ko
    kernel/drivers/virtio/virtio_pci_modern_dev.ko
    #kernel/drivers/virtio/virtio_ring.ko
)
for mod in ${COPY_MODS[@]}; do
    src="/lib/modules/$(uname -r)/$mod"
    dest="$WORKDIR/lib/modules/$(uname -r)/$mod"
    mkdir -p $(dirname $dest)
    cp $src $dest
done


# Generate initrd
(cd $WORKDIR && find . | cpio -o -H newc -R '+0:+0') | gzip > $IMAGE
gzip -dc $IMAGE | cpio -itv
