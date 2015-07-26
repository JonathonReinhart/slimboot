#!/bin/bash

set -e

mkdir -p initrd/bin
mkdir -p initrd/sbin
mkdir -p initrd/lib
mkdir -p initrd/lib64
mkdir -p initrd/proc
mkdir -p initrd/sys
mkdir -p initrd/dev
mkdir -p initrd/etc

gcc -o initrd/sbin/init -Wall -Werror -static hello.c

(cd initrd && find . | cpio -o -H newc | gzip > ../initrd-1.img)
