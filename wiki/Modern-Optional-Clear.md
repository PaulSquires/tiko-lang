[Home](Home) › [Optional](Category-Optional) › [Optional](Category-Optional) › **Clear**

# Clear

O(1)   becomes empty

## Syntax

```freebasic
Clear( )
```

## Notes

- O(1) — becomes empty

## Examples

```freebasic
#import "std/outcome"
using FB

dim o as Optional( of integer ) = Some( 42 )
print o.HasValue( )          '' true

o.Clear( )
print o.HasValue( )          '' false

'' The stored T still exists -- an Optional is a T plus a boolean, not a
'' tagged union, so T's default constructor has already run and the slot
'' is always a real default-constructed T
dim as integer dflt = 7
print o.ValueOr( dflt )      '' 7
```

---

**Library:** [Optional](Category-Optional)  
**Category:** [Optional](Category-Optional)  
**Documented under:** Members  
**Source:** `docs/optional/optional.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
