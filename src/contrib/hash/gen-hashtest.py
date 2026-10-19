"""Generates tests/codegen/src/std-hash-p3.tiko with every expected value computed by Python.

    python src/contrib/hash/gen-hashtest.py > tests/codegen/src/std-hash-p3.tiko
"""
import hashlib, hmac, zlib, sys

M64 = (1 << 64) - 1

def msg(n):
    return bytes(((i * 167 + 13) & 255) for i in range(n))

def crc32c(data):
    c = 0xFFFFFFFF
    for b in data:
        c ^= b
        for _ in range(8):
            c = (c >> 1) ^ 0x82F63B78 if c & 1 else c >> 1
    return c ^ 0xFFFFFFFF

def fnv32(d):
    h = 2166136261
    for b in d:
        h = ((h ^ b) * 16777619) & 0xFFFFFFFF
    return h

def fnv64(d):
    h = 14695981039346656037
    for b in d:
        h = ((h ^ b) * 1099511628211) & M64
    return h

P1, P2, P3, P4, P5 = 11400714785074694791, 14029467366897019727, 1609587929392839161, 9650029242287828579, 2870177450012600261
def rotl(x, r): return ((x << r) | (x >> (64 - r))) & M64
def rnd(acc, lane): return (rotl((acc + lane * P2) & M64, 31) * P1) & M64
def merge(acc, v): return (((acc ^ rnd(0, v)) * P1) + P4) & M64
def xxh64(d, seed=0):
    n, i = len(d), 0
    le = lambda k, w: int.from_bytes(d[k:k + w], 'little')
    if n >= 32:
        v = [(seed + P1 + P2) & M64, (seed + P2) & M64, seed, (seed - P1) & M64]
        while i + 32 <= n:
            v = [rnd(v[j], le(i + 8 * j, 8)) for j in range(4)]
            i += 32
        h = (rotl(v[0], 1) + rotl(v[1], 7) + rotl(v[2], 12) + rotl(v[3], 18)) & M64
        for x in v:
            h = merge(h, x)
    else:
        h = (seed + P5) & M64
    h = (h + n) & M64
    while i + 8 <= n:
        h ^= rnd(0, le(i, 8)); h = (rotl(h, 27) * P1 + P4) & M64; i += 8
    if i + 4 <= n:
        h ^= (le(i, 4) * P1) & M64; h = (rotl(h, 23) * P2 + P3) & M64; i += 4
    while i < n:
        h ^= (d[i] * P5) & M64; h = (rotl(h, 11) * P1) & M64; i += 1
    h ^= h >> 33; h = (h * P2) & M64; h ^= h >> 29; h = (h * P3) & M64; h ^= h >> 32
    return h

# the references must agree with published values before they are trusted
assert crc32c(b"123456789") == 0xE3069283
assert xxh64(b"") == 0xEF46DB3751D8E999 and xxh64(b"abc") == 0x44BC2CF5AD770999
assert xxh64(b"a") == 0xD24EC4F1A98C6E5B
assert fnv32(b"a") == 0xE40C292C and fnv64(b"a") == 0xAF63DC4C8601EC8C

def h32(v): return f"{v:08x}"
def h64(v): return f"{v:016x}"
ALGS = [
    ("HASH_CRC32",   lambda d: h32(zlib.crc32(d))),
    ("HASH_CRC32C",  lambda d: h32(crc32c(d))),
    ("HASH_ADLER32", lambda d: h32(zlib.adler32(d))),
    ("HASH_FNV1A32", lambda d: h32(fnv32(d))),
    ("HASH_FNV1A64", lambda d: h64(fnv64(d))),
    ("HASH_XXHASH64", lambda d: h64(xxh64(d))),
    ("HASH_MD5",     lambda d: hashlib.md5(d).hexdigest()),
    ("HASH_SHA1",    lambda d: hashlib.sha1(d).hexdigest()),
    ("HASH_SHA224",  lambda d: hashlib.sha224(d).hexdigest()),
    ("HASH_SHA256",  lambda d: hashlib.sha256(d).hexdigest()),
    ("HASH_SHA384",  lambda d: hashlib.sha384(d).hexdigest()),
    ("HASH_SHA512",  lambda d: hashlib.sha512(d).hexdigest()),
]
LENS = [0, 1, 3, 31, 32, 33, 55, 56, 57, 63, 64, 65, 111, 112, 113, 127, 128, 129, 200, 1000, 5553, 70000]
HM = [("HASH_MD5", hashlib.md5), ("HASH_SHA1", hashlib.sha1), ("HASH_SHA224", hashlib.sha224),
      ("HASH_SHA256", hashlib.sha256), ("HASH_SHA384", hashlib.sha384), ("HASH_SHA512", hashlib.sha512)]
