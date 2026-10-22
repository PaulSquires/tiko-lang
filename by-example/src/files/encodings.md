# Text encodings

Text in a file is bytes, and an **encoding** says which bytes stand for which
characters. std/fs reads and writes UTF-8 unless told otherwise. Give any text
call an encoding as its last argument to read or write UTF-16, a Windows code
page, or the raw bytes.

```tiko
{{#include ../../examples/files/encodings.tiko}}
```

**Output**

```text
{{#include ../../examples/files/encodings.out}}
```

An encoding is a `TextEncoding`, made by one of these:

| Call | Writes |
|---|---|
| `Utf8( )` | UTF-8, no BOM: the default. `Utf8( true )` adds the BOM `EF BB BF` |
| `Utf16LE( )`, `Utf16BE( )` | UTF-16 with a BOM (`FF FE` or `FE FF`); pass `false` for none |
| `CodePage( n )` | a Windows code page: `1252` is Western Europe, `1251` Cyrillic, `932` Japanese |
| `Ansi( )` | the code page Windows is set to on this machine; Windows only |
| `BinaryMode( )` | byte n is character n: any file reads, and writes back unchanged |

The same overloads exist on `ReadAllText`, `ReadAllLines`, `WriteAllText`,
`AppendAllText`, `WriteAtomic`, `ReadLines`, `TextReader` and `TextWriter`.

Reading **believes the encoding you give**: a BOM that matches it is skipped,
and anything else is text. Bytes that make no sense in it become U+FFFD, the
replacement character, as the UTF-8 read of `E9` shows above; pass
`TEXT_STRICT` to fail instead. When you do not know the encoding, the
`TextDetect` overload takes a BOM if there is one, else UTF-8 if the bytes are
valid UTF-8, else the fallback you name, and says in `found` which it used.

Writing is **strict by default**. A character the encoding has no byte for
fails with `FS_INVALID_DATA`, and the file is not touched. With
`TEXT_REPLACE` it becomes `?`, the write succeeds, and the result's value is
`false`: written, but not exactly.

A file that starts with a UTF-32 byte-order mark is refused by every read that
chooses the encoding itself, with `FS_UNSUPPORTED`, rather than misread as
UTF-16.

### Activities

1. Write `text` with `Utf16BE( )` and with `Utf8( true )`. Which bytes are the
   BOM in each?
2. Read the Windows-1252 file with `Utf16LE( )`. How many characters come back,
   and why?
3. Change the `TextDetect` fallback to `BinaryMode( )`. Which name is
   detected now?
