# Declare First

Every variable must be declared before it is used, but it does not need a
value at that point. A variable declared without one starts at zero, so a
program can declare it first and decide its value later.

```tiko
{{#include ../../examples/variables/declarefirst.tiko}}
```

**Output**

```text
{{#include ../../examples/variables/declarefirst.out}}
```

"Zero" depends on the type: 0 for numbers, `false` for a `boolean`, `""`
for a `ustring`. Records start with every field at zero, unless the field
declares a value of its own, and arrays start with every element at zero.
`verdict` shows the usual reason to declare first: the value depends on a
test, and each branch of the `if` assigns it.

A declaration runs each time the program reaches it. Inside a loop, `n` is
declared, and zeroed, on every pass, which is why `n += i` gives 1, 2 and 3
rather than a running total.

`= any` skips the zeroing, for the rare case where a large variable is about
to be overwritten anyway. The variable then holds whatever was in that
memory, so write it before you read it.

Using a name that was never declared is an error, which turns a typing
mistake into a message instead of a second, silent variable:

```tiko
{{#include ../../examples/variables/undeclared.tiko}}
```

```text
undeclared.tiko(3,1): error TKO0743: 'totl' is not declared
     |
   3 | totl = total + 1      '' a typo: there is no variable called totl
     | ^
```

The same error appears for a variable used on a line above its declaration.

### Activities

1. Declare a `dim as float64 readings( 1 to 5 )` and print the sum of its
   elements before assigning any of them.
2. Move `dim as int32 n` above the `for` loop and predict the output.
