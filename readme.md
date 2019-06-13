# Installation

Starting with a blank disk with GPT partition table and UEFI boot process:

* Drive partitioning
    * EFI boot partition (gparted)
        * Create 100MB fat32 primary partition
        * Apply
        * Add `esp` label to the partition
    * Boot partition (gparted)
        * Create 1GB ext4 primary partition
    * Installation partition (Disks)
        * Create partition that fills the drive
            * Type: Other
            * On the next screen, select:
                * No Filesystem
                * Password protect volume (LUKS)
    * Create LVM
        * `# vgcreate system /dev/mapper/<partition>_crypt`
        * Create LVM partitions
            * `# lvcreate -L 8G -n swap system`
            * `# lvcreate -L 64G -n root system`
            * `# lvcreate -l 100%FREE -n home system`
* Follow the installer instructions, but don't reboot at the end
* Set up grub
    * `# blkid /dev/<partition>`
    * `# echo '<partition>_crypt UUID=<UUID> none luks,discard' > /target/etc/crypttab`
    * Chroot into the installation
        * `# mount -t proc proc /target/proc; mount --rbind /sys /target/sys; mount --rbind /dev /target/dev; chroot /target`
    * Within the chroot:
        * `# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader=ubuntu --boot-directory=/boot/efi/EFI/ubuntu --recheck /dev/<device>`
        * `# grub-mkconfig --output=/boot/efi/EFI/ubuntu/grub/grub.cfg`
        * `# update-initramfs -ck all`

After completing the above, you'll have a system w/ full encryption that will work with secure boot (make sure to allow "Other OS" mode in BIOS).

# Provisioning

To provision, run `configure.sh` at the project root.  This will configure everything it can automatically, but there are a few manual installations required for packages outside standard package managers.

# Misc

Dell XPS 9570 with Intel 9260 wifi has bad wifi performance on kernels older than 4.16; upgrading the kernel to 4.16 fixes this.  This also provides better system stability on the platform as well.

Upgrading the kernel can be done by downloading and installing the `linux-headers`, `linux-headers-generic`, `linux-image-generic`, and `linux-modules-generic` deb packages and installing w/ `dpkg -i` then updating grub with the grub setup commands above.

Spotify may not display when using current Nvidia drivers; this can be fixed by opening `Main Menu` application and adding `--disable-gpu` to the startup flags under startup properties.

# Possible missing firmware warnings

`git clone git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git`
`cp *.bin /lib/firmware/i915/`

