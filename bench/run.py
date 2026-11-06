#!/usr/bin/env python3
"""Build, verify and time the Benchmarks Game programs in game/.

    python bench/run.py                  full sizes, 3 timed runs, every language
    python bench/run.py --quick          small sizes, 1 run (development)
    python bench/run.py --only n-body,fasta --lang tiko,c --runs 5
    python bench/run.py --check          build and verify only, no timing

Every program is built from game/<program>/<program>.<ext> with each language's
release flags, run with its output written to a file, and the output compared
with the Python reference (oracle.py) where that is affordable, and with the C
program's output always. A program whose output is wrong is reported and not
timed.

Toolchains are found from environment variables, then a bench-tools directory
($BENCH_TOOLS, ~/bench-tools, or bench-tools beside the repository), then PATH.
C is compiled by the clang tiko uses ($TIKO_CLANG, else tiko's default path), so
both go through the same LLVM:

    BENCH_TIKO  BENCH_CC  BENCH_RUSTC  BENCH_CARGO  BENCH_GO  BENCH_ZIG
    BENCH_LIBS  (Windows: a MinGW prefix with include/, lib/, bin/ holding GMP and PCRE2)
    BENCH_INC   (Linux: extra include directories for gmp.h and pcre2.h, ':'-separated)
"""

import argparse
import hashlib
import json
import os
import platform
import shutil
import statistics
import subprocess
import sys
import time

import oracle

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
GAME = os.path.join(HERE, "game")
WINDOWS = os.name == "nt"
EXE = ".exe" if WINDOWS else ""
TARGET = "windows" if WINDOWS else "linux"

LANGS = ["tiko", "c", "rust", "go", "zig"]
EXT = {"tiko": "tiko", "c": "c", "rust": "rs", "go": "go", "zig": "zig"}

# name: (full size, quick size, input file or None, C libraries used)
PROGRAMS = {
    "binary-trees":       (21,       10,    None,               []),
    "fannkuch-redux":     (12,       7,     None,               []),
    "fasta":              (25000000, 1000,  None,               []),
    "k-nucleotide":       (None,     None,  (25000000, 25000),  []),
    "mandelbrot":         (16000,    200,   None,               []),
    "n-body":             (50000000, 1000,  None,               []),
    "pidigits":           (10000,    30,    None,               ["gmp"]),
    "regex-redux":        (None,     None,  (5000000, 25000),   ["pcre2"]),
    "reverse-complement": (None,     None,  (25000000, 25000),  []),
    "spectral-norm":      (5500,     100,   None,               []),
}

# Rust and Go do not use the C libraries: Go has math/big and regexp, and Rust
# uses the regex crate for regex-redux (a cargo project in game/regex-redux/rust).
C_LIB_LANGS = {"tiko", "c", "zig", "rust"}
NO_C_LIBS = {("rust", "pcre2")}


# ------------------------------------------------------------------ toolchains

def tools_dirs():
    dirs = []
    if os.environ.get("BENCH_TOOLS"):
        dirs.append(os.environ["BENCH_TOOLS"])
    dirs.append(os.path.expanduser("~/bench-tools"))
    dirs.append(os.path.join(os.path.dirname(REPO), "bench-tools"))
    return [d for d in dirs if os.path.isdir(d)]


def find_tool(env, names, rel=()):
    if os.environ.get(env):
        return os.environ[env]
    for d in tools_dirs():
        for r in rel:
            p = os.path.join(d, r)
            if os.path.isfile(p):
                return p
    for n in names:
        p = shutil.which(n)
        if p:
            return p
    return None


