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
pacstrap /mnt linux base base-devel linux-firmware archlinux-keyring grub efibootmgr
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
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable Networkmanager
systemctl enable sddm
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
yay -S --noconfirm google-chrome nerd-fonts-complete rofi-wifi-menu-git shell-color-scripts spotify minecraft-launcher
mkdir github
mkdir Downloads
mkdir Pictures
mkdir Documents
cd github
git clone https://github.com/sebbelindholm/arch-install-script.git
pacman -S - < packages.txt
cd /home/sebastian
git clone https://www.github.com/sebbelindholm/dotfiles.git
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
EOF
sed -n '$d' /mnt/etc/sudoers
sed -n '$d' /mnt/etc/sudoers
echo "%wheel ALL=(ALL:ALL) ALL" >> /mnt/etc/sudoers
arch-chroot /mnt /bin/bash << "EOF"
EOF
