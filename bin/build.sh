##==|------------------------------------------------------|==#
#   *****          The Zelix Programming Language         *****
#
# A fast, memory-safe and strongly typed systems programming
# language, aiming for native speeds and systems-level
# control.
#
# Find more at:
# https://github.com/zelix-lang/zelix
#
# Licensed under the Apache License v2.0
# <https://www.apache.org/licenses/LICENSE-2.0>.
# SPDX-License-Identifier: Apache-2.0
#
##==|------------------------------------------------------|==#
shopt -s nullglob

echo "\033[1;33mThe Zelix Programming Language\033[0m"
echo "\033[90mBuild Script\033[0m"
echo ""

echo "Where would you like to build the standard library and entry point?"
printf "\033[90m(default=pwd) > \033[0m"
read -r build_dir

initial_pwd=$(pwd)
cd "${build_dir:-$(pwd)}" || exit 1

echo ""
echo "\033[90m1. Cleaning build directories\033[0m\n"
if [ -d "build" ]; then
    rm -rf build/*
fi

if [ -d "entry_build" ]; then
    rm -rf entry_build/*
fi

if [ -d "interop_build" ]; then
    rm -rf interop_build/*
fi

mkdir -p build/logs
mkdir -p entry_build/logs
mkdir -p interop_build/logs

echo "\033[1;92mDone.\033[0m"
echo "\033[90m----------------------------\033[0m"
echo "\033[90m2. Compiling standard library\033[0m\n"

find "std" -type f -print0 | while IFS= read -r -d '' file; do
    if [ -f "$file" ]; then
        printf "\033[90m[Compiling] $file\033[0m"
        "$ZELIX_COMPILER" compile "$file" \
            -p -r --wT 5 \
            --tP build \
            --eN zelix_stdlib \
            --lib --lC --nSL > "build/logs/$(basename "$file").log" 2>&1

        if [ $? -ne 0 ]; then
            echo "\r\033[1;91m[Error] @ $file\033[0m"
            echo "Check the log file: build/logs/$(basename "$file").log"
            exit 1
        else
            echo "\r\033[1;92m[Success] @ $file\033[0m"
        fi
    fi
done

find "interop" -type f -print0 | while IFS= read -r -d '' file; do
    if [ -f "$file" ]; then
        printf "\033[90m[Compiling] $file\033[0m"
        cc $file -o "interop_build/$(basename "$file" .c).o" -c -fPIC > "interop_build/logs/$(basename "$file").log" 2>&1

        if [ $? -ne 0 ]; then
            echo "\r\033[1;91m[Error] @ $file\033[0m"
            echo "Check the log file: interop_build/logs/$(basename "$file").log"
            exit 1
        else
            echo "\r\033[1;92m[Success] @ $file\033[0m"
        fi
    fi
done

echo "\033[90m----------------------------\033[0m"
echo "\033[90m3. Compiling entry point\033[0m\n"

printf "\033[90m[Compiling] entry/entry.zx\033[0m"
"$ZELIX_COMPILER" compile "entry/entry.zx" \
    -p -r --wT 5 \
    --tP entry_build \
    --eN zelix_stdlib \
    --lib --lC --nSL > "entry_build/logs/entry_entry.log" 2>&1

if [ $? -ne 0 ]; then
    echo "\r\033[1;91m[Error] @ entry/entry.zx\033[0m"
    echo "Check the log file: entry_build/logs/entry_entry.log"
    exit 1
else
    echo "\r\033[1;92m[Success] @ entry/entry.zx\033[0m"
fi

echo "\033[90m----------------------------\033[0m"
echo "\033[90m4. Linking\033[0m\n"

link_files=("build"/*.o "interop_build"/*.o)

if [ ${#link_files[@]} -gt 0 ]; then
    printf "\033[90m[Linking] $file\033[0m"

    cc "${link_files[@]}" \
        -o build/zelix_stdlib.so \
        -dynamiclib \
        -fPIC \
        -Wl,-install_name,@rpath/zelix_stdlib.so > "build/logs/link.log" 2>&1

    if [ $? -ne 0 ]; then
        echo "\r\033[1;91m[Error] Linking failed\033[0m"
        echo "Check the log file: build/logs/link.log"
        exit 1
    else
        echo "\r\033[1;92m[Success] Linking completed\033[0m"
    fi
else
    echo "\033[1;91m[Error] No object files found to link\033[0m"
    exit 1
fi

echo "\033[90m----------------------------\033[0m"
echo "\033[92mSuccess!\033[0m"
echo ""

echo "Build completed successfully."
echo "Shared library: \033[90m$(pwd)/build/zelix_stdlib.so\033[0m"
echo ""

echo "Add the following lines to your shell configuration file:"
echo "\033[1mexport ZELIX_BUILT_STDLIB_PATH=\"$(pwd)/build/zelix_stdlib.so\"\033[0m"
echo "\033[1mexport ZELIX_BUILT_ENTRY_PATH=\"$(pwd)/entry_build/entry_entry.o\"\033[0m"
cd "$initial_pwd" || exit 1

shopt -u nullglob