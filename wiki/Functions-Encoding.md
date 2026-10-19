[Home](Home) › [Function Finder](Function-Finder) › **Encoding, hashes and IDs**

# Encoding, hashes and IDs

The functions to encode and decode Base64, hex and percent-encoding; hash and checksum data; generate UUIDs, grouped by what you want to do. The **From** column says what a program needs before it can call one:

- `std/<Name>`: `#import "std/<Name>"`, then `using <Name>` to call it by its bare name.

Jump to: [Encode and decode base64](#encode-and-decode-base64) · [Encode and decode hex](#encode-and-decode-hex) · [Percent-encode text for URLs](#percent-encode-text-for-urls) · [Encode and decode base32](#encode-and-decode-base32) · [Find out why decoding failed](#find-out-why-decoding-failed) · [Hash or checksum data in one call](#hash-or-checksum-data-in-one-call) · [Pick a checksum or hash](#pick-a-checksum-or-hash) · [Hash data in pieces](#hash-data-in-pieces) · [Sign and check a message with HMAC](#sign-and-check-a-message-with-hmac) · [Make a UUID](#make-a-uuid) · [Turn a UUID into text or bytes and back](#turn-a-uuid-into-text-or-bytes-and-back) · [Inspect a UUID](#inspect-a-uuid) · [Read numbers from a byte buffer](#read-numbers-from-a-byte-buffer) · [Write numbers into a byte buffer](#write-numbers-into-a-byte-buffer)

## Encode and decode base64

| Function | What it does | From |
|---|---|---|
| [Base64Encode](Category-Codec#base64-base32-and-hex) | Returns bytes or a string as base64 text, in the standard or URL-safe alphabet. | `std/codec` |
| [Base64Decode](Category-Codec#base64-base32-and-hex) | Decodes base64 text into a byte array and returns the byte count, or an error. | `std/codec` |
| [Base64DecodeText](Category-Codec#base64-base32-and-hex) | Decodes base64 text straight to a string; the decoded bytes must be UTF-8. | `std/codec` |

## Encode and decode hex

| Function | What it does | From |
|---|---|---|
| [HexEncode](Category-Codec#base64-base32-and-hex) | Returns bytes or a string as hexadecimal text, two digits a byte, lower or upper case. | `std/codec` |
| [HexDecode](Category-Codec#base64-base32-and-hex) | Decodes hexadecimal text into a byte array and returns the byte count, or an error. | `std/codec` |
| [HexDecodeText](Category-Codec#base64-base32-and-hex) | Decodes hexadecimal text straight to a string; the decoded bytes must be UTF-8. | `std/codec` |

## Percent-encode text for URLs

| Function | What it does | From |
|---|---|---|
| [PercentEncode](Category-Codec#percent-encoding) | Returns text with the characters a URL cannot hold written as %XX escapes. | `std/codec` |
| [PercentDecode](Category-Codec#percent-encoding) | Turns %XX escapes, and + in query mode, back into text, or returns an error. | `std/codec` |

## Encode and decode base32

| Function | What it does | From |
|---|---|---|
| [Base32Encode](Category-Codec#base64-base32-and-hex) | Returns bytes or a string as base32 text, in the standard or sortable hex alphabet. | `std/codec` |
| [Base32Decode](Category-Codec#base64-base32-and-hex) | Decodes base32 text into a byte array and returns the byte count, or an error. | `std/codec` |
| [Base32DecodeText](Category-Codec#base64-base32-and-hex) | Decodes base32 text straight to a string; the decoded bytes must be UTF-8. | `std/codec` |

## Find out why decoding failed

| Function | What it does | From |
|---|---|---|
| [EncodingError](Category-Codec#strict-decoding) | Holds why decoding failed: a code, the position of the first bad character, a message. | `std/codec` |

## Hash or checksum data in one call

| Function | What it does | From |
|---|---|---|
| [Digest](Category-Hash#one-call) | Returns the digest of text or a byte array as bytes, for the algorithm named. | `std/hash` |
| [DigestHex](Category-Hash#one-call) | Returns the digest of text or a byte array as lower-case hex. | `std/hash` |
| [DigestFile](Category-Hash#one-call) | Returns the digest of a whole file, read in 64 KB pieces, or why it could not be read. | `std/hash` |
| [HashStream](Category-Hash#one-call) | Feeds a stream from where it is to its end into a hasher; returns the bytes read. | `std/hash` |
| [HashAlgorithm](Category-Hash#one-call) | Names the algorithms the one-call functions take, from HASH_CRC32 to HASH_SHA512. | `std/hash` |
| [NewHasher](Category-Hash#one-call) | Returns a new hasher for an algorithm, which the caller deletes, or nullptr. | `std/hash` |

## Pick a checksum or hash

| Function | What it does | From |
|---|---|---|
| [Crc32](Category-Hash#which-one) | Holds a CRC-32 checksum, the 4-byte one zip, gzip and PNG use. | `std/hash` |
| [Crc32C](Category-Hash#which-one) | Holds a CRC-32C checksum, the 4-byte one iSCSI and ext4 use. | `std/hash` |
| [Adler32](Category-Hash#which-one) | Holds an Adler-32 checksum, the 4-byte one zlib streams use. | `std/hash` |
| [Fnv1a32](Category-Hash#which-one) | Holds a 32-bit FNV-1a hash, quick for short keys; not for security. | `std/hash` |
| [Fnv1a64](Category-Hash#which-one) | Holds a 64-bit FNV-1a hash, quick for short keys; not for security. | `std/hash` |
| [XxHash64](Category-Hash#which-one) | Holds a 64-bit xxHash with an optional seed, fast on large data; not for security. | `std/hash` |
| [Md5](Category-Hash#which-one) | Holds a 16-byte MD5 hash, only for matching formats that already use it. | `std/hash` |
| [Sha1](Category-Hash#which-one) | Holds a 20-byte SHA-1 hash, only for matching formats that already use it. | `std/hash` |
| [Sha224](Category-Hash#which-one) | Holds a 28-byte SHA-224 hash, for data someone could tamper with. | `std/hash` |
| [Sha256](Category-Hash#which-one) | Holds a 32-byte SHA-256 hash, for data someone could tamper with. | `std/hash` |
| [Sha384](Category-Hash#which-one) | Holds a 48-byte SHA-384 hash, faster than SHA-256 on long messages on 64-bit machines. | `std/hash` |
| [Sha512](Category-Hash#which-one) | Holds a 64-byte SHA-512 hash, faster than SHA-256 on long messages on 64-bit machines. | `std/hash` |

## Hash data in pieces

| Function | What it does | From |
|---|---|---|
| [Hasher](Category-Hash#hashing-in-pieces) | Holds what every hash type shares, so one procedure can take any of them. | `std/hash` |
| [Hasher.Update](Category-Hash#hashing-in-pieces) | Adds a number of bytes at a pointer to the hash. | `std/hash` |
| [Hasher.UpdateBytes](Category-Hash#hashing-in-pieces) | Adds the bytes of an Array to the hash. | `std/hash` |
| [Hasher.UpdateText](Category-Hash#hashing-in-pieces) | Adds text to the hash as its UTF-8 bytes. | `std/hash` |
| [Hasher.UpdateRaw](Category-Hash#hashing-in-pieces) | Adds the bytes of a string to the hash as they are, with no conversion. | `std/hash` |
| [Hasher.Finish](Category-Hash#hashing-in-pieces) | Returns the digest so far as bytes; more data can still be added after it. | `std/hash` |
| [Hasher.FinishHex](Category-Hash#hashing-in-pieces) | Returns the digest so far as lower-case hex; more data can still be added after it. | `std/hash` |
| [Hasher.Reset](Category-Hash#hashing-in-pieces) | Forgets everything added and starts the hash again. | `std/hash` |
| [Hasher.DigestSize](Category-Hash#hashing-in-pieces) | Returns the size of the digest in bytes. | `std/hash` |
| [Hasher.BlockSize](Category-Hash#hashing-in-pieces) | Returns the size of the block the algorithm works on, in bytes. | `std/hash` |
| [Sum32 / Sum64](Category-Hash#hashing-in-pieces) | Returns a checksum or fast hash as a number instead of bytes. | `std/hash` |

## Sign and check a message with HMAC

| Function | What it does | From |
|---|---|---|
| [Hmac](Category-Hash#hmac) | Holds an HMAC: a cryptographic hash with a key, which is itself a Hasher. | `std/hash` |
| [HmacHex](Category-Hash#hmac) | Returns the HMAC of a message under a key as lower-case hex, in one call. | `std/hash` |
| [ConstantTimeEquals](Category-Hash#hmac) | Returns true if two byte arrays match, taking the same time whichever byte differs. | `std/hash` |

## Make a UUID

| Function | What it does | From |
|---|---|---|
| [Uuid](Category-UUID#as-a-key) | Holds a 128-bit identifier that can be compared, sorted and used as a Map key. | `std/uuids` |
| [NewV4](Category-UUID#which-kind-to-make) | Returns a new random UUID from the system's secure random generator. | `std/uuids` |
| [NewV7](Category-UUID#which-kind-to-make) | Returns a new UUID that starts with the time, so each one sorts after the one before. | `std/uuids` |
| [NilUuid](Category-UUID#members) | Returns the nil UUID, with all 16 bytes zero. | `std/uuids` |
| [MaxUuid](Category-UUID#members) | Returns the max UUID, with every bit set. | `std/uuids` |

## Turn a UUID into text or bytes and back

| Function | What it does | From |
|---|---|---|
| [Parse](Category-UUID#parsing-and-printing) | Parses a UUID with or without hyphens, braces or a urn:uuid: prefix, or returns an error. | `std/uuids` |
| [Uuid.ToString](Category-UUID#parsing-and-printing) | Returns the UUID as 36 characters of lower-case text in the 8-4-4-4-12 form. | `std/uuids` |
| [FromBytes](Category-UUID#members) | Returns a UUID from an array of exactly 16 bytes, or an error. | `std/uuids` |
| [Uuid.ToBytes](Category-UUID#members) | Returns the UUID's 16 bytes as an Array. | `std/uuids` |
| [UuidError](Category-UUID#parsing-and-printing) | Holds why a UUID did not parse: a code and the position of the offending character. | `std/uuids` |

## Inspect a UUID

| Function | What it does | From |
|---|---|---|
| [Uuid.Version](Category-UUID#members) | Returns the UUID's version, such as 4 or 7, or 0 for the nil UUID. | `std/uuids` |
| [Uuid.Variant](Category-UUID#members) | Returns the UUID's variant field, which is 1 for every standard UUID. | `std/uuids` |
| [Uuid.IsNil](Category-UUID#members) | Returns true if all 16 bytes of the UUID are zero. | `std/uuids` |
| [Uuid.UnixMillis](Category-UUID#members) | Returns when a version 7 UUID was made, in Unix milliseconds, or -1 for any other. | `std/uuids` |
| [Uuid.HashOf](Category-UUID#members) | Returns a hash of the UUID, used when it is a Map or Set key. | `std/uuids` |

## Read numbers from a byte buffer

| Function | What it does | From |
|---|---|---|
| [GetU16LE … GetF64BE](Category-Codec#numbers-in-a-byte-buffer) | Reads a fixed-width integer or float at a byte offset, little- or big-endian. | `std/codec` |
| [ReadUVarint](Category-Codec#variable-length-integers) | Reads an unsigned variable-length integer at an offset and moves the offset past it. | `std/codec` |
| [ReadVarint](Category-Codec#variable-length-integers) | Reads a signed variable-length integer at an offset and moves the offset past it. | `std/codec` |

## Write numbers into a byte buffer

| Function | What it does | From |
|---|---|---|
| [PutU16LE … PutF64BE](Category-Codec#numbers-in-a-byte-buffer) | Writes a fixed-width number at a byte offset, growing the array if it is too short. | `std/codec` |
| [AppendU16LE … AppendF64BE](Category-Codec#numbers-in-a-byte-buffer) | Adds a fixed-width number to the end of a byte array, little- or big-endian. | `std/codec` |
| [AppendUVarint](Category-Codec#variable-length-integers) | Adds an unsigned integer to a byte array in as few bytes as it needs. | `std/codec` |
| [AppendVarint](Category-Codec#variable-length-integers) | Adds a signed integer to a byte array, keeping small negative numbers short. | `std/codec` |

## See Also

- [Codec guide](Category-Codec)
- [Hash guide](Category-Hash)
- [UUID guide](Category-UUID)
- [Array, which holds the bytes](Category-Array)
- [Result, which the decoders and Parse return](Category-Result)

---

[Home](Home) · [Function Finder](Function-Finder) · [Keyword Index](Keyword-Index)

<!-- Generated by tools/wikifinder/finder.py. Edit the data, not this page. -->
