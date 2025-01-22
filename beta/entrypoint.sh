#!/bin/bash

set -ex

echo "Downloading tarball for beta"

wget https://static.rust-lang.org/dist/rustc-beta-src.tar.xz

echo "Extracting beta tarball"

tar xf rustc-beta-src.tar.xz

cd rustc-beta-src

echo "Applying patches for beta"

for patch in /src/beta/*.patch; do
	patch -p1 < $patch
done
/src/clear_checksums.py vendor/libc-0.2.107/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.112/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.119/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.121/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.124/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.150/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.155/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.158/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.167/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.169/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.94/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.97/.cargo-checksum.json
/src/clear_checksums.py vendor/compiler_builtins-0.1.140/.cargo-checksum.json
/src/clear_checksums.py vendor/cc-1.2.0/.cargo-checksum.json

cp /src/beta/config.toml .

./x.py dist --jobs $(nproc)

cp build/dist/* /dist/beta/
