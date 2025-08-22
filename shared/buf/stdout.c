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

#include <stddef.h>
#include <string.h>

extern struct std_buf_StdoutBuffer
{
    size_t pos;
    char buf[1024];
} std_buf_StdoutBuffer;

extern void std_buf_write(
    struct std_buf_StdoutBuffer *inst,
    char *buf,
    size_t n
)
{
    // Bounds checking performed by the Zelix side
    // check @std/io/print
    memcpy(inst->buf + inst->pos, buf, n);
    inst->pos += n;
}

extern int std_buf_max(
    struct std_buf_StdoutBuffer *inst
)
{
    return sizeof(inst->buf);
}

extern void std_buf_pos(
    struct std_buf_StdoutBuffer *inst,
    int p
)
{
    inst->pos = p;
}

extern char *std_buf_leak(
    struct std_buf_StdoutBuffer *inst
)
{
    return inst->buf;
}
