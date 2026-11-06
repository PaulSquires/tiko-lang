"""fmtdiff.py <seed> <count> [--tiko <exe>] [--keep] -- strings.Format against C++ std::format.

THE DIFFERENTIAL HARNESS for std/strings' Format (docs/tiko-strings/RFC-0002-format.md, sec. 9).
One run generates <count> random cases -- a format string and the arguments it formats -- and
writes them twice: as a C++ program over std::vformat and as a tiko program over
strings.TryFormat. Both are compiled and run, and their outputs are compared line by line. A
case that C++ refuses must be refused by tiko and the other way round; the error TEXT is not
compared, only that there is one.

The cases are edge-weighted: zero, the limits of every width, -0.0, infinities, NaNs and
subnormals; every spec field, alone and combined, including the ones a type refuses; manual,
automatic and dynamic indexing; '{{' and '}}'. Doubles and singles are built from the SAME BIT
PATTERNS on both sides, so neither compiler's literal parsing is under test.

Deliberate differences are not generated: 'L' (refused by tiko in v1, accepted by MSVC's STL in
the C locale), 'c' over a value past 127 (a code point for tiko, a byte for C++), and display
width (tiko counts code points) -- every string argument is ASCII.

The oracle is clang++ (C++23) with the MSVC STL. The same seed always writes the same cases, so
a difference is reproduced by its seed alone. Exit 0 when nothing differs.
"""
import os
import random
import struct
import subprocess
import sys

args = [a for a in sys.argv[1:]]
keep = "--keep" in args
if keep:
    args.remove("--keep")
tiko = None
if "--tiko" in args:
    i = args.index("--tiko")
    tiko = args[i + 1]
    del args[i:i + 2]
seed, count = int(args[0]), int(args[1])
sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")
R = random.Random(seed)

HERE = os.path.dirname(os.path.abspath(__file__))
TREE = os.path.normpath(os.path.join(HERE, "..", ".."))
if tiko is None:
    tiko = os.path.join(TREE, "bin", "tiko.exe")
WORK = os.path.join(os.environ.get("TEMP", "/tmp"), "fmtdiff-%d" % seed)
os.makedirs(WORK, exist_ok=True)

# ----------------------------------------------------------------------------- values
# Each value: (kind, cpp_decl, tiko_decl) where the decl takes the variable name.

def v_int(x):
    return ("int", "int %s = %d;" % ("{}", x), "dim as long {} = %d" % x)

def v_ll(x):
    lit = "(-9223372036854775807LL - 1)" if x == -2**63 else "%dLL" % x
    tl = "-9223372036854775807 - 1" if x == -2**63 else "%d" % x
    return ("ll", "long long {} = %s;" % lit, "dim as longint {} = %s" % tl)

def v_ull(x):
    return ("ull", "unsigned long long {} = %dULL;" % x, "dim as ulongint {} = %dull" % x)

def v_bool(b):
    return ("bool", "bool {} = %s;" % ("true" if b else "false"),
            "dim as boolean {} = %s" % ("true" if b else "false"))

def v_str(s):
    # ASCII only, no quote or backslash in the literal; control characters through chr( ).
    cpp = '"' + "".join(c if 32 <= ord(c) < 127 and c not in '"\\' else "\\x%02x" % ord(c) for c in s) + '"'
    parts, run = [], ""
    for c in s:
        if 32 <= ord(c) < 127 and c != '"':
            run += c
        else:
            if run:
                parts.append('"%s"' % run)
                run = ""
            parts.append("chr( %d )" % ord(c))
    if run:
        parts.append('"%s"' % run)
    tk = " & ".join(parts) if parts else '""'
    return ("str", "std::string {} = %s;" % cpp, "dim as string {} = %s" % tk)

def v_double(bits):
    return ("dbl", "double {} = std::bit_cast<double>(0x%016xULL);" % bits,
            "dim as ulongint {}_b = &h%016xull : dim as double {} = *cast( double ptr, @{}_b )" % bits)

def v_float(bits):
    return ("flt", "float {} = std::bit_cast<float>(0x%08xU);" % bits,
            "dim as ulong {}_b = &h%08xu : dim as single {} = *cast( single ptr, @{}_b )" % bits)

def v_ptr(x):
    return ("ptr", "const void* {} = (const void*)0x%xULL;" % x,
            "dim as any ptr {} = cast( any ptr, &h%xull )" % x)

