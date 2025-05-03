FROM docker.io/chimeralinux/chimera:latest

ENV CROSS_ARCHES loongarch64 riscv64 ppc ppc64 ppc64le aarch64
ENV PRETTY_ARCHES loongarch64 riscv64 powerpc powerpc64 powerpc64le aarch64

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
        libffi-devel \
        libgit2-devel \
        libxml2-devel \
        linux-headers \
        llvm-devel \
        llvm-tools \
        mount \
        ncurses-devel \
        pkgconf \
        python \
        wasi-libc \
        wget \
        zlib-ng-compat-devel \
        zstd-devel && \
    for ARCH in $CROSS_ARCHES; do \
        apk add base-cross-$ARCH; \
    done

SHELL ["/bin/bash", "-c"]

# Install bootstrapping rust compiler
RUN wget https://dl.musl.rs/beta/rust-beta-x86_64-unknown-linux-musl.tar.xz && \
    tar xf rust-beta-x86_64-unknown-linux-musl.tar.xz && \
    cd rust-beta-x86_64-unknown-linux-musl && \
    ./install.sh

RUN cross_arches=($CROSS_ARCHES) && \
    pretty_arches=($PRETTY_ARCHES) && \
    for i in "${!cross_arches[@]}"; do \
        ARCH=${cross_arches[i]} && \
        PRETTY=${pretty_arches[i]} && \
        echo "Creating chroot for $ARCH ($PRETTY)" && \
        mkdir -p /usr/$PRETTY-chimera-linux-musl/usr/lib/apk && \
        cp -r /usr/lib/apk/repositories.d /usr/$PRETTY-chimera-linux-musl/usr/lib/apk/ && \
        mkdir /usr/$PRETTY-chimera-linux-musl/proc && \
        mount --bind /proc /usr/$PRETTY-chimera-linux-musl/proc && \
        mkdir -p /usr/$PRETTY-chimera-linux-musl/etc/apk && \
        echo $ARCH > /usr/$PRETTY-chimera-linux-musl/etc/apk/arch && \
        apk --root /usr/$PRETTY-chimera-linux-musl add --allow-untrusted -U --initdb \
            base-files \
            chimerautils \
            chimera-repo-main || true && \
        apk --root /usr/$PRETTY-chimera-linux-musl add \
            base-bootstrap \
            libffi-devel \
            libgit2-devel \
            libxml2-devel \
            linux-headers \
            llvm-devel \
            ncurses-devel \
            pkgconf \
            zlib-ng-compat-devel \
            zstd-devel || true; \
    done

RUN ln -s /usr/lib/clang/20/lib/x86_64-chimera-linux-musl /usr/lib/clang/20/lib/x86_64-unknown-linux-musl && \
    for ARCH in $PRETTY_ARCHES; do \
        ln -s /usr/lib/clang/20/lib/$ARCH-chimera-linux-musl /usr/lib/clang/20/lib/$ARCH-unknown-linux-musl; \
    done

ENV SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
ENV OPENSSL_NO_VENDOR 1
ENV RUST_BACKTRACE 1
ENV RUSTFLAGS --remap-path-prefix=library=/usr/lib/rustlib/src/rust/library
ENV PKG_CONFIG_SYSROOT_DIR ''
ENV PKG_CONFIG_PATH_x86_64_unknown_linux_musl /usr/lib/pkgconfig

ENV PKG_CONFIG_PATH_aarch64_unknown_linux_musl /usr/lib/aarch64-linux-musl/pkgconfig
ENV CFLAGS_aarch64_unknown_linux_musl "--sysroot=/usr/aarch64-chimera-linux-musl/"
ENV CXXFLAGS_aarch64_unknown_linux_musl "--sysroot=/usr/aarch64-chimera-linux-musl/ -nostdinc++ -isystem /usr/aarch64-chimera-linux-musl/usr/include/c++/v1 -isystem /usr/aarch64-chimera-linux-musl/usr/include/"
ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_MUSL_RUSTFLAGS "-Lnative=/usr/aarch64-chimera-linux-musl/usr/lib"

