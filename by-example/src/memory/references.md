# References

A *reference* is a second name for a variable that already exists. Underneath
it is an address, like a pointer, but it is used like the variable it names:
no `*`, no `->`, and no way for it to be null.

```tiko
{{#include ../../examples/memory/references.tiko}}
```

**Output**

```text
{{#include ../../examples/memory/references.out}}
```

There are three places a reference appears:

- **A `byref` parameter.** `Double_( x )` hands the procedure `x` itself, so
  `n *= 2` changes `x`.
- **A `dim byref` variable.** `alias_` is bound to `b` when it is declared and
  stays bound to it; `alias_` and `b` have the same address. It must be bound
  where it is declared, so there is no null reference and no rebinding.
- **A `byref` result.** `Largest` returns the largest *element*, not a copy of
  its value, so the caller can assign through the result or bind a
  `dim byref` to it. `top += 100` changes `nums( 2 )`.

Prefer a reference whenever "nothing" is not a valid answer, and a pointer
when it is.

````admonish danger title="Pitfall"
**At the start of a statement, `F( x ) = value` is not an assignment.** It
reads as a call to `F` whose argument is the comparison `x = value`:

```tiko
{{#include ../../examples/memory/byrefpitfall.tiko}}
```

```text
{{#include ../../examples/memory/byrefpitfall.out}}
```

The first line changes nothing. The compiler warns,
`TKO0931: '=' is read as a comparison inside the argument of 'cell', not as an
assignment to its byref result; to assign, write '( cell( ... ) ) = value'`,
but the program still builds and runs. Wrap the call in parentheses, as the
second line does, to assign through a `byref` result.
````

```admonish warning title="Status in this version"
With an array argument, as in `Largest( nums() ) = 0`, the same statement
stops the build with an internal compiler error, `TKO0994`, after the
`TKO0931` warning. The parenthesised form works.
```

### Activities

1. Write `function Smallest( a() as int32 ) byref as int32` and use it to set
   the smallest element to 0.
2. Bind a `dim byref` to an element of an array, then `redim preserve` the
   array to 1000 elements. Why must you not use the reference afterwards?
