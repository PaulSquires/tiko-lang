[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **BitWidth**

# BitWidth

Returns how many bits the value needs, or 0 for zero.

## Syntax

```freebasic
BitWidth( byval x as T ) as int32
```

## Notes

- One more than the index of the highest set bit, so it is the width of the value rather than of the type.
- Zero needs **0** bits, which is the convention that makes `BitWidth` and `NextPow2` agree.
- It is the type's width minus `LeadingZeros`.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as uint32 x = 8
print BitWidth( x )          '' 4 -- 1000 needs four bits

dim as uint32 y = 7
print BitWidth( y )          '' 3 -- 111 needs three

dim as uint32 zero_ = 0
print BitWidth( zero_ )      '' 0 -- zero needs none
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
