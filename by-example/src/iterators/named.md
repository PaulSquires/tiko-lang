# Named elements

A tuple's elements can be given names where its type is written, and the names
then reach the elements of any value seen through that declaration. The
positional names `_1` to `_N` always work as well.

```tiko
{{#include ../../examples/iterators/named.tiko}}
```

**Output**

```text
{{#include ../../examples/iterators/named.out}}
```

`type Size as (w as int32, h as int32)` names a tuple type, so `s.w` and `s.h`
work on anything declared as a `Size`. A call's result takes the names from
the function's declaration, which is why `ScreenSize( ).h` compiles. Names
nest along with the tuples: `box.bottomRight.w`.

**The names are not part of the type.** `(int32, int32)`,
`(lo as int32, hi as int32)` and `Size` are one type, so they assign to each
other freely and compare with `=`. Each variable is read with the names of its
own declaration.

````admonish danger title="Pitfall"
Because names are not checked, a tuple will put a value into an element with
the wrong name without a word:

```tiko
{{#include ../../examples/iterators/wrongnames.tiko}}
```

```text
{{#include ../../examples/iterators/wrongnames.out}}
```

`ScreenSize` returns `(w, h)` and `s` is declared `(h, w)`. Both are
`(int32, int32)`, so the copy goes by position and the width lands in the
element `s` calls `h`. Destructuring is by position too: `var (h, w)` declares
two new variables and does not look elements up by name.

When the meaning of each element matters, declare a `type` with fields. Two
different `type`s never convert into each other.
````

### Activities

1. Rewrite `wrongnames.tiko` with `type Size` holding fields `w` and `h`.
   Which line now refuses to compile?
2. Print `s._2` for the `s` in `wrongnames.tiko`. Which number is it?
