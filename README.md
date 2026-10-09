<div align="center">
    <img src="https://assets.zelixlang.dev/logo.png?update=true" height="60" width="60">
    <h1>The Zelix Programming Language</h1>
    Zelix is a modern and blazing-fast programming language.
    <br>
    <br>

[![GitHub](https://img.shields.io/github/license/zelix-lang/Zelix)](LICENSE)
![GitHub repo size](https://img.shields.io/github/repo-size/zelix-lang/Zelix)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/zelix-lang/Zelix)
![GitHub Repo stars](https://img.shields.io/github/stars/zelix-lang/Zelix?style=flat)

[Website][Website] | [Documentation][Documentation] | [Contributing][Contributing]
</div>

---

[Website]: https://zelixlang.dev
[Documentation]: https://docs.zelixlang.dev
[Contributing]: CONTRIBUTING.md
[stdlib]: https://github.com/zelix-lang/stdlib

# Zelix

Zelix is an experimental, statically typed systems programming language focused on safety, correctness, and native performance. Its compiler is written in C++20 and uses LLVM to produce native binaries.

> The `dev` branch is under active development. Expect language features, compiler behavior, and build requirements to change.

## What is in this repository?

- `Src/` — the compiler, command-line interface, language front end, IR passes, and LLVM backend.
- `Build/Black_Magic/` — language definitions and Typed scripts that generate compiler headers and CLI bindings during configuration.
- `Build/CMake/` — CMake setup, dependency registration, and build helpers.
- `Example/` — small Zelix programs, including a Hello World program and a package/macro example.

## Prerequisites

To build Zelix, install the following:

- A C++20 compiler.
- CMake 3.31 or later.
- LLVM, including `llvm-config` and CMake package files discoverable by `find_package(LLVM CONFIG)`.
- [Typed](https://github.com/zelix-lang/Typed), built separately. Set `ZELIX_TYPED_LOCATION` to its executable.
- Git and internet access for CMake to retrieve the C++ dependencies on the first configure.

On macOS with Homebrew LLVM, make its tools visible before configuring:

```sh
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
```

Set the Typed executable location for the current shell:

```sh
export ZELIX_TYPED_LOCATION=/absolute/path/to/typed
```

## Build from source

Clone the development branch using SSH:

```sh
git clone --branch dev --single-branch git@github.com:zelix-lang/Zelix.git
cd Zelix
```

Configure and build with the `cmake-build-debug` directory:

```sh
cmake -S . -B cmake-build-debug
cmake --build cmake-build-debug --parallel
```

The Typed generation scripts currently write generated headers to `cmake-build-debug/Generated`, so that directory name is required for a successful build. The resulting executable is typically `cmake-build-debug/Zelix` (add `.exe` on Windows).

## Compile a Zelix program

The compiler exposes `compile` (or `c`) and `explain` (or `e`) subcommands. Run the executable without arguments to see the generated help text.

Compile the included Hello World example:

```sh
./cmake-build-debug/Zelix compile Example/Main.zx \
  --target-path ./out \
  --executable-name hello
```

Optional compiler flags:

| Flag | Purpose |
| --- | --- |
| `--release` | Optimize generated code for release. |
| `--profile` | Profile compiler performance. |
| `--aliasing-check` | Enable aliasing-bug checks. |
| `--lib` | Build a library instead of an executable. |
| `--lib-c` | Link against libc and the CRT. |
| `--no-std-lib` | Do not link the standard library. |
| `--worker-threads <1-10>` | Set the number of concurrent analysis workers. |

## Example

`Example/Main.zx` is a minimal Zelix program:

```zx
package main;

import std::io::print;

fun main(): nothing {
    std::io::println("Hello, world!");
}
```

See `Example/Pack.zx` for packages, methods, annotations, and macro-generated accessors.

## License

Zelix is licensed under the [Apache License 2.0](LICENSE).
