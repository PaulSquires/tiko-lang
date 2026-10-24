"""fastcorpus.py <tree> <exe> --list <file> [--list <file>] [<regex>] [--save <snap.json>]
                [--against <snap.json>] [--times]

Runs <exe> --dump-ir over every corpus file, 8 at a time, starting tiko directly (no bash per
file). Each file's diagnostics are reduced to 'line,col sev TKOnnnn'. A list holds one path
per line, relative to <tree> or absolute; build/gate-corpus.txt is the committed one.

  --save F      write the full per-file diagnostic snapshot to F
  --against F   print every file whose diagnostics differ from snapshot F -- ANY id, so a
                change nobody was looking for shows up too -- and EXIT 1 if any does
  <regex>       without --against: print each file with a matching diagnostic (a NEW id)
  --times       print the ten slowest files

Use a Release binary (build/relbuild.sh). Never run beside the suite. Notes are not compared:
the reduction keeps errors and warnings only.
"""
import json, os, re, subprocess, sys, time
from concurrent.futures import ThreadPoolExecutor

args = sys.argv[1:]
def opt(name):
    if name in args:
        i = args.index(name); v = args[i + 1]; del args[i:i + 2]; return v
    return None
lists = []
while "--list" in args:
    lists.append(opt("--list"))
save, against = opt("--save"), opt("--against")
times = "--times" in args
if times: args.remove("--times")
tree, exe = args[0], args[1]
pat = re.compile(args[2]) if len(args) > 2 else None
if not lists:
    sys.exit("fastcorpus: no --list given")

env = dict(os.environ)
env["TKO_INCLUDE"] = tree + "/toolchains/tiko-windows/inc"
env.pop("TKO_LIBPATH", None)
files = []
for lp in lists:
    files += [f for f in open(lp).read().split("\n") if f.strip()]
diag = re.compile(r"\((\d+),(\d+)\): (error|warning) (TKO\d+)")
afx = os.environ.get("TKO_AFXNOVA", "C:/dev/utils/AfxNova/src")

def one(f):
    p = f if os.path.isabs(f) or f[1:2] == ":" else os.path.join(tree, f)
    t = time.time()
    try:
        r = subprocess.run([exe, "--dump-ir", "-i", afx, os.path.basename(p)],
                           cwd=os.path.dirname(p), env=env, capture_output=True, timeout=120)
        out = (r.stdout + r.stderr).decode("utf-8", "replace")
        ds = sorted("%s,%s %s %s" % m.groups() for m in diag.finditer(out))
    except subprocess.TimeoutExpired:
        ds = ["TIMEOUT"]
    return f, ds, time.time() - t

# LONGEST FIRST, by the times the last run recorded, so a slow file started last is no tail.
tfile = os.path.join(os.path.dirname(os.path.abspath(save or against or exe)), "corpus-times.json")
try: prev = json.load(open(tfile))
except Exception: prev = {}
order = sorted(files, key=lambda f: -prev.get(f, 1.0))
t0 = time.time()
with ThreadPoolExecutor(8) as ex:
    res = list(ex.map(one, order))
json.dump({f: dt for f, _, dt in res}, open(tfile, "w"))
snap = {f: ds for f, ds, _ in res}
print("fastcorpus: %.0f cpu-s over %d files" % (sum(dt for _, _, dt in res), len(res)))

rc = 0
if against:
    old = json.load(open(against))
    n = 0
    for f in files:
        a, b = old.get(f), snap[f]
        if a is None or a == b: continue
        gone = sorted(set(a) - set(b)); new = sorted(set(b) - set(a))
        n += 1
        print("DIFF %s  -%s  +%s" % (f, gone, new))
    print("fastcorpus: %d files differ" % n)
    if n: rc = 1
elif pat:
    for f, ds, _ in sorted(res):
        hits = [d for d in ds if pat.search(d)]
        if hits: print("HIT %d %s" % (len(hits), f))
if times:
    for f, _, dt in sorted(res, key=lambda x: -x[2])[:10]: print("%.1fs %s" % (dt, f))
if save:
    json.dump(snap, open(save, "w"))
print("fastcorpus: %d files, %ds" % (len(files), time.time() - t0))
sys.exit(rc)