HMAC_CASES = [  # RFC 4231 cases 1, 2, 3, 4, 6, 7 (RFC 2202 uses the same shapes for MD5/SHA-1)
    (b"\x0b" * 20, b"Hi There"),
    (b"Jefe", b"what do ya want for nothing?"),
    (b"\xaa" * 20, b"\xdd" * 50),
    (bytes(range(1, 26)), b"\xcd" * 50),
    (b"\xaa" * 131, b"Test Using Larger Than Block-Size Key - Hash Key First"),
    (b"\xaa" * 131, b"This is a test using a larger than block-size key and a larger than block-size data. "
                    b"The key needs to be hashed before being used by the HMAC algorithm."),
]

o = []
o.append("'' std/hash phase P3 (C:\\dev\\docs\\tiko-stdlib\\RFC-0001 section 6), GENERATED: every expected")
o.append("'' value below was computed by Python's hashlib, hmac and zlib, and by reference CRC-32C and")
o.append("'' xxHash64 implementations checked against their published vectors first. Covers each")
o.append("'' algorithm at every padding/stripe boundary length, streaming in every split of 200 bytes,")
o.append("'' the million-'a' messages, HMAC RFC 4231 cases 1-4, 6, 7 over all six cryptographic")
o.append("'' hashers (keys longer than the block included), Finish not disturbing the state, Reset,")
o.append("'' DigestFile against a temp file, and ConstantTimeEquals.")
o.append('#import "std/hash"\n#import "std/containers"\n#import "std/fs"\nusing containers\n')
o.append("dim shared as integer fails = 0\n")
o.append("sub Check( byref what as string, byval ok as boolean )\n    if ok = false then\n        print \"FAIL \"; what\n        fails += 1\n    end if\nend sub\n")
o.append("function Msg( byval n as long ) as Array( of ubyte )\n    dim as Array( of ubyte ) a\n    for i as long = 0 to n - 1\n        a.Push( cubyte( ( i * 167 + 13 ) and 255 ) )\n    next\n    return a\nend function\n")
o.append("function Unhex( byref h as string ) as Array( of ubyte )\n    dim as Array( of ubyte ) a\n    for i as long = 1 to len( h ) step 2\n        a.Push( cubyte( valint( \"&h\" & mid( h, i, 2 ) ) ) )\n    next\n    return a\nend function\n")
o.append("function HexOf( byref a as Array( of ubyte ) ) as string\n    dim as string s\n    for i as long = 0 to a.Count( ) - 1\n        s &= lcase( hex( a[i], 2 ) )\n    next\n    return s\nend function\n")

o.append("'' ------------------------------------------------------------ every algorithm, boundary lengths")
o.append(f"dim as long lens( 0 to {len(LENS) - 1} ) = {{ {', '.join(map(str, LENS))} }}")
for name, fn in ALGS:
    vals = [fn(msg(n)) for n in LENS]
    o.append(f"scope\n    dim as string want( 0 to {len(LENS) - 1} ) = {{ _")
    o.append(", _\n".join(f'        "{v}"' for v in vals) + " }")
    o.append(f"    for k as long = 0 to {len(LENS) - 1}")
    o.append(f"        dim as Array( of ubyte ) m = Msg( lens( k ) )")
    o.append(f'        Check( "{name} len " & lens( k ), hash.DigestHex( hash.{name}, m ) = want( k ) )')
    o.append("    next\nend scope")

o.append("\n'' ------------------------------------------------------------ streaming: every split of 200 bytes")
o.append("scope\n    dim as Array( of ubyte ) m = Msg( 200 )\n    dim as long algs( 0 to 11 ) = { _")
o.append("        " + ", ".join(f"hash.{n}" for n, _ in ALGS) + " }")
o.append("""    dim as boolean ok = TRUE
    for a as long = 0 to 11
        dim as string whole = hash.DigestHex( cast( hash.HashAlgorithm, algs( a ) ), m )
        for cut as long = 0 to 200
            dim as hash.Hasher ptr h = hash.NewHasher( cast( hash.HashAlgorithm, algs( a ) ) )
            if cut > 0 then h->Update( @m[0], cut )
            if cut < 200 then h->Update( @m[cut], 200 - cut )
            if h->FinishHex( ) <> whole then ok = FALSE
            delete h
        next
    next
    Check( "streaming equals one-shot", ok )
end scope""")