class Toolchains:
    def __init__(self):
        tiko_rel = ("toolchains/tiko-windows/tiko.exe" if WINDOWS
                    else "toolchains/tiko-linux/bin/tiko")
        self.tiko = os.environ.get("BENCH_TIKO") or os.path.join(REPO, tiko_rel)
        self.cc = self.find_cc()
        self.rustc = find_tool("BENCH_RUSTC", ["rustc"], ["cargo/bin/rustc" + EXE])
        self.cargo = find_tool("BENCH_CARGO", ["cargo"], ["cargo/bin/cargo" + EXE])
        self.go = find_tool("BENCH_GO", ["go"], ["go/bin/go" + EXE])
        self.zig = find_tool("BENCH_ZIG", ["zig"], ["zig/zig" + EXE])
        self.env = dict(os.environ)
        if not WINDOWS:
            for d in tools_dirs():
                if os.path.isdir(os.path.join(d, "rustup")):
                    self.env.setdefault("RUSTUP_HOME", os.path.join(d, "rustup"))
                    self.env.setdefault("CARGO_HOME", os.path.join(d, "cargo"))
                    break
        self.inc, self.libfile, self.dlldir = self.find_libs()
        if self.dlldir:
            self.env["PATH"] = self.dlldir + os.pathsep + self.env["PATH"]

    @staticmethod
    def find_cc():
        """The clang tiko itself uses, so C and tiko share one LLVM."""
        for env in ("BENCH_CC", "TIKO_CLANG"):
            if os.environ.get(env):
                return os.environ[env]
        default = (r"C:\Program Files\LLVM\bin\clang.exe" if WINDOWS else "/usr/bin/clang")
        return default if os.path.isfile(default) else shutil.which("clang")

    def find_libs(self):
        """Include dirs, {lib: link file}, and the directory of the DLLs (Windows)."""
        if WINDOWS:
            prefix = os.environ.get("BENCH_LIBS")
            if not prefix:
                for d in tools_dirs():
                    p = os.path.join(d, "msys", "ucrt64")
                    if os.path.isdir(p):
                        prefix = p
                        break
            if not prefix:
                return [], {}, None
            lib = os.path.join(prefix, "lib")
            return ([os.path.join(prefix, "include")],
                    {"gmp": os.path.join(lib, "libgmp.dll.a"),
                     "pcre2": os.path.join(lib, "libpcre2-8.dll.a")},
                    os.path.join(prefix, "bin"))
        inc = [p for p in os.environ.get("BENCH_INC", "").split(":") if p]
        if not inc:
            for d in tools_dirs():
                p = os.path.join(d, "sysroot", "usr", "include")
                if os.path.isdir(p):
                    inc = [p, os.path.join(p, "x86_64-linux-gnu")]
                    break
        so = "/usr/lib/x86_64-linux-gnu"
        return inc, {"gmp": os.path.join(so, "libgmp.so.10"),
                     "pcre2": os.path.join(so, "libpcre2-8.so.0")}, None

    def path(self, lang):
        return {"tiko": self.tiko, "c": self.cc, "rust": self.rustc,
                "go": self.go, "zig": self.zig}[lang]

    def version(self, lang):
        exe = self.path(lang)
        if not exe:
            return "missing"
        args = {"tiko": ["--version"], "c": ["--version"], "rust": ["--version"],
                "go": ["version"], "zig": ["version"]}[lang]
        try:
            out = subprocess.run([exe] + args, capture_output=True, text=True,
                                 env=self.env).stdout.strip().splitlines()[0]
        except (OSError, IndexError):
            return "unknown"
        return out


# ---------------------------------------------------------------------- build

FLAGS = {
    "tiko": "-O2",
    "c": "-O2",
    "rust": "-C opt-level=3",
    "go": "(defaults)",
    "zig": "-O ReleaseFast -mcpu baseline",
}


def run_cmd(cmd, tc, cwd=None):
    r = subprocess.run(cmd, capture_output=True, text=True, env=tc.env, cwd=cwd)
    if r.returncode != 0:
        msg = (r.stdout + r.stderr).strip()
        raise RuntimeError("build failed: %s\n%s" % (" ".join(cmd), msg[-3000:]))


