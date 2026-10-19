[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **TextWriter.WriteLine**

# TextWriter.WriteLine

Writes a string followed by the writer's NewLine.

## Syntax

```freebasic
TextWriter.WriteLine( [ s ] )
```

## Notes

- s, then NewLine.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m
dim as TextWriter tw = TextWriter( m )
tw.NewLine = "|"
tw.WriteLine( "a" )
tw.WriteLine( )
print m.ToUtf8Text( )    '' a||
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
