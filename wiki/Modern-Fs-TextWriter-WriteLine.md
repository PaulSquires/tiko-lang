[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **TextWriter.WriteLine**

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
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
