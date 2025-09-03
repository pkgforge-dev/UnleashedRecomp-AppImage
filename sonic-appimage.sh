##!/bin/sh

set -eux

ARCH="$(uname -m)"
VERSION="$(cat ~/version)"
URUNTIME="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/uruntime2appimage.sh"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

export DESKTOP=/usr/share/applications/io.github.hedge_dev.unleashedrecomp.desktop
export ICON=/usr/share/icons/hicolor/128x128/apps/io.github.hedge_dev.unleashedrecomp.png
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export OUTNAME=UnleashedRecomp-"$VERSION"-anylinux-"$ARCH".AppImage
export DEPLOY_PIPEWIRE=1
export DEPLOY_VULKAN=1

# ADD LIBRARIES
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun /usr/bin/UnleashedRecomp /usr/lib/libpulse.so*

# MAKE APPIMAGE WITH URUNTIME
wget --retry-connrefused --tries=30 "$URUNTIME" -O ./uruntime2appimage
chmod +x ./uruntime2appimage
./uruntime2appimage

# make appbundle
UPINFO="$(echo "$UPINFO" | sed 's#.AppImage.zsync#*.AppBundle.zsync#g')"
wget -O ./pelf "https://github.com/xplshn/pelf/releases/latest/download/pelf_$(uname -m)" 
chmod +x ./pelf
echo "Generating [dwfs]AppBundle..."
./pelf --add-appdir ./AppDir \
	--appimage-compat \
	--add-updinfo "$UPINFO" \
	--appbundle-id="UnleashedRecomp#github.com/$GITHUB_REPOSITORY:$VERSION@$(date +%d_%m_%Y)" \
	--compression "-C zstd:level=22 -S26 -B8" \
	--output-to ./UnleashedRecomp-"$VERSION"-anylinux-"$ARCH".dwfs.AppBundle
zsyncmake ./*.AppBundle -u ./*.AppBundle

mkdir -p ./dist
mv -v ./*.AppImage* ./dist
mv -v ~/version     ./dist

echo "All Done!"
