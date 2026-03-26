FROM debian:bookworm-slim
LABEL Description="Image for running CppUTest with Clang"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add LLVM apt repository for Clang 19
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates gnupg wget \
    && wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key \
        | gpg --dearmor > /usr/share/keyrings/llvm-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/llvm-archive-keyring.gpg] http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-19 main" \
        > /etc/apt/sources.list.d/llvm.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    autoconf automake clang-19 clang-format-19 clang-tidy-19 cmake cppcheck gdb git lcov libtool make sudo \
    && rm -rf /var/lib/apt/lists/*

# Set clang-19 as the default cc, c++, clang-format, and clang-tidy
RUN update-alternatives --install /usr/bin/cc          cc          /usr/bin/clang-19        100 \
 && update-alternatives --install /usr/bin/c++         c++         /usr/bin/clang++-19      100 \
 && update-alternatives --install /usr/bin/clang       clang       /usr/bin/clang-19        100 \
 && update-alternatives --install /usr/bin/clang++     clang++     /usr/bin/clang++-19      100 \
 && update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-19 100 \
 && update-alternatives --install /usr/bin/clang-tidy  clang-tidy  /usr/bin/clang-tidy-19   100

# Build CppUTest with Clang, with -fPIC so it links cleanly into PIE executables
WORKDIR /home/cpputest
RUN git clone --depth 1 --branch v4.0 https://github.com/cpputest/cpputest.git . \
 && autoreconf . -i \
 && CC=clang-19 CXX=clang++-19 CFLAGS="-fPIC" CXXFLAGS="-fPIC" ./configure \
 && make install

ENV CPPUTEST_HOME=/home/cpputest

WORKDIR /home/legacy-build
RUN git clone https://github.com/jwgrenning/legacy-build.git . \
 && git submodule update --init \
 && bash test/all-tests.sh

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN mkdir -p /home/src \
    && groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} --create-home ${USERNAME} \
    && echo "${USERNAME} ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && chown -R ${USERNAME}:${USERNAME} /home/cpputest /home/legacy-build /home/src

USER ${USERNAME}

WORKDIR /home/src
