# Slices and lifetime

A slice points into memory it does not own. If the string it came from goes
away, or moves its text somewhere else, the slice would read whatever is
there now. The compiler keeps track of where each slice came from and refuses
the programs where that could happen.

```tiko
{{#include ../../examples/strings/sliceviews.tiko}}
```

**Output**

```text
{{#include ../../examples/strings/sliceviews.out}}
```

**A function may return a slice of its caller's text.** `Before` takes `s`
`byref`, so the text belongs to the caller and is still there after the call.
With `byval s`, `s` is the call's own copy, and returning a slice of it is
error `TKO1059`.

**A slice lives in a local, a parameter or a result**, nowhere else. It
cannot be `shared` or `static`, an array element, a container element or
allocated with `new` (`TKO1054`), and it cannot be kept past the end of the
block, or the statement, its text belongs to (`TKO1057`, `TKO1058`).

**A type that holds a slice is declared `as view`**, and follows the same
rules: `Cursor` can be a local, a parameter or a result, and an ordinary type
cannot hold one (`TKO1055`).

While a slice is in use, the string it came from cannot change size:

```tiko
{{#include ../../examples/strings/slicelock.tiko}}
```

```text
slicelock.tiko(6,1): error TKO1062: 'name_' cannot be changed while slice 'initial' borrows from it (last used at line 7)
     |
   6 | name_ &= " Lovelace"
     | ^
```

Assigning, appending, `swap`, `input` and passing the string `byref` to
something that may change it all count, up to the last line that reads the
slice. Move the `print` above the `&=` and it compiles. Writing one unit,
`name_[0] = x`, or the `mid` statement never moves the text, and is allowed.

The compiler sees one procedure at a time. When another procedure changes
the string, `-exx` catches it when the slice is next read:

```tiko
{{#include ../../examples/strings/slicecheck.tiko}}
```

```text
{{#include ../../examples/strings/slicecheck.out}}
```

```admonish danger title="Pitfall"
Without `-exx` the same program reads freed memory and may well print `abc`,
because nothing has reused it yet. Build with `-exx` while you develop. A
slice of a `zstring ptr` has nothing to check against: the pointer is
trusted, as it is everywhere else.
```

### Activities

1. Change `Before` to take `byval s as ustring` and read the error.
2. Move `print initial` above the `&=` in `slicelock.tiko` and run it.
