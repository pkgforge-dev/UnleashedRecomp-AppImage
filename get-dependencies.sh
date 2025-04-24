#!/bin/sh

set -ex

sed -i 's/DownloadUser/#DownloadUser/g' /etc/pacman.conf

if [ "$(uname -m)" = 'x86_64' ]; then
	PKG_TYPE='x86_64.pkg.tar.zst'
else
	PKG_TYPE='aarch64.pkg.tar.xz'
fi

LLVM_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/llvm-libs-mini-$PKG_TYPE"
LIBXML_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/libxml2-iculess-$PKG_TYPE"
OPUS_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/opus-nano-$PKG_TYPE"
FFMPEG_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/ffmpeg-mini-$PKG_TYPE"


echo "Installing build dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	base-devel \
	curl \
	desktop-file-utils \
	git \
	gtk3 \
	patchelf \
	pipewire-audio \
	pulseaudio \
	pulseaudio-alsa \
	strace \
	wayland \
	wget \
	xorg-server-xvfb \
	zsync

echo "Installing debloated pckages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$LLVM_URL"    -O  ./llvm.pkg.tar.zst
wget --retry-connrefused --tries=30 "$LIBXML_URL"  -O  ./libxml2.pkg.tar.zst
wget --retry-connrefused --tries=30 "$OPUS_URL"    -O  ./opus.pkg.tar.zst
wget --retry-connrefused --tries=30 "$FFMPEG_URL"  -O  ./ffmpeg.pkg.tar.zst

pacman -U --noconfirm ./*.pkg.tar.zst
rm -f ./*.pkg.tar.zst


echo "All done!"
echo "---------------------------------------------------------------"

