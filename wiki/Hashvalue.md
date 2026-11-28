[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **HashValue**

# HashValue

Returns the hash Map and Set use for a key: any built-in, derive hash or Hashable type.

## Syntax

```freebasic
declare function hashvalue( byref k as any_type ) as ulongint
```

## Usage

```freebasic
result = hashvalue( k )
```

## Parameters

- `k`: the value to hash.

## Return Value

The hash of `k`, as a `ulongint`. Equal values give equal hashes; different values may share one.

## Description

`hashvalue` is the hash [Map](Category-Map) and [Set](Category-Set) use for their keys. It is built into the compiler, so it needs no `#import`, and it works inside a generic body for whatever type the body is instantiated with.

What it does depends on the type of `k`:

| Type of `k` | Hash |
| --- | --- |
| an integer type | the value itself, as an unsigned number of its own size: an `int8` of -1 hashes as `&hFF` |
| `boolean` | 1 for true, 0 for false |
| an enum | its value, as a 32-bit integer |
| `single`, `double` | from the value's bits; `-0.0` hashes like `0.0`, because they compare equal |
| `string` | its characters, **up to the first NUL** |
| `ustring` | all of its code units |
| `zstring ptr`, `wstring ptr`, `zstring * N`, `wstring * N` | the characters, up to the terminating NUL |
| any other pointer or procedure pointer | the address, mixed through `containers.HashInt` |
| a type with `derive equal, hash` | its fields, folded as [`Derive`](Derive) describes |
| a type with a `HashOf( ) as ulongint` member, such as one that extends `containers.Hashable` | a call to that member |

Anything else is an error (TKO1266), naming the type:

```freebasic
type Cell
    as int32 row, col
end type
dim as Cell c
print hashvalue( c )
```

```
error TKO1266: hashvalue( ) cannot hash 'cell': it is not a built-in type, has no 'derive hash' and no HashOf( ) method
```

The values are the ones `containers.HashOf` gives for the same value, and they are the same on every target, except that a `wstring` is 4 bytes on Linux and 2 on Windows.

A `string` stops at its first NUL, so `chr( 0 ) & "x"` hashes like `""`. That is a collision only: `=` still tells them apart, so a Map keeps both. A `ustring` hashes all of its code units.

## Examples

```freebasic
#import "std/containers"

type Point
    derive equal, hash
    as int32 x, y
end type

type Tag extends containers.Hashable
    as int32 id
    declare function HashOf( ) as ulongint override
end type
function Tag.HashOf( ) as ulongint
    return containers.HashInt( id )
end function

dim as string s = "abc"
dim as Point p = ( 2, 3 ), q = ( 2, 3 )
dim as Tag t
t.id = 7

print hex( hashvalue( 42 ) )                                  '' an integer hashes as its value
print hex( hashvalue( s ) )                                   '' a string by its characters
print cbool( hashvalue( s ) = hashvalue( "abc" ) )            '' ...so a literal finds it
print cbool( hashvalue( 0.0 ) = hashvalue( -0.0 ) )           '' equal floats, equal hashes
print cbool( hashvalue( p ) = hashvalue( q ) )                '' derive hash: from the fields
print cbool( hashvalue( t ) = t.HashOf( ) )                   '' a Hashable: its HashOf( )
print cbool( hashvalue( chr( 0 ) & "x" ) = hashvalue( "" ) )  '' a string stops at its first NUL
```

```
2A
E71FA2190541574B
true
true
true
true
true
```

## Remarks

- **A key type of your own** needs `derive equal, hash`, or extends `containers.Hashable` and overrides `HashOf( )` (with an `operator =` of its own). Either way, equal keys hash equal; with `derive` that holds by construction.
- **Not a reserved word.** A procedure, variable or other symbol of your own named `hashvalue` wins, and the built-in is then out of reach in that scope. A Map or Set instantiated where your own `hashvalue` is visible picks yours up too, and fails to compile inside `map.tiko` or `set.tiko`, so a program that uses them should not declare a global `hashvalue`. One inside a namespace of your own (`Mine.hashvalue`) does not interfere.
- `__TIKO_HASHVALUE__` is defined when the compiler has `hashvalue`; see [`__TIKO_COMPILER__`](Category-Tiko-Compiler-Define).
- `hashvalue` is a tiko addition.

### See also

- [`Derive`](Derive)
- [Map](Category-Map) · [Set](Category-Set)
- [Hash](Category-Hash) — hashes for checksums and passwords, which are a different job

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)
**Kind:** function
