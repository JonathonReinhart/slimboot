#!/bin/bash

set -e

mkdir -p initrd
gcc -o initrd/init -Wall -Werror -static hello.c

(cd initrd && find . | cpio -o -H newc -R '+0:+0' | gzip > ../initrd-1.img)
