import struct, sys
def load(p):
    d = open(p, 'rb').read()
    off = struct.unpack_from('<I', d, 10)[0]
    w, h = struct.unpack_from('<ii', d, 18)
    bpp = struct.unpack_from('<H', d, 28)[0]
    comp = struct.unpack_from('<I', d, 30)[0]
    bytespp = bpp // 8
    stride = (w * bytespp + 3) & ~3
    flip = h > 0; h = abs(h)
    px = []
    for y in range(h):
        row = (h - 1 - y) if flip else y
        base = off + row * stride
        r = []
        for x in range(w):
            b = d[base + x*bytespp: base + x*bytespp + 3]
            r.append((b[2], b[1], b[0]))   # assume BGR(A) byte order
        px.append(r)
    return w, h, px, bpp, comp
a = load(sys.argv[1]); b = load(sys.argv[2])
print(sys.argv[1].split('/')[-1], a[0], a[1], 'bpp', a[3], ' vs ', sys.argv[2].split('/')[-1], b[0], b[1], 'bpp', b[3])
if a[:2] != b[:2]: print('size differs'); sys.exit()
w, h = a[0], a[1]
n = 0; mx = 0; hist = {}
rows = set()
for y in range(h):
    for x in range(w):
        p, q = a[2][y][x], b[2][y][x]
        dd = max(abs(p[i] - q[i]) for i in range(3))
        if dd:
            n += 1; mx = max(mx, dd); rows.add(y)
            k = 1 if dd <= 2 else 8 if dd <= 8 else 32 if dd <= 32 else 255
            hist[k] = hist.get(k, 0) + 1
print('pixels differing: %d of %d (%.2f%%), max channel delta %d' % (n, w*h, 100.0*n/(w*h), mx))
print('by delta: <=2:%d  <=8:%d  <=32:%d  >32:%d' % (hist.get(1,0), hist.get(8,0), hist.get(32,0), hist.get(255,0)))
