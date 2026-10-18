# Operator overloading

A type that behaves like a number reads best when it is written like one:
`half + third` rather than `half.Plus( third )`. An *operator overload* is a
procedure the compiler calls when it sees an operator applied to your type.

```tiko
{{#include ../../examples/objects/operators.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/operators.out}}
```

An operator is defined like a function whose name is the operator:
`operator + ( byref a as Fraction, byref b as Fraction ) as Fraction`. From
then on, `a + b` on two fractions is a call to it.

Where an operator is declared depends on what it acts on:

| Operators | Declared | Why |
|---|---|---|
| `+ - * /`, `=`, `<>`, `<`, unary `-`, ... | outside the type | neither operand is privileged |
| `let`, `+=` and the other compound assignments, `cast` | inside the type | they change, or convert from, this object |
| `[]` | inside the type | see [Indexing](indexing.md) |

Declaring a binary operator inside the type is refused with
`TKO0790: operator '+' cannot be a member of a type`.

A few things in the example are deliberate:

- **Each comparison is its own operator.** Defining `=` does not define
  `<>`, so `<>` is written as `not ( a = b )` to keep the two in agreement.
- **Precedence does not change.** `half + third * half` multiplies first,
  because the expression is parsed before any operator procedure is chosen.
- **`operator let( byval whole as int64 )`** makes `total = 3` work: it is
  assignment *from another type*. Assignment from another `Fraction` is the
  ordinary copy, covered in [Copying](copying.md).
- **`operator cast( ) as ustring`** is what lets `print` show a fraction, as
  on the [Display](../hello/display.md) page.

A global operator sees only the type's public members, like any other code
outside the type. That keeps operators from breaking the type's rules.

```admonish warning title="Status in this version"
Inside a method, `this` cannot yet be an operand of an overloaded operator:
`this = this + o` is refused with `TKO0820: no operator '+' takes these
operand types`. Build the result from the fields, as `+=` does here, or copy
`this` into a local first.
```

### Activities

1. Add `operator -` for two fractions, and `operator >`.
2. Add `operator cast( ) as float64` and print `cast( float64, third )`.
