#!/bin/bash
umount -R /mnt
timedatectl set-ntp true

wipefs --all /dev/nvme1n1
sgdisk /dev/nvme1n1 -o
sgdisk /dev/nvme1n1 -n 1::+512MiB -t 1:ef00
sgdisk /dev/nvme1n1 -n 2
mkfs.vfat -F32 /dev/nvme1n1p1
mkfs.ext4  -F /dev/nvme1n1p2

mount /dev/nvme1n1p2 /mnt
mount --mkdir /dev/nvme1n1p1 /mnt/boot
mount --mkdir /dev/nvme0n1p1 /mnt/nvme
mount --mkdir /dev/sda1 /mnt/hdd

rm -rf /etc/pacman.conf
cp pacman.conf /etc/
pacstrap /mnt linux base base-devel linux-firmware archlinux-keyring xdg-user-dirs
rm -rf /mnt/etc/pacman.conf
cp pacman.conf /mnt/etc/pacman.conf

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
xdg-user-dirs-update
mkdir Github
mkdir Github/Personal
mkdir Github/Cloned
cd Github/Personal
git clone https://github.com/sebbelindholm/arch-install-script.git
cd arch-install-script
sudo pacman --noconfirm -Syu - < pacman_packages.txt
cd /home/sebastian
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo systemctl enable NetworkManager
sudo systemctl --user enable emacs
EOF

sed -n '$d' /mnt/etc/sudoers
sed -n '$d' /mnt/etc/sudoers
echo "%wheel ALL=(ALL:ALL) ALL" >> /mnt/etc/sudoers
arch-chroot /mnt /bin/bash << "EOF"
EOF