o.append("\n'' ------------------------------------------------------------ the million-'a' messages")
o.append("scope")
for name, f in [("Md5", hashlib.md5), ("Sha1", hashlib.sha1), ("Sha256", hashlib.sha256), ("Sha512", hashlib.sha512)]:
    o.append(f"    scope\n        dim as hash.{name} h\n        dim as string chunk = string( 1000, \"a\" )")
    o.append(f"        for i as long = 1 to 1000\n            h.UpdateRaw( chunk )\n        next")
    o.append(f'        Check( "million a {name}", h.FinishHex( ) = "{f(b"a" * 1000000).hexdigest()}" )\n    end scope')
o.append("end scope")

o.append("\n'' ------------------------------------------------------------ HMAC")
for name, f in HM:
    for ci, (k, d) in enumerate(HMAC_CASES):
        exp = hmac.new(k, d, f).hexdigest()
        tname = {"HASH_MD5": "Md5", "HASH_SHA1": "Sha1", "HASH_SHA224": "Sha224", "HASH_SHA256": "Sha256",
                 "HASH_SHA384": "Sha384", "HASH_SHA512": "Sha512"}[name]
        o.append(f"scope\n    dim as Array( of ubyte ) key = Unhex( \"{k.hex()}\" )")
        o.append(f"    dim as Array( of ubyte ) dat = Unhex( \"{d.hex()}\" )")
        o.append(f"    dim as hash.Hmac( of hash.{tname} ) mac = hash.Hmac( of hash.{tname} )( key )")
        o.append(f"    mac.UpdateBytes( dat )")
        o.append(f'    Check( "hmac {tname} case {ci}", mac.FinishHex( ) = "{exp}" )\nend scope')
o.append(f'Check( "HmacHex", hash.HmacHex( hash.HASH_SHA256, "key", "The quick brown fox jumps over the lazy dog" ) = "{hmac.new(b"key", b"The quick brown fox jumps over the lazy dog", hashlib.sha256).hexdigest()}" )')

o.append("\n'' ------------------------------------------------------------ Finish, Reset, text, sums")
o.append(f"""scope
    dim as hash.Sha256 h
    h.UpdateText( "a" )
    dim as string mid_ = h.FinishHex( )
    h.UpdateText( "bc" )
    Check( "finish keeps state", mid_ = "{hashlib.sha256(b"a").hexdigest()}" andalso h.FinishHex( ) = "{hashlib.sha256(b"abc").hexdigest()}" )
    h.Reset( )
    h.UpdateText( "abc" )
    Check( "reset", h.FinishHex( ) = "{hashlib.sha256(b"abc").hexdigest()}" )
    dim as ustring u = "caf" & wchr( &hE9 )
    Check( "text is utf-8", hash.DigestHex( hash.HASH_SHA1, u ) = "{hashlib.sha1("café".encode()).hexdigest()}" )
    dim as hash.Crc32 c
    c.UpdateRaw( "123456789" )
    Check( "crc sum", c.Sum32( ) = &hCBF43926 )
    dim as hash.XxHash64 x = hash.XxHash64( 0 )
    x.UpdateRaw( "abc" )
    Check( "xxh sum", x.Sum64( ) = &h44BC2CF5AD770999ull )
    dim as Array( of ubyte ) d = hash.Digest( hash.HASH_ADLER32, "Wikipedia" )
    Check( "adler wikipedia", HexOf( d ) = "11e60398" )
end scope""")

o.append(f"""
'' ------------------------------------------------------------ DigestFile, ConstantTimeEquals
scope
    dim as ustring dir_ = fs.CreateTempDir( ).Value( )
    dim as ustring p = fs.PathJoin( dir_, "data.bin" )
    dim as Array( of ubyte ) m = Msg( 70000 )
    fs.WriteAllBytes( p, m )
    var r = hash.DigestFile( hash.HASH_SHA256, p )
    Check( "digest file", r.IsOk( ) andalso HexOf( r.Value( ) ) = "{hashlib.sha256(msg(70000)).hexdigest()}" )
    var missing = hash.DigestFile( hash.HASH_SHA256, fs.PathJoin( dir_, "nope" ) )
    Check( "digest missing file", missing.IsOk( ) = FALSE andalso missing.Failure( ).Code( ) = fs.FS_NOT_FOUND )
    fs.RemoveDirAll( dir_ )
    dim as Array( of ubyte ) a = Unhex( "00ff10" ), b = Unhex( "00ff10" ), c = Unhex( "00ff11" ), e = Unhex( "00ff" )
    Check( "cte equal", hash.ConstantTimeEquals( a, b ) )
    Check( "cte differ", hash.ConstantTimeEquals( a, c ) = FALSE andalso hash.ConstantTimeEquals( a, e ) = FALSE )
end scope

if fails = 0 then print "ok"
""")
sys.stdout.write("\n".join(o))
