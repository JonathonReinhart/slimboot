#!/bin/bash
kernel_bzimage="/boot/vmlinuz-4.0.4-202.fc21.x86_64"
kernel_cmdline="console=ttyS0"
kernel_initrd="initrd-1.img"

# unix.stackexchange.com/questions/167165
#stty intr "^]"

qemu-kvm \
    -nographic \
    -kernel $kernel_bzimage \
    -append $kernel_cmdline \
    -initrd $kernel_initrd \
    & qemupid=$!
echo "PID: $qemupid"
