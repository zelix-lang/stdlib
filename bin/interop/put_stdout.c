//#==|------------------------------------------------------|==#
//   *****          The Zelix Programming Language         *****
//
// A fast, memory-safe and strongly typed systems programming
// language, aiming for native speeds and systems-level
// control.
//
// Find more at:
// https://github.com/zelix-lang/zelix
//
// Licensed under the Apache License v2.0
// <https://www.apache.org/licenses/LICENSE-2.0>.
// SPDX-License-Identifier: Apache-2.0
//
//#==|------------------------------------------------------|==#

#include <stdio.h>

void __put_stdout(const char* str) 
{
    fputs(str, stdout);
}

void __put_stderr(const char* str) 
{
    fputs(str, stderr);
}