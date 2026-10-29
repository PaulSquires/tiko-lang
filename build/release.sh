#!/bin/bash
# release.sh -- archive, hash, smoke-test and (only when asked) publish a toolchain release.
#
#   bash build/release.sh --notes <notes.md> [--sha <commit>] [--prev <dir>]
#                         [--editor <dir>] [--no-tkedit] [--no-mac] [--publish [--latest]]
#
# THE RECIPE THAT LIVED IN MEMORY NOTES (review BLD-06, 2026-10-24), as one script. It does
# not package: run build/package.sh --verify for each host first (Windows here, Linux under
# WSL, and on the Mac in ~/dev/tiko-lang), at the SAME commit. Then this:
#
#   1. refuses unless every toolchain's MANIFEST.txt names the commit (default HEAD);
#   2. zips toolchains/tiko-windows with C:/Windows/System32/tar.exe (bsdtar) -- Git Bash's
#      bare tar.exe is GNU tar, whose '-a -cf x.zip' writes an uncompressed TAR named .zip --
#      and checks the result is a zip;
#   3. tars toolchains/tiko-linux under WSL from a copy in ~/tkrel-<sha>, 644 for files and
#      755 for bin/tiko, owner 0 (tarring from /mnt/c gives every file 777);
#      both archives carry the editor beside the toolchain: toolchains/tkedit-<host> (made by
#      package.sh) as tkedit/, so each unpacks to tiko-<host>/ and tkedit/ (--no-tkedit: not;
#      the zip adds a staged copy named tkedit, as System32's bsdtar cannot rename with -s);
#   3b. tars toolchains/tiko-macos ON THE MAC (docs/tiko-macos M9), over ssh to TKO_MAC_HOST
#      (default 'mac', options in TKO_MAC_SSH_OPTS): bsdtar, owner 0, no extended attributes
#      or AppleDouble files, 644/755 as above; copied back here. It unpacks to tiko-macos/
#      and tkedit/ (the Mac's toolchains/tkedit-macos), as the others do. --no-mac leaves it out;
#   4. writes SHA256SUMS and appends the hashes to a copy of the notes;
#   5. smoke-tests each archive extracted into an empty directory with no TKO_* variable:
#      hello.tiko compiled and run, and tkedit/ holds the program alone -- tkedit.exe / tkedit,
#      or on macOS tkEdit.app, whose signature verifies (tkedit is one file, docs/tkEdit/SINGLE-FILE.md);
#   6. with --prev <dir> holding the previous release's two archives, prints the files each
#      archive gained and lost;
#   7. with --editor <dir>, mirrors tiko-windows into <dir> (the editor's toolchain copy);
#   8. with --publish, and only then, 'gh release create toolchain-<short> --target <full sha>'
#      -- a short sha is HTTP 422 -- with the archives. --latest marks it Latest.
#
# Everything lands in build/.release/<short>/. Nothing is published without --publish.
set -o pipefail
ROOT=$(cd "$(dirname "$0")/.." && pwd)
cd "$ROOT" || exit 2
NOTES="" SHA="" PREV="" EDITOR="" PUBLISH=0 LATEST=0 TKEDIT=1 MAC=1
while [ $# -gt 0 ]; do
    case "$1" in
        --notes)   shift; NOTES=$1 ;;
        --sha)     shift; SHA=$1 ;;
        --prev)    shift; PREV=$1 ;;
        --editor)  shift; EDITOR=$1 ;;
        --publish) PUBLISH=1 ;;
        --latest)  LATEST=1 ;;
        --no-tkedit) TKEDIT=0 ;;
        --no-mac)  MAC=0 ;;
        -h|--help) sed -n '2,33p' "$0"; exit 0 ;;
        *) echo "release: unknown argument '$1'" >&2; exit 2 ;;
    esac
    shift
done
die( ) { echo "release: FAILED -- $*" >&2; exit 1; }
note( ) { echo "release: $*"; }

