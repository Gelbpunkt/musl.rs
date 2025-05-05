#!/bin/env sh
set -e

cleanup() {
	rv=$?
	echo "Cleaning up temporary directory"
	rm -rf "$OUT_DIR"
	exit $rv
}

trap "cleanup" EXIT

ARCH=$(uname -m)
OUT_DIR=$(mktemp -d)

echo "Downloading for architecture $ARCH"

download_wget() {
	wget https://dl.musl.rs/nightly/rust-nightly-$ARCH-unknown-linux-musl.tar.xz -O $OUT_DIR/rust.tar.xz
	wget https://dl.musl.rs/nightly/rust-src-nightly.tar.xz -O $OUT_DIR/rust-src.tar.xz
}

download_curl() {
	curl https://dl.musl.rs/nightly/rust-nightly-$ARCH-unknown-linux-musl.tar.xz -o $OUT_DIR/rust.tar.xz
	curl https://dl.musl.rs/nightly/rust-src-nightly.tar.xz -o $OUT_DIR/rust-src.tar.xz
}

if command -v wget >/dev/null 2>&1; then
	download_wget
elif command -v curl >/dev/null 2>&1; then
	download_curl
else
	echo "Error: Neither wget nor curl is installed." >&2
	exit 1
fi

echo "Extracting"

tar xf $OUT_DIR/rust.tar.xz -C $OUT_DIR
tar xf $OUT_DIR/rust-src.tar.xz -C $OUT_DIR

if [ "$(id -u)" -eq 0 ]; then
	PREFIX="/usr/local"
else
	PREFIX="~/.local"
fi

echo "Installing to $PREFIX"

sh $OUT_DIR/rust-nightly-$ARCH-unknown-linux-musl/install.sh --prefix=$PREFIX
sh $OUT_DIR/rust-src-nightly/install.sh --prefix=$PREFIX
