import struct, math, random, subprocess, sys
from pathlib import Path
W = Path(r"C:\dev\fbx\build\.str")

def dbls():
    v = [0.0, -0.0, 1.0, -1.0, 0.1, 0.2, 0.3, 1.0/3.0, 2.0/3.0, 1.5, -1.5, 2.5,
         0.5, 0.0001, 0.00001, 1e-5, 3.14159265358979, 2.718281828459045]
    for e in range(-320, 309):
        try: v.append(float("1e%d" % e))
        except: pass
    for e in range(-30, 31):
        v.append(float("-1e%d" % e))
        v.append(float("1.2345678901234567e%d" % e))
        v.append(float("9.999999999999999e%d" % e))
    for n in [1,2,3,7,9,10,15,16,17,99,100,123456789,10**15,10**16,10**17,2**53,2**53+2,2**62]:
        v.append(float(n)); v.append(-float(n))
    v += [5e-324, 1e-323, 2.2250738585072014e-308, 2.225073858507201e-308,
          1.7976931348623157e308, 4.9406564584124654e-324,
          float('inf'), float('-inf'), float('nan')]
    v += [123456789012345678.0, 0.1+0.2, 1e21, 1e22, 1e23]
    random.seed(7)
    for _ in range(150):
        b = random.getrandbits(64)
        d = struct.unpack('<d', struct.pack('<Q', b))[0]
        if math.isnan(d): continue
        v.append(d)
    for _ in range(80):
        v.append(random.uniform(-1e6, 1e6))
        v.append(random.uniform(-1, 1))
    out, seen = [], set()
    for x in v:
        b = struct.unpack('<Q', struct.pack('<d', x))[0]
        if b in seen: continue
        seen.add(b); out.append(x)
    return out

def sngs():
    v = [0.0, -0.0, 1.0, -1.0, 0.1, 1.0/3.0, 16777217.0, 16777216.0, 1e-20, 1.5]
    for e in range(-45, 39):
        try:
            f = struct.unpack('<f', struct.pack('<f', float("1e%d" % e)))[0]
            v.append(f)
        except: pass
    for n in [1,2,3,7,9,10,99,123456,10**7,10**8,2**24,2**24+2,2**30]:
        v.append(float(n)); v.append(-float(n))
    v += [float('inf'), float('-inf'), float('nan'), 1.4012984643e-45, 1.1754943508e-38]
    random.seed(11)
    for _ in range(150):
        b = random.getrandbits(32)
        f = struct.unpack('<f', struct.pack('<I', b))[0]
        if math.isnan(f): continue
        v.append(f)
    out, seen = [], set()
    for x in v:
        try: b = struct.unpack('<I', struct.pack('<f', x))[0]
        except OverflowError: continue
        if b in seen: continue
        seen.add(b); out.append(struct.unpack('<f', struct.pack('<I', b))[0])
    return out

def dlit(x):
    if math.isnan(x): return "d_nan"
    if math.isinf(x): return "d_pinf" if x > 0 else "d_ninf"
    r = repr(x)
    if r in ("0.0","-0.0"): return "-0.0d" if math.copysign(1,x)<0 else "0.0d"
    if "e" in r or "E" in r:
        m, e = r.split("e"); 
        if "." not in m: m += ".0"
        return m + "d" + ("+" if int(e)>=0 else "-") + str(abs(int(e)))
    if "." not in r: r += ".0"
    return r + "d"

def slit(x):
    if math.isnan(x): return "s_nan"
    if math.isinf(x): return "s_pinf" if x > 0 else "s_ninf"
    r = repr(struct.unpack('<f', struct.pack('<f', x))[0])
    if r in ("0.0","-0.0"): return "-0.0f" if math.copysign(1,x)<0 else "0.0f"
    if "e" in r or "E" in r:
        m, e = r.split("e")
        if "." not in m: m += ".0"
        return m + "f" + ("+" if int(e)>=0 else "-") + str(abs(int(e)))
    if "." not in r: r += ".0"
    return r + "f"

D = dbls(); S = sngs()
L = []
L.append('#include once "crt.bi"')
L.append('dim as double d_pinf = 1.0/0.0, d_ninf = -1.0/0.0, d_nan = 0.0/0.0')
L.append('dim as single s_pinf = 1.0f/0.0f, s_ninf = -1.0f/0.0f, s_nan = 0.0f/0.0f')
L.append('dim as zstring * 64 buf')
L.append('dim as double d')
L.append('dim as single s')
for x in D:
    L.append("d = %s : snprintf(@buf, 64, \"%%.16g\", d) : print str(d); chr(9); buf" % dlit(x))
for x in S:
    L.append("s = %s : snprintf(@buf, 64, \"%%.7g\", cdbl(s)) : print str(s); chr(9); buf" % slit(x))
p = W / "explore.bas"
p.write_text("\n".join(L) + "\n", encoding="utf-8", newline="\n")
print(len(D), len(S))
