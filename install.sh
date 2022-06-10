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
pacstrap /mnt base base-devel linux linux-firmware dunst networkmanager polybar gtk-engine-murrine kitty nautilus vim man-db man-pages zsh-syntax-highlighting zsh-completions texinfo intel-ucode grub efibootmgr xorg-server i3-gaps rofi dmenu firefox alacritty ranger lightdm lightdm-gtk-greeter nvidia i3status neofetch git nvidia-settings discord pulseaudio pavucontrol nitrogen picom os-prober deepin-screenshot zsh btop gtk3 lxappearance ttf-iosevka-nerd zip unzip
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
ln -sf /home/sebastian/github/dotfiles/grub/sleek /usr/share/grub/themes
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
cat >> /etc/default/grub << "END"
GRUB_DISABLE_OS_PROBER=false
END
cat >> /etc/default/grub << "END"
GRUB_THEME="/usr/share/grub/themes/sleek/theme.txt"
END
mount --mkdir /dev/nvme0n1p1 /mnt/windowsefi
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
systemctl enable lightdm
useradd -g wheel -m sebastian
chpasswd < pass.txt
rm -rf pass.txt
echo "%wheel ALL=(ALL:ALL) NOPASSWD :ALL" >> /etc/sudoers
ln -sf /home/sebastian/github/dotfiles/.config /home/sebastian/
ln -sf /home/sebastian/github/dotfiles/X11/00-keyboard.conf /etc/X11/xorg.conf.d/
ln -sf /home/sebastian/github/dotfiles/Xresources/.Xresources /home/sebastian/
ln -sf /home/sebastian/github/dotfiles/vim/.vimrc /home/sebastian/
ln -sf /home/sebastian/github/dotfiles/X11/xorg.conf /etc/X11/
ln -sf /home/sebastian/github/dotfiles/X11/00-keyboard.conf /etc/X11/xorg.conf.d/
ln -sf /home/sebastian/github/dotfiles/fonts /home/sebastian/.local/share/
ln -sf /home/sebastian/github/dotfiles/zsh/.zshrc /home/sebastian/
ln -sf /home/sebastian/github/dotfiles/.themes /home/sebastian/
ln -sf /home/sebastian/github/dotfiles/icons/.icons /home/sebastian/
su sebastian
cd /home/sebastian
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay
yay -S --noconfirm google-chrome nerd-fonts-complete rofi-wifi-menu-git
mkdir github
mkdir Download
mkdir Pictures
mkdir Documents
cd /home/sebastian/github
git clone https://www.github.com/sebbelindholm/dotfiles.git
git clone https://www.gitlab.com/dwt1/wallpapers.git
EOF
sed -n '$d' /mnt/etc/sudoers
sed -n '$d' /mnt/etc/sudoers
echo "%wheel ALL=(ALL:ALL) ALL" >> /mnt/etc/sudoers
arch-chroot /mnt /bin/bash << "EOF"
EOF
