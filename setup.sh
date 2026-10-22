#!/bin/bash

# Create docker image from iso file

mkdir rootfs unsquashfs
losetup -f
sudo mount -o loop ./lcos-08.iso rootfs
sudo unsquashfs -f -d unsquashfs/ rootfs/live/filesystem.squashfs 

# check if image exists and version or remove
sudo tar -C unsquashfs -c . | docker import - lcos