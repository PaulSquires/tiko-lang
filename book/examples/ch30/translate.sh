#!/usr/bin/env bash
# translate.sh -- translate the four libraries' C headers into tiko with 'tiko c2t'.
#
# Run it once, after fetch-libs.sh has laid out vendor/, from this directory:
#
#     bash translate.sh
#
# Each .ti is written beside its .h and committed with the book: a program that uses the
# library includes the .ti, and nothing that builds the program needs Clang or the C headers.
# Run it again after upgrading a library; a diff of the .ti files shows what changed.
#
# c2t parses each header for windows-x86_64 and for linux-x86_64. A header that includes
# the C library's own headers (<stdio.h>, <GL/gl.h>) needs Linux's system headers for the
# Linux pass: on Linux they are already there, and on Windows --sysroot names a Linux
# installation's root, here the WSL distribution's.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

TIKO="${TIKO:-tiko}"
sysroot=()
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) sysroot=(--sysroot //wsl.localhost/Ubuntu) ;;
esac

# Exit 0: clean. 2: translated, with C2T-TODOs to read. 1: nothing written.
c2t() {
  "$TIKO" c2t "$@"
  local rc=$?
  (( rc == 1 )) && { echo "translate.sh: c2t failed on $1" >&2; exit 1; }
  echo "$1: exit $rc"
}

# SQLite: one header. Its shared-build switch is the export macro SQLITE_API.
c2t vendor/sqlite/sqlite3.h --verify \
    --shared-macro "SQLITE_API=__attribute__((dllimport))"

# raylib: one header.
c2t vendor/raylib/raylib.h --verify

# GLFW: one header, which includes OpenGL's.
c2t vendor/glfw/include/GLFW/glfw3.h "${sysroot[@]}" --verify

# SDL3: one run per header, each header's includes first, so that --verify finds them
# already translated. SDL_begin_code.h and SDL_close_code.h only decorate the headers
# between them: c2t strips their macros where they are used, and they are not translated.
inc=vendor/sdl3/include
declare -A seen=()
order=()
visit() {
  local h="$1" sub
  [[ -n "${seen[$h]:-}" ]] && return 0
  seen[$h]=1
  [[ $h == */SDL_begin_code.h || $h == */SDL_close_code.h ]] && return 0
  [[ -f "$inc/$h" ]] || return 0
  while read -r sub; do
    visit "$sub"
  done < <(sed -n 's|^[[:space:]]*#[[:space:]]*include[[:space:]]*<\(SDL3/[^>]*\)>.*|\1|p' \
             "$inc/$h" | tr -d '\r')
  order+=("$h")
}
visit SDL3/SDL.h
for h in "${order[@]}"; do
  c2t "$inc/$h" -I "$inc" "${sysroot[@]}" --verify
done
# SDL_main.h would write the program's main() in C. SDL_MAIN_HANDLED says the program has
# its own, and -D writes the macro into SDL_main.ti, so the translation reads it the same way.
c2t "$inc/SDL3/SDL_main.h" -I "$inc" "${sysroot[@]}" -D SDL_MAIN_HANDLED --verify
