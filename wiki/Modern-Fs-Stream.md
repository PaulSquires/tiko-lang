[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream**

# Stream

Holds the base type of every byte stream, with read, write, seek and flush.

## Syntax

```freebasic
type Stream extends object
    CanRead( ) / CanWrite( ) / CanSeek( )        '' const virtual
    Read( buf, n ) / Write( buf, n )             '' virtual, FsResultI64
    Seek( offset [, origin ] )                   '' virtual, FsResultI64
    Flush( )                                     '' virtual, FsResultBool
    ReadExact / ReadToEnd / WriteAll / WriteBytes / WriteUtf8 / Position
end type
```

## Notes

- Read, Write, Seek and Flush are virtual. A stream of your own extends Stream and overrides the ones it supports, plus CanRead, CanWrite and CanSeek.
- The versions Stream itself provides fail with FS_UNSUPPORTED, except Flush, which has nothing to flush and succeeds.
- An override keeps the contract below itself, the argument rule included. ReadExact, ReadToEnd, WriteAll, WriteBytes and WriteUtf8 are built on Read and Write and check their own arguments.
- The contract every stream keeps: Read may return fewer bytes than asked, and Ok( 0 ) for n > 0 means the end; Write may write fewer, but never 0; n < 0 or a null buf with n > 0 is FS_INVALID_ARGUMENT; Seek returns the new position and fails below 0 but not past the end; a failed call leaves the position unspecified.
- A stream is not thread-safe unless its own page says so.

## Examples

```freebasic
#import "std/fs"
#import "std/outcome"
using fs, outcome


'' A stream that yields the letters a to z, then ends
type Alphabet extends Stream
    as long nextLetter = 0
    declare const function CanRead( ) as boolean override
    declare function Read( byval buf as ubyte ptr, byval n as longint ) as FsResultI64 override
end type

const function Alphabet.CanRead( ) as boolean
    return true
end function

function Alphabet.Read( byval buf as ubyte ptr, byval n as longint ) as FsResultI64
    if( ( n < 0 ) orelse ( ( buf = nullptr ) andalso ( n > 0 ) ) ) then
        return FsFail( of longint )( FS_INVALID_ARGUMENT, "Read", "" )
    end if
    dim as longint got = 0
    while( ( got < n ) andalso ( this.nextLetter < 26 ) )
        buf[got] = asc( "a" ) + this.nextLetter
        got += 1
        this.nextLetter += 1
    wend
    return Ok( of longint, FsError )( got )
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
