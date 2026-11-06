"""irsnap.py <tree> <exe> --list <file> [--list <file>] [--self <srcdir>] [--save <snap.json>]
             [--against <snap.json>] [--keep <dir>]

THE REFACTOR GATE'S FIRST STEP (docs/tiko-review/LATER-PLAN.md section 2): a change meant to
alter nothing a program sees must leave the compiler's output BYTE-IDENTICAL. Per corpus
file this records the SHA-1 of '--dump-ir' (MIR) and of '--emit-ir' (LLVM), each with its
exit code; '--self D' adds one '--dump-ir' of the tiko units D/build/sources.txt names,
compiled in D -- the self-host lowering gate.sh runs, over a FIXED copy of the sources (a
'git archive' of the base commit), since a refactor changes tiko's own source by definition.
fastcorpus.py compares DIAGNOSTICS and so cannot see an IR change at all; this compares
nothing else.

  --save F      write the snapshot to F
  --against F   print every file whose MIR or LLVM differs from snapshot F and EXIT 1 if any
  --keep D      also write each output to D (to diff a file the comparison names)

Run the same tree path for both sides: the IR carries absolute source paths. Use a Release
binary (build/relbuild.sh) and never beside the suite. TIKO_IR_SPILL and the rest of the
environment are passed through, so 'TIKO_IR_SPILL=1' compares the emitter's streamed path.
"""
import hashlib, json, os, re, shutil, subprocess, sys, time
from concurrent.futures import ThreadPoolExecutor

args = sys.argv[1:]
def opt(name):
    if name in args:
        i = args.index(name); v = args[i + 1]; del args[i:i + 2]; return v
    return None
lists = []
while "--list" in args:
    lists.append(opt("--list"))
save, against, keep = opt("--save"), opt("--against"), opt("--keep")
selfhost = opt("--self")
tree, exe = args[0], args[1]
if not lists and not selfhost:
    sys.exit("irsnap: no --list and no --self")

env = dict(os.environ)
env["TIKO_INCLUDE"] = tree + "/toolchains/tiko-windows/inc"
env.pop("TIKO_LIBPATH", None)
files = []
for lp in lists:
    files += [f for f in open(lp).read().split("\n") if f.strip()]
afx = os.environ.get("TIKO_AFXNOVA", "C:/dev/utils/AfxNova/src")
if keep: os.makedirs(keep, exist_ok=True)

SKIPSITE = re.compile(rb"(skip-site )\S+")
def run(cmd, cwd, tag, e=env):
    try:
        r = subprocess.run(cmd, cwd=cwd, env=e, capture_output=True, timeout=300)
        out, rc = r.stdout, r.returncode
    except subprocess.TimeoutExpired:
        out, rc = b"TIMEOUT", -1
    # A DECLINE NAMES THE COMPILER'S OWN SOURCE LINE ('skip-site src/mir/lower.tiko:238'), which
    # a refactor of the compiler moves by definition: the site is kept out of the hash.
    out = SKIPSITE.sub(rb"\1@", out)
    if keep:
        open(os.path.join(keep, tag.replace("/", "_").replace(":", "_")), "wb").write(out)
    return "%d:%s" % (rc, hashlib.sha1(out).hexdigest())

def one(f):
    p = f if os.path.isabs(f) or f[1:2] == ":" else os.path.join(tree, f)
    d, b = os.path.dirname(p), os.path.basename(p)
    mir = run([exe, "--dump-ir", "-i", afx, b], d, f + ".mir")
    ll = run([exe, "--emit-ir", "-i", afx, b], d, f + ".ll")
    return f, [mir, ll]

t0 = time.time()
with ThreadPoolExecutor(8) as ex:
    snap = dict(ex.map(one, files))
if selfhost:
    srcs = [l.strip() for l in open(os.path.join(selfhost, "build/sources.txt")) if l.strip() and not l.startswith("#")]
    e2 = dict(env)
    e2["TIKO_INCLUDE"] = selfhost + "/inc"; e2["TIKO_PKG"] = selfhost + "/pkg"
    # A COLD module cache, every run: the dump of a unit that imports a module the cache already
    # holds differs from one that built it, so a cache warmed by the other side's run would turn
    # "same compiler output" into "same cache state" (measured: the base binary, twice, gave two
    # hashes until this).
    mc = os.path.join(os.path.dirname(os.path.abspath(save or against or exe)), "irsnap.modcache.%d" % os.getpid())
    shutil.rmtree(mc, ignore_errors=True)
    e2["TIKO_MODCACHE"] = mc
    snap["<self>"] = [run([exe, "--dump-ir", "-target", "windows-x86_64", "-i", "src"] + srcs, selfhost, "self.mir", e2)]
    shutil.rmtree(mc, ignore_errors=True)

rc = 0
if against:
    old = json.load(open(against))
    n = 0
    for f in sorted(snap):
        a, b = old.get(f), snap[f]
        if a is None or a == b: continue
        n += 1
        what = [k for k, x, y in zip(("mir", "ll"), a, b) if x != y]
        print("IRDIFF %s  %s  (%s -> %s)" % (f, "+".join(what), a, b))
    print("irsnap: %d of %d differ" % (n, len(snap)))
    if n: rc = 1
if save:
    json.dump(snap, open(save, "w"), indent=0, sort_keys=True)
print("irsnap: %d entries, %ds" % (len(snap), time.time() - t0))
sys.exit(rc)
