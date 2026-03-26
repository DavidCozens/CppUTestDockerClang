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

Run tests by mounting your project directory to `/home/src`:

```
docker run -v <path>:/home/src davidcozens/cpputest-clang make
```

The `CPPUTEST_HOME` environment variable is set to `/home/cpputest` inside the container.

## Building

The image is built automatically via GitHub Actions on each push to `main` and pushed to
DockerHub as `davidcozens/cpputest-clang`.

To build locally:

```
docker build -t cpputest-clang .
```