def rand_double():
    pick = R.random()
    if pick < 0.25:
        x = R.choice([0.0, -0.0, 1.0, -1.0, 0.1, 0.5, 2.5, 3.5, 100000.0, 1e21, 1e-5, 0.0001,
                      123456789.0, 1.7976931348623157e308, 5e-324, 2.2250738585072014e-308,
                      float("inf"), float("-inf"), 1e16, 9007199254740993.0, 0.30000000000000004])
        return struct.unpack("<Q", struct.pack("<d", x))[0]
    if pick < 0.30:
        return R.choice([0x7ff8000000000000, 0xfff8000000000000])     # nan, -nan
    if pick < 0.65:
        x = R.uniform(-1e6, 1e6) if R.random() < 0.5 else R.uniform(-10, 10)
        return struct.unpack("<Q", struct.pack("<d", x))[0]
    return R.getrandbits(64) & 0x7fefffffffffffff | (R.getrandbits(1) << 63)

def rand_float():
    pick = R.random()
    if pick < 0.3:
        x = R.choice([0.0, 1.0, 0.1, -2.5, 16777216.0, 3.4028234663852886e38, 1e-45, 1e10])
        return struct.unpack("<I", struct.pack("<f", x))[0]
    if pick < 0.7:
        return struct.unpack("<I", struct.pack("<f", R.uniform(-1000, 1000)))[0]
    return R.getrandbits(32) & 0x7f7fffff | (R.getrandbits(1) << 31)

def rand_value():
    k = R.choice(["int", "ll", "ull", "bool", "str", "dbl", "dbl", "flt", "ptr"])
    if k == "int":
        return v_int(R.choice([0, 1, -1, 42, -42, 255, 2**31 - 1, -2**31, R.randint(-10**6, 10**6)]))
    if k == "ll":
        return v_ll(R.choice([0, -2**63, 2**63 - 1, R.randint(-10**15, 10**15)]))
    if k == "ull":
        return v_ull(R.choice([0, 2**64 - 1, R.randint(0, 2**64 - 1)]))
    if k == "bool":
        return v_bool(R.random() < 0.5)
    if k == "str":
        alpha = "abcxyz ABC 0123-+.,:;!?#"
        s = "".join(R.choice(alpha) for _ in range(R.randint(0, 12)))
        if R.random() < 0.15:
            s += R.choice(["\t", "\n", "\r", "\x01", "\x7f"])
        return v_str(s)
    if k == "dbl":
        return v_double(rand_double())
    if k == "flt":
        return v_float(rand_float())
    return v_ptr(R.choice([0, 0xdead, 0x7ffe12345678, R.getrandbits(48)]))

# ----------------------------------------------------------------------------- specs

TYPES = {
    "int": "dbBoxX", "ll": "dbBoxX", "ull": "dbBoxX", "bool": "sdbBoxX", "str": "s?",
    "dbl": "aAeEfFgG", "flt": "aAeEfFgG", "ptr": "pP",
}
ALL_TYPES = "aAbBcdeEfFgGosxXpP?"

def rand_spec(kind):
    s = ""
    r = R.random()
    if r < 0.15:
        s += R.choice("*x-.") + R.choice("<>^")
    elif r < 0.35:
        s += R.choice("<>^")
    if R.random() < 0.15:
        s += R.choice("+- ")
    if R.random() < 0.12:
        s += "#"
    if R.random() < 0.12:
        s += "0"
    if R.random() < 0.5:
        s += str(R.choice([1, 2, 5, 8, 10, 12, 20, 30]))
    if R.random() < 0.3:
        s += "." + str(R.choice([0, 1, 2, 3, 6, 10, 17, 20]))
    if R.random() < 0.7:
        good = TYPES[kind]
        s += R.choice(good) if R.random() < 0.85 else R.choice(ALL_TYPES)
    return s

def rand_case():
    nargs = R.randint(1, 3)
    vals = [rand_value() for _ in range(nargs)]
    manual = R.random() < 0.25
    parts = []
    used = 0
    for f in range(R.randint(1, 3)):
        if R.random() < 0.2:
            parts.append(R.choice(["{{", "}}", "-", " | ", "x"]))
        idx = R.randrange(nargs) if manual else used
        if idx >= nargs:
            break
        kind = vals[idx][0]
        spec = rand_spec(kind) if R.random() < 0.8 else ""
        # 'c' past 127 is a code point here and an error in C++ -- a documented deviation.
        if spec.endswith("c") and kind in ("int", "ll", "ull"):
            spec = spec[:-1] + R.choice("dx")
        if spec and "{" not in spec and R.random() < 0.05:
            spec = spec  # no dynamic here
        field = "{" + (str(idx) if manual else "") + (":" + spec if spec else "") + "}"
        parts.append(field)
        used += 1
    # occasionally a malformed string
    if R.random() < 0.04:
        parts.append(R.choice(["{", "}", "{:", "{0", "{x}", "{ }", "{:.}", "{00}"]))
    return "".join(parts), vals

