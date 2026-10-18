# Directories

```tiko
{{#include ../../examples/files/directories.tiko}}
```

**Output**

```text
{{#include ../../examples/files/directories.out}}
```

`CreateDirAll` creates every missing level of a path, and is not an error when
the directory is already there; `CreateDir` creates one level and fails with
`FS_ALREADY_EXISTS` if it exists.

`WalkDir( p, options )` walks a whole tree. Each element is a `Result`, because
a directory part-way down may not be readable; the walk reports it and carries
on. `Depth( )` counts from 0 for the root's own entries, and `Name( )` is the
last part of the path. The order is whatever the system gives unless
`SortByName` is set. `ReadDir( p )` lists one directory the same way.

`RemoveDirAll( p )` deletes a tree and returns how many objects it removed, the
directory itself included. A symbolic link inside the tree is removed as a
link; what it points at is not touched. A `p` that is itself a link is refused
with `FS_NOT_A_DIRECTORY`, and nothing is deleted.

| Call | Does |
|---|---|
| `CreateDir( p )`, `CreateDirAll( p )` | create one level, or every level |
| `ReadDir( p )` | the entries of one directory, for `for each` |
| `WalkDir( p [, options ] )` | every entry in the tree, for `for each` |
| `Glob( pattern, results )` | the paths that match `*`, `?` and `**` |
| `CopyDir( src, dst )` | a copy of the tree; returns the count |
| `RemoveDir( p )` | delete one empty directory |
| `RemoveDirAll( p )` | delete the tree; returns the count |

### Activities

1. Set `o.ContentsFirst = true` and see each directory listed after what is in
   it.
2. Set `o.MaxDepth = 1` to list only the entries directly inside `dir_`.
