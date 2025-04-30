FROM docker.io/chimeralinux/chimera:latest

# Install hostmakedepends
RUN apk add \
        bash \
        bsdtar \
        cargo \
        chimerautils \
        chimerautils-extra  \
        cmake \
        curl \
        gmake \
        libatomic-chimera-devel-static \
        libcxx-devel-static \
        libcxxabi-devel-static \
        libffi-devel \
        libgit2-devel \
        libunwind-devel-static  \
        libxml2-devel \
        linux-headers \
        llvm-devel \
        llvm-tools \
        musl-devel-static \
        ncurses-devel \
        pkgconf \
        python \
        wasi-libc \
        wget \
        zlib-ng-compat-devel \
        zstd-devel

# Install makedepends
RUN apk add \
        libffi-devel \
        libxml2-devel \
        llvm-devel \
        ncurses-devel \
        zlib-ng-compat-devel \
        zstd-devel

# Install bootstrapping rust compiler
RUN apk add rust

RUN ln -s /usr/lib/clang/20/lib/x86_64-chimera-linux-musl /usr/lib/clang/20/lib/x86_64-unknown-linux-musl

ENV SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
ENV OPENSSL_NO_VENDOR 1
ENV RUST_BACKTRACE 1
ENV RUSTFLAGS --remap-path-prefix=library=/usr/lib/rustlib/src/rust/library
ENV CBUILD_TARGET_SYSROOT /
ENV PKG_CONFIG_SYSROOT_DIR ''
ENV PKG_CONFIG_PATH_x86_64_unknown_linux_musl /usr/lib/pkgconfig

WORKDIR /src

COPY . .

CMD ["./beta/entrypoint.sh"]
