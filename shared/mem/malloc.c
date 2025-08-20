/*
==== The Zelix Programming Language ====
---------------------------------------------------------
  - This file is part of the Zelix Programming Language
    codebase. Zelix is a fast, statically-typed and
    memory-safe programming language that aims to
    match native speeds while staying highly performant.
---------------------------------------------------------
  - Zelix is categorized as free software; you can
    redistribute it and/or modify it under the terms of
    the GNU General Public License as published by the
    Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.
---------------------------------------------------------
  - Zelix is distributed in the hope that it will
    be useful, but WITHOUT ANY WARRANTY; without even
    the implied warranty of MERCHANTABILITY or FITNESS
    FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.
---------------------------------------------------------
  - You should have received a copy of the GNU General
    Public License along with Zelix. If not, see
    <https://www.gnu.org/licenses/>.
*/

//
// Created by rodrigo on 8/20/25.
//

#include <stdlib.h>

/// Zelix's C Bridge for memory allocation.
extern void *std_unsafe_mem_malloc(size_t size)
{
    if (size == 0)
    {
        // Todo: Maybe panic
        return NULL;
    }

    // Allocate memory using malloc
    void *ptr = malloc(size);

    // If allocation failed, return NULL
    if (!ptr)
    {
        // Todo: Maybe panic
        return NULL;
    }

    // Return the allocated memory pointer
    return ptr;
}