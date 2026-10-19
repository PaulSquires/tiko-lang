# Checksums and hashes

A **hash** turns any amount of data into a short value of fixed size: change
one byte of the data and the value changes. `std/hash` computes them, from a
string, from bytes, or from a file.

```tiko
{{#include ../../examples/files/checksums.tiko}}
```

**Output**

```text
{{#include ../../examples/files/checksums.out}}
```

`DigestHex( algorithm, data )` is the whole job in one call. Each algorithm is
also a type — `hash.Sha256`, `hash.Crc32` and the rest — that takes its data in
pieces with `UpdateText`, `UpdateBytes` or `Update( pointer, count )` and gives
the same answer as one call. `DigestFile` reads a file a block at a time, so
its size does not matter, and returns the digest's bytes in a `Result`.

| Choose | When |
|---|---|
| `HASH_CRC32`, `HASH_CRC32C`, `HASH_ADLER32` | checking for accidental damage |
| `HASH_FNV1A64`, `HASH_XXHASH64` | fast hashing of keys and large data |
| `HASH_SHA256`, `HASH_SHA512` | anything someone might change on purpose |
| `HASH_MD5`, `HASH_SHA1` | only to match a format that already uses them |

A CRC is quick, but anyone can change a file without changing its CRC. SHA-256
is the default when that matters.

An **HMAC** mixes a secret key into the hash. `Hmac( of hash.Sha256 )` takes the
key, then the message, and only someone who knows the key can produce the same
bytes — so a receiver who shares the key can tell a genuine message from a
forged one. Compare MACs with `hash.ConstantTimeEquals`, never with `=`: it
takes the same time wherever the first difference is, so the timing gives
nothing away. `hash.HmacHex( algorithm, key, message )` is the one-call form
when hex text is all you need.

### Activities

1. Hash `"hello"` with every algorithm in the table and compare the lengths.
2. Change one letter of the message `Sign` receives from Ada and check that
   it no longer matches.
