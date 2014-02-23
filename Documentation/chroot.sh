#!/bin/env bash

mount -t proc none /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
cp -L /etc/resolv.conf /mnt/gentoo/etc/

echo "source /etc/profile; export PS1=\"(chroot) \$PS1\""
chroot /mnt/gentoo /bin/bash
