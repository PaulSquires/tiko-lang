#!/usr/bin/env python3
"""bench.py -- how long tiko takes from 'tiko foo.tiko -o foo.exe' to the program on disk.

The compile-time benchmark of the speed audit (docs/tiko-speed in the workspace). Each case is
a whole build -- process start to exit, link included -- timed from outside, N times; the
minimum and the median are reported, with the root process's peak working set. One more run
with --time-passes records where the time went, for a compiler that prints it.

    python bench/compile/bench.py --tiko bin/tiko.exe --work <scratch dir> [--runs 5]
                                  [--cases a,b] [--tree .] [--pscal <dir>] [--json out.json]

Cases are GENERATED into --work, deterministically, so two compilers are always measured on
the same bytes. 'selfhost' compiles the tiko-lang tree given by --tree (all of build/
sources.txt, the large multi-unit project); 'pscal' a PsControls demo (AfxNova + windows.bi,
a real GUI program) when --pscal names its directory. Both are skipped when not given.

TIKO_INCLUDE / TIKO_LIBPATH must be set as for any build (see build/test.sh).
"""
import argparse, ctypes, ctypes.wintypes as wt, json, os, re, shutil, statistics, subprocess, sys, time

# ----------------------------------------------------------------------------- generators

def gen_hello():
    return 'print "hello"\n'

def gen_functions(n):
    out = []
    for i in range(n):
        out.append(f"function f{i}( byval a as long, byval b as long ) as long\n"
                   f"    dim as long t = a * {i % 7 + 1} + b\n"
                   f"    if t > {i} then t -= b else t += a\n"
                   f"    return t\nend function\n")
    out.append("dim as long acc = 0\n")
    for i in range(0, n, 10):
        out.append(f"acc += f{i}( {i}, acc and 255 )\n")
    out.append("print acc\n")
    return "".join(out)

def gen_types(n):
    out = []
    for i in range(n):
        out.append(f"type T{i}\n    as long a, b\n    as double d\n    as string s\n"
                   f"    declare constructor( byval x as long )\n"
                   f"    declare function Sum( ) as long\nend type\n"
                   f"constructor T{i}( byval x as long )\n    a = x : b = x + {i} : d = x / 2 : s = str( x )\nend constructor\n"
                   f"function T{i}.Sum( ) as long\n    return a + b + len( s )\nend function\n")
    out.append("dim as long acc = 0\n")
    for i in range(0, n, 5):
        out.append(f"scope\n    dim as T{i} v = T{i}( {i} )\n    acc += v.Sum( )\nend scope\n")
    out.append("print acc\n")
    return "".join(out)

def gen_expressions(n, terms=40):
    out = ["dim as long a = 3, b = 5, c = 7\ndim as double x = 1.5, y = 2.25\ndim as long r = 0\ndim as double q = 0\n"]
    ops = ["+", "-", "*", "and", "or", "xor"]
    for i in range(n):
        e = []
        for k in range(terms):
            v = ("a", "b", "c", str((i * 31 + k) % 97 + 1))[(i + k) % 4]
            e.append(v)
            if k < terms - 1:
                e.append(ops[(i + k) % len(ops)])
        out.append(f"r = (r + ({' '.join(e)})) and &hFFFF\n")
        if i % 4 == 0:
            out.append(f"q = q + x * {i % 13 + 1}.5 / (y + {i % 5 + 1}) - (x - y) * 0.25\n")
    out.append("print r, q\n")
    return "".join(out)

def gen_strings(n):
    out = ["dim as string s = \"\"\ndim as long total = 0\n"]
    for i in range(n):
        lit = f"literal number {i} with some text to make it longer {i * 7919 % 10007}"
        out.append(f"s = \"{lit}\" & str( {i} ) & \"/\" & mid( \"{lit}\", 3, 9 )\n")
        out.append(f"total += len( s ) + instr( s, \"{i % 10}\" )\n")
    out.append("print total\n")
    return "".join(out)