def build(lang, prog, tc, work):
    src = os.path.join(GAME, prog, "%s.%s" % (prog, EXT[lang]))
    libs = [l for l in PROGRAMS[prog][3] if (lang, l) not in NO_C_LIBS]
    if lang == "rust" and prog == "regex-redux":
        src = os.path.join(GAME, prog, "rust", "Cargo.toml")
    if not os.path.isfile(src):
        return None
    out_dir = os.path.join(work, "bin", lang)
    os.makedirs(out_dir, exist_ok=True)
    exe = os.path.join(out_dir, prog + EXE)
    tool = tc.path(lang)
    if not tool:
        raise RuntimeError("no %s toolchain found" % lang)

    if lang == "tiko":
        cmd = [tool, "-O2", src, "-o", exe]
        if libs:
            stage_tiko_libs(tc, libs)
            for d in tc.inc:
                cmd += ["-cinclude", d]
            if "pcre2" in libs:
                cmd += ["-cdefine", "PCRE2_CODE_UNIT_WIDTH=8"]
        run_cmd(cmd, tc)
    elif lang == "c":
        cmd = [tool, "-O2", src, "-o", exe]
        cmd += ["-I" + d for d in tc.inc]
        cmd += [tc.libfile[l] for l in libs]
        if not WINDOWS:
            cmd += ["-lm"]
        run_cmd(cmd, tc)
    elif lang == "rust":
        if src.endswith("Cargo.toml"):
            target = os.path.join(work, "cargo")
            run_cmd([tc.cargo, "build", "--release", "-q", "--manifest-path", src,
                     "--target-dir", target], tc)
            shutil.copy2(os.path.join(target, "release", prog + EXE), exe)
        else:
            cmd = [tool, "--edition", "2021", "-C", "opt-level=3", src, "-o", exe]
            for l in libs:
                cmd += ["-C", "link-arg=" + tc.libfile[l]]
            run_cmd(cmd, tc)
    elif lang == "go":
        run_cmd([tool, "build", "-o", exe, src], tc, cwd=os.path.dirname(src))
    elif lang == "zig":
        zdir = os.path.join(work, "zig", prog)
        os.makedirs(zdir, exist_ok=True)
        zsrc = os.path.join(zdir, prog + ".zig")
        shutil.copy2(src, zsrc)
        cmd = [tool, "build-exe", "-O", "ReleaseFast", "-mcpu", "baseline",
               "--cache-dir", os.path.join(work, "zig-cache"),
               "--global-cache-dir", os.path.join(work, "zig-global-cache")]
        if libs:
            write_zig_c(tc, libs, zdir)
            cmd += ["-lc"] + [tc.libfile[l] for l in libs]
        cmd += [zsrc, "-femit-bin=" + exe]
        run_cmd(cmd, tc, cwd=zdir)
    return exe


def stage_tiko_libs(tc, libs):
    """#foreignlib X dynamic "../libs/x" finds libs/x_<os>_x86_64.<ext>."""
    d = os.path.join(GAME, "libs")
    os.makedirs(d, exist_ok=True)
    ext = ".dll.a" if WINDOWS else ".so"
    for l in libs:
        dst = os.path.join(d, "%s_%s_x86_64%s" % (l, TARGET, ext))
        if not os.path.isfile(dst):
            shutil.copy2(tc.libfile[l], dst)


def write_zig_c(tc, libs, zdir):
    """Zig 0.17 has no @cImport: translate the headers to c.zig beside the source."""
    h = os.path.join(zdir, "libs.h")
    with open(h, "w") as f:
        if "pcre2" in libs:
            f.write("#define PCRE2_CODE_UNIT_WIDTH 8\n#include <pcre2.h>\n")
        if "gmp" in libs:
            f.write("#include <gmp.h>\n")
    cmd = [tc.zig, "translate-c", "-lc"]
    for d in tc.inc:
        cmd += ["-I", d]
    cmd.append(h)
    r = subprocess.run(cmd, capture_output=True, env=tc.env, cwd=zdir)
    if r.returncode != 0:
        raise RuntimeError("zig translate-c failed:\n" + r.stderr.decode()[-2000:])
    with open(os.path.join(zdir, "c.zig"), "wb") as f:
        f.write(r.stdout)


# ------------------------------------------------------------------------ run

def pin(cpu):
    """Pin this process, and so every child, to one logical CPU."""
    if cpu < 0:
        return
    if WINDOWS:
        import ctypes
        k = ctypes.windll.kernel32
        k.SetProcessAffinityMask(k.GetCurrentProcess(), 1 << cpu)
    else:
        os.sched_setaffinity(0, {cpu})


