# Files

Files are the `std/fs` module. It opens and closes files, reads and writes
them whole or a line at a time, takes paths apart, walks directories and says
where a program should keep its own files. Every operation that can fail
returns a `Result`: a missing file is a value you look at, not a crash.

```tiko
{{#include ../../examples/files/overview.tiko}}
```

**Output**

```text
{{#include ../../examples/files/overview.out}}
```

`CreateTempDir` makes a directory under a fresh, unpredictable name, which the
examples in this section use so that they never touch anything else.
`PathJoin` builds a path with the platform's separator. `WriteAllText` and
`ReadAllText` write and read a whole file as text, and `Stat` gathers the facts
about a file in one call.

`ReadAllText` of a file that is not there returns a failure instead of a value.
`IsOk( )` says which you have, `Value( )` is the value, and `Failure( )` is an
`FsError` whose `Code( )` says what went wrong. `Value( )` on a failure is a
runtime error, so test first when failure is possible. `RemoveDirAll` deletes
a whole tree and returns how many objects it removed.

The pages in this section:

- [Paths](paths.md): taking paths apart and putting them together.
- [Reading and writing files](readwrite.md): a whole file in one call.
- [Line by line](lines.md): `File`, `TextWriter` and `ReadLines`.
- [Opening a File](opening.md): the ways to open, and what each refuses.
- [Records at a position](records.md): `ReadAt` and `WriteAt`.
- [Streams](streams.md): one interface for files, memory and your own types.
- [File information](metadata.md): `Stat` and the yes-or-no questions.
- [Directories](directories.md): creating, walking and removing trees.
- [Where files live](userdirs.md): the configuration, data and cache
  directories, and the program's own path.

### Activities

1. Write a second file into the scratch directory and check that the count
   `RemoveDirAll` prints goes up by one.
2. Print `missing.Failure( ).Message( )` to see the error as text.
