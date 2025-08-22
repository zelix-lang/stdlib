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
#if !defined (_WIN32)
#   include <sys/syscall.h>
#   include <unistd.h>
#else
#   include <windows.h>
#endif

/// The unsafe syscall to write to a file descriptor.
///
/// # Safety
///
/// This function is unsafe because it does not check if the file descriptor is valid.
///
/// # Parameters
///
/// * `fd` - The file descriptor to write to.
/// * `n` - The number of bytes to write.
/// * `str` - The string to write.
extern void std_unsafe_sys_write(const int fd, const size_t n, const char *str)
{
#   if !defined (_WIN32)
    syscall(SYS_write, fd, str, n);
#   else
    WriteConsole(GetStdHandle(fd), str, n, NULL, NULL);
#   endif
}
