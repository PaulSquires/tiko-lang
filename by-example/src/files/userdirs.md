# Where files live

A program should keep its settings, data and caches where the platform
expects them, not beside its executable or in the current directory.

```tiko
{{#include ../../examples/files/userdirs.tiko}}
```

**Output**

```text
{{#include ../../examples/files/userdirs.out}}
```

| Function | Windows | Linux | macOS |
|---|---|---|---|
| `HomeDir( )` | the user's profile folder | `$HOME`, else the user's account entry | `$HOME`, else the user's account entry |
| `ConfigDir( )` | `AppData\Roaming` | `$XDG_CONFIG_HOME`, else `~/.config` | `$XDG_CONFIG_HOME`, else `~/Library/Application Support` |
| `DataDir( )` | `AppData\Local` | `$XDG_DATA_HOME`, else `~/.local/share` | `$XDG_DATA_HOME`, else `~/Library/Application Support` |
| `CacheDir( )` | `AppData\Local` | `$XDG_CACHE_HOME`, else `~/.cache` | `$XDG_CACHE_HOME`, else `~/Library/Caches` |
| `StateDir( )` | `AppData\Local` | `$XDG_STATE_HOME`, else `~/.local/state` | `$XDG_STATE_HOME`, else `~/Library/Application Support` |

**Nothing is created and no program name is added.** Join your own program's
name and create the directory with `CreateDirAll` before writing there. None
of the answers ends with a separator. On Linux and macOS an `XDG_` variable
counts only when it holds an absolute path.

`ExecutablePath( )` is the full path of the running program, however it was
started, which `command( 0 )` is not. `PathParent` of it is the directory the
program is installed in. `ExpandHome` replaces a leading `~` with the home
directory and leaves every other path as it was.

The example prints properties of the paths, not the paths, because they differ
from one machine and user to the next.

### Activities

1. Build the path of `settings.ini` in `ConfigDir( )` under a name of your own,
   create its directory and write the file.
2. Print `fs.PathParent( fs.ExecutablePath( ).Value( ) )`.
