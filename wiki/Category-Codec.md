[Home](Home) › [All Categories](Categories) › **Codec**

# Codec: Base64, Hex, Percent-Encoding And Binary Data

The `std/codec` module turns bytes into text and back — base64, base32 and hex for putting binary data into text formats, percent-encoding for URLs — and reads and writes fixed-width numbers and variable-length integers in a byte buffer.

```freebasic
#import "std/codec"

print codec.Base64Encode( "hello" )                   ' aGVsbG8=
print codec.HexEncode( "hi" )                         ' 6869
print codec.PercentEncode( "a b&c" )                  ' a%20b%26c
print codec.Base64DecodeText( "aGVsbG8=" ).Value( )   ' hello
```

**Bytes** are a `containers.Array( of ubyte )`, as in [std/fs](Category-Filesystem). **Text** is `ustring`; where text becomes bytes, it is UTF-8. A `string` argument is taken as raw bytes.

## Base64, Base32 And Hex

```freebasic
#import "std/codec"
#import "std/containers"

dim raw as containers.Array( of ubyte )
raw.Push( &hFB ) : raw.Push( &hFF )

print codec.Base64Encode( raw )                         ' +/8=
print codec.Base64Encode( raw, codec.B64_URL )          ' -_8=
print codec.Base64Encode( raw, codec.B64_URL, false )   ' -_8
print codec.Base32Encode( "hi" )                        ' NBUQ====
print codec.HexEncode( raw, true )                      ' FBFF

dim back as containers.Array( of ubyte )
var r = codec.Base64Decode( "+/8=", back )
if r.IsOk( ) then print r.Value( ); " bytes"            ' 2 bytes
```

Each family has three procedures: `…Encode` (bytes, `ustring` or `string` in, text out), `…Decode` (text in, bytes into an array, returning the byte count) and `…DecodeText` (text in, `ustring` out — the decoded bytes must be UTF-8).

| Alphabet | Value |
|---|---|
| `B64_STANDARD` | `A-Z a-z 0-9 + /` |
| `B64_URL` | `A-Z a-z 0-9 - _`, safe in URLs and file names |
| `B32_STANDARD` | `A-Z 2-7` |
| `B32_HEX` | `0-9 A-V`, which sorts like the bytes it encodes |

## Strict Decoding

Decoding accepts exactly what an encoder writes, so every byte sequence has one accepted encoding:

- only the alphabet's characters — a base32 decoder does not accept lower case;
- `=` padding exactly where it belongs, and required;
- no whitespace;
- no stray low bits in the last character (`Zh==` is refused, `Zg==` is not).

Two options relax that, and can be combined with `or`:

| Option | Accepts |
|---|---|
| `DECODE_IGNORE_WHITESPACE` | spaces, tabs and line breaks anywhere (MIME base64) |
| `DECODE_ALLOW_MISSING_PAD` | base64 or base32 with the `=` left off, as in JSON Web Tokens |

A failure is an `EncodingError` with a `Code( )`, the 1-based `Position( )` of the first bad character, and a `Message( )`:

```freebasic
#import "std/codec"
#import "std/containers"

dim b as containers.Array( of ubyte )
var r = codec.Base64Decode( "Zm9v!", b )
print r.Failure( ).Message( )        ' Base64Decode: invalid character at 5
```

| Code | Meaning |
|---|---|
| `ENC_INVALID_CHAR` | a character outside the alphabet |
| `ENC_INVALID_LENGTH` | a length no encoder produces |
| `ENC_INVALID_PADDING` | `=` missing, misplaced or excessive |
| `ENC_TRAILING_BITS` | the last character has non-zero unused bits |
| `ENC_INVALID_UTF8` | `…DecodeText` decoded bytes that are not UTF-8 |
| `ENC_TRUNCATED`, `ENC_OVERFLOW` | a varint ends early, or is wider than 64 bits |

## Percent-Encoding

```freebasic
#import "std/codec"

print codec.PercentEncode( "a b/c?d" )                        ' a%20b%2Fc%3Fd
print codec.PercentEncode( "a b/c", codec.PCT_PATH )          ' a%20b/c
print codec.PercentEncode( "q=a b&x", codec.PCT_QUERY )       ' q%3Da+b%26x
print codec.PercentDecode( "a+b%26c", codec.PCT_QUERY ).Value( )   ' a b&c
```

| Mode | Keeps | For |
|---|---|---|
| `PCT_COMPONENT` | `A-Z a-z 0-9 - . _ ~` | one value inside a URL |
| `PCT_PATH` | also `/ : @ ! $ & ' ( ) * + , ; =` | a path with its separators |
| `PCT_QUERY` | `A-Z a-z 0-9 - . _ ~`; space becomes `+` | HTML form data |

Every other byte of the UTF-8 text becomes `%XX` in upper-case hex. Decoding accepts either case, turns `+` into a space only in `PCT_QUERY` mode, and passes characters that were never escaped through unchanged.

## Numbers In A Byte Buffer

```freebasic
#import "std/codec"
#import "std/containers"

dim b as containers.Array( of ubyte )
codec.AppendU32LE( b, &h11223344 )      ' 44 33 22 11
codec.AppendU16BE( b, 513 )             ' 02 01
print hex( codec.GetU32LE( b, 0 ) )     ' 11223344
print codec.GetU16BE( b, 4 )            ' 513
```

`Get<T><E>( b, offset )`, `Put<T><E>( b, offset, value )` and `Append<T><E>( b, value )`, for `T` = `U16 U32 U64 I16 I32 I64 F32 F64` and `E` = `LE` (little-endian) or `BE` (big-endian). Offsets count bytes from 0. A `Get` past the end is runtime error 6; a `Put` past the end grows the array, filling any gap with zeros. Floats move as their IEEE 754 bit pattern.

## Variable-Length Integers

```freebasic
#import "std/codec"
#import "std/containers"

dim b as containers.Array( of ubyte )
codec.AppendUVarint( b, 300 )           ' AC 02
codec.AppendVarint( b, -2 )             ' 03

dim at as long = 0
print codec.ReadUVarint( b, at ).Value( ), at      ' 300  2
print codec.ReadVarint( b, at ).Value( ), at       ' -2  3
```

LEB128: seven bits per byte, low group first, the high bit set on every byte but the last — the format protobuf, DWARF and WebAssembly use. `AppendVarint` zig-zags first (0, -1, 1, -2 … become 0, 1, 2, 3 …), so small negative numbers stay short. `Read…` advances its offset past the value, and leaves it alone on failure.

## See Also

[UUID](Category-UUID) · [Array](Category-Array) · [Filesystem](Category-Filesystem) · [String Library](Category-String-Library)
