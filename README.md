# UnleashedRecomp-AppImage 🐧

[![GitHub Downloads](https://img.shields.io/github/downloads/pkgforge-dev/UnleashedRecomp-AppImage/total?logo=github&label=GitHub%20Downloads)](https://github.com/pkgforge-dev/UnleashedRecomp-AppImage/releases/latest)
[![CI Build Status](https://github.com//pkgforge-dev/UnleashedRecomp-AppImage/actions/workflows/blank.yml/badge.svg)](https://github.com/pkgforge-dev/UnleashedRecomp-AppImage/releases/latest)

# ⚠️ WARNING ⚠️

This repo uses the [AUR package](https://aur.archlinux.org/packages/unleashedrecomp-bin) to get the unleashedrecomp binary, **unfortunately because compilation needs binaries from the xbox360 which cannot be distributed, there is no transparency on how the binary was built at all**

If you wish to still use this, it is strongly suggested that you sandbox this with [sas](https://github.com/Samueru-sama/simple-appimage-sandbox)

* [Latest Stable Release](https://github.com/pkgforge-dev/UnleashedRecomp-AppImage/releases/latest)

---

**This AppImage bundles everything and should work on any linux distro, even on musl based ones.** 

AppImage made using [sharun](https://github.com/VHSgunzo/sharun), which makes it extremely easy to turn any binary into a portable package without using containers or similar tricks.

**This AppImage bundles everything and should work on any linux distro, even on musl based ones.**

It is possible that this appimage may fail to work with appimagelauncher, I recommend these alternatives instead: 

* [AM](https://github.com/ivan-hc/AM) `am -ias unleashedrecomp` or `appman -ias unleashedrecomp` **it gets sandboxed with sas**

* [dbin](https://github.com/xplshn/dbin) `dbin install unleashedrecomp.appimage`

* [soar](https://github.com/pkgforge/soar) `soar install unleashedrecomp`

This appimage works without fuse2 as it can use fuse3 instead, it can also work without fuse at all thanks to the [uruntime](https://github.com/VHSgunzo/uruntime)

<details>
  <summary><b><i>raison d'être</i></b></summary>
    <img src="https://github.com/user-attachments/assets/d40067a6-37d2-4784-927c-2c7f7cc6104b" alt="Inspiration Image">
  </a>
</details>

---

More at: [AnyLinux-AppImages](https://pkgforge-dev.github.io/Anylinux-AppImages/) 
