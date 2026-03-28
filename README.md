# CppUTest Docker (Clang)

A base Docker image for TDD development with Clang and [CppUTest](http://cpputest.github.io/).
Companion to [CppUTestDocker](https://github.com/DavidCozens/CppUTestDocker) which provides the GCC variant.

## Contents

- Clang 19 (via the official LLVM apt repository on `debian:bookworm-slim`)
- CppUTest v4.0 (compiled with Clang, `-fPIC` for PIE-compatible linking)
- clang-format 19
- clang-tidy 19
- CMake
- cppcheck
- lcov
- [James Grenning's legacy-build toolkit](https://github.com/jwgrenning/legacy-build)

## Usage

Pull the image from the GitHub Container Registry:

```
docker pull ghcr.io/davidcozens/cpputest-clang:latest
```

Run tests by mounting your project directory to `/home/src`:

```
docker run -v <path>:/home/src ghcr.io/davidcozens/cpputest-clang make
```

The `CPPUTEST_HOME` environment variable is set to `/home/cpputest` inside the container.

For production use and traceability, prefer a specific SHA tag over `latest`. Each build is tagged with the commit SHA it was built from (e.g. `sha-abc1234`). Available tags can be found on the [package page](https://github.com/davidcozens/CppUTestDockerClang/pkgs/container/cpputest-clang):

```
docker run -v <path>:/home/src ghcr.io/davidcozens/cpputest-clang:sha-<commit-sha> make
```

## Building

The image is built automatically via GitHub Actions on each push to `main` and pushed to the
[GitHub Container Registry](https://ghcr.io) as `ghcr.io/davidcozens/cpputest-clang`.

To build locally:

```
docker build -t cpputest-clang .
```
