#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1
export DEPLOY_SDL=1

# Deploy dependencies
quick-sharun ./AppDir/bin/*

# The flatpak build hardcodes /var/data as the game location
# which is a read only by default and useless for us
sed -i -e 's|/var/data|/tmp/._Ur|g' ./AppDir/shared/bin/UnleashedRecomp

echo '#!/bin/false
datadir=${XDG_DATA_HOME:-$HOME/.local/share}/UnleashedRecomp
mkdir -p "$datadir"
ln -sfn "$datadir" /tmp/._Ur' > ./AppDir/bin/fix-flatpak-path.src.hook

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open

# in this case since there is no gpu available we have to install vulkan-swrast
pacman -S --noconfirm vulkan-swrast

quick-sharun --test ./dist/*.AppImage
