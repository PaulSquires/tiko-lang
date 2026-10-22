# Records at a position

A file of fixed-size records can be read and changed **by record number**,
without touching the records around the one you want. A
`RecordFile( of T )` is such a file, holding records of the type `T`.

```tiko
{{#include ../../examples/files/records.tiko}}
```

**Output**

```text
{{#include ../../examples/files/records.out}}
```

`Open( path )` opens the file for reading and writing, and creates it if it is
not there. Records are numbered **from 1**. `Append` adds a record after the
last one and returns its number; `PutRecord( n, s )` writes record `n` and
`GetRecord( n, s )` reads it. `Count( )` is the number of whole records, and
`for each` walks them in order, one `Result` per record.

Reading a record that is not all there, past the end or a short last record,
is not an error: the value is `false` and the record is left as it was.
Writing past the end grows the file, and the records in the gap read as zeros.

The record must hold only fixed-size fields: numbers, `zstring * n`, and types
made of those. A `ustring` is a pointer to its text, and a pointer written to a
file means nothing when it is read back. The bytes are the record's bytes in
memory, so add `field = 1` to the type for a layout with no padding.

Underneath, these are `ReadAt` and `WriteAt`, which read and write bytes at a
byte position in any `File` without moving its position. Use them directly for
a file that mixes records with other data, such as a header, and
`ReadRecord( of T )`, `WriteRecord( of T )` and `RecordCount( of T )` for
records in a `File` you opened yourself.

### Activities

1. Add a `bonus as int32` field to `Score`. Which numbers in the output change?
2. Write record 6 with `PutRecord`, then print `Count( )` and record 5.
