#!/usr/bin/env python3
import os
import sys
import platform
from subprocess import Popen

pidfile = "qemu.pid"
kernel_bzimage = "/boot/vmlinuz-" + platform.release()
kernel_initrd = "build/initrd-1.img"
kernel_cmdline = ' '.join((
        'quiet',
        'console=ttyS0',
        'raid=noautodetect',
        ))

# unix.stackexchange.com/questions/167165
#stty intr "^]"

VM_CID = 7

qemu_opts = [
    '-machine', 'accel=kvm',
    '-nographic',
    '-kernel', kernel_bzimage,
    '-initrd', kernel_initrd,
    '-append', kernel_cmdline,
    '-pidfile', pidfile,
    '-device', f'vhost-vsock-pci,id=vhost-vsock-pci0,guest-cid={VM_CID}',
]

p = Popen(['qemu-system-x86_64'] + qemu_opts)
p.wait()
