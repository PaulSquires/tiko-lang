[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream**

# Stream

The byte-stream base type.

## Syntax

```freebasic
type Stream extends object
    CanRead( ) / CanWrite( ) / CanSeek( )        '' const virtual
    Read( buf, n ) / Write( buf, n )             '' FsResultI64
    Seek( offset [, origin ] )                   '' FsResultI64
    Flush( )                                     '' FsResultBool
    ReadExact / ReadToEnd / WriteAll / WriteBytes / WriteUtf8 / Position
protected:
    ReadCore / WriteCore / SeekCore / FlushCore  '' the virtual hooks
end type
```

## Notes

- Read, Write, Seek and Flush are not virtual. They check their arguments and call a protected virtual hook. A stream of your own extends Stream and overrides the hooks it supports, plus CanRead, CanWrite and CanSeek.
- Each hook returns true on success, or false with its byref FsError filled in. ReadCore and WriteCore are called only with n > 0 and a non-null buf; SeekCore only with a valid origin.
- The hooks Stream itself provides fail with FS_UNSUPPORTED, except FlushCore, which has nothing to flush and succeeds.
- The contract every stream keeps: Read may return fewer bytes than asked, and Ok( 0 ) for n > 0 means the end; Write may write fewer, but never 0; n < 0 or a null buf with n > 0 is FS_INVALID_ARGUMENT; Seek returns the new position and fails below 0 but not past the end; a failed call leaves the position unspecified.
- A stream is not thread-safe unless its own page says so.

## Examples

```freebasic
#import "std/fs"
using fs


'' A stream that yields the letters a to z, then ends
type Alphabet extends Stream
    as long nextLetter = 0
    declare const function CanRead( ) as boolean override
protected:
    declare function ReadCore( byval buf as ubyte ptr, byval n as longint, byref got as longint, byref failure as FsError ) as boolean override
end type

const function Alphabet.CanRead( ) as boolean
    return true
end function

function Alphabet.ReadCore( byval buf as ubyte ptr, byval n as longint, byref got as longint, byref failure as FsError ) as boolean
    got = 0
    while( ( got < n ) andalso ( this.nextLetter < 26 ) )
        buf[got] = asc( "a" ) + this.nextLetter
        got += 1
        this.nextLetter += 1
    wend
    return true
end function

dim as Alphabet a
dim as MemoryStream m
print Copy( a, m ).Value( )          '' 26
print m.ToUtf8Text( )                '' abcdefghijklmnopqrstuvwxyz
print a.Write( @"x", 1 ).Failure( ).Message( )    '' unsupported
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
