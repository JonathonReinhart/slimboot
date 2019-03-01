#!/bin/bash

set -e

mkdir -p initrd
gcc -o initrd/init -Wall -Werror -static hello.c

(cd initrd && find . | cpio -o -H newc | gzip > ../initrd-1.img)
