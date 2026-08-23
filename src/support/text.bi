'' text.bi -- encoding detection, UTF-8/UTF-16 transcoding, column arithmetic.
''
'' tiko-lang normalises every source file to UTF-8 once, at load, and then works in bytes
'' (docs/plan/03 section 2 -- decision D6). USTRING appears only where a caller needs
'' real Unicode: diagnostic rendering and wstring/ustring literal payloads.
''
'' Invariants:
''   - Decode never fails. Invalid input yields U+FFFD and consumes one byte, so a
''     malformed file still produces a complete token stream.
''   - Byte offsets always refer to the NORMALISED buffer, never the original file.
''   - Lengths and buffer indices are LONG, matching FB.Array.Count( ). Codepoints
''     and source locations are ULONG. The two are never interchanged silently.

#ifndef __TKO_TEXT_BI__
#define __TKO_TEXT_BI__

#include once "tko.bi"

namespace Tko.Text

    const REPLACEMENT_CP as ulong = &hFFFD
    const DEFAULT_TAB_WIDTH as long = 8

    enum Encoding
        ENC_UTF8 = 0        '' no BOM, valid UTF-8 (includes pure ASCII)
        ENC_UTF8_BOM        '' EF BB BF
        ENC_UTF16LE         '' FF FE
        ENC_UTF16BE         '' FE FF
        '' UTF-32LE's BOM BEGINS WITH UTF-16LE's, so it must be tested first or every
        '' UTF-32LE file is read as UTF-16LE followed by a stream of NULs.
        ENC_UTF32LE         '' FF FE 00 00
        ENC_UTF32BE         '' 00 00 FE FF
        ENC_BYTES           '' no BOM, not valid UTF-8 -- preserved verbatim
    end enum

    declare function DetectEncoding _
        ( byval p as const ubyte ptr, byval n as long ) as Encoding

    declare function EncodingName( byval e as Encoding ) as string

    declare function IsValidUtf8 _
        ( byval p as const ubyte ptr, byval n as long ) as boolean

    '' Byte offset of the first sequence that is not valid UTF-8, or -1 if the whole
    '' buffer is valid. Diagnostics point here, so "not valid UTF-8" names a byte
    '' rather than a file.
    declare function FirstInvalidUtf8 _
        ( byval p as const ubyte ptr, byval n as long ) as long

    '' Transcode src into dst as UTF-8, stripping any BOM. dst is cleared first.
    declare sub NormalizeToUtf8 _
        ( byref src as ByteBuf, byref dst as ByteBuf, byval enc as Encoding )

    '' Decode one codepoint at p[i], advancing i past it. Never reads beyond n.
    declare function DecodeUtf8 _
        ( byval p as const ubyte ptr, byval n as long, byref i as long ) as ulong

    declare sub AppendUtf8( byref dst as ByteBuf, byval cp as ulong )

    '' Bytes the codepoint starting at p[i] occupies, clamped to n.
    declare function Utf8SeqLen _
        ( byval p as const ubyte ptr, byval n as long, byval i as long ) as long

    '' 1-based display column of byteOffset, counting codepoints and expanding tabs.
    declare function ColumnOf _
        ( byval p as const ubyte ptr, byval lineStart as long, _
          byval byteOffset as long, byval tabWidth as long = DEFAULT_TAB_WIDTH ) as long

    '' Terminal cells a codepoint occupies: 0 for combining marks, 2 for East Asian
    '' wide and emoji, 1 otherwise. Used only to align caret underlines.
    declare function DisplayWidth( byval cp as ulong ) as long

    '' ASCII-only case folding. FreeBASIC identifiers and keywords are ASCII, so this
    '' is the correct fold for symbol lookup -- deliberately not locale-aware.
    declare function LowerAscii( byval s as string ) as string
    '' ASCII-only, deliberately: a mangled name is bytes, and folding non-ASCII here
    '' would change identifiers the linker treats as opaque.
    declare function UpperAscii( byval s as string ) as string
    declare sub LowerAsciiInto _
        ( byval src as const ubyte ptr, byval n as long, byval dst as ubyte ptr )

    declare function Utf8ToUString( byval p as const ubyte ptr, byval n as long ) as ustring
    declare function UStringToUtf8( byval s as ustring ) as string

end namespace

#endif
