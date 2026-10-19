[Home](Home) › [Function Finder](Function-Finder) › **Encoding and IDs**

# Encoding and IDs

The functions to encode and decode Base64, hex and percent-encoding; generate UUIDs, grouped by what you want to do. The **From** column says what a program needs before it can call one:

- `std/codec`: `#import "std/codec"`, then `using codec` to call it by its bare name.
- `std/uuids`: `#import "std/uuids"`, then `using uuids` to call it by its bare name.

Jump to: [Encode and decode base64](#encode-and-decode-base64) · [Encode and decode hex](#encode-and-decode-hex) · [Percent-encode text for URLs](#percent-encode-text-for-urls) · [Encode and decode base32](#encode-and-decode-base32) · [Find out why decoding failed](#find-out-why-decoding-failed) · [Make a UUID](#make-a-uuid) · [Turn a UUID into text or bytes and back](#turn-a-uuid-into-text-or-bytes-and-back) · [Inspect a UUID](#inspect-a-uuid) · [Read numbers from a byte buffer](#read-numbers-from-a-byte-buffer) · [Write numbers into a byte buffer](#write-numbers-into-a-byte-buffer)

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
- [UUID guide](Category-UUID)
- [Array, which holds the bytes](Category-Array)
- [Result, which the decoders and Parse return](Category-Result)

---

[Home](Home) · [Function Finder](Function-Finder) · [Keyword Index](Keyword-Index)

<!-- Generated by tools/wikifinder/finder.py. Edit the data, not this page. -->
