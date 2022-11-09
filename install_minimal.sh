#!/bin/bash
umount -R /mnt
timedatectl set-ntp true
fdisk /dev/nvme1n1 << "EOF"
g
n


+550M
n



t
1
1
t
2
23
w
EOF
mkfs.ext4 /dev/nvme1n1p2 << "EOF"
y
EOF
mkfs.fat -F 32 /dev/nvme1n1p1
mount /dev/nvme1n1p2 /mnt
mount --mkdir /dev/nvme1n1p1 /mnt/boot
pacstrap /mnt base base-devel linux linux-firmware networkmanager vim grub efibootmgr xorg-server nvidia git nvidia-settings os-prober zsh zip unzip
genfstab -U /mnt >> /mnt/etc/fstab
echo "root:$1" >> /mnt/pass.txt
echo "sebastian:$2" >> /mnt/pass.txt
arch-chroot /mnt /bin/bash << "EOF"
ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc
cat >> /etc/locale.gen << "END"
en_US.UTF-8 UTF-8
END
locale-gen
cat >> /etc/locale.conf << "END"
LANG=en_US.UTF-8
END
cat >> /etc/vconsole.conf << "END"
KEYMAP=sv-latin1
END
cat >> /etc/hostname << "END"
arch-desktop
END
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
cat >> /etc/default/grub << "END"
GRUB_DISABLE_OS_PROBER=false
END
mount --mkdir /dev/nvme0n1p1 /mnt/windowsefi
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
useradd -g wheel -m sebastian
chpasswd < pass.txt
rm -rf pass.txt
echo "%wheel ALL=(ALL:ALL) NOPASSWD :ALL" >> /etc/sudoers
su sebastian
cd /home/sebastian
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay
mkdir github
mkdir Download
mkdir Pictures
mkdir Documents
EOF
sed -n '$d' /mnt/etc/sudoers
sed -n '$d' /mnt/etc/sudoers
echo "%wheel ALL=(ALL:ALL) ALL" >> /mnt/etc/sudoers
arch-chroot /mnt /bin/bash << "EOF"
EOF
