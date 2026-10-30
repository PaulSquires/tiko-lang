#!/usr/bin/env bash
# build.sh -- rebuild geom's static libraries, one per target, beside this script.
#
#   bash build.sh windows     geom_windows_x86_64.lib   (clang + llvm-lib, MSVC format)
#   bash build.sh linux       geom_linux_x86_64.a       (clang + ar), run on Linux
#   bash build.sh macos       geom_macos_arm64.a        (clang + ar), run on a Mac
#
# #foreignlib GEOM static "geom/geom" picks the right one by its name.
set -euo pipefail
cd "$(dirname "$0")"
case "${1:?windows, linux or macos}" in
  windows)
    clang -c -O2 --target=x86_64-pc-windows-msvc geom.c -o geom.obj
    llvm-lib /out:geom_windows_x86_64.lib geom.obj
    rm -f geom.obj ;;
  linux)
    clang -c -O2 -fPIC geom.c -o geom.o
    ar rcs geom_linux_x86_64.a geom.o
    rm -f geom.o ;;
  macos)
    clang -c -O2 geom.c -o geom.o
    ar rcs geom_macos_arm64.a geom.o
    rm -f geom.o ;;
esac
