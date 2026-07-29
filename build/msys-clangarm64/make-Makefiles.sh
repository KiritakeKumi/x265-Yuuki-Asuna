#!/bin/sh
# Build x265 natively for Windows on ARM64 using MSYS2's clangarm64 toolchain
# (clang targeting aarch64-w64-mingw32). The compiler and the produced x265
# binary are native ARM64; only the MSYS2 runtime (bash/cmake/ninja as cygwin
# tools) runs under x64 emulation — MSYS2 ships no native aarch64 runtime yet.
#
# Prerequisites — install once from any MSYS2 shell:
#   pacman -S --needed mingw-w64-clang-aarch64-clang \
#                   mingw-w64-clang-aarch64-cmake \
#                   mingw-w64-clang-aarch64-ninja \
#                   mingw-w64-clang-aarch64-lld
#   (package prefix is mingw-w64-clang-aarch64-, i.e. the *target* arch, not
#    the clangarm64 environment name)
#
# Usage:
#   cd build/msys-clangarm64
#   ./make-Makefiles.sh
#
# Options:
#   ENABLE_AVISYNTH / ENABLE_VPYSYNTH default OFF because their SDKs are not
#     shipped by MSYS2 — flip back ON if you have installed those SDKs.
#   CMAKE_POLICY_VERSION_MINIMUM works around Yuuki's CMakeLists still using
#     cmake_minimum_required(2.8.8) and CMP0025/CMP0054 OLD, removed in CMake 4.

# The clangarm64 login shell does not prepend /clangarm64/bin to PATH, so add
# it here so cmake, ninja and clang are all resolved from the clangarm64 prefix.
export PATH="/clangarm64/bin:$PATH"

cmake -G "Ninja" \
      -DCMAKE_BUILD_TYPE=Release \
      -DENABLE_SHARED=OFF \
      -DENABLE_CLI=ON \
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
      -DENABLE_AVISYNTH=OFF \
      -DENABLE_VPYSYNTH=OFF \
      ../../source && \
ninja
