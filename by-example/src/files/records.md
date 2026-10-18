# Records at a position

`ReadAt` and `WriteAt` read and write bytes at a position in the file, so a
file of fixed-size records can be read and changed by record number.

```tiko
{{#include ../../examples/files/records.tiko}}
```

**Output**

```text
{{#include ../../examples/files/records.out}}
```

`WriteAt( position, buffer, count )` writes `count` bytes at byte `position`;
`ReadAt` reads them. Record `n` starts `n * sizeof( Score )` bytes into the
file, so record 2 is read, changed and written back without touching the
others. `Size( )` is the length of the file in bytes.

Neither call moves the file's position, and several threads may use them on
one `File` at once. The record must hold only fixed-size fields: a `ustring` is
a pointer to its text, and a pointer written to a file means nothing when it is
read back.

### Activities

1. Add a `bonus as int32` field to `Score`. Which numbers in the output change?
2. Read record 10, past the end of the file, and print the count `ReadAt`
   returns.
