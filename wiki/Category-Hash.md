[Home](Home) › [All Categories](Categories) › **Hash**

# Hash: Checksums, Hashes And HMAC

The `std/hash` module turns any amount of data into a short fixed-size value: a **checksum** to catch accidental corruption, a **fast hash** for tables and deduplication, or a **cryptographic hash** where someone may be trying to fool you. `Hmac` adds a key, so only someone holding the key can produce the value.

```freebasic
#import "std/hash"

print hash.DigestHex( hash.HASH_SHA256, "abc" )
' ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad

print hash.DigestHex( hash.HASH_CRC32, "123456789" )    ' cbf43926
```

## Which One

| Type | Size | Use it for |
|---|---|---|
| `Crc32` | 4 bytes | zip, gzip, PNG and Ethernet checksums |
| `Crc32C` | 4 bytes | iSCSI, ext4, and formats that name "CRC-32C" |
| `Adler32` | 4 bytes | the zlib stream checksum |
| `Fnv1a32`, `Fnv1a64` | 4, 8 bytes | quick hashes of short keys |
| `XxHash64` | 8 bytes | fast hashing of large data; takes a seed |
| `Sha256`, `Sha224` | 32, 28 bytes | **integrity where someone could tamper**, signatures, content addresses |
| `Sha512`, `Sha384` | 64, 48 bytes | the same, faster than SHA-256 on 64-bit machines for long messages |
| `Md5`, `Sha1` | 16, 20 bytes | **interoperability only** — reading formats and protocols that name them |

The checksums and fast hashes are **not** security tools: anyone can make two inputs with the same value on purpose. MD5 and SHA-1 have the same weakness, which is why they are only for matching what another program already uses.

## Hashing In Pieces

Every type extends `Hasher`. Feed it as much as you like, in as many pieces as you like, then ask for the digest:

```freebasic
#import "std/hash"

dim h as hash.Sha256
h.UpdateText( "a" )
h.UpdateText( "bc" )
print h.FinishHex( )          ' the same as hashing "abc" at once
h.Reset( )                    ' start again
```

| Member | Does |
|---|---|
| `Update( p, n )` | adds `n` bytes at `p` |
| `UpdateBytes( a )` | adds a `containers.Array( of ubyte )` |
| `UpdateText( s )` | adds a `ustring` as its UTF-8 bytes |
| `UpdateRaw( s )` | adds a `string`'s bytes as they are |
| `Finish( )`, `FinishHex( )` | the digest, as bytes or lower-case hex; the hasher can keep going |
| `Reset( )` | forgets everything added |
| `DigestSize( )`, `BlockSize( )` | in bytes |

The checksum types also have `Sum32( )` (and `Sum64( )` for the 64-bit ones) to get the value as a number. As bytes, a checksum is written most significant byte first.

Because they share `Hasher`, one procedure can work with any of them:

```freebasic
#import "std/hash"

sub Report( byref h as hash.Hasher, byref label as ustring )
    h.UpdateText( "tiko" )
    print label; ": "; h.FinishHex( )
end sub

dim c as hash.Crc32
dim s as hash.Sha1
Report( c, "crc32" )
Report( s, "sha1" )
```

## One Call

```freebasic
#import "std/hash"
#import "std/containers"

dim raw as containers.Array( of ubyte ) = hash.Digest( hash.HASH_MD5, "abc" )
print raw.Count( )                                     ' 16

var r = hash.DigestFile( hash.HASH_SHA256, "no-such-file.iso" )
if r.IsOk( ) = false then print r.Failure( ).Message( )
```

`Digest` and `DigestHex` take a `HashAlgorithm` (`HASH_CRC32`, `HASH_SHA256`, …) and a `ustring`, a byte array, or — for `DigestHex` — a `string` of raw bytes. `DigestFile` reads a file in 64 KB pieces and returns a `Result`, so a missing file is a value, not a crash. `HashStream( h, stream )` feeds any [`fs.Stream`](Category-File-Streams) into a hasher.

## HMAC

```freebasic
#import "std/hash"

dim mac as hash.Hmac( of hash.Sha256 ) = hash.Hmac( of hash.Sha256 )( "key" )
mac.UpdateText( "The quick brown fox jumps over the lazy dog" )
print mac.FinishHex( )
' f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8

print hash.HmacHex( hash.HASH_SHA256, "key", "The quick brown fox jumps over the lazy dog" )
```

An HMAC proves a message came from someone holding the key and was not changed. `Hmac( of H )` works over any of the cryptographic hashers, takes the key as a `ustring` or a byte array, and is itself a `Hasher`.

**Compare MACs with `ConstantTimeEquals`, never with `=`.** An ordinary comparison stops at the first byte that differs, and the time it takes tells an attacker how much of a forged MAC was right:

```freebasic
#import "std/hash"
#import "std/containers"

dim mac as hash.Hmac( of hash.Sha256 ) = hash.Hmac( of hash.Sha256 )( "key" )
mac.UpdateText( "order 1042: paid" )
dim got as containers.Array( of ubyte ) = mac.Finish( )
dim expected as containers.Array( of ubyte ) = mac.Finish( )
print hash.ConstantTimeEquals( got, expected )          ' true
```

## Not Included

No password hashing, key derivation or encryption. Those need carefully reviewed constant-time code; use a dedicated library for them.

## See Also

[Codec](Category-Codec) · [UUID](Category-UUID) · [Filesystem](Category-Filesystem)
