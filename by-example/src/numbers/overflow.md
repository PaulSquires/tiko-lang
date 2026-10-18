# Overflow and wrapping

Integer arithmetic **wraps** when a result does not fit its type: one past the
largest `int32` is the smallest, and nothing reports it. `std/numeric` lets a
program say what should happen instead.

```tiko
{{#include ../../examples/numbers/overflow.tiko}}
```

**Output**

```text
{{#include ../../examples/numbers/overflow.out}}
```

Unsigned types wrap at both ends: a `uint8` holding 255 plus one is 0, and 0
minus one is 255.

| Family | On overflow |
|---|---|
| `AddChecked`, `SubChecked`, `MulChecked`, `DivChecked`, `NegChecked`, `AbsChecked`, `IPowChecked` | return an empty `Optional` |
| `AddSaturating` and its siblings | stop at the end of the range |
| `AddWrapping` and its siblings | wrap, exactly as the operators do |

The wrapping family exists so that deliberate wrapping, in a hash or a
checksum, says it is deliberate. A checked result is an `Optional`:
`HasValue( )` says whether there is one and `Value( )` reads it; see
[Error Handling](../errors/index.md).

```admonish danger title="Pitfall"
**`^` on integers is not exact above 2^53.** It converts both sides to
`float64`, and a `float64` holds 53 bits of precision, so `3 ^ 38` comes back
rounded, by 89. Use `numeric.IPow` for integer powers.
```

These functions protect the calls you thought to protect; overflow elsewhere is
still silent.

### Activities

1. Use `MulChecked` to find the first factorial that does not fit in an
   `int32`.
2. Give two `uint8` variables the values 0 and 1, and compare
   `numeric.SubSaturating` of them with their difference stored in a `uint8`.
