[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **ExpandHome**

# ExpandHome

FsResultUStr -- p with a leading ~ replaced by the home directory

## Syntax

```freebasic
ExpandHome( p )
```

## Notes

- Expands "~" and a leading "~/" (and "~\" on Windows) only. Anything else -- "~bob/x", "a/~", an empty string -- comes back unchanged.
- Fails only when p starts with ~ and HomeDir( ) fails.

## Examples

```freebasic
#import "std/fs"
using fs

print cbool( ExpandHome( "~/notes.txt" ).ValueOr( "" ) = PathJoin( HomeDir( ).ValueOr( "" ), "notes.txt" ) )    '' true
print ExpandHome( "~bob/x" ).ValueOr( "" )      '' ~bob/x -- other users are not looked up
print ExpandHome( "a/~" ).ValueOr( "" )         '' a/~
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Directories
