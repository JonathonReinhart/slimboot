#!/bin/bash

set -e

WORKDIR="initrd"
IMAGE="initrd-1.img"

rm -rf $WORKDIR
mkdir -p $WORKDIR

# Build sample app
gcc -o $WORKDIR/hello -Wall -Werror -static hello.c
(
    cd $WORKDIR
    ln -s hello init
)

# Generate initrd
(cd $WORKDIR && find . | cpio -o -H newc -R '+0:+0') | gzip > $IMAGE