[ -n "$NOTES" ] && [ -f "$NOTES" ] || die "--notes <file> is required: write them from the previous release's"
SHA=$(git rev-parse "${SHA:-HEAD}") || die "no such commit"
SHORT=${SHA:0:8}
WIN=toolchains/tiko-windows
LNX=toolchains/tiko-linux
TKWIN=toolchains/tkedit-windows
TKLNX=toolchains/tkedit-linux
OUT=build/.release/$SHORT
mkdir -p "$OUT"
MACH=${TKO_MAC_HOST:-mac}
MSSH=${TKO_MAC_SSH_OPTS:-}
# A REMOTE STEP IS A FILE, run by a login zsh: a non-login ssh shell has no Homebrew on PATH,
# and variables in an inline ssh command expand on the wrong side (build/aapcslane.sh).
on_mac( ) {
    scp -q -o BatchMode=yes $MSSH "$1" "$MACH:tkm/$(basename "$1")" || return 1
    ssh -o BatchMode=yes $MSSH "$MACH" zsh -l "tkm/$(basename "$1")" < /dev/null
}

# 1. both hosts packaged at this commit
for t in "$WIN" "$LNX"; do
    [ -f "$t/MANIFEST.txt" ] || die "$t has no MANIFEST.txt -- run build/package.sh --verify for it"
    grep -q "$SHORT" "$t/MANIFEST.txt" || die "$t/MANIFEST.txt does not name $SHORT -- repackage it at this commit"
    grep -q " FAIL" "$t/MANIFEST.txt" && die "$t/MANIFEST.txt records a FAIL -- read its verification section"
done
note "both MANIFESTs name $SHORT"
if [ "$MAC" = "1" ]; then
    cat > "$OUT/mac-check.sh" <<EOF
cd ~/dev/tiko-lang/toolchains/tiko-macos || exit 2
grep -q "$SHORT" MANIFEST.txt || exit 3
grep -q " FAIL" MANIFEST.txt && exit 4
[ "$TKEDIT" = "1" ] || exit 0
[ -f ../tkedit-macos/tkEdit.app/Contents/MacOS/tkedit ] || exit 5
grep -q "^tkedit  *\.\./tkedit-macos" MANIFEST.txt || exit 6
exit 0
EOF
    on_mac "$OUT/mac-check.sh"; rc=$?
    [ $rc = 0 ] || die "the Mac's toolchains/tiko-macos: none (2), MANIFEST not at $SHORT (3), a FAIL in it (4), no tkedit-macos/tkEdit.app (5) or no tkedit line (6; or pass --no-tkedit) -- rc $rc"
    note "the Mac's MANIFEST names $SHORT"
fi
if [ "$TKEDIT" = "1" ]; then
    [ -f "$TKWIN/tkedit.exe" ] || die "no $TKWIN/tkedit.exe -- package.sh packages it (or pass --no-tkedit)"
    [ -f "$TKLNX/tkedit" ] || die "no $TKLNX/tkedit -- package.sh under WSL packages it (or pass --no-tkedit)"
    grep -q "^tkedit  *\.\./tkedit-windows" "$WIN/MANIFEST.txt" || die "$WIN/MANIFEST.txt has no tkedit line: $TKWIN is not from this packaging"
    grep -q "^tkedit  *\.\./tkedit-linux" "$LNX/MANIFEST.txt" || die "$LNX/MANIFEST.txt has no tkedit line: $TKLNX is not from this packaging"
fi

# 2. the Windows zip
ZIP=$OUT/tiko-windows-x86_64-$SHORT.zip
BSDTAR=/c/Windows/System32/tar.exe
[ -x "$BSDTAR" ] || die "no $BSDTAR (bsdtar) -- the GNU tar in Git Bash cannot write a zip"
rm -f "$ZIP"
if [ "$TKEDIT" = "1" ]; then
    # tkedit-windows goes in as tkedit/: System32's bsdtar has no -s to rename, so a copy named
    # tkedit is staged in $OUT and added from there with -C
    rm -rf "$OUT/stage" && mkdir -p "$OUT/stage" && cp -r "$TKWIN" "$OUT/stage/tkedit" || die "staging tkedit"
    ( cd toolchains && "$BSDTAR" -a -cf "$ROOT/$ZIP" tiko-windows -C "$ROOT/$OUT/stage" tkedit ) || die "zip failed"
    rm -rf "$OUT/stage"
else
    ( cd toolchains && "$BSDTAR" -a -cf "$ROOT/$ZIP" tiko-windows ) || die "zip failed"
fi
file "$ZIP" | grep -q "Zip archive" || die "$ZIP is not a zip archive"
note "zip $(du -h "$ZIP" | cut -f1)"

