[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CToString**

# CToString

The round-tripping text form.

## Syntax

```freebasic
CToString( byref z as Complex ) as string
```

## Notes

- Built on `ToString` from `mathtext.tiko`, so **the components round-trip**: what `TryParseDouble` gives back is bit-for-bit what went in. `STR` does not promise that and does not deliver it.
- **The sign is emitted separately from the magnitude so that a negative zero survives.** `"3-0i"` parses back to `-0.0`, where `"3+0i"` would not — and which zero an operand carries is what decides the side of a branch cut.
- The non-finite components come out as `"nan"`, `"inf"` and `"-inf"`, all of which `TryParseDouble` accepts again. A NaN is not equal to itself, though, so what survives that trip is the spelling and not the value.
- `CStr` is a keyword, which is why AfxNova's `CStr( z )` could not keep its name.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CSet( 3, 4 ) )          '' 3+4i
print CToString( CSet( 3, -4 ) )         '' 3-4i
print CToString( CSet( 3, -0.0 ) )       '' 3-0i   -- the negative zero survives
print CToString( CSet( 0.1 + 0.2, 0 ) )  '' 0.30000000000000004+0i   -- shortest round-trip, not STR
print str( 0.1 + 0.2 )                   '' 0.3   -- STR, for comparison
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
