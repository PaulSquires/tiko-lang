# Streams

A `Stream` is something bytes can be read from, written to, or both. A `File`
is one and a `MemoryStream` is another, and whatever works with a stream works
with either.

```tiko
{{#include ../../examples/files/streams.tiko}}
```

**Output**

```text
{{#include ../../examples/files/streams.out}}
```

The `TextWriter` writes into memory here, and `fs.Copy( source, destination )`
moves the bytes into the file. `Copy` starts at the source's position, which is
the end after writing, so the example seeks back to 0 first. A `TextReader`
reads lines from any stream; `ReadLine` returns `false` when there are none
left.

| Type | Is |
|---|---|
| `File` | a file on disk; each `Read` and `Write` is one call to the system |
| `MemoryStream` | a growable buffer of bytes in memory |
| `BufferedReader`, `BufferedWriter` | a buffer over another stream |
| `TextReader`, `TextWriter` | lines of text over another stream |

A reader or writer keeps a pointer to the stream it was given, so declare the
stream first: it must outlive the wrapper.

## Your own stream

A type that extends `fs.Stream` and overrides some of its operations is a
stream too:

```tiko
{{#include ../../examples/files/ownstream.tiko}}
```

**Output**

```text
{{#include ../../examples/files/ownstream.out}}
```

`Read`, `Write`, `Seek` and `Flush` are virtual, and each returns a `Result`.
`LineCounter` overrides `Write`, and `CanWrite` to say so. Whatever it does not
override fails with `FS_UNSUPPORTED`, and `CanRead( )` is `false`. The
`TextWriter` neither knows nor cares what it is writing to.

### Activities

1. Wrap the `File` in a `BufferedWriter` and the `TextWriter` around that.
2. Make `LineCounter` also count the bytes, and print both.
