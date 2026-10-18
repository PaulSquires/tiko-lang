# Reading and writing files

For a file small enough to hold in memory, one call reads or writes all of
it.

```tiko
{{#include ../../examples/files/readwrite.tiko}}
```

**Output**

```text
{{#include ../../examples/files/readwrite.out}}
```

| Function | Does |
|---|---|
| `WriteAllText( p, s )` | creates or replaces `p`, with `s` as UTF-8 |
| `AppendAllText( p, s )` | adds `s` to the end, creating `p` if needed |
| `ReadAllText( p )` | the whole file as one `ustring` |
| `ReadAllLines( p, lines )` | the lines, into an `Array( of ustring )`; returns the count |
| `ReadAllBytes( p, bytes )` | the bytes, into an `Array( of ubyte )` |
| `WriteAllBytes( p, bytes )` | creates or replaces `p` with exactly those bytes |
| `WriteAtomic( p, s )` | replaces `p` so that no reader sees half of it |

`ReadAllLines` removes each line's ending, whether it is a line feed or a
carriage return and line feed, and a final line feed does not make an empty
last line. Text is read as UTF-8 unless the file starts with a byte-order mark
that says otherwise.

`WriteAtomic` writes a temporary file beside `p` and then puts it in `p`'s
place. A program reading at the same moment sees the old contents or the new,
and a crash part-way through leaves the old file as it was. Use it to save a
configuration or a document.

### Activities

1. Read a file that is not there with `ReadAllLines` and print the failure's
   `Message( )`.
2. Write the text with a carriage return and line feed after each line and
   check that `ReadAllLines` gives the same two lines.
