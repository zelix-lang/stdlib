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

find "std_bin" -type f -print0 | while IFS= read -r -d '' file; do
    if [ -f "$file" ]; then
        echo "Compiling $file..."
        "$ZELIX_COMPILER" compile "$file" \
            -p -r --wT 5 \
            --tP build \
            --eN zelix_stdlib \
            --lib --lC --nSL

        echo "----------------------------"
    fi
done

echo "Compiling entry..."
"$ZELIX_COMPILER" compile "entry/entry.zx" \
    -p -r --wT 5 \
    --tP entry_build \
    --eN zelix_stdlib \
    --lib --lC --nSL

echo "Linking..."

link_files=("build"/*.o)

if [ ${#link_files[@]} -gt 0 ]; then
    cc "${link_files[@]}" \
        -o build/zelix_stdlib.so \
        -dynamiclib \
        -fPIC \
        -Wl,-install_name,@rpath/zelix_stdlib.so

    if [ $? -ne 0 ]; then
        echo "Failed to link zelix_stdlib.so"
        exit 1
    fi
else
    echo "No .o files found in build directory."
    exit 1
fi

echo "Build completed successfully."
echo "Shared library: $(pwd)/build/zelix_stdlib.so"

echo "Add the following lines to your shell configuration file:"
echo "export ZELIX_BUILT_STDLIB_PATH=\"$(pwd)/build/zelix_stdlib.so\""
echo "export ZELIX_BUILT_ENTRY_PATH=\"$(pwd)/entry_build/entry_entry.o\""

shopt -u nullglob