# Paths

A path is a `ustring`, and the `Path` functions take it apart and build it
without touching the disk. They accept either separator, `/` or `\`, on
Windows; on Linux and macOS only `/` separates.

```tiko
{{#include ../../examples/files/paths.tiko}}
```

**Output**

```text
{{#include ../../examples/files/paths.out}}
```

| Function | Gives |
|---|---|
| `PathFileName( p )` | the last part |
| `PathParent( p )` | everything before the last part |
| `PathStem( p )` | the file name without its last extension |
| `PathExtension( p )` | the last extension, with its dot |
| `PathFilePrefix( p )` | the file name before its first dot |
| `PathChangeExtension( p, ext )` | `p` with a different extension |
| `PathAddExtension( p, ext )` | `p` with one more extension |
| `PathComponents( p )` | the parts, one at a time, for `for each` |
| `PathJoin( a, b, ... )` | the parts joined with the platform's separator |
| `PathNormalize( p )` | `.` and `..` resolved, separators made uniform |
| `PathEquals( a, b )` | the same path, by the platform's rules |

A name that starts with a dot, `.gitignore`, has no extension: the dot is part
of the name. `PathComponents` drops a `.` but keeps a `..`, because what `..`
means depends on links on the disk; `PathNormalize` removes both, without
looking.

`PathJoin` writes `\` on Windows and `/` on Linux and macOS, which is why the example
compares joined paths rather than printing them. `PathEquals` compares the way
the platform does: on Windows it ignores case and treats both separators alike.

```admonish danger title="Pitfall"
`PathJoin( "uploads", name )` with an absolute `name` throws `uploads` away,
and a `name` containing `..` climbs out of it. Before joining a name that came
from a user, check it with `PathIsLocal( name )`, which is `false` for both,
and for device names such as `NUL` on Windows.
```

### Activities

1. Print `fs.PathParent( "main.tiko" )`. What is the parent of a bare name?
2. Use `PathComponents` to count how many directories deep a path is.
