#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	fontconfig \
	freetype2  \
	harfbuzz   \
	libx11     \
	libxext    \
	pango      \
	pixman     \
	unzip      \
	zlib

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common ffmpeg-mini

# Comment this out if you need an AUR package
make-aur-package flatpak-extract

echo "Getting binary..."
echo "---------------------------------------------------------------"
BINARY=https://github.com/hedge-dev/UnleashedRecomp/releases/latest/download/UnleashedRecomp-Flatpak.zip
if ! wget --retry-connrefused --tries=30 "$BINARY" 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi

unzip "${BINARY##*/}"
flatpak-extract ./*.flatpak

mkdir -p ./AppDir/bin
mv -v ./*-flatpak/files/bin/UnleashedRecomp                    ./AppDir/bin
mv -v ./*-flatpak/files/share/applications/*.desktop           ./AppDir
cp -v ./*-flatpak/files/share/icons/hicolor/128x128/apps/*.png ./AppDir
mv -v ./*-flatpak/files/share/icons/hicolor/128x128/apps/*.png ./.DirIcon

awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version