# 3. the Linux tar.gz, under WSL
TGZ=$OUT/tiko-linux-x86_64-$SHORT.tar.gz
WSLSH=$OUT/tar-linux.sh
TKDIRS=""
[ "$TKEDIT" = "1" ] && TKDIRS="tkedit"
cat > "$WSLSH" <<EOF
set -e
rm -rf ~/tkrel-$SHORT && mkdir -p ~/tkrel-$SHORT
cp -r "/mnt/c${ROOT#/c}/$LNX" ~/tkrel-$SHORT/tiko-linux
[ -z "$TKDIRS" ] || cp -a "/mnt/c${ROOT#/c}/$TKLNX" ~/tkrel-$SHORT/tkedit
cd ~/tkrel-$SHORT
find tiko-linux $TKDIRS -type f -exec chmod 644 {} +
find tiko-linux $TKDIRS -type d -exec chmod 755 {} +
chmod 755 tiko-linux/bin/tiko
[ -z "$TKDIRS" ] || chmod 755 tkedit/tkedit
tar -czf "/mnt/c${ROOT#/c}/$TGZ" --owner=0 --group=0 tiko-linux $TKDIRS
EOF
MSYS_NO_PATHCONV=1 wsl.exe -e sh "/mnt/c${ROOT#/c}/$WSLSH" || die "WSL tar failed"
[ -s "$TGZ" ] || die "no $TGZ"
note "tar.gz $(du -h "$TGZ" | cut -f1)"

# 3b. the macOS tar.gz, on the Mac
MTGZ=""
if [ "$MAC" = "1" ]; then
    MTGZ=$OUT/tiko-macos-arm64-$SHORT.tar.gz
    cat > "$OUT/tar-macos.sh" <<EOF
set -e
rm -rf ~/tkrel-$SHORT && mkdir -p ~/tkrel-$SHORT
cp -R ~/dev/tiko-lang/toolchains/tiko-macos ~/tkrel-$SHORT/tiko-macos
[ -z "$TKDIRS" ] || cp -R ~/dev/tiko-lang/toolchains/tkedit-macos ~/tkrel-$SHORT/tkedit
cd ~/tkrel-$SHORT
xattr -cr tiko-macos $TKDIRS
find tiko-macos $TKDIRS -type f -exec chmod 644 {} +
find tiko-macos $TKDIRS -type d -exec chmod 755 {} +
chmod 755 tiko-macos/bin/tiko
[ -z "$TKDIRS" ] || chmod 755 tkedit/tkEdit.app/Contents/MacOS/tkedit
COPYFILE_DISABLE=1 tar --no-xattrs --no-mac-metadata --uid 0 --gid 0 -czf tiko-macos-arm64-$SHORT.tar.gz tiko-macos $TKDIRS
EOF
    on_mac "$OUT/tar-macos.sh" || die "the Mac's tar failed"
    scp -q -o BatchMode=yes $MSSH "$MACH:tkrel-$SHORT/tiko-macos-arm64-$SHORT.tar.gz" "$MTGZ" || die "scp of the macOS archive"
    [ -s "$MTGZ" ] || die "no $MTGZ"
    note "macOS tar.gz $(du -h "$MTGZ" | cut -f1)"
fi

# 4. hashes, and the notes with them
( cd "$OUT" && sha256sum "$(basename "$ZIP")" "$(basename "$TGZ")" ${MTGZ:+"$(basename "$MTGZ")"} > SHA256SUMS ) || die "sha256sum"
{ cat "$NOTES"; echo; echo "### SHA-256"; echo; echo '```text'; cat "$OUT/SHA256SUMS"; echo '```'; } > "$OUT/notes.md"
note "SHA256SUMS and notes.md written"

# 5. smoke tests: an empty directory, no TKO_*
SMOKE=$OUT/smoke
rm -rf "$SMOKE" && mkdir -p "$SMOKE/win"
printf 'print "hello from tiko"\n' > "$SMOKE/hello.tiko"
( cd "$SMOKE/win" && "$BSDTAR" -xf "$ROOT/$ZIP" ) || die "zip does not extract"
got=$( cd "$SMOKE" && env -u TKO_INCLUDE -u TKO_LIBPATH -u TKO_PKG \
       win/tiko-windows/tiko.exe hello.tiko -o hello.exe && ./hello.exe ) || die "Windows smoke: $got"
[ "$got" = "hello from tiko" ] || die "Windows smoke printed '$got'"
if [ "$TKEDIT" = "1" ]; then
    [ -f "$SMOKE/win/tkedit/tkedit.exe" ] && [ "$(ls -A "$SMOKE/win/tkedit" | wc -l)" = 1 ] \
        || die "Windows smoke: tkedit/ in the zip is not tkedit.exe alone"
