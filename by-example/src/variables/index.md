# Variable Bindings

A variable is a name for a value of one type. tiko has two ways to declare
one: `dim`, which states the type, and `var`, which takes the type from the
value it starts with.

```tiko
{{#include ../../examples/variables/bindings.tiko}}
```

**Output**

```text
{{#include ../../examples/variables/bindings.out}}
```

`dim` has two spellings. `dim as int32 columns = 80, rows = 25` puts the type
first and applies it to every name on the line. `dim title as ustring = ...`
puts a type after each name, so one line can declare variables of different
types.

`var` needs a value, because the value is where the type comes from: `count`
is an `integer`, from the literal 3, and `area` has the type of
`columns * rows`. Use `var` when the type is obvious from the line, and `dim`
when it is not. Text is declared with `dim ... as ustring`, as `greeting` is;
[Inference](../types/inference.md) explains why.

A variable keeps its type for its whole life. It can be given a new value of
that type at any time, but `count = "three"` is error
`TKO0702: a string and a number do not convert into each other`.

A declaration is a statement like any other, so it can go where the variable
is first needed, as `average` does.

### Activities

1. Declare three `float64` variables on one `dim` line and print their sum.
2. Write `var empty` with no value and read the compiler's message.
