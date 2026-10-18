# Jumps and subroutines

Older code moves around with labels: `goto` to a label, `on n goto` to the
`n`th of a list, and `gosub` to a subroutine that `return`s. tiko keeps the
first two and refuses the third.

`gosub` belongs to the older dialects:

```tiko
{{#include ../../examples/compat/gosub.bas}}
```

```text
gosub.bas(3,7): error TKO0409: 'GOSUB' is not available in the fb dialect
     |
   3 | gosub add_one
     |       ^
gosub.bas(4,7): error TKO0409: 'GOSUB' is not available in the fb dialect
     |
   4 | gosub add_one
     |       ^
```

A `gosub` subroutine has no parameters and no local variables: everything it
touches is shared with its caller. Rewritten as a `sub`, the variable it
changes becomes a `byref` parameter:

```tiko
{{#include ../../examples/compat/nogosub.tiko}}
```

**Output**

```text
{{#include ../../examples/compat/nogosub.out}}
```

`on … goto` still compiles:

```tiko
{{#include ../../examples/compat/menu.bas}}
```

**Output**

```text
{{#include ../../examples/compat/menu.out}}
```

A value of 0, or one past the end of the list, jumps nowhere, and execution
carries on with the next line. In modern code, `select case` says the same
thing with no labels and no `goto` at the end of every branch:

```tiko
{{#include ../../examples/compat/selectmenu.tiko}}
```

**Output**

```text
{{#include ../../examples/compat/selectmenu.out}}
```

Other older statements are refused the same way, each with `TKO0409` naming
the keyword: `resume`, `let` in front of an assignment, `call` in front of a
call, the `def` statements such as `defint`, and `option` statements. Numbered
lines are refused too; a label is a name followed by a colon on a line of its
own.

### Activities

1. Add a fourth option to both menus and compare how much each one changed.
2. Make `AddOne` take the amount to add as a second parameter.