ENV PKG_CONFIG_PATH_powerpc_unknown_linux_musl /usr/lib/powerpc-linux-musl/pkgconfig
ENV CFLAGS_powerpc_unknown_linux_musl "--sysroot=/usr/powerpc-chimera-linux-musl/"
ENV CXXFLAGS_powerpc_unknown_linux_musl "--sysroot=/usr/powerpc-chimera-linux-musl/ -nostdinc++ -isystem /usr/powerpc-chimera-linux-musl/usr/include/c++/v1 -isystem /usr/powerpc-chimera-linux-musl/usr/include/"
ENV CARGO_TARGET_POWERPC_UNKNOWN_LINUX_MUSL_RUSTFLAGS "-Lnative=/usr/powerpc-chimera-linux-musl/usr/lib"

ENV PKG_CONFIG_PATH_powerpc64_unknown_linux_musl /usr/lib/powerpc64-linux-musl/pkgconfig
ENV CFLAGS_powerpc64_unknown_linux_musl "--sysroot=/usr/powerpc64-chimera-linux-musl/"
ENV CXXFLAGS_powerpc64_unknown_linux_musl "--sysroot=/usr/powerpc64-chimera-linux-musl/ -nostdinc++ -isystem /usr/powerpc64-chimera-linux-musl/usr/include/c++/v1 -isystem /usr/powerpc64-chimera-linux-musl/usr/include/"
ENV CARGO_TARGET_POWERPC64_UNKNOWN_LINUX_MUSL_RUSTFLAGS "-Lnative=/usr/powerpc64-chimera-linux-musl/usr/lib"

ENV PKG_CONFIG_PATH_powerpc64le_unknown_linux_musl /usr/lib/powerpc64le-linux-musl/pkgconfig
ENV CFLAGS_powerpc64le_unknown_linux_musl "--sysroot=/usr/powerpc64le-chimera-linux-musl/"
ENV CXXFLAGS_powerpc64le_unknown_linux_musl "--sysroot=/usr/powerpc64le-chimera-linux-musl/ -nostdinc++ -isystem /usr/powerpc64le-chimera-linux-musl/usr/include/c++/v1 -isystem /usr/powerpc64le-chimera-linux-musl/usr/include/"
ENV CARGO_TARGET_POWERPC64LE_UNKNOWN_LINUX_MUSL_RUSTFLAGS "-Lnative=/usr/powerpc64le-chimera-linux-musl/usr/lib"

ENV PKG_CONFIG_PATH_riscv64gc_unknown_linux_musl /usr/lib/riscv64-linux-musl/pkgconfig
ENV CFLAGS_riscv64gc_unknown_linux_musl "--sysroot=/usr/riscv64-chimera-linux-musl/"
ENV CXXFLAGS_riscv64gc_unknown_linux_musl "--sysroot=/usr/riscv64-chimera-linux-musl/ -nostdinc++ -isystem /usr/riscv64-chimera-linux-musl/usr/include/c++/v1 -isystem /usr/riscv64-chimera-linux-musl/usr/include/"
ENV CARGO_TARGET_RISCV64GC_UNKNOWN_LINUX_MUSL_RUSTFLAGS "-Lnative=/usr/riscv64-chimera-linux-musl/usr/lib"

ENV PKG_CONFIG_PATH_loongarch64_unknown_linux_musl /usr/lib/loongarch64-linux-musl/pkgconfig
ENV CFLAGS_loongarch64_unknown_linux_musl "--sysroot=/usr/loongarch64-chimera-linux-musl/"
ENV CXXFLAGS_loongarch64_unknown_linux_musl "--sysroot=/usr/loongarch64-chimera-linux-musl/ -nostdinc++ -isystem /usr/loongarch64-chimera-linux-musl/usr/include/c++/v1 -isystem /usr/loongarch64-chimera-linux-musl/usr/include/"
ENV CARGO_TARGET_LOONGARCH64_UNKNOWN_LINUX_MUSL_RUSTFLAGS "-Lnative=/usr/loongarch64-chimera-linux-musl/usr/lib"

WORKDIR /src

COPY . .

CMD ["./nightly/entrypoint.sh"]
