[Home](Home) › [Using C Libraries](Using-C-Libraries-Tutorial) › **Compression**

# Compression Tutorial

> 📘 **Start with:** [Vendor Packages](Vendor-Packages), what a vendor package is and how `link static` and `link dynamic` work.
>
> Measured with zlib 1.4, zstd 1.6.0, xz 5.8.4, brotli 1.2.1, lz4 1.11.1 and bzip2 1.0.8. Every program here was compiled and run on Windows and Linux (x86-64); the package itself is also measured on Linux arm64, macOS arm64 and Android.

tiko ships seven compression libraries as one [vendor package](Vendor-Packages), built into one library:

| Library | Formats | Where you meet them |
| --- | --- | --- |
| **zlib** | deflate, zlib, gzip (`.gz`) | HTTP, PNG, PDF, `.tar.gz`, nearly everything |
| **minizip** (part of zlib) | `.zip` archives, zip64 | everywhere |
| **zstd** | Zstandard (`.zst`) | Linux packages, databases, HTTP `zstd` |
| **liblzma** (xz) | `.xz`, `.lzma` | source tarballs, 7-Zip's LZMA |
| **brotli** | `.br` | HTTP `br`, WOFF2 fonts |
| **lz4** | LZ4 blocks and frames (`.lz4`) | games, real-time data |
| **bzip2** | `.bz2` | older tarballs |

One line gives a program all of their C APIs and links the library:

```freebasic
#import "vendor/compression"
```

