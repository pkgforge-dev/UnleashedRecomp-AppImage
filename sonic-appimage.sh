##!/bin/sh

set -eux

PACKAGE=UnleashedRecomp
ICON="https://raw.githubusercontent.com/hedge-dev/UnleashedRecompResources/e5a4adccb30734321ac17347090abeb6690dab70/images/game_icon.png"

export ARCH="$(uname -m)"
export APPIMAGE_EXTRACT_AND_RUN=1

UPINFO="gh-releases-zsync|$(echo "$GITHUB_REPOSITORY" | tr '/' '|')|latest|*$ARCH.AppImage.zsync"
LIB4BN="https://raw.githubusercontent.com/VHSgunzo/sharun/refs/heads/main/lib4bin"
APPIMAGETOOL="https://github.com/pkgforge-dev/appimagetool-uruntime/releases/download/continuous/appimagetool-$ARCH.AppImage"
BINARY=$(wget "https://api.github.com/repos/Jujstme/UnleashedRecomp/releases" -O - \
	| sed 's/[()",{} ]/\n/g' | grep -oi "https.*unleashed.*.zip$" | head -1)
VERSION=$(echo "$BINARY" | awk -F'/' '{print $(NF-1)}')
echo "$VERSION" > ~/version

# Prepare AppDir
mkdir -p ./AppDir/shared/bin
cd ./AppDir

wget "$ICON" -O ./unleashedrecomp.png
ln -s unleashedrecomp.png ./.DirIcon

echo '[Desktop Entry]
Name=Unleashed Recompiled
Exec=UnleashedRecomp
Type=Application
Icon=unleashedrecomp
Categories=Game;
Comment=Static recompilation of Sonic Unleashed
MimeType=x-scheme-handler/unleashedrecomp
StartupWMClass=UnleashedRecomp' > ./unleashedrecomp.desktop

wget "$BINARY" -O ./bin.zip
unzip ./bin.zip
rm -f ./bin.zip
mv -v ./UnleashedRecomp ./shared/bin

# ADD LIBRARIES
wget "$LIB4BN" -O ./lib4bin
chmod +x ./lib4bin
xvfb-run -a -- ./lib4bin -p -v -e -s -k \
	./shared/bin/UnleashedRecomp \
	/usr/lib/gconv/* \
	/usr/lib/libvulkan* \
	/usr/lib/libwayland* \
	/usr/lib/gtk-3*/*/* \
	/usr/lib/dri/* \
	/usr/lib/libXss.so* \
	/usr/lib/pulseaudio/* \
	/usr/lib/pipewire-0.3/* \
	/usr/lib/spa-0.2/*/*

# Prepare sharun
echo "Preparing sharun..."
ln ./sharun ./AppRun
./sharun -g

# MAKE APPIMAGE WITH URUNTIME
cd ..
wget "$APPIMAGETOOL" -O ./appimagetool
chmod +x ./appimagetool

echo "Generating AppImage..."
./appimagetool -n -u "$UPINFO" "$PWD"/AppDir "$PWD"/"$PACKAGE"-"$VERSION"-anylinux-"$ARCH".AppImage

wget -O ./pelf "https://github.com/xplshn/pelf/releases/latest/download/pelf_$(uname -m)" 
chmod +x ./pelf
echo "Generating [dwfs]AppBundle..."
./pelf --add-appdir ./AppDir \
	--appimage-compat \
	--add-updinfo "$UPINFO" \
	--appbundle-id="$PACKAGE#github.com/$GITHUB_REPOSITORY:$VERSION@$(date +%d_%m_%Y)" \
	--compression "-C zstd:level=22 -S26 -B8" \
	--output-to "$PACKAGE-$VERSION-anylinux-$ARCH.dwfs.AppBundle"

echo "All Done!"
