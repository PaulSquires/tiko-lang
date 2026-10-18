# File information

`Stat( p )` gathers everything about a file in one call: its kind, size,
times and flags.

```tiko
{{#include ../../examples/files/metadata.tiko}}
```

**Output**

```text
{{#include ../../examples/files/metadata.out}}
```

`Stat` returns a `Result` holding a `FileInfo`. `Size( )` is in bytes;
`IsFile( )`, `IsDirectory( )` and `IsSymlink( )` give the kind;
`IsReadOnly( )` and `IsHidden( )` the flags; and `Modified( )`, `Created( )`
and `Accessed( )` the times. A path that is not there is a failure with code
`FS_NOT_FOUND`, which is a different answer from `FS_ACCESS_DENIED`.

`Exists`, `IsFile` and `IsDir` answer yes or no and fold every failure into
`false`. They read well in an `if`, but they cannot tell "absent" from "not
allowed to look". Use `Stat` when the difference matters, and use it once
rather than asking `Exists` and then the size: the file can change between two
calls.

`Stat` follows a symbolic link to what it points at; `LStat` describes the link
itself.

### Activities

1. Make the file read-only with `fs.SetReadOnly( p, true )` and `Stat` it
   again.
2. `Stat` the scratch directory and print its `IsDirectory( )`.