# Dynamic width / precision cases use an int argument after the formatted one.
def rand_dynamic_case():
    v = rand_value()
    w = v_int(R.choice([0, 3, 8, 15, -1]))
    which = R.choice(["{:{}}", "{:.{}}", "{:>{}}", "{0:{1}}", "{:*^{}}"])
    return which, [v, w]

# ----------------------------------------------------------------------------- programs

cases = []
for n in range(count):
    cases.append(rand_dynamic_case() if R.random() < 0.08 else rand_case())

def tiko_lit(s):
    return '"' + s.replace('"', '""') + '"'

cpp = ["#include <format>", "#include <cstdio>", "#include <string>", "#include <bit>", "",
       "template<class... A> void T(int id, const char* f, A&&... a) {",
       "  try { auto s = std::vformat(f, std::make_format_args(a...)); std::printf(\"%d:[%s]\\n\", id, s.c_str()); }",
       "  catch (std::format_error&) { std::printf(\"%d:ERR\\n\", id); } }",
       "int main() {"]
tk = ["#import \"std/strings\"",
      "sub Show( byval id as long, byref r as outcome.Result( of ustring, strings.FormatError ) )",
      "    if r.IsOk( ) then print id & \":[\" & r.Value( ) & \"]\" else print id & \":ERR\"",
      "end sub"]
for n, (f, vals) in enumerate(cases):
    names = ["a%d_%d" % (n, k) for k in range(len(vals))]
    cpp.append("  {")
    tk.append("scope")
    for name, (kind, cd, td) in zip(names, vals):
        cpp.append("    " + cd.replace("{}", name))
        tk.append("    " + td.replace("{}", name))
    cpp.append("    T(%d, %s%s);" % (n, '"' + f.replace("\\", "\\\\").replace('"', '\\"') + '"',
                                     "".join(", " + nm for nm in names)))
    tk.append("    Show( %d, strings.TryFormat( %s%s ) )" % (n, tiko_lit(f), "".join(", " + nm for nm in names)))
    cpp.append("  }")
    tk.append("end scope")
cpp.append("}")
tk.insert(1, "#import \"std/outcome\"")

cpp_path = os.path.join(WORK, "cases.cpp")
tk_path = os.path.join(WORK, "cases.tiko")
open(cpp_path, "w", newline="\n").write("\n".join(cpp) + "\n")
open(tk_path, "w", newline="\n").write("\n".join(tk) + "\n")

def run(cmd, **kw):
    return subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace", **kw)

r = run(["clang++", "-std=c++23", "-O1", cpp_path, "-o", os.path.join(WORK, "cpp.exe")])
if r.returncode != 0:
    print("C++ COMPILE FAILED\n" + r.stdout[-2000:] + r.stderr[-2000:])
    sys.exit(2)
env = dict(os.environ)
env.setdefault("TIKO_LIBPATH", os.path.join(TREE, "toolchains", "tiko-windows", "lib", "windows-x86_64"))
env["TIKO_PKG"] = os.path.join(TREE, "pkg")
r = run([tiko, tk_path, "-o", os.path.join(WORK, "tk.exe")], env=env)
if r.returncode != 0:
    print("TIKO COMPILE FAILED\n" + (r.stdout + r.stderr)[-3000:])
    sys.exit(2)
co = run([os.path.join(WORK, "cpp.exe")]).stdout.splitlines()
to = run([os.path.join(WORK, "tk.exe")]).stdout.splitlines()

diffs = 0
for a, b in zip(co, to):
    if a != b:
        diffs += 1
        if diffs <= 30:
            n = int(a.split(":")[0])
            f, vals = cases[n]
            print("DIFF %-40s  C++ %s   tiko %s" % (repr(f) + " " + ",".join(v[0] for v in vals),
                                                     ascii(a[len(str(n)) + 1:]), ascii(b[len(str(n)) + 1:])))
if len(co) != len(to):
    print("LINE COUNT C++ %d tiko %d" % (len(co), len(to)))
    diffs += 1
print("fmtdiff seed %d: %d cases, %d differ" % (seed, count, diffs))
sys.exit(1 if diffs else 0)
