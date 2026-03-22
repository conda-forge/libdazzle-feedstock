#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# necessary to ensure the gobject-introspection-1.0 pkg-config file gets found
# meson needs this to determine where the g-ir-scanner script is located
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$BUILD_PREFIX/lib/pkgconfig
export XDG_DATA_DIRS=${XDG_DATA_DIRS:-}:$PREFIX/share

meson setup builddir ${MESON_ARGS} -Dwith_introspection=true -Dwith_vapi=false
meson compile -C builddir -j ${CPU_COUNT}
meson install -C builddir