def gen_mixed(n_blocks):
    """A program shaped like an application: types with methods, procedures, loops,
    select, strings and arrays -- 'small', 'medium' and 'large' are this at three sizes."""
    out = ["dim shared as long g_count\n"]
    for i in range(n_blocks):
        out.append(f"""type Item{i}
    as long id
    as string name
    as double price
    declare function Describe( ) as string
end type
function Item{i}.Describe( ) as string
    return name & " #" & str( id ) & " @ " & str( price )
end function
function Score{i}( arr( ) as long, byval k as long ) as long
    dim as long best = 0
    for j as long = lbound( arr ) to ubound( arr )
        select case arr( j ) mod 4
        case 0 : best += arr( j ) * k
        case 1 : best -= arr( j )
        case 2, 3 : best xor= j
        end select
        if best > 100000 then best \\= 3
    next
    return best
end function
sub Run{i}( )
    dim as long arr( 0 to 15 )
    for j as long = 0 to 15 : arr( j ) = j * {i % 11 + 1} : next
    dim as Item{i} it
    it.id = {i} : it.name = "item{i}" : it.price = {i}.25
    dim as string d = it.Describe( )
    g_count += Score{i}( arr( ), {i % 5 + 1} ) + len( d )
end sub
""")
    for i in range(n_blocks):
        out.append(f"Run{i}( )\n")
    out.append("print g_count\n")
    return "".join(out)

def gen_modules(root, n):
    """n modules under libs/bench/m<k>, each importing the one before it; main imports all."""
    libs = os.path.join(root, "libs", "bench")
    for k in range(n):
        d = os.path.join(libs, f"m{k}")
        os.makedirs(d, exist_ok=True)
        body = [f'#module "m{k}"\n']
        if k > 0:
            body.append(f'#import "bench/m{k-1}"\n')
        for j in range(20):
            prev = f"m{k-1}.F{k-1}_{j}( a ) + " if k > 0 else ""
            body.append(f"public function F{k}_{j}( byval a as long ) as long\n"
                        f"    return {prev}a * {j + 1} + {k}\nend function\n")
        body.append(f"public type P{k}\n    as long x, y\n    declare function Len2( ) as long\nend type\n"
                    f"function P{k}.Len2( ) as long\n    return x * x + y * y\nend function\n")
        with open(os.path.join(d, f"m{k}.tiko"), "w", newline="\n") as f:
            f.write("".join(body))
    main = [f'#import "bench/m{k}"\n' for k in range(n)]
    main.append("dim as long acc = 0\n")
    for k in range(n):
        main.append(f"acc += m{k}.F{k}_3( {k} )\n")
    main.append("print acc\n")
    with open(os.path.join(root, "main.tiko"), "w", newline="\n") as f:
        f.write("".join(main))

def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", newline="\n") as f:
        f.write(text)

# ----------------------------------------------------------------------------- timing

class PMC(ctypes.Structure):
    _fields_ = [("cb", wt.DWORD), ("PageFaultCount", wt.DWORD),
                ("PeakWorkingSetSize", ctypes.c_size_t), ("WorkingSetSize", ctypes.c_size_t),
                ("a", ctypes.c_size_t), ("b", ctypes.c_size_t), ("c", ctypes.c_size_t),
                ("d", ctypes.c_size_t), ("e", ctypes.c_size_t), ("f", ctypes.c_size_t)]

def peak_ws(handle):
    if os.name != "nt":
        return 0
    p = PMC(); p.cb = ctypes.sizeof(PMC)
    ctypes.windll.psapi.GetProcessMemoryInfo(int(handle), ctypes.byref(p), p.cb)
    return p.PeakWorkingSetSize

