"""vendor/pl_mpeg: the header 'tiko c2t' translates into pl_mpeg.ti, made from the PATCHED pl_mpeg.h.

    patch -p1 -i patches/0001-pl_mpeg-stdio-and-PLM_API.patch     (in the unpacked c871f2b)
    python -I prepare.py <patched pl_mpeg.h> pl_mpeg.h
    tiko c2t pl_mpeg.h -o pl_mpeg.ti --verify --sysroot //wsl.localhost/Ubuntu --macos-sysroot c2t-macsdk

(the macOS pass, on Windows, against c2t-macsdk: a stand-in for the SDK's <stdio.h>, declaring
FILE alone, as an incomplete type -- no Apple file may leave the Mac).

(the output keeps the name pl_mpeg.h, so the translation's banner and TODO lines name it).

THE DECLARATION HALF only: c2t translates branches no target takes, so on the whole header it
translates the implementation too (147 TODOs, against 6 for the declarations). The lines from
'#ifdef PL_MPEG_IMPLEMENTATION' to its '#endif' are dropped.
"""
import re
import sys

inp, outp = sys.argv[1:3]
with open(inp, encoding='utf-8', newline='') as f:
    lines = f.read().replace('\r\n', '\n').splitlines(keepends=True)
out, skip = [], False
for ln in lines:
    if not skip and re.match(r'#ifdef PL_MPEG_IMPLEMENTATION\s*$', ln):
        skip = True
    elif skip and re.match(r'#endif // PL_MPEG_IMPLEMENTATION', ln):
        skip = False
    elif not skip:
        out.append(ln)
if skip or len(out) == len(lines):
    sys.exit("prepare.py: implementation guard not found or not closed")
with open(outp, 'w', encoding='utf-8', newline='\n') as f:
    f.writelines(out)
print(f"prepare.py: pl_mpeg: {len(out)} of {len(lines)} lines")
