#!/usr/bin/env python
import sys
import platform
from subprocess import Popen

kernel_bzimage = "/boot/vmlinuz-" + platform.release()
kernel_initrd = "initrd-1.img"
kernel_cmdline = 'console=ttyS0 raid=noautodetect'

# unix.stackexchange.com/questions/167165
#stty intr "^]"

qemu_opts = [
    '-nographic',
    '-kernel', kernel_bzimage,
    '-initrd', kernel_initrd,
    '-append', kernel_cmdline,
]


Popen(['qemu-kvm'] + qemu_opts)