def run_once(exe, args, stdin_path, out_path, tc):
    """Wall time in seconds and peak memory in MB of one run."""
    stdin = open(stdin_path, "rb") if stdin_path else subprocess.DEVNULL
    with open(out_path, "wb") as out:
        t0 = time.perf_counter()
        p = subprocess.Popen([exe] + args, stdin=stdin, stdout=out,
                             stderr=subprocess.PIPE, env=tc.env)
        if WINDOWS:
            _, err = p.communicate()
            wall = time.perf_counter() - t0
            mem = peak_memory_windows(p)
        else:
            err = p.stderr.read()
            _, status, ru = os.wait4(p.pid, 0)
            wall = time.perf_counter() - t0
            p.returncode = os.waitstatus_to_exitcode(status)
            mem = ru.ru_maxrss / 1024.0
    if stdin_path:
        stdin.close()
    if p.returncode != 0:
        raise RuntimeError("exit code %d: %s" % (p.returncode, err.decode(errors="replace")[-500:]))
    return wall, mem


def peak_memory_windows(p):
    import ctypes
    from ctypes import wintypes

    class PMC(ctypes.Structure):
        _fields_ = [("cb", wintypes.DWORD), ("PageFaultCount", wintypes.DWORD),
                    ("PeakWorkingSetSize", ctypes.c_size_t), ("WorkingSetSize", ctypes.c_size_t),
                    ("QuotaPeakPagedPoolUsage", ctypes.c_size_t), ("QuotaPagedPoolUsage", ctypes.c_size_t),
                    ("QuotaPeakNonPagedPoolUsage", ctypes.c_size_t), ("QuotaNonPagedPoolUsage", ctypes.c_size_t),
                    ("PagefileUsage", ctypes.c_size_t), ("PeakPagefileUsage", ctypes.c_size_t)]

    pmc = PMC()
    pmc.cb = ctypes.sizeof(PMC)
    ok = ctypes.windll.psapi.GetProcessMemoryInfo(wintypes.HANDLE(int(p._handle)),
                                                  ctypes.byref(pmc), pmc.cb)
    return pmc.PeakWorkingSetSize / 1048576.0 if ok else float("nan")