fi
note "smoke windows-x86_64: ok"
cat > "$OUT/smoke-linux.sh" <<EOF
set -e
rm -rf ~/tksmoke-$SHORT && mkdir -p ~/tksmoke-$SHORT && cd ~/tksmoke-$SHORT
tar -xzf "/mnt/c${ROOT#/c}/$TGZ"
[ -z "$TKDIRS" ] || { test -x tkedit/tkedit && test "\$(ls -A tkedit | wc -l)" = 1; }
printf 'print "hello from tiko"\n' > hello.tiko
env -u TKO_INCLUDE -u TKO_LIBPATH -u TKO_PKG tiko-linux/bin/tiko hello.tiko -o hello
./hello
EOF
got=$(MSYS_NO_PATHCONV=1 wsl.exe -e sh "/mnt/c${ROOT#/c}/$OUT/smoke-linux.sh" | tr -d '\r') || die "Linux smoke: $got"
[ "$got" = "hello from tiko" ] || die "Linux smoke printed '$got'"
note "smoke linux-x86_64: ok"
# AS A NEW USER WOULD: a fresh HOME, PATH the system's alone, no TKO_*. The compiler finds
# Homebrew's clang by its own default (docs/tiko-macos D6), not through PATH.
if [ "$MAC" = "1" ]; then
    cat > "$OUT/smoke-macos.sh" <<EOF
set -e
rm -rf ~/tksmoke-$SHORT && mkdir -p ~/tksmoke-$SHORT/home && cd ~/tksmoke-$SHORT
tar -xzf ~/tkrel-$SHORT/tiko-macos-arm64-$SHORT.tar.gz
[ -z "$TKDIRS" ] || { test -x tkedit/tkEdit.app/Contents/MacOS/tkedit && test "\$(ls -A tkedit | wc -l)" = 1 && codesign --verify --deep --strict tkedit/tkEdit.app; }
echo 'print "hello from tiko"' > hello.tiko
env -i HOME=\$PWD/home PATH=/usr/bin:/bin tiko-macos/bin/tiko hello.tiko -o hello
./hello
EOF
    got=$(on_mac "$OUT/smoke-macos.sh") || die "macOS smoke: $got"
    [ "$got" = "hello from tiko" ] || die "macOS smoke printed '$got'"
    note "smoke macos-arm64: ok"
fi

# 6. what changed against the previous release
if [ -n "$PREV" ]; then
    for kind in zip tar.gz; do
        p=$(ls "$PREV"/*."$kind" 2>/dev/null | head -1)
        n=$(ls "$OUT"/*."$kind" | head -1)
        [ -n "$p" ] || { note "no previous .$kind in $PREV"; continue; }
        "$BSDTAR" -tf "$p" | sort > "$OUT/prev.$kind.txt"
        "$BSDTAR" -tf "$n" | sort > "$OUT/new.$kind.txt"
        note ".$kind: +$(comm -13 "$OUT/prev.$kind.txt" "$OUT/new.$kind.txt" | wc -l) files, -$(comm -23 "$OUT/prev.$kind.txt" "$OUT/new.$kind.txt" | wc -l) files (lists in $OUT)"
    done
fi

# 7. the editor's copy
if [ -n "$EDITOR" ]; then
    MSYS_NO_PATHCONV=1 robocopy "$(cygpath -w "$ROOT/$WIN")" "$(cygpath -w "$EDITOR")" /MIR /NFL /NDL /NJH /NJS /NP > /dev/null
    [ $? -lt 8 ] || die "robocopy into $EDITOR failed"
    note "editor toolchain mirrored into $EDITOR"
fi

# 8. publish -- only when asked
if [ "$PUBLISH" = "1" ]; then
    command -v gh > /dev/null 2>&1 || die "no gh"
    flags=""; [ "$LATEST" = "1" ] && flags="--latest"
    gh release create "toolchain-$SHORT" --target "$SHA" --title "toolchain-$SHORT" \
        --notes-file "$OUT/notes.md" $flags "$ZIP" "$TGZ" ${MTGZ:+"$MTGZ"} || die "gh release create"
    note "published toolchain-$SHORT"
else
    note "not published (pass --publish); everything is in $OUT"
fi
