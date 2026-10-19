# UUIDs

A **UUID** is a 128-bit identifier that can be made anywhere, with no central
counter, and still be unique. `std/uuids` makes, parses and compares them.

```tiko
{{#include ../../examples/numbers/uuid.tiko}}
```

**Output**

```text
{{#include ../../examples/numbers/uuid.out}}
```

`uuids.NewV4( )` is 122 random bits from the operating system's secure
generator. `uuids.NewV7( )` starts with the time in milliseconds, so later ones
sort later — good for database keys — and within a program each one is
greater than the one before. The time inside a v7 is readable with
`UnixMillis( )`, so use v4 where creation time should stay private.

`uuids.Parse` accepts upper or lower case, with or without hyphens, in braces,
or after `urn:uuid:`; `ToString( )` always gives the lower-case hyphenated
form. A `Uuid` has `=`, `<` and a hash, so it can be a
[`Map`](../containers/map.md) key or be sorted.

### Activities

1. Print `uuids.NilUuid( ).ToString( )` and `uuids.MaxUuid( ).ToString( )`.
2. Keep a `containers.Map( of uuids.Uuid, ustring )` of names, and look one up
   by a `Uuid` you parsed from text.
