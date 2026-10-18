# Opening a File

Each way of opening a `File` returns a `Result( of boolean, FsError )`, so an
open that fails says why.

```tiko
{{#include ../../examples/files/opening.tiko}}
```

**Output**

```text
{{#include ../../examples/files/opening.out}}
```

| Method | Opens for | An existing file is | A missing file |
|---|---|---|---|
| `OpenRead( p )` | reading | read | `FS_NOT_FOUND` |
| `Create( p )` | writing | emptied | created |
| `CreateNew( p )` | writing | refused, `FS_ALREADY_EXISTS` | created |
| `OpenAppend( p )` | writing at the end | kept | created |
| `Open( p, options )` | what the options say | as the options say | as the options say |

An `OpenOptions` names what the program needs: `Read`, `Write`, `Append`,
`Truncate`, `Create` and `CreateNew`. A combination that makes no sense, such
as `Append` with `Truncate`, is refused before anything is opened.

An operation the `File` was not opened for fails: writing to a `File` opened
with `OpenRead` returns a failure. `Close( )` closes the file and returns a
`Result` of its own; after it `IsOpen( )` is `false`, and the same `File` can
be opened again.

Other programs may read, write, rename and delete a file you have open. A
program you start does not get your open files unless `Inheritable` is set.

### Activities

1. Open the file twice with `CreateNew` in a loop and print each result.
2. Set `Append` and `Truncate` together and print the failure's `Message( )`.
