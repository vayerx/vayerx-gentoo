#!/usr/bin/env bash
mount -t proc none /mnt/gentoo/proc
mount -o bind /dev /mnt/gentoo/dev
cp -L /etc/resolv.conf /mnt/gentoo/etc/
chroot /mnt/gentoo /bin/bash
source /etc/profile
env-update
export PS1="(chroot) $PS1"