There is nothing to download or install. The names are each library's own, as its documentation has them -- zlib's [manual](https://zlib.net/manual.html), `zstd.h`, liblzma's `lzma/*.h`, brotli's `encode.h` and `decode.h`, `lz4.h` and `lz4frame.h`, bzip2's [manual](https://sourceware.org/bzip2/manual/manual.html). Nothing is wrapped. More programs are in the toolchain's `examples/compression`.

---

## 1. A first program

The simplest calls are zlib's `compress2` and `uncompress`, which work on whole buffers. A tiko `string` is a buffer: `strptr` is its address, and `space( n )` makes room for `n` bytes.

```freebasic
#import "vendor/compression"

dim as string text = ""
for i as integer = 1 to 200
    text &= "Row " & i & ": the quick brown fox jumps over the lazy dog." & !"\n"
next

' compress2 writes a zlib stream; compressBound is the most it can need
dim as uLongf packedSize = compressBound( len( text ) )
dim as string packed = space( packedSize )
if compress2( strptr( packed ), @packedSize, strptr( text ), len( text ), Z_BEST_COMPRESSION ) <> Z_OK then
    print "compress2 failed" : end 1
end if
packed = left( packed, packedSize )
print "text:"; len( text ); " bytes, compressed:"; len( packed ); " bytes"

' uncompress needs room for the original: keep its length beside the data
dim as uLongf backSize = len( text )
dim as string back = space( backSize )
dim as int32 r = uncompress( strptr( back ), @backSize, strptr( packed ), len( packed ) )
print "uncompress: "; iif( r = Z_OK, "ok", "error " & r ); ", "; backSize; " bytes, the same text: "; iif( back = text, "yes", "no" )
print "zlib "; *zlibVersion( )
```
```text
text: 10692 bytes, compressed: 566 bytes
uncompress: ok, 10692 bytes, the same text: yes
zlib 1.4
```

`compressBound` is the most `compress2` can need, so the first `space` is big enough for any input; the size it really used comes back in `packedSize`. `uncompress` is told how much room it has and must have enough for the whole original, so **keep the original's length** beside the compressed bytes (a file format would store it in a header). Both return `Z_OK` or a negative `Z_*` error.

`uLongf` is zlib's own type for those lengths: C's `unsigned long`, which is 32 bits on Windows and 64 on Linux and macOS. Declare them as `uLongf` (or `uLong_`; `ulong` itself is a tiko keyword), never as a fixed width.

## 2. `.gz` files

zlib also reads and writes `.gz` files directly. `gzopen` takes a path and a mode -- `"wb9"` writes at level 9, `"rb"` reads -- and the rest look like C's file calls: `gzwrite`, `gzread`, `gzputs`, `gzgets`, `gzclose`.

```freebasic
#import "vendor/compression"

' write a .gz file a line at a time
dim as gzFile g = gzopen( "notes.txt.gz", "wb9" )
if g = nullptr then print "cannot create notes.txt.gz" : end 1
for i as integer = 1 to 3
    gzputs( g, "note " & i & !": compressed on the way to the disk\n" )
next
gzclose( g )

' and read it back the same way
g = gzopen( "notes.txt.gz", "rb" )
dim as zstring * 256 buf
while gzgets( g, @buf, 256 )
    print buf;
wend
gzclose( g )
```
```text
note 1: compressed on the way to the disk
note 2: compressed on the way to the disk
note 3: compressed on the way to the disk
```

The file is an ordinary `.gz`: `gzip -d`, 7-Zip and browsers read it. `gzread` on a file that is not compressed at all just returns its bytes, so the same code reads `notes.txt` and `notes.txt.gz`.

## 3. Which format?

The same text through each library at a high setting, with the size it came out and a check that it came back:

```freebasic
#import "vendor/compression"

' The same 60 KB of text through each format, at a high setting, and back.
dim as string text = ""
for i as integer = 1 to 2000
    text &= "item " & i & ", price " & ( i * 37 ) mod 1000 & ", stock " & ( i * 13 ) mod 97 & !"\n"
next
dim as uinteger n = len( text ), room = n + n \ 2 + 1024
dim as string packed = space( room ), back = space( n )
print using "\      \ ######  &"; "input"; n; "bytes"

dim as uLongf zl = room, zb = n
compress2( strptr( packed ), @zl, strptr( text ), n, 9 )
uncompress( strptr( back ), @zb, strptr( packed ), zl )
print using "\      \ ######  &"; "zlib"; zl; iif( back = text, "ok", "FAIL" )

dim as uinteger s = ZSTD_compress( strptr( packed ), room, strptr( text ), n, 19 )
ZSTD_decompress( strptr( back ), n, strptr( packed ), s )
print using "\      \ ######  &"; "zstd"; s; iif( back = text, "ok", "FAIL" )

dim as uinteger x = 0, ip = 0, op = 0
dim as uint64 limit = &hFFFFFFFFFFFFFFFFull
lzma_easy_buffer_encode( 9, LZMA_CHECK_CRC64, nullptr, strptr( text ), n, strptr( packed ), @x, room )
lzma_stream_buffer_decode( @limit, 0, nullptr, strptr( packed ), @ip, x, strptr( back ), @op, n )
print using "\      \ ######  &"; "xz"; x; iif( back = text, "ok", "FAIL" )

dim as uinteger b = room, bb = n
BrotliEncoderCompress( 11, BROTLI_DEFAULT_WINDOW, BROTLI_MODE_TEXT, n, strptr( text ), @b, strptr( packed ) )
BrotliDecoderDecompress( b, strptr( packed ), @bb, strptr( back ) )
print using "\      \ ######  &"; "brotli"; b; iif( back = text, "ok", "FAIL" )

dim as int32 l = LZ4_compress_HC( strptr( text ), strptr( packed ), n, room, LZ4HC_CLEVEL_MAX )
LZ4_decompress_safe( strptr( packed ), strptr( back ), l, n )
print using "\      \ ######  &"; "lz4"; l; iif( back = text, "ok", "FAIL" )

dim as uint32 z2 = room, z2b = n
BZ2_bzBuffToBuffCompress( strptr( packed ), @z2, strptr( text ), n, 9, 0, 0 )
BZ2_bzBuffToBuffDecompress( strptr( back ), @z2b, strptr( packed ), z2, 0, 0 )
print using "\      \ ######  &"; "bzip2"; z2; iif( back = text, "ok", "FAIL" )
```
```text
input     60466  bytes
zlib      10988  ok
zstd       7576  ok
xz         6720  ok
brotli     4667  ok
lz4       15772  ok
bzip2      7284  ok
```

On this text brotli is smallest and lz4 largest, the usual order. Which one to use is mostly decided by who reads the data:

- **gzip / zlib** when anything else has to read it -- it is the one format every tool, language and browser has.
- **zstd** for your own files and network data: close to xz's ratio here, with levels from 1 (fastest) to 22 (smallest) -- `02-zstd` times each.
- **xz** when size is all that matters and the data is written once: release archives.
- **brotli** for web content: browsers decode it, and it was tuned on web text.
- **lz4** when speed matters more than size: it is built to be fast, at a modest ratio.
- **bzip2** to read old `.bz2` files.

## 4. Streams: files of any size

Whole-buffer calls need the whole input and output in memory. For a large file every library has a **stream**: a record holding the coder's state, fed a buffer at a time. zlib's is `z_stream`; liblzma's `lzma_stream` and bzip2's `bz_stream` work the same way, and zstd's `ZSTD_compressStream2` very nearly. This program gzips a 2.3 MB file through two 16 KB buffers:

```freebasic
#import "vendor/compression"

' A file of any size to FILE.gz through two 16 KB buffers: deflate is called until it has
' taken all the input it was given, then again with Z_FINISH until it returns Z_STREAM_END.
const CHUNK = 16384

sub GzipFile( byref src as const string, byref dst as const string )
    dim as integer fin = freefile
    open src for binary access read as #fin
    dim as integer fout = freefile
    open dst for binary access write as #fout
    dim as z_stream z
    deflateInit2( @z, 9, Z_DEFLATED, 16 + 15, 8, Z_DEFAULT_STRATEGY )   ' 16 + 15: a gzip wrapper
    dim as uint8 inbuf( 0 to CHUNK - 1 ), outbuf( 0 to CHUNK - 1 )
    dim as integer remaining = lof( fin )
    dim as int32 flush
    do
        dim as integer n = iif( remaining < CHUNK, remaining, CHUNK )
        if n > 0 then get #fin, , inbuf(0), n
        remaining -= n
        flush = iif( remaining = 0, Z_FINISH, Z_NO_FLUSH )
        z.next_in = @inbuf(0) : z.avail_in = n
        do
            z.next_out = @outbuf(0) : z.avail_out = CHUNK
            deflate( @z, flush )
            put #fout, , outbuf(0), CHUNK - z.avail_out
        loop while z.avail_out = 0
    loop until flush = Z_FINISH
    print src; ": "; z.total_in; " bytes in, "; z.total_out; " bytes out"
    deflateEnd( @z )
    close #fin, #fout
end sub

dim as integer f = freefile
open "big.txt" for output as #f
for i as integer = 1 to 50000
    print #f, "line "; i; " of a log file that compresses well"
next
close #f
GzipFile( "big.txt", "big.txt.gz" )
```
```text
big.txt: 2338894 bytes in, 125375 bytes out
```

The pattern is the same for each library: point `next_in` / `avail_in` at the next input; call the coder until it leaves room in `next_out` (which means it has taken all the input); write what it produced; repeat, and with the last input say *finish* (`Z_FINISH`, `LZMA_FINISH`, `BZ_FINISH`) until the stream reports its end. On Windows the input is 2,388,894 bytes: `print #` ends each line with CR LF there.

- **The stream is yours.** `dim as z_stream z` gives a record of zeros, which is what zlib (and liblzma's `LZMA_STREAM_INIT`) ask a new stream to be. Its init routine sets it up, its end routine frees what that allocated, and you must not copy it in between.
- **`deflateInit2( @z, level, Z_DEFLATED, windowBits, memLevel, strategy )`** picks the wrapper by `windowBits`: 15 for a zlib stream, 16 + 15 for gzip, -15 for raw deflate (as inside a `.zip`). `inflateInit2( @z, 16 + 15 )` reads gzip, and `32 + 15` either. In C these are macros, and here too: they pass zlib's version and the size of `z_stream` for it to check.

## 5. Zip archives

minizip writes and reads `.zip` files: `zipOpen64` creates one, `zipOpenNewFileInZip64` starts each entry, `zipWriteInFileInZip` fills it; `unzOpen64` opens one, and `unzGoToFirstFile` / `unzGoToNextFile` walk its entries.

```freebasic
#import "vendor/compression"

' Two files into a .zip, then the archive listed back.
dim as zipFile zf = zipOpen64( @"notes.zip", APPEND_STATUS_CREATE )
dim as zstring ptr names(0 to 1) = { @"readme.txt", @"docs/howto.txt" }
dim as string bodies(0 to 1) = { "Read me first." & !"\n", string( 500, "-" ) & !"\n" }
for i as integer = 0 to 1
    dim as zip_fileinfo info                 ' all zeros: no date, no attributes
    zipOpenNewFileInZip64( zf, names(i), @info, nullptr, 0, nullptr, 0, nullptr, Z_DEFLATED, 6, 0 )
    zipWriteInFileInZip( zf, strptr( bodies(i) ), len( bodies(i) ) )
    zipCloseFileInZip( zf )
next
zipClose( zf, nullptr )

dim as unzFile uf = unzOpen64( @"notes.zip" )
dim as int32 r = unzGoToFirstFile( uf )
while r = UNZ_OK
    dim as unz_file_info64 fi
    dim as zstring * 260 nm
    unzGetCurrentFileInfo64( uf, @fi, @nm, 260, nullptr, 0, nullptr, 0 )
    print nm; ": "; fi.uncompressed_size; " bytes, stored in "; fi.compressed_size
    r = unzGoToNextFile( uf )
wend
unzClose( uf )
```
```text
readme.txt: 15 bytes, stored in 17
docs/howto.txt: 501 bytes, stored in 9
```

- **`zipOpen64` and `unzOpen64` take C's `const void *`**: the path is the file layer's business. A literal goes in as `@"notes.zip"`, a string variable as `strptr( path )`.
- Names are stored as given, with `/` between folders. An entry is read with `unzOpenCurrentFile`, `unzReadCurrentFile` and `unzCloseCurrentFile`; the close returns `UNZ_CRCERROR` when the bytes did not match the entry's CRC.
- The short entry came out *larger* than it went in: deflate cannot shrink 15 bytes and adds a few of its own. The 501 dashes became 9.
- On Windows minizip opens files through the C runtime, so a name must be in the ANSI code page. For any Unicode path, open the archive with `fill_win32_filefunc64W` and `zipOpen2_64` / `unzOpen2_64` (`iowin32.h`).

## 6. Noticing damage

Every library reports a corrupt input as an error rather than crashing -- **if the format checks.** zlib, gzip, xz and bzip2 always carry a checksum. A zstd frame carries one only when asked, and a raw LZ4 block never does (an LZ4 frame does, with `contentChecksumFlag`). Here one byte of zstd data is damaged, with the checksum off and on:

```freebasic
#import "vendor/compression"

' One flipped byte, read back with zstd's frame checksum off (the default) and on.
dim as string text = ""
for i as integer = 1 to 500
    text &= "record " & i & ": " & string( i mod 40, "x" ) & !"\n"
next
dim as uinteger room = ZSTD_compressBound( len( text ) )

for withChecksum as integer = 0 to 1
    dim as string packed = space( room ), back = space( len( text ) )
    dim as ZSTD_CCtx ptr cc = ZSTD_createCCtx( )
    ZSTD_CCtx_setParameter( cc, ZSTD_c_checksumFlag, withChecksum )
    dim as uinteger n = ZSTD_compress2( cc, strptr( packed ), room, strptr( text ), len( text ) )
    ZSTD_freeCCtx( cc )
    packed[40] xor= &h20                       ' damage one byte of the data
    dim as uinteger r = ZSTD_decompress( strptr( back ), len( back ), strptr( packed ), n )
    print "checksum "; iif( withChecksum, "on: ", "off:" );
    if ZSTD_isError( r ) then
        print " error -- "; *ZSTD_getErrorName( r )
    else
        print " no error, and the text is "; iif( back = text, "the same", "different" )
    end if
next
```
```text
checksum off: no error, and the text is different
checksum on:  error -- Restored data doesn't match checksum
```

Without the checksum the damaged byte decoded to different text and **reported success**. Turn the checksum on (`ZSTD_c_checksumFlag`, through a `ZSTD_CCtx` and `ZSTD_compress2`) for anything stored or sent where it can be damaged; it costs four bytes a frame.

## 7. More programs

The toolchain's `examples/compression`, each built with `tiko <name>.tiko`:

| Folder | Shows |
| --- | --- |
| `01-gzip` | a file to `FILE.gz` and back with the gz* calls -- `gzip FILE`, `gzip -d FILE.gz` |
| `02-zstd` | buffers through `ZSTD_compress` / `ZSTD_decompress` at five levels, with sizes and times |
| `03-zip` | a `.zip` written and listed back, every entry's CRC checked -- `zip ARCHIVE.zip FILE...`, `zip -l ARCHIVE.zip` |
| `04-xz` | a file to `FILE.xz` and back through liblzma's `lzma_stream`; a corrupt or truncated file reported |
| `selftest` | every format round-tripped, one corrupt input each, and files made by the reference tools (gzip, zstd, xz, bzip2, Python's zipfile) decoded exactly |

## 8. In a project

A [`tiko build`](Category-Tiko-Build) project needs nothing in its `tiko.toml` for this package: the import says it all. `tiko build`'s `copy_to` copies the shared library along with the program.

## 9. Shipping the program

- **Linked dynamically** (the default): ship the library the build put beside the program -- `compression.dll` on Windows, `compression_linux_x86_64.so` or `compression_linux_arm64.so` on Linux, `compression_macos_arm64.dylib` on macOS. It holds all seven libraries, about 2 MB, and needs nothing else (on Windows, only `KERNEL32.dll`).
- **Linked statically** (`#import "vendor/compression" link static`): the program alone, carrying only what it calls -- a program that uses zlib alone grows by about 46 KB. Android is always static.
- **With `link dynamic` on Windows the DLL has its own C runtime**: never give it the program's `FILE *` (`BZ2_bzReadOpen`, `BZ2_bzWriteOpen`) or a C file descriptor (`gzdopen`, `BZ2_bzdopen`). The calls that take a path, and every buffer and stream call, are fine.

The licences are all permissive, in full in the toolchain's `pkg/vendor/compression/LICENSE`. zstd's and lz4's BSD licences, brotli's MIT licence and minizip's Info-ZIP part ask for their notices to go with a program you distribute: shipping that file with it does. zlib's, liblzma's and bzip2's ask nothing of a binary.

## 10. Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| `TKO0698: this argument does not convert` on `zipOpen64` or `unzOpen64` | their path is `const void *`: pass `@"name.zip"` or `strptr( path )` |
| `uncompress` returns `Z_BUF_ERROR` (-5) | the output room is smaller than the original: store the original length with the data |
| `inflate` returns `Z_DATA_ERROR` (-3) on a `.gz` | it was set up for a zlib stream: `inflateInit2( @z, 16 + 15 )` for gzip, `32 + 15` for either |
| a damaged zstd or LZ4 input decodes "successfully" to wrong data | no checksum: section 6 |
| `lzma_code` returns `LZMA_BUF_ERROR` (10) | the input ended before the stream did: a truncated file |
| a name outside the ANSI code page cannot be opened by `zipOpen64` / `unzOpen64` (Windows) | they go through the C runtime's `fopen`: open with `fill_win32_filefunc64W` |
| the program exits at once with `-1073741515` (Windows) | `compression.dll` is not beside the program |
| `TKO0813: 'run' is already declared` | a tiko built-in; name the function something else |

---

**Next:** [Vendor Packages](Vendor-Packages) · [Using C Libraries](Using-C-Libraries-Tutorial) · [SQLite](SQLite-Tutorial)

[Home](Home)