def run_once(cmd, cwd, env):
    t = time.perf_counter()
    pr = subprocess.Popen(cmd, cwd=cwd, env=env, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    out, err = pr.communicate()
    wall = time.perf_counter() - t
    pk = peak_ws(pr._handle) if os.name == "nt" else 0
    return wall, pk, pr.returncode, out.decode(errors="replace") + err.decode(errors="replace")

PHASE_RE = re.compile(r"^\s+(\S.*?)\s+([\d.]+) s\s+([\d.]+)%")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--tiko", required=True)
    ap.add_argument("--work", required=True)
    ap.add_argument("--runs", type=int, default=5)
    ap.add_argument("--cases", default="")
    ap.add_argument("--tree", default="")
    ap.add_argument("--pscal", default="")
    ap.add_argument("--json", default="")
    ap.add_argument("--opt", default="", help="e.g. -O2, passed to every build")
    a = ap.parse_args()

    tiko = os.path.abspath(a.tiko)
    work = os.path.abspath(a.work)
    os.makedirs(work, exist_ok=True)
    env = dict(os.environ)
    extra = [a.opt] if a.opt else []

    gen = os.path.join(work, "gen")
    files = {
        "hello": gen_hello(),
        "small": gen_mixed(10),
        "medium": gen_mixed(150),
        "large": gen_mixed(1200),
        "many_functions": gen_functions(5000),
        "many_types": gen_types(1500),
        "large_expressions": gen_expressions(3000),
        "large_strings": gen_strings(4000),
        "windows_bi": '#include "windows.bi"\nMessageBeep( 0 )\nprint "hi"\n',
    }
    cases = []   # (name, cwd, argv-after-tiko, env-overrides, prep)
    for name, text in files.items():
        src = os.path.join(gen, name + ".tiko")
        write(src, text)
        cases.append((name, gen, [src, "-o", os.path.join(gen, name + ".exe")], {}, None))

    modroot = os.path.join(gen, "many_modules")
    if os.path.isdir(modroot):
        shutil.rmtree(modroot)
    gen_modules(modroot, 30)
    modargs = ["-i", os.path.join(modroot, "libs"), os.path.join(modroot, "main.tiko"),
               "-o", os.path.join(modroot, "main.exe")]
    cold = os.path.join(work, "modcache-cold")
    warm = os.path.join(work, "modcache-warm")
    def wipe_cold():
        if os.path.isdir(cold):
            shutil.rmtree(cold)
    cases.append(("modules_cold", modroot, modargs, {"TIKO_MODCACHE": cold}, wipe_cold))
    cases.append(("modules_warm", modroot, modargs, {"TIKO_MODCACHE": warm}, None))

    if a.pscal:
        cases.append(("pscalendar", a.pscal, ["-i", "C:\\dev", "main.bas", "main.rc", "-o",
                      os.path.join(work, "pscal.exe")], {}, None))
    if a.tree:
        tree = os.path.abspath(a.tree)
        with open(os.path.join(tree, "build", "sources.txt")) as f:
            srcs = [l.strip() for l in f if l.strip() and not l.strip().startswith("#")]
        cases.append(("selfhost", tree, srcs + ["-m", "main", "-i", "src", "-target", "windows-x86_64",
                      "-o", os.path.join(work, "selfhost.exe")], {}, None))

    if a.cases:
        want = set(a.cases.split(","))
        cases = [c for c in cases if c[0] in want]

    results = {}
    for name, cwd, args, envx, prep in cases:
        e = dict(env); e.update(envx)
        if name == "modules_warm":   # fill the cache once, untimed
            run_once([tiko] + args + extra, cwd, e)
        walls, peaks, rc, log = [], [], 0, ""
        for _ in range(a.runs):
            if prep:
                prep()
            w, pk, rc, log = run_once([tiko] + args + extra, cwd, e)
            walls.append(w); peaks.append(pk)
            if rc != 0:
                break
        phases = {}
        if rc == 0:
            if prep:
                prep()
            _, _, _, tlog = run_once([tiko] + args + extra + ["--time-passes"], cwd, e)
            for line in tlog.splitlines():
                m = PHASE_RE.match(line)
                if m:
                    phases[m.group(1)] = float(m.group(2))
        r = {"min": min(walls), "median": statistics.median(walls), "peak_mb": max(peaks) / 1048576,
             "rc": rc, "runs": len(walls), "phases": phases}
        results[name] = r
        print(f"{name:18} min {r['min']:7.3f}s  med {r['median']:7.3f}s  peak {r['peak_mb']:6.0f} MB"
              + ("" if rc == 0 else f"  FAILED rc={rc}: {log.strip()[-300:]}"), flush=True)
    if a.json:
        with open(a.json, "w") as f:
            json.dump({"tiko": tiko, "runs": a.runs, "opt": a.opt, "results": results}, f, indent=1)

if __name__ == "__main__":
    main()
