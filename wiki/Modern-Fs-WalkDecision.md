[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **WalkDecision**

# WalkDecision

What a walk filter answers for one entry.

## Syntax

```freebasic
enum WalkDecision
    WALK_SKIP    = 0    '' neither yield it nor walk into it
    WALK_YIELD   = 1    '' hand it to the caller
    WALK_DESCEND = 2    '' if it is a directory, walk into it
    WALK_ALL     = 3
    WALK_STOP    = 4    '' end the whole walk after this entry
end enum
```

## Notes

- Bit flags: WALK_YIELD or WALK_STOP yields the entry and then ends the walk.

## Examples

```freebasic
#import "std/fs"
using fs

print cbool( WALK_ALL = ( WALK_YIELD or WALK_DESCEND ) )    '' true
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Directories
