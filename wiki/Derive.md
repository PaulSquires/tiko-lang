[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Derive**

# Derive

Has the compiler write a type's comparisons, hash and `ToText( )` from its fields.

## Syntax

```freebasic
type typename
    derive word [, word ...]
    field declarations ...
end type
```

## Parameters

- `word`: one of `equal`, `order`, `hash` and `text`, in any order, each at most once.

## Description

`derive` is a body line of a `type` or `class`, like [`Implements`](Implements). Each word gives the type members written from its fields, so they cannot fall out of step with the field list:

| Word | Gives |
| --- | --- |
| `equal` | `operator =` and `operator <>`. The base type (if any) is compared first, then each field in declaration order, stopping at the first difference. |
| `order` | `operator <`, `>`, `<=` and `>=`, in the same order as `equal`. The first field whose own `=` is false decides, and the operator asked for is applied to that field. When every field is equal, `<=` and `>=` are true and `<` and `>` are false. |
| `hash` | A hash for [`hashvalue( k )`](Hashvalue), so the type can be a key of a [Map](Category-Map) or an element of a [Set](Category-Set) without extending `containers.Hashable`. It covers exactly the fields `equal` compares, so equal values always hash equal. |
| `text` | A member `declare function ToText( ) as ustring` that returns `Name(field=value, ...)`. |

```freebasic
#import "std/containers"

type Cell
    derive equal, hash, text
    as int32 row, col
end type

dim as containers.Map( of Cell, ustring ) sheet
dim as Cell a = ( 2, 3 ), b = ( 2, 3 ), c = ( 3, 1 )
sheet[ a ] = "=SUM(A1:A9)"

print sheet.Contains( b )           '' another variable, equal by its fields
print a = b, a <> c
print a.ToText( )
print sheet[ b ]
```

```
true
true          true
Cell(row=2, col=3)
=SUM(A1:A9)
```

Without `derive`, the same key needs `extends containers.Hashable`, an override of `HashOf( )` and a hand-written `operator =`, kept in step with the fields by hand.

Every field takes part, private fields too. A field of a type of your own takes part through that type's own `=`, `<`, hash and `ToText( )`, whether derived or written by hand.

### The hash

`h` starts at 0, and each field, base first, does `h = containers.HashInt( h ) xor <the field's hash>`, where a field's hash is the one [`hashvalue`](Hashvalue) gives it. For two fields this is the hand-written `HashInt( HashOf( a ) ) xor HashOf( b )`, so a type that changes from a hand-written hash to `derive hash` keeps its values.

### The text

`ToText( )` is for debugging and test messages. It is not a serialization format, and nothing reads it back.

| Field | Text |
| --- | --- |
| integer | decimal |
| `boolean` | `true` or `false` |
| enum | the constant's name (see [`enumname`](Enumname)), or the decimal value when no constant has it |
| float | as `str( )` writes it |
| string of any kind | in double quotes, with each `"` doubled |
| pointer | `&h` and the address in hex; null is `&h0` |
| fixed-size array | `[a, b, c]`; a 2-D array nests by its first dimension, `[[1, 2], [3, 4]]` |
| dynamic array | `[a, b, c]`; empty is `[]` |
| a type of your own | its own `ToText( )` |
| base type | first, as a field named `base`: `Mixed(base=Base0(id=5), flag=true)` |

A generic instance is named with its arguments: `Box(of int32)(value=3)`.

`derive text` adds a member, not a conversion, so `print p` and `"" & p` are still errors; write `print p.ToText( )`. The error for `print p` carries a note saying so.

### Ordering with `derive order`

`containers.Sort` and the ordered containers ([OrderedMap](Category-OrderedMap), OrderedSet) take a type whose `<` is derived:

```freebasic
#import "std/containers"

type Version
    derive equal, order, text
    as int32 major, minor, patch
end type

dim as containers.Array( of Version ) vs
vs.Push( type<Version>( 1, 10, 0 ) )
vs.Push( type<Version>( 1, 2, 7 ) )
vs.Push( type<Version>( 0, 9, 9 ) )
containers.Sort( vs )
for i as integer = 0 to vs.Count( ) - 1
    print vs[ i ].ToText( )
next
print type<Version>( 1, 2, 7 ) < type<Version>( 1, 10, 0 )   '' minor decides: 2 < 10
print type<Version>( 2, 0, 0 ) <= type<Version>( 2, 0, 0 )
```

```
Version(major=0, minor=9, patch=9)
Version(major=1, minor=2, patch=7)
Version(major=1, minor=10, patch=0)
true
true
```

A float field orders as the language does, so `<=` over a NaN field is false.

## Rules

- `hash` and `order` need `equal` beside them (TKO1264, TKO1268).
- A hand-written operator beside the word that writes it is an error: `derive equal` with your own `operator =`, `derive order` with your own `operator <` (TKO1263). So is `derive text` beside a member named `ToText`, declared or inherited (TKO1269), and `derive hash` beside your own `HashOf( )` (TKO1265). Keep one of the two.
- Every field must have what the word needs. A field that has no `=` is TKO1261, no hash TKO1262, no order TKO1267, no text TKO1270, each naming the field and its type. A `boolean` has no order, so `derive order` refuses a boolean field. A `string * N` has no hash.
- A type with an anonymous union is refused (TKO1260): which member is live cannot be known.
- An unknown word is TKO1258, which lists the four.
- **In a generic**, the members are checked per instance, and only where they are used. `Box( of Opaque )` with `derive equal` compiles, and is an error only where two such boxes are compared, with a note naming the instance.
- The members are written in each unit that uses them, privately, so `derive` changes no module's interface: an importer writes its own copy from the type in the module's interface.

```freebasic
type Opaque
    as int32 x
end type

type Box( of T )
    derive equal
    as T value
end type

dim as Box( of Opaque ) a, b        '' compiles
print a = b                         '' error TKO1261: ... field 'value' is 'opaque', which has none
```

### Not yet supported

Each of these is refused with a diagnostic rather than compiled wrongly:

- `derive` in a partial type (TKO0992).
- A bitfield field (TKO0992).
- `p.ToText` without parentheses (TKO0992); write `p.ToText( )`.
- For `derive text`: a field whose type has only `operator cast( ) as string` and no `ToText( )`, and a dynamic array field of more than one dimension (TKO1270).

## Remarks

- `derive` is not a reserved word. It is recognised only at the start of a line in a type body, followed by a word, so a field named `derive` (`derive as int32`) keeps its meaning, and outside a type body `derive` is an ordinary name.
- An enum takes no `derive` line; use [`enumname`](Enumname), [`enumcount`](Enumcount) and [`enumvalue`](Enumvalue).
- `derive` is a tiko addition.

### See also

- [`hashvalue`](Hashvalue)
- [`Type...End Type`](Type-Udt)
- [`Operator`](Operator)
- [Map](Category-Map) · [Set](Category-Set) · [OrderedMap](Category-OrderedMap)
- [`enumname`](Enumname)

---

**Category:** [User Defined Types](Category-User-Defined-Types)
**Kind:** keyword
