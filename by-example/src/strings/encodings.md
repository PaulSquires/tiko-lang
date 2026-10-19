# Base64, hex and URLs

Bytes that are not text — a token, a hash, a key — have to be spelled in
characters before they can go into JSON, an e-mail or a URL. `std/codec` has
the usual spellings, and percent-encoding for text inside URLs.

```tiko
{{#include ../../examples/strings/encodings.tiko}}
```

**Output**

```text
{{#include ../../examples/strings/encodings.out}}
```

| Procedure | Gives |
|---|---|
| `codec.Base64Encode( x )` | base64; `codec.B64_URL` for the URL-safe alphabet |
| `codec.Base32Encode( x )` | capitals and digits only, for codes people type |
| `codec.HexEncode( x )` | two digits per byte; pass `true` for upper case |
| `codec.PercentEncode( s, mode )` | text safe inside a URL |

`x` can be a `ustring` (encoded as its UTF-8 bytes) or a
`containers.Array( of ubyte )`. Each encoding has a `…Decode` that fills an
array of bytes and a `…DecodeText` that gives back a `ustring`; both return a
`Result`.

Decoding is **strict**: a character outside the alphabet, missing or misplaced
`=` padding, or whitespace is refused, and the error says where. Pass
`codec.DECODE_IGNORE_WHITESPACE` or `codec.DECODE_ALLOW_MISSING_PAD` when the
input is known to be loose.

`PercentEncode` keeps letters, digits and `- . _ ~`. `PCT_PATH` also keeps `/`;
`PCT_QUERY` is what an HTML form sends, with a space as `+`.

### Activities

1. Encode the same token with `codec.B64_URL` and no padding, as a JSON Web
   Token does, and decode it back with `codec.DECODE_ALLOW_MISSING_PAD`.
2. Decode `"dXNlcjpzZWNyZXQ"` without the option and read the error.
