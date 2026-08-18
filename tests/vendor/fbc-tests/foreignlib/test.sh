#!/bin/bash
#
# Functional test for #foreignlib (RFC-0005).
#
# tests/errors covers the diagnostics and the per-target probe order. What it
# cannot cover is the part that actually matters: that a library VENDORED INTO
# THE SOURCE TREE is found relative to the file that declares it, links, and
# runs -- from a working directory that knows nothing about it. That is the
# case #libpath cannot express, so it is the case worth having a test for.
#
# Self-contained: builds its own library, cleans up after itself, and is run
# directly rather than through make (same as tests/errors and tests/warnings).
#
#   FBC="/path/to/fbc.exe -i /path/to/src/inc" bash ./test.sh
#
# Exits non-zero on the first failure.

set -u

FBC=`printenv FBC`
FBC=${FBC:-fbc}

here=$( cd "$( dirname "$0" )" && pwd )
work="$here/tmp"
fails=0

function check() {
	if [ "$2" == "$3" ]; then
		echo "ok       $1"
	else
		echo "FAILED   $1"
		echo "           expected: $2"
		echo "           got:      $3"
		fails=$((fails+1))
	fi
}

rm -rf "$work"
mkdir -p "$work/pkg/lib"

# ---------------------------------------------------------------- the package
#
# A binding that ships its own static library, named by the convention, and
# refers to it by a path relative to the .bi -- not to anyone's cwd.

cat > "$work/pkg/src.bas" <<'EOF'
function pkg_add cdecl alias "pkg_add" ( byval a as long, byval b as long ) as long export
	return a + b
end function
EOF

hostos=`uname`
case "$hostos" in
*MINGW*|*MSYS*|*CYGWIN*) ostag=windows ;;
Darwin)                  ostag=darwin  ;;
*)                       ostag=linux   ;;
esac
case `uname -m` in
x86_64|amd64) archtag=x86_64  ;;
aarch64|arm64) archtag=aarch64 ;;
i?86)         archtag=x86     ;;
*)            archtag=`uname -m` ;;
esac

$FBC -lib "$work/pkg/src.bas" -x "$work/pkg/lib/pkg_${ostag}_${archtag}.a" || exit 1

cat > "$work/pkg/pkg.bi" <<'EOF'
#foreignlib PKG static "lib/pkg"
declare function pkg_add cdecl lib PKG alias "pkg_add" ( byval a as long, byval b as long ) as long
EOF

cat > "$work/main.bas" <<'EOF'
#include once "pkg/pkg.bi"
print pkg_add( 20, 22 )
EOF

# ------------------------------------------------ 1. builds from the tree root

( cd "$work" && $FBC main.bas -x main1 ) || exit 1
check "vendored lib links from the project directory" "42" "$( cd "$work" && ./main1 | tr -d ' \r' )"

# ------------------------- 2. and from a directory that has never heard of it
#
# This is the whole point. The same source, built from elsewhere, resolves the
# same library -- because the spec is relative to pkg.bi, not to cwd.

( cd / && $FBC "$work/main.bas" -x "$work/main2" ) || exit 1
check "vendored lib links from an unrelated cwd"     "42" "$( cd / && "$work/main2" | tr -d ' \r' )"

# ------------------------------- 3. the recipe survives into the object file
#
# A module compiled to .o on its own must carry its own link recipe, exactly
# as an #inclib does, or separate compilation loses the binding.

cat > "$work/mod.bas" <<'EOF'
#include once "pkg/pkg.bi"
function callit cdecl alias "callit" ( ) as long export
	return pkg_add( 1, 2 )
end function
EOF
cat > "$work/drv.bas" <<'EOF'
declare function callit cdecl alias "callit" ( ) as long
print callit( )
EOF

( cd "$work" && $FBC -c mod.bas -x mod.o ) || exit 1
( cd "$work" && $FBC -c -m drv drv.bas -x drv.o ) || exit 1
( cd / && $FBC "$work/drv.o" "$work/mod.o" -x "$work/main3" ) || exit 1
check "objinfo carries the resolved recipe"          "3"  "$( cd / && "$work/main3" | tr -d ' \r' )"

# --------------------------------------- 4. the untagged fallback still works

mkdir -p "$work/pkg2/lib"
cp "$work/pkg/lib/pkg_${ostag}_${archtag}.a" "$work/pkg2/lib/plain.a"
cat > "$work/pkg2/pkg.bi" <<'EOF'
#foreignlib PLAIN static "lib/plain"
declare function pkg_add cdecl lib PLAIN alias "pkg_add" ( byval a as long, byval b as long ) as long
EOF
cat > "$work/main4.bas" <<'EOF'
#include once "pkg2/pkg.bi"
print pkg_add( 3, 4 )
EOF
( cd "$work" && $FBC main4.bas -x main4 ) || exit 1
check "untagged filename resolves as the fallback"   "7"  "$( cd "$work" && ./main4 | tr -d ' \r' )"

# ---------------------------- 5. a more specific variant wins over a plainer one

cp "$work/pkg/lib/pkg_${ostag}_${archtag}.a" "$work/pkg2/lib/plain_${ostag}_${archtag}.a"
cat > "$work/wrong.bas" <<'EOF'
function pkg_add cdecl alias "pkg_add" ( byval a as long, byval b as long ) as long export
	return 999
end function
EOF
$FBC -lib "$work/wrong.bas" -x "$work/pkg2/lib/plain.a" || exit 1
( cd "$work" && $FBC main4.bas -x main5 ) || exit 1
check "os_arch variant is preferred over untagged"   "7"  "$( cd "$work" && ./main5 | tr -d ' \r' )"

rm -rf "$work"

echo
if [ $fails -eq 0 ]; then
	echo "foreignlib: all checks passed"
else
	echo "foreignlib: $fails check(s) FAILED"
	exit 1
fi
