# Macros

A `#define` with parameters is a **macro**. Each use is replaced by the body,
with the *text* of each argument put in place of the parameter. That makes a
macro able to do things a procedure cannot: turn code into a string, build a
name, or expand to whole statements.

```tiko
{{#include ../../examples/preprocessor/macros.tiko}}
```

**Output**

```text
{{#include ../../examples/preprocessor/macros.out}}
```

- **`LARGER( a, b )`** and **`SQUARE( x )`** take arguments. The output shows
  what each use turned into: the arguments are pasted in as text, so
  `SQUARE( column1 + 1 )` evaluates `column1 + 1` twice.
- **`#expr`** turns an argument into a string literal. The argument is
  expanded first, which is why the first line shows `LARGER`'s body, not its
  name.
- **`column##n`** pastes two pieces into one token: `COLUMN( 2 )` becomes the
  identifier `column2`.
- **`#macro` … `#endmacro`** defines a macro over several lines, so it can
  expand to statements. `SWAP_VALUES` wraps its temporary in a `scope` block,
  so that two uses in one procedure do not both declare `tmp_`.

A macro cannot take the name of a keyword: `#define FIELD( n ) …` is refused
with `TKO0371`, "'field' cannot be defined as a macro: it is a reserved word".

````admonish danger title="Pitfall"
**A macro substitutes text, not values.** The parentheses in `SQUARE` are what
make it work:

```tiko
{{#include ../../examples/preprocessor/badsquare.tiko}}
```

```text
{{#include ../../examples/preprocessor/badsquare.out}}
```

`BAD_SQUARE( 1 + 2 )` becomes `1 + 2 * 1 + 2`, which is 5. Wrap every
parameter in parentheses, and the whole body too.
````

A procedure has none of these problems: its argument is evaluated once and has
a type. Write a procedure first, and a macro only when you need the source
text itself.

### Activities

1. Call `SQUARE` with a function that prints each time it runs, and count the
   calls.
2. Write `#macro REPEAT( n, body )` that runs `body` `n` times in a `for`
   loop, and use it to print three lines.
