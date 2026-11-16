#!/usr/bin/env bash
# Builds every rasterizer mini demo into its own folder, then runs it once.
# Your examples/ sources stay untouched (no rename.py needed).
#
# Usage (from anywhere):   bash examples/build_demos.sh [demo ...]
#   no arguments  -> all demos
#   e.g.          -> bash examples/build_demos.sh depth blend
#
# Result: examples/demos/<name>/demo           (the binary)
#         examples/demos/<name>/triangle.png   (or triangle.gif for animation)
#
# Override paths if needed:
#   EIGEN_DIR=/path/to/eigen3 EXT_DIR=/path/to/ext CXX=clang++ bash examples/build_demos.sh

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXT_DIR="${EXT_DIR:-$HERE/../../ext}"
CXX="${CXX:-c++}"

# Eigen: Homebrew (Apple Silicon, then Intel), then the course's ext/eigen
if [ -z "${EIGEN_DIR:-}" ]; then
    for d in /opt/homebrew/include/eigen3 /usr/local/include/eigen3 "$EXT_DIR/eigen" /usr/include/eigen3; do
        if [ -d "$d/Eigen" ]; then EIGEN_DIR="$d"; break; fi
    done
fi
: "${EIGEN_DIR:?Eigen not found; set EIGEN_DIR=/path/to/eigen3}"

ALL="base lines attributes depth view blend projective supersample animation"
DEMOS="${*:-$ALL}"

for name in $DEMOS; do
    out="$HERE/demos/$name"
    mkdir -p "$out"

    # Each demo gets its own copy, so raster.h picks up that demo's attributes.h
    cp "$HERE/raster.cpp" "$HERE/raster.h" "$out/"
    cp "$HERE/extra/main_$name.cpp" "$out/main.cpp"
    cp "$HERE/extra/attributes_$name.h" "$out/attributes.h"

    echo "== $name: building"
    "$CXX" -std=c++11 -O2 -w -include cstdint -include functional \
        -I"$out" -isystem "$EIGEN_DIR" \
        -isystem "$EXT_DIR/stb" -isystem "$EXT_DIR/gif-h" \
        "$out/main.cpp" "$out/raster.cpp" -o "$out/demo"

    echo "== $name: rendering"
    (cd "$out" && ./demo)
done

echo
echo "Done. Outputs are in $HERE/demos/<name>/"
