#!/bin/sh

set -eux

ARCH="$(uname -m)"
EXTRA_PACKAGES="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh"

echo "Installing build dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	base-devel         \
	curl               \
	git                \
	libxss             \
	pipewire-audio     \
	pulseaudio         \
	pulseaudio-alsa    \
	unzip              \
	vulkan-headers     \
	vulkan-mesa-layers \
	wayland            \
	wget               \
	xorg-server-xvfb   \
	zsync

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$EXTRA_PACKAGES" -O ./get-debloated-pkgs.sh
chmod +x ./get-debloated-pkgs.sh
./get-debloated-pkgs.sh --add-vulkan libxml2-mini gtk3-mini ffmpeg-mini opus-mini
