"""vendor/miniaudio: the header 'tiko c2t' translates into ../miniaudio.ti, made from miniaudio.h.

    python -I prepare.py <miniaudio.h, 0.11.26> miniaudio.h
    tiko c2t miniaudio.h -o ../miniaudio.ti --verify --shared-macro MA_DLL --sysroot //wsl.localhost/Ubuntu \n        --macos-sysroot ../../pl_mpeg/c2t-macsdk

(the macOS pass, on Windows: the declaration half includes no system header but clang's own
<stddef.h> and <stdarg.h>, so any sysroot serves -- pl_mpeg's stand-in is one).

(the output keeps the name miniaudio.h, so the translation's banner and TODO lines name it).
The library itself is built from the untouched header (build.sh); this one is c2t's alone.

THE DECLARATION HALF only: c2t translates branches no target takes, so on the whole header it
would translate the implementation too. The implementation guard's lines are dropped; what
follows it (the licence) is kept. Besides, each change keeping the C layout -- checked with clang
(sizeof and alignof of 33 records, original vs prepared header) and against tiko's sizeof, in
RFC-0005 P0 (claude-docs docs/tiko-vendor/probes/av0, layout-check.*):
  - MA_ATOMIC(n, T) -> T. Every use's n is T's natural alignment on the 64-bit targets tiko has
    (4 for 32-bit types and enums, 8 for ma_uint64, MA_SIZEOF_PTR for pointers). c2t refuses
    the declarations MA_ATOMIC_SAFE_TYPE_DECL(...) invocations make; they become the typedef
    structs they expand to.
  - <pthread.h> -> opaque unions of the MEASURED sizes (pthread-sizes.c), per target -- the
    table is in PTHREAD below; a target not measured is an #error, and so is Android (PTHREAD
    says why). c2t maps no <pthread.h>, and without this every record holding a
    pthread type -- ma_context and ma_device among them -- is refused on the Linux pass.
    miniaudio's own MA_NO_PTHREAD_IN_HEADER is glibc x86-64's sizes for every POSIX target,
    which is wrong for glibc arm64 (mutex 48) and macOS (mutex 64).
  - ma_device_info's unnamed member struct gets a tag, ma_device_info_native_data_format: c2t
    cannot refer to an unnamed record in an array member.
"""
import re
import sys


def cut(lines, start_re, end_re):
    out, skip = [], False
    for ln in lines:
        if not skip and re.match(start_re, ln):
            skip = True
            continue
        if skip:
            if re.match(end_re, ln):
                skip = False
            continue
        out.append(ln)
    if skip:
        sys.exit("prepare.py: implementation guard not closed")
    return out


PTHREAD = """        /* prepare.py (RFC-0005): pthread types as opaque unions of each target's MEASURED size and
           alignment (pthread-sizes.c, run on the target; for Android, its object-file twin):
               target          mutex   cond    (size/alignment)
               linux x86-64    40/8    48/8    glibc 2.35
               linux arm64     48/8    48/8    glibc 2.35 and 2.39
               macos arm64     64/8    48/8    the macOS 26 SDK
               android         40/4    48/4    NDK 30, x86-64 and arm64
           pthread_t is 8/8 on all of them. */
        typedef ma_uintptr ma_pthread_t;
        #if defined(TIKO_OS_ANDROID)
            /* tiko's own name, not __ANDROID__: c2t takes __ANDROID__ as never true, having no
               Android pass. And Android is not translated: five records -- ma_context, ma_device,
               ma_event, ma_fence, ma_semaphore -- are laid out differently there (its backends,
               and these 4-byte alignments), which only an Android pass would carry. */
            #error "vendor/miniaudio is not translated for Android: c2t has no Android pass (RFC-0005 P3)"
        #elif defined(__APPLE__)
            typedef union ma_pthread_mutex_t { char __data[64]; ma_uint64 __alignment; } ma_pthread_mutex_t;
            typedef union ma_pthread_cond_t  { char __data[48]; ma_uint64 __alignment; } ma_pthread_cond_t;
        #elif defined(__linux__) && defined(__aarch64__)
            typedef union ma_pthread_mutex_t { char __data[48]; ma_uint64 __alignment; } ma_pthread_mutex_t;
            typedef union ma_pthread_cond_t  { char __data[48]; ma_uint64 __alignment; } ma_pthread_cond_t;
        #elif defined(__linux__) && defined(__x86_64__)
            typedef union ma_pthread_mutex_t { char __data[40]; ma_uint64 __alignment; } ma_pthread_mutex_t;
            typedef union ma_pthread_cond_t  { char __data[48]; ma_uint64 __alignment; } ma_pthread_cond_t;
        #else
            #error "vendor/miniaudio: pthread sizes not measured for this target"
        #endif
"""


def miniaudio(src):
    lines = src.splitlines(keepends=True)
    lines = cut(lines, r'#if defined\(MINIAUDIO_IMPLEMENTATION\) \|\| defined\(MA_IMPLEMENTATION\)\s*$',
                r'#endif\s+/\* MINIAUDIO_IMPLEMENTATION \*/')
    s = "".join(lines)
    # pthread
    old = re.search(r'( *)#ifndef MA_NO_PTHREAD_IN_HEADER\n.*?\n\1#endif\n', s, re.S)
    if not old:
        sys.exit("prepare.py: pthread block not found")
    s = s[:old.start()] + PTHREAD + s[old.end():]
    # atomics: the safe-type invocations, then every MA_ATOMIC use outside a #define
    s, n = re.subn(r'^MA_ATOMIC_SAFE_TYPE_DECL\(\s*\w+\s*,\s*\d+\s*,\s*(\w+)\s*\)',
                   lambda m: f'typedef struct {{ ma_{m[1]} value; }} ma_atomic_{m[1]};', s, flags=re.M)
    if n != 6:
        sys.exit(f"prepare.py: {n} MA_ATOMIC_SAFE_TYPE_DECL invocations, expected 6")
    out, uses = [], 0
    for ln in s.splitlines(keepends=True):
        if not ln.lstrip().startswith('#define'):
            ln, k = re.subn(r'MA_ATOMIC\(\s*(?:\d+|MA_SIZEOF_PTR)\s*,\s*([^()]+?)\s*\)', r'\1', ln)
            uses += k
        out.append(ln)
    s = "".join(out)
    # what is left is inside macro bodies (MA_ATOMIC_SAFE_TYPE_DECL's), never a use
    if re.search(r'MA_ATOMIC\(\s*(?:\d+|MA_SIZEOF_PTR)\s*,', s):
        sys.exit("prepare.py: an MA_ATOMIC use is left")
    # ma_device_info's unnamed member struct
    s, n = re.subn(r'(ma_uint32 nativeDataFormatCount;\n\s*)struct\n', r'\1struct ma_device_info_native_data_format\n', s)
    if n != 1:
        sys.exit("prepare.py: ma_device_info.nativeDataFormats not found")
    print(f"prepare.py: miniaudio: {len(lines)} lines, {uses} MA_ATOMIC uses flattened")
    return s


if __name__ == '__main__':
    inp, outp = sys.argv[1:3]
    with open(inp, encoding='utf-8', newline='') as f:
        src = f.read().replace('\r\n', '\n')
    res = miniaudio(src)
    with open(outp, 'w', encoding='utf-8', newline='\n') as f:
        f.write(res)
