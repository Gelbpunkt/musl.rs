#!/bin/bash

set -ex

echo "Downloading tarball for nightly"

wget https://static.rust-lang.org/dist/rustc-nightly-src.tar.xz

echo "Extracting nightly tarball"

tar xf rustc-nightly-src.tar.xz

cd rustc-nightly-src

echo "Applying patches for nightly"

for patch in /src/nightly/*.patch; do
	patch -p1 < $patch
done

/src/clear_checksums.py vendor/libc-0.2.107/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.112/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.119/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.121/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.124/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.155/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.167/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.168/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.169/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.170/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.171/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.94/.cargo-checksum.json
/src/clear_checksums.py vendor/libc-0.2.97/.cargo-checksum.json
/src/clear_checksums.py vendor/compiler_builtins-0.1.151/.cargo-checksum.json
/src/clear_checksums.py vendor/libffi-sys-2.3.0/.cargo-checksum.json

cp /src/nightly/config.toml .

./x.py dist --jobs $(nproc)

cp build/dist/* /dist/nightly/
