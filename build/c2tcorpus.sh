#!/usr/bin/env bash
# c2tcorpus.sh -- c2t's acceptance corpus (RFC-0001 D24, PLAN P7).
#
#   bash build/c2tcorpus.sh            translate, compile, compare with the baseline
#   bash build/c2tcorpus.sh --accept   ... and write the results as the new baseline
#
# The libraries' headers at pinned releases, each download checked against its SHA-256
# and never committed: raylib.h + raymath.h, sqlite3.h, GLFW/glfw3.h and the SDL3 headers
# SDL.h includes (in include order, so each one's includes exist when --verify compiles
# it). Each is translated by `tiko c2t ... --verify` and then compiled with `-c` for both
# targets. One row per header goes to build/.c2tcorpus/results.txt:
#
#   <header>  <c2t exit>  <TODOs>  <windows -c>  <linux -c>
#
# and is compared with tests/c2t/corpus.baseline. A header that does worse than its
# baseline row -- more TODOs, or a compile that passed and now fails, or a c2t exit of 1 --
# fails the run; one that does better is reported, and --accept records it.
#
#   TIKO          the compiler to run (default: bin/tiko.exe, bin/tiko on Linux)
#   C2T_CACHE     where downloads are kept (default: build/.c2tcorpus/downloads); point it
#                 at book/examples/ch29/vendor/.downloads to reuse that chapter's copies
#   C2T_SYSROOT   the Linux pass's sysroot on Windows (default: //wsl.localhost/Ubuntu)
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

accept=0
[[ "${1:-}" == "--accept" ]] && accept=1

case "$(uname -s)" in
  MINGW*|MSYS*) tiko="${TIKO:-$root/bin/tiko.exe}"
                sysroot=(--sysroot "${C2T_SYSROOT:-//wsl.localhost/Ubuntu}") ;;
  *)            tiko="${TIKO:-$root/bin/tiko}"; sysroot=() ;;
esac
[[ -x "$tiko" ]] || { echo "c2tcorpus: no compiler at $tiko (build first, or set TIKO)" >&2; exit 1; }

work="$root/build/.c2tcorpus"
cache="${C2T_CACHE:-$work/downloads}"
baseline="$root/tests/c2t/corpus.baseline"
mkdir -p "$cache"

fetch() { # fetch <url> <sha256>: the cached archive, downloaded once, checked every time
  local url="$1" sum="$2" file="$cache/${1##*/}"
  [[ -f "$file" ]] || curl -fsSL -o "$file" "$url"
  echo "$sum *$file" | sha256sum -c --quiet - || { echo "c2tcorpus: $file: SHA-256 mismatch" >&2; exit 1; }
  printf '%s\n' "$file"
}

unpack() { # unpack <archive>: into build/.c2tcorpus/src/<archive name>, printed
  local out="$work/src/$(basename "$1")"
  if [[ ! -d "$out" ]]; then
    mkdir -p "$out"
    case "$1" in
      *.zip) unzip -q "$1" -d "$out" ;;
      *)     tar -xzf "$1" -C "$out" ;;
    esac
  fi
  printf '%s\n' "$out"
}

SQLITE_VER=3540000
RAYLIB_VER=6.0
GLFW_VER=3.5.1
SDL_VER=3.4.18

sqlite="$(unpack "$(fetch https://sqlite.org/2026/sqlite-amalgamation-$SQLITE_VER.zip \
  68e913b0fe8ec6b4e5f391c594a28872884e80d6cd042a1e50c957be46b5aa4d)")/sqlite-amalgamation-$SQLITE_VER"
raylib="$(unpack "$(fetch https://github.com/raysan5/raylib/releases/download/$RAYLIB_VER/raylib-${RAYLIB_VER}_win64_msvc16.zip \
  c93c7dc74576e00e3ee57fa2bd5fd109fbfc5aca87e12046dd7ec2c2268b3f78)")/raylib-${RAYLIB_VER}_win64_msvc16/include"
glfw="$(unpack "$(fetch https://github.com/glfw/glfw/releases/download/$GLFW_VER/glfw-$GLFW_VER.zip \
  ea79bc5feffc254c87291980c2d0bce9acebb68c4983b79f961dcd2cb8a611a0)")/glfw-$GLFW_VER/include"
sdl="$(unpack "$(fetch https://github.com/libsdl-org/SDL/releases/download/release-$SDL_VER/SDL3-$SDL_VER.tar.gz \
  9c75cf16330322c217dedd2e0609f1124f1b54b8633e763467b4684d0f4334a3)")/SDL3-$SDL_VER/include"

# ---------------------------------------------------------------- what to translate

# Rows: <name as in the baseline> <include root> <header below it>
jobs=()
jobs+=("raylib/raylib.h  $raylib raylib.h")
jobs+=("raylib/raymath.h $raylib raymath.h")
jobs+=("sqlite/sqlite3.h $sqlite sqlite3.h")
jobs+=("glfw/GLFW/glfw3.h $glfw GLFW/glfw3.h")

