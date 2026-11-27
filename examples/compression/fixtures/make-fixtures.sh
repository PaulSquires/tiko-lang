#!/bin/bash
# examples/compression/fixtures: the files selftest decodes, made by the REFERENCE tools -- not by
# vendor/compression -- so the selftest checks the formats, not our library against itself. Run
# once, in WSL (or any Linux), from this directory; the outputs are committed beside it.
#
#     bash make-fixtures.sh
#
# sample.txt is generated (deterministic, 19,666 bytes of numbered lines: free to use). Each tool
# compresses it at a fixed level; gzip with -n (no name or time stamp, so the bytes do not
# change). A tool that is not installed is skipped and named: brotli and lz4 are not on stock
# Ubuntu ('sudo apt install brotli lz4'). The zip is written by Python's zipfile, with a fixed
# date, deflated.
set -u
cd "$(dirname "$0")" || exit 1
python3 - <<'EOF'
words = ["alpha", "bravo", "charlie", "delta", "echo", "foxtrot", "golf", "hotel", "india", "juliet"]
with open("sample.txt", "w", newline="\n") as f:
    for i in range(1, 801):
        f.write("%04d %s %s %s\n" % (i, words[i % 10], words[(i * 7) % 10], "-" * (i % 13)))
EOF
made=; skipped=
mk( ) {  # mk <tool> <output> <command...>  (reads sample.txt, writes the output)
    local tool=$1 out=$2; shift 2
    if command -v "$tool" >/dev/null 2>&1; then "$@" < sample.txt > "$out" && made="$made $out ($($tool --version 2>&1 | head -1))" || echo "FAILED: $out"
    else rm -f "$out"; skipped="$skipped $tool"; fi
}
mk gzip   sample.txt.gz   gzip -9 -n -c
mk zstd   sample.txt.zst  zstd -19 -q -c
mk xz     sample.txt.xz   xz -6 -c
mk bzip2  sample.txt.bz2  bzip2 -9 -c
mk brotli sample.txt.br   brotli -q 11 -c
mk lz4    sample.txt.lz4  lz4 -9 -c
python3 - <<'EOF'
import zipfile
with zipfile.ZipFile("sample.zip", "w", zipfile.ZIP_DEFLATED) as z:
    zi = zipfile.ZipInfo("sample.txt", date_time=(2026, 11, 26, 0, 0, 0))
    zi.compress_type = zipfile.ZIP_DEFLATED
    z.writestr(zi, open("sample.txt", "rb").read())
EOF
echo "made: sample.txt$made sample.zip (Python $(python3 -c 'import sys; print(sys.version.split()[0])') zipfile)"
[ -n "$skipped" ] && echo "skipped (not installed):$skipped"
ls -l sample.*
