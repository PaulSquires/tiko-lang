# compression examples

The seven compression libraries of `vendor/compression` from tiko -- zlib (deflate, zlib, gzip),
minizip (.zip), zstd, xz (liblzma), brotli, lz4 and bzip2 -- through one import that comes with
the toolchain. Each example is one `.tiko` program, built on its own with `tiko <name>.tiko`.

| Folder | Shows |
| --- | --- |
| `01-gzip` | a file to `FILE.gz` and back with zlib's gz* file API -- `gzip FILE`, `gzip -d FILE.gz` |
| `02-zstd` | buffers through `ZSTD_compress` / `ZSTD_decompress` at five levels, with sizes and times -- `zstd [FILE]` |
| `03-zip` | a `.zip` written with minizip and listed back, every entry's CRC checked -- `zip ARCHIVE.zip FILE...`, `zip -l ARCHIVE.zip` |
| `04-xz` | a file to `FILE.xz` and back as a stream: liblzma's `lzma_stream` through 64 KB buffers -- `xz FILE`, `xz -d FILE.xz` |
| `05-codecs` | the tiko layer, `vendor/compression/codecs`: a file packed in any format and unpacked with the format read from the file -- `codecs pack FILE [FORMAT [LEVEL]]`, `codecs unpack FILE.EXT`, `codecs info FILE` |
| `selftest` | every codec round-tripped, one corrupt input each, and the files in `fixtures/` -- made by the reference tools -- decoded exactly. Exits 1 if anything is off |

`fixtures/` holds `sample.txt` and that text as `gzip`, `zstd`, `xz`, `bzip2` and Python's
`zipfile` wrote it (`fixtures/make-fixtures.sh`, run once in WSL), so the selftest checks the
formats rather than the library against itself. `brotli` and `lz4` fixtures are made when those
tools are installed (`sudo apt install brotli lz4`); until then the selftest names them as
skipped.

## The C APIs or the tiko layer

Examples 01 to 04 call the libraries' own C APIs, as their documentation has them. `05-codecs` uses
**`vendor/compression/codecs`** instead, the tiko layer over all seven: `codecs.CompressBytes` /
`DecompressBytes` on `Array( of ubyte )`, `CompressText` / `DecompressText` on `ustring`,
`CompressFile` / `DecompressFile`, and `CompressWriter` / `DecompressReader`, which are
`fs.Stream`s. The format is a `codecs.Codec` (`CODEC_GZIP`, `CODEC_ZSTD`, ...); `CODEC_DETECT`
reads it from the data (every format but brotli and raw deflate has a magic number). Errors are
`fs.FsError`s (`FS_INVALID_DATA`, `FS_UNEXPECTED_EOF`, `FS_TOO_LARGE`), and zstd and LZ4 frames get
their checksums, so damage is refused. `DecompressBytes` stops at 1 GiB unless given another limit.

## Things to know

- **Every API is the library's own**, called as its documentation shows: zlib.net's manual,
  `zstd.h`, liblzma's `lzma/*.h`, brotli's `encode.h`/`decode.h`, `lz4.h`/`lz4frame.h`,
  bzip2's manual. Nothing is wrapped.
- **Streams are yours.** `dim as z_stream z`, `dim as lzma_stream s`, `dim as bz_stream b`: a
  tiko `dim` is all zeros, which is what each library asks a new stream to be
  (`LZMA_STREAM_INIT`, zlib's `Z_NULL` fields). Then the init routine on its address, and its
  end routine when done.
- **zlib's init routines are macros in C**, and so here: `deflateInit`, `deflateInit2`,
  `inflateInit`, `inflateInit2` (in the package's residue) pass zlib's version and the size of
  `z_stream` for you.
- **`uLong` is C's `unsigned long`**: 32 bits on Windows, 64 on Linux. Declare zlib's lengths as
  `uLongf` / `uLong_` (c2t's name for it: `ulong` is a tiko keyword), never as a fixed width.
- **Sizes are unsigned** (`size_t` is `uinteger`): `for i = 0 to n - 1` with `n = 0` runs to the
  type's maximum.
- **Each library reports errors its own way**: zlib's `Z_*` and bzip2's `BZ_*` codes (negative),
  `ZSTD_isError( r )` with `ZSTD_getErrorName( r )`, liblzma's `lzma_ret`, brotli's
  `BrotliDecoderResult`, a negative LZ4 count or `LZ4F_isError`. A corrupt input is reported,
  never a crash. But **not every format notices damage**: a zstd frame carries a checksum only
  when asked (`ZSTD_CCtx_setParameter( cc, ZSTD_c_checksumFlag, 1 )`, then `ZSTD_compress2`), and
  a raw LZ4 block never does (an LZ4 frame does, with `contentChecksumFlag`). Without one, a
  damaged input can decode to different bytes and report success. zlib, gzip, xz and bzip2
  always check.
- **Paths on Windows**: gzopen, BZ2_bzopen and minizip open files through the C runtime, so a
  name must be in the ANSI code page. For Unicode paths with minizip, open with
  `fill_win32_filefunc64W` and `zipOpen2_64` / `unzOpen2_64`.

## Dynamic or static

The examples import the package with

```
#import "vendor/compression" link dynamic
```

which links the shared library and copies it beside the program -- `compression.dll` on Windows,
`compression_linux_x86_64.so` / `compression_linux_arm64.so` on Linux, `compression_macos_arm64.dylib`
on macOS (~2 MB: all seven libraries). On Android the package is always static. With `link static`
instead, only what a program calls is built into it: a program using zlib alone grows by about
46 KB. The selftest links statically.

**With `link dynamic` on Windows** the DLL has its own C runtime: never give it the program's
`FILE *` (`BZ2_bzReadOpen`, `BZ2_bzWriteOpen`) or a C file descriptor (`gzdopen`, `BZ2_bzdopen`).
The calls that take a path -- `gzopen`, `BZ2_bzopen`, `zipOpen64`, `unzOpen64` -- and every
buffer and stream routine are fine.

A program that ships either form carries the libraries' notices:
`pkg/vendor/compression/LICENSE` says which ask for it. These examples are public domain.