# SDL3: SDL.h and everything it includes, includes first (a depth-first walk over
# '#include <SDL3/...>' lines), so --verify finds each header's includes translated.
declare -A seen=()
sdlorder=()
visit() {
  local h="$1" inc
  [[ -n "${seen[$h]:-}" ]] && return 0
  seen[$h]=1
  [[ -f "$sdl/$h" ]] || return 0
  while read -r inc; do
    visit "$inc"
  done < <(sed -n 's|^[[:space:]]*#[[:space:]]*include[[:space:]]*<\(SDL3/[^>]*\)>.*|\1|p' "$sdl/$h" | tr -d '\r')
  sdlorder+=("$h")
}
visit SDL3/SDL.h
for h in "${sdlorder[@]}"; do
  jobs+=("sdl3/$h $sdl $h")
done

# ---------------------------------------------------------------- run

out="$work/out"
rm -rf "$out"
mkdir -p "$out"
results="$work/results.txt"
: > "$results"

for job in "${jobs[@]}"; do
  read -r name inc rel <<< "$job"
  ti="$out/${name%.h}.ti"
  mkdir -p "$(dirname "$ti")"
  set +e
  "$tiko" c2t "$inc/$rel" -I "$inc" "${sysroot[@]}" --verify -o "$ti" > "${ti%.ti}.c2t.log" 2>&1
  rc=$?
  set -e
  todos=0
  if [[ -f "$ti" ]]; then
    n="$(sed -n "s/^'' \([0-9]*\) items\{0,1\} needs\{0,1\} manual translation:.*/\1/p" "$ti" | head -1)"
    [[ -n "$n" ]] && todos="$n"
  fi
  cw=fail; cl=fail
  if [[ $rc -ne 1 ]]; then
    "$tiko" -c -target windows-x86_64 "$ti" -o "${ti%.ti}.win.o" > "${ti%.ti}.win.log" 2>&1 && cw=ok
    "$tiko" -c -target linux-x86_64   "$ti" -o "${ti%.ti}.lin.o" > "${ti%.ti}.lin.log" 2>&1 && cl=ok
  fi
  printf '%-40s %d %5d %-4s %-4s\n' "$name" "$rc" "$todos" "$cw" "$cl" | tee -a "$results"
done

# ---------------------------------------------------------------- compare

if [[ $accept -eq 1 ]]; then
  { echo "# c2t acceptance corpus: header, c2t exit, TODOs, windows -c, linux -c."
    echo "# Written by 'bash build/c2tcorpus.sh --accept'; a row may only get better."
    cat "$results"; } > "$baseline"
  echo "c2tcorpus: baseline written ($(wc -l < "$results") headers)"
  exit 0
fi

[[ -f "$baseline" ]] || { echo "c2tcorpus: no baseline yet -- run with --accept" >&2; exit 1; }
worse=0; better=0
declare -A base=()
while read -r name rc todos cw cl; do
  [[ -z "$name" || "$name" == \#* ]] && continue
  base[$name]="$rc $todos $cw $cl"
done < "$baseline"
while read -r name rc todos cw cl; do
  if [[ -z "${base[$name]:-}" ]]; then
    echo "NEW    $name ($todos TODOs, windows $cw, linux $cl)"; better=1; continue
  fi
  read -r brc btodos bcw bcl <<< "${base[$name]}"
  msg=""
  # A HEADER c2t COULD NOT TRANSLATE had no TODOs to count: any translation is better.
  (( todos > btodos )) && [[ $brc -ne 1 ]] && msg+=" TODOs $btodos -> $todos;"
  [[ $rc -eq 1 && $brc -ne 1 ]] && msg+=" c2t now fails;"
  [[ $bcw == ok && $cw != ok ]] && msg+=" windows compile now fails;"
  [[ $bcl == ok && $cl != ok ]] && msg+=" linux compile now fails;"
  if [[ -n "$msg" ]]; then
    echo "WORSE  $name:$msg"; worse=1
  elif (( todos < btodos )) || [[ $bcw != ok && $cw == ok ]] || [[ $bcl != ok && $cl == ok ]] || [[ $brc -eq 1 && $rc -ne 1 ]]; then
    echo "BETTER $name: TODOs $btodos -> $todos, windows $bcw -> $cw, linux $bcl -> $cl"; better=1
  fi
done < "$results"
total=$(awk '{s += $3} END {print s}' "$results")
echo "c2tcorpus: $(wc -l < "$results") headers, $total TODOs"
if [[ $worse -ne 0 ]]; then echo "c2tcorpus: FAILED -- worse than tests/c2t/corpus.baseline" >&2; exit 1; fi
if [[ $better -ne 0 ]]; then echo "c2tcorpus: better than the baseline -- record it with --accept"; fi
exit 0