def sha(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


# ----------------------------------------------------------------------- data

def ensure_input(n, quick, work, tc, built):
    """The fasta output of size n, made by the oracle (quick) or the C fasta."""
    d = os.path.join(work, "data")
    os.makedirs(d, exist_ok=True)
    path = os.path.join(d, "fasta-%d.txt" % n)
    if os.path.isfile(path):
        return path
    if n <= 100000:
        with open(path, "wb") as f:
            f.write(oracle.fasta(n))
        return path
    exe = built.get(("c", "fasta"))
    if not exe:
        exe = build("c", "fasta", tc, work)
    tmp = path + ".tmp"
    run_once(exe, [str(n)], None, tmp, tc)
    os.replace(tmp, path)
    return path


# ----------------------------------------------------------------------- main

def default_work():
    if not WINDOWS and HERE.startswith("/mnt/"):
        # The Windows drive is a 9p mount under WSL: slow enough to distort
        # the I/O programs. Build and run on the Linux file system instead.
        return os.path.expanduser("~/.cache/tiko-bench")
    return os.path.join(GAME, "build", TARGET)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--quick", action="store_true", help="small sizes, 1 run")
    ap.add_argument("--check", action="store_true", help="build and verify only")
    ap.add_argument("--only", help="comma-separated program names")
    ap.add_argument("--lang", help="comma-separated languages (%s)" % ",".join(LANGS))
    ap.add_argument("--runs", type=int, help="timed runs per program (default 3; 1 with --quick)")
    ap.add_argument("--cpu", type=int, default=2, help="logical CPU to pin to (-1: no pinning)")
    ap.add_argument("--work", default=default_work(), help="build and data directory")
    ap.add_argument("--json", help="write results to this file")
    a = ap.parse_args()

    progs = a.only.split(",") if a.only else list(PROGRAMS)
    langs = a.lang.split(",") if a.lang else LANGS
    for p in progs:
        if p not in PROGRAMS:
            sys.exit("unknown program: " + p)
    runs = a.runs or (1 if a.quick else 3)
    tc = Toolchains()
    os.makedirs(a.work, exist_ok=True)
    pin(a.cpu)

    env = {"target": "%s-x86_64" % TARGET, "machine": platform.processor() or platform.machine(),
           "cpu": a.cpu, "quick": a.quick, "runs": runs,
           "versions": {l: tc.version(l) for l in langs}, "flags": {l: FLAGS[l] for l in langs}}
    print("target %s, pinned to CPU %d, %s" % (env["target"], a.cpu,
                                                "quick sizes" if a.quick else "full sizes"))
    for l in langs:
        print("  %-5s %-60s %s" % (l, env["versions"][l][:60], FLAGS[l]))

    results = {}
    failures = 0
    built = {}
    for prog in progs:
        full, quick, inp, _ = PROGRAMS[prog]
        args, stdin_path, size = [], None, None
        if inp:
            n = inp[1] if a.quick else inp[0]
            stdin_path = ensure_input(n, a.quick, a.work, tc, built)
            size = "fasta %d" % n
        else:
            size = quick if a.quick else full
            args = [str(size)]
        print("\n%s (%s)" % (prog, size))

        want = None
        if stdin_path and a.quick:
            with open(stdin_path, "rb") as f:
                want = oracle.expected(prog, data=f.read())
        elif not stdin_path:
            want = oracle.expected(prog, size=size)
        want_sha = hashlib.sha256(want).hexdigest() if want is not None else None

        order = ["c"] + [l for l in langs if l != "c"] if "c" in langs else langs
        ref_sha = None
        results[prog] = {}
        for lang in order:
            try:
                exe = build(lang, prog, tc, a.work)
            except RuntimeError as e:
                print("  %-5s BUILD FAILED\n%s" % (lang, indent(str(e))))
                failures += 1
                continue
            if exe is None:
                print("  %-5s (no source)" % lang)
                continue
            built[(lang, prog)] = exe
            out_path = os.path.join(a.work, "out-%s-%s" % (lang, prog))
            times, mems = [], []
            try:
                n_runs = 1 if a.check else runs
                for _ in range(n_runs):
                    w, m = run_once(exe, args, stdin_path, out_path, tc)
                    times.append(w)
                    mems.append(m)
                    if len(times) == 1:
                        got = sha(out_path)
                        ok, why = verify(got, want_sha, ref_sha, lang)
                        if not ok:
                            raise RuntimeError(why)
                        if lang == "c":
                            ref_sha = got
            except RuntimeError as e:
                print("  %-5s FAILED: %s" % (lang, e))
                failures += 1
                continue
            r = {"min": min(times), "median": statistics.median(times),
                 "peak_mb": max(mems), "runs": times}
            results[prog][lang] = r
            if a.check:
                print("  %-5s ok" % lang)
            else:
                print("  %-5s %8.3f s  (median %.3f, %d runs)  %7.1f MB"
                      % (lang, r["min"], r["median"], len(times), r["peak_mb"]))

    if not a.check:
        print_table(results, progs, langs)
    if a.json:
        with open(a.json, "w") as f:
            json.dump({"env": env, "results": results}, f, indent=2)
    if failures:
        print("\n%d failure(s)" % failures)
        sys.exit(1)


def verify(got, want_sha, ref_sha, lang):
    if want_sha is not None and got != want_sha:
        return False, "output differs from the reference (oracle.py)"
    if ref_sha is not None and got != ref_sha:
        return False, "output differs from the C program's"
    if want_sha is None and ref_sha is None and lang != "c":
        return False, "nothing to verify against (C program missing or failed)"
    return True, ""


def indent(s):
    return "\n".join("        " + line for line in s.splitlines())


def print_table(results, progs, langs):
    print("\nmin wall time, seconds (x C)")
    print("%-20s" % "" + "".join("%14s" % l for l in langs))
    for p in progs:
        row = results.get(p, {})
        c = row.get("c", {}).get("min")
        cells = []
        for l in langs:
            t = row.get(l, {}).get("min")
            if t is None:
                cells.append("%14s" % "-")
            elif c and l != "c":
                cells.append("%14s" % ("%.2f (%.2f)" % (t, t / c)))
            else:
                cells.append("%14s" % ("%.2f" % t))
        print("%-20s" % p + "".join(cells))


if __name__ == "__main__":
    main()
