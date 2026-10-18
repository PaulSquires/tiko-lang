# From and Into

Your own types can take part in conversions too. A **constructor** that
takes another type says how to build your type *from* it, and an
**`operator cast`** says how to turn your type *into* another one. Once they
exist, the compiler calls them wherever the conversion is needed.

```tiko
{{#include ../../examples/conversion/castops.tiko}}
```

**Output**

```text
{{#include ../../examples/conversion/castops.out}}
```

`Celsius` has three ways in and two ways out:

| Declared | Runs when |
|---|---|
| `constructor( byval d as float64 )` | a `Celsius` is declared from a number: `dim as Celsius b = 37.5` |
| `constructor( byref f as Fahrenheit )` | a `Celsius` is declared from a `Fahrenheit` |
| `operator let( byref f as Fahrenheit )` | a `Fahrenheit` is assigned to an existing `Celsius` |
| `operator cast( ) as float64` | a `float64` is expected, or `cast( float64, ... )` asks |
| `operator cast( ) as ustring` | text is expected: `print`, `&`, a `ustring` variable |

The constructors only run when a value is being created. Assigning to a
variable that already exists is a different operation, and needs an
`operator let`; without it, `b = freezing` is error
`TKO0738: no conversion between these two types`.

`print` picks the `ustring` cast, which is why `a` prints as `100.0 C`.
`cast( float64, a )` asks for one particular cast by naming its type, which
keeps the reader from having to work out which of the two arithmetic will
use.

Constructors and operators are covered properly in
[Objects](../objects/index.md); [Display](../hello/display.md) uses the same
`ustring` cast to make a type printable.

### Activities

1. Add a constructor that builds a `Fahrenheit` from a `Celsius`, and convert
   `a` back.
2. Remove the `operator let` and read the error for `b = freezing`.
