[Home](Home) › [All Categories](Categories) › **UUID**

# UUID

A **UUID** is a 128-bit identifier that can be made anywhere, without asking a central counter, and still be unique — a database key, a request id, a file name. The `std/uuids` module makes, parses and compares them.

```freebasic
#import "std/uuids"

dim id as uuids.Uuid = uuids.NewV7( )
print id.Version( )                    ' 7
print len( id.ToString( ) )            ' 36

var r = uuids.Parse( "{F81D4FAE-7DEC-11D0-A765-00A0C91E6BF6}" )
if r.IsOk( ) then print r.Value( ).ToString( )   ' f81d4fae-7dec-11d0-a765-00a0c91e6bf6
```

## Which Kind To Make

| | `NewV4( )` | `NewV7( )` |
|---|---|---|
| Contents | 122 random bits from the operating system's secure generator | the time in milliseconds, then random bits |
| Sorts by | nothing | creation time |
| As a database key | inserts land all over the index | inserts land at the end, and the index stays compact |
| Reveals | nothing | when it was made (`UnixMillis( )`) |

Within one program, every `NewV7( )` is strictly greater than the one before, even when many are made in the same millisecond.

## Parsing And Printing

`Parse` accepts the usual 8-4-4-4-12 form, the same in braces `{…}`, with a `urn:uuid:` prefix, or as 32 hex digits with no hyphens — in either case. `ToString( )` always writes the 8-4-4-4-12 form in lower case. Every UUID version parses, not only the two this module makes.

A failure is a `UuidError` with a `Code( )` — `UUID_INVALID_LENGTH`, `UUID_INVALID_CHAR` or `UUID_INVALID_FORMAT` — and the 1-based `Position( )` of the offending character.

## As A Key

`Uuid` extends `containers.Hashable` and has `=`, `<>` and `<`, so it can be a [Map](Category-Map) or [Set](Category-Set) key, an [OrderedMap](Category-OrderedMap) key, or sorted:

```freebasic
#import "std/uuids"
#import "std/containers"

dim owners as containers.Map( of uuids.Uuid, ustring )
dim a as uuids.Uuid = uuids.NewV4( )
owners[ a ] = "ada"
print owners[ a ]                      ' ada
```

`<` compares the 16 bytes in order, which for version 7 is the order they were made.

## Members

```freebasic
ToString( ) as ustring                  8-4-4-4-12, lower case
ToBytes( ) as Array( of ubyte )         the 16 bytes
Version( ) as long                      4 or 7 for the ones made here; 0 for the nil UUID
Variant( ) as long                      1 for every standard UUID
IsNil( ) as boolean                     all 16 bytes zero
UnixMillis( ) as longint                version 7: when it was made; -1 otherwise
HashOf( ) as ulongint

NewV4( ) as Uuid
NewV7( ) as Uuid
Parse( byref s as const ustring ) as Result( of Uuid, UuidError )
FromBytes( byref a as Array( of ubyte ) ) as Result( of Uuid, UuidError )
NilUuid( ) as Uuid                      00000000-0000-0000-0000-000000000000
MaxUuid( ) as Uuid                      ffffffff-ffff-ffff-ffff-ffffffffffff
```

## See Also

[Codec](Category-Codec) · [Map](Category-Map) · [Math Library](Category-Math-Library)
