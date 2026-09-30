# Arrays

An array is many values of one type under one name, reached by number. It is the oldest data
structure there is and still the one to reach for first: the elements sit next to each other in
memory, so walking an array is the fastest thing a processor does.

tiko's arrays carry their bounds with them — not a length, but a first and last index, which the
compiler and the runtime both know. That one decision explains most of what follows.

## Bounds, not length

```tiko
{{#include ../examples/ch07/bounds.tiko}}
```

```text
{{#include ../examples/ch07/bounds.out}}
```

`lbound( a )` and `ubound( a )` are the first and last valid index. Every loop over an array in
this book is written between them, and never between `0` and some remembered count.

```admonish danger title="Pitfall"
**`dim as int32 a( 10 )` declares eleven elements, not ten.** A single number is the *upper bound*,
and the lower bound defaults to 0 — so the valid indices are 0 through 10.

Anyone arriving from C, Java, Python or Rust will read that line as "ten elements" and write a
loop from 0 to 9, quietly ignoring the last one. The reverse mistake is worse: read it as "indices
0 to 9" in a language where the eleventh exists, and a bug hides in the element nobody looks at.

**Write both bounds.** `dim as int32 a( 0 to 9 )` says exactly what it means, in the same number of
keystrokes, and it cannot be misread.
```

Elements start at zero — or empty, for a string — so there is no such thing as an uninitialised
array element. An initialiser in braces fills them in order.

A lower bound other than 0 is worth using when the index means something. `band( 0 to 9 )` in the
histogram below is indexed by tens, and `temperature( 1900 to 2000 )` indexed by year needs no
arithmetic at the point of use, which is where arithmetic goes wrong.

## Arrays that change size

```tiko
{{#include ../examples/ch07/dynamic.tiko}}
```

```text
{{#include ../examples/ch07/dynamic.out}}
```

`dim as int32 a( )` declares an array with no room yet. Its `ubound` is **below** its `lbound`,
which is how an empty array reads — and why `for i = lbound( a ) to ubound( a )` over an empty
array runs zero times instead of needing a guard.

`redim` gives it a size. `redim preserve` gives it a size **and keeps what was there**, growing
with zeros and shrinking by truncation.

```admonish danger title="Pitfall"
**`redim` without `preserve` discards every element.** It is not a resize; it is a fresh array at
the same name.

That is easy to accept when you read it here and easy to miss in code, because nothing about
`redim a( 1 to 5 )` looks destructive, and the array is still there afterwards — just full of
zeros. The listing above shows `10 20 30` becoming `0 0 0 0 0`.

Reach for `redim preserve` by default, and use plain `redim` only when you mean to start over.
```

`erase` does two different things, and which one depends on the array:

```tiko
{{#include ../examples/ch07/erasefixed.tiko}}
```

```text
{{#include ../examples/ch07/erasefixed.out}}
```

On a **dynamic** array, `erase` frees the storage and leaves it empty. On a **fixed** array there
is nothing to free, so it resets the elements and the bounds stay. One keyword, two meanings,
neither surprising once you know which array you are holding.

## An array indexed by what it counts

```tiko
{{#include ../examples/ch07/histogram.tiko}}
```

```text
{{#include ../examples/ch07/histogram.out}}
```

This is the shape worth recognising: the index *is* the data. `band( score \ 10 )` needs no search
and no comparison chain — the value computes its own slot, and counting is one addition.

The bounds document the meaning. `band( 0 to 9 )` says there are ten bands of ten; the clamp says
what happens to a perfect score. Both are visible at the declaration rather than implied by a loop
somewhere below.

## More than one subscript

```tiko
{{#include ../examples/ch07/matrix.tiko}}
```

```text
{{#include ../examples/ch07/matrix.out}}
```

Dimensions are separated by commas, and `lbound`/`ubound` take the dimension number as a second
argument: `ubound( m, 2 )` is the last column index. An array may have up to eight dimensions.

The last line of that output is the one to keep. Reading the same storage as a flat run of `int32`
gives `0 1 2 3 4 5` — the order the elements were written, row by row. **The last subscript varies
fastest.** A row is contiguous; a column is strided.

That is not a detail of the implementation you are free to ignore, because it decides how fast the
loop runs. Iterating with the last subscript innermost walks memory forwards and every cache line
that is fetched gets used. Swapping the loops reads one element per cache line, and on a large
array that is the difference between fast and slow, with identical source.

## Passing an array to a procedure

```tiko
{{#include ../examples/ch07/params.tiko}}
```

```text
{{#include ../examples/ch07/params.out}}
```

A parameter is written `a( ) as int32` and the argument is written `a( )` — the empty parentheses
are required at both ends. An array is always passed by reference; there is no copy, and writes
inside the procedure are writes to the caller's array.

The bounds travel with it. `FillWith` was given an array indexed 5 to 8 and saw exactly that, which
is why a procedure that works from `lbound` and `ubound` works on any array of the right type
without being told anything else.

A multi-dimensional parameter states its **rank** with commas and nothing more: `m( , ) as int32`
takes any two-dimensional `int32` array. Rank is fixed at compile time; bounds are not.

```admonish warning title="Status in this version"
**An array of `ustring` cannot be a parameter** at the pinned compiler. `sub S( a( ) as ustring )`
is refused with `TKO0636: parameter 'a' cannot be a fixed-length string` — the wrong diagnostic for
a type that is not fixed-length. An array of `string` is accepted.

The same gap has a second face: `lbound( )` and `ubound( )` of a `ustring` array produce nothing
when used inside a larger expression, so `print "n="; ubound( names )` prints `n=` and then
discards the rest of the statement. Taking the value into an `int32` first works, and
`for i = lbound( names ) to ubound( names )` is correct — which is why every listing in this
chapter is written that way.

Tracked as **T23**. Until it lands, keep a `ustring` array in the scope that owns it, and move its
bounds through a variable.
```

## Walking it

```tiko
{{#include ../examples/ch07/walking.tiko}}
```

```text
{{#include ../examples/ch07/walking.out}}
```

Three ways across, and the difference between the last two matters:

- **By index**, `for i = lbound( a ) to ubound( a )`. You have the position as well as the value,
  which you need whenever the answer depends on where you are.
- **`for each v as T in a`** hands you a **copy** of each element. Writing to `v` changes nothing —
  the listing proves it.
- **`for each byref v as T in a`** hands you the element itself, so writes land in the array.

Use `for each` when you only need the values, and `byref` when you mean to modify them. The `byref`
form also avoids copying each element, which matters when the elements are large.

`for each` will not walk a grid:

```tiko
{{#include ../examples/ch07/foreach2d.tiko}}
```

```text
foreach2d.tiko(4,1): error TKO0608: 'for each' over a multi-dimensional array has no defined order
     |
   4 | for each v as int32 in m        '' refused: which way, rows or columns?
     | ^
```

The compiler could have picked row-major and said nothing. Refusing is the better answer: an
iteration order over a grid is a decision the code should state, not one to inherit silently from
the memory layout.

## When the index is wrong

An index outside the bounds reads or writes memory that belongs to something else. Chapter 1
introduced `-exx`, which adds a check to every array access and stops the program with runtime
error 6 rather than letting it continue with nonsense.

```admonish warning title="Status in this version"
**`-exx` does not check dynamic arrays.** A fixed array is checked, as Chapter 1's listing shows.
An array that has been through a `redim` is not: on a three-element dynamic array, reading `a( 9 )`
returns 0 and **writing `a( 9 ) = 42` succeeds**, corrupting whatever follows, and the program
exits normally.

fbc traps on the same program. This is tiko's own gap, tracked as **T21**, and it is the one to
watch for, because the arrays it misses are the ones whose size you cannot see in the source.
```

Until that lands — and afterwards, in any build without `-exx` — the check you write yourself is
the one you can rely on:

```tiko
{{#include ../examples/ch07/guard.tiko}}
```

```text
{{#include ../examples/ch07/guard.out}}
```

Comparing against `lbound` and `ubound` costs two comparisons and works on every array, of every
kind, in every build. Where an index comes from outside the program — a file, an argument, a
calculation you are not certain of — that guard is not optional.

```admonish danger title="Pitfall"
**Do not assign one array to another.** `a = b` compiles, with no diagnostic, and copies the
*source's* byte size into the destination regardless of how big the destination is. Measured: a
two-element `int32` array assigned from an eight-element one wrote 24 bytes past its end. `-exx`
does not catch it, and fbc refuses the statement outright.

To copy an array, loop. Tracked as **T22**.
```

## Text stored in an array

```tiko
{{#include ../examples/ch07/textarray.tiko}}
```

```text
{{#include ../examples/ch07/textarray.out}}
```

Growing an array one element at a time — `redim preserve` to `ubound + 1`, then write the new
slot — is the pattern for building a list whose length is not known in advance. It is correct, and
it is also the slow way to do it: each `redim preserve` may copy the whole array, so appending *n*
items can cost *n²* work.

For a handful of rows that does not matter. For a file of them it does, and the answer is either to
grow in chunks — double the size when it fills — or to use the container that already does exactly
that, which is the next section.

## The descriptor

```tiko
{{#include ../examples/ch07/descriptor.tiko}}
```

```text
{{#include ../examples/ch07/descriptor.out}}
```

An array variable is a **descriptor**: a pointer to the elements plus the bounds, the element size
and the number of dimensions. That is what travels when an array is passed, and what `lbound` reads.

`fbc-int/array.bi` exposes it. `FB.ArrayLen` is the total element count across all dimensions and
`FB.ArraySize` the total bytes; `FBC.ArrayDescriptorPtr` hands over the record itself. You will not
often need these, and when you do — writing a procedure that takes an array of any type, checking
what a `redim` actually allocated — nothing else will do.

## When to reach for something else

An array is the right answer when the index is meaningful and the size is known, or grows rarely.
It is the wrong answer when you find yourself writing the bookkeeping around it: a separate count
of how many slots are really in use, a doubling strategy, a search to find where something is.

That bookkeeping is what `FB.Array( of T )` already contains, along with `Map`, `Set` and the rest
of the containers in Chapter 23. The rule is the ordinary one: use the raw array while it is
simpler, and stop as soon as it is not.

## What it costs

- **Indexing is an address calculation**, not a search. Cost does not depend on which element.
- **`redim preserve` may copy everything.** Growing one at a time is quadratic; grow in chunks.
- **Row-major order is a performance fact**, not trivia — put the last subscript in the inner loop.
- **`-exx` costs a comparison per access.** It is worth it while you are writing the program;
  measure before you decide it is not worth it afterwards.
- **`for each byref` avoids copying each element**, which is free to write and matters for large
  ones.

## Summary

- An array carries **bounds**, not a length: `lbound` and `ubound` are the first and last index.
- **`a( 10 )` is eleven elements**, indexed 0 to 10. Write both bounds.
- Elements are zero-initialised; an initialiser in braces fills them in order.
- `dim a( )` is empty, with `ubound` below `lbound`, so loops over it run zero times.
- **`redim` discards the contents; `redim preserve` keeps them.** `erase` frees a dynamic array and
  zeroes a fixed one.
- Dimensions are comma-separated, `ubound( m, 2 )` names one, and **the last subscript varies
  fastest**.
- Arrays pass by reference as `a( )`, carrying their bounds; a rank-2 parameter is written `m( , )`.
- `for each` gives copies, `for each byref` gives the elements, and neither will walk a
  multi-dimensional array (`TKO0608`).
- **`-exx` does not check dynamic arrays at this version (T21)** — compare against `lbound` and
  `ubound` yourself when the index is not obviously safe.
- **Never write `a = b` between arrays (T22)**, and keep `ustring` arrays out of parameter lists
  (T23).
- The array variable is a descriptor; `fbc-int/array.bi` exposes `FB.ArrayLen`, `FB.ArraySize` and
  the record itself.
- **Stop using a raw array when you start writing bookkeeping around it** — a live count, a doubling
  strategy, a search. `FB.Array( of T )` and the containers in Chapter 23 already contain it, and
  growing one element at a time with `redim preserve` is quadratic.

## Exercises

1. Write `Reverse`, which reverses an array in place and works whatever its bounds — test it on
   arrays indexed from 1, from 0 and from −2, and on an empty one. Use no literal 0 and no literal
   length. {solution="ex07-01"}
2. Transpose a two-dimensional array into a second array whose dimensions are the original's,
   swapped. Where do the new bounds come from? {solution="ex07-02"}
3. Predict how many elements `dim as int32 a( 5 )` has before running anything, then print
   `lbound`, `ubound` and the count. Rewrite the declaration so the answer is obvious.
4. Take the `redim` line in `dynamic.tiko`, add `preserve`, and say in one sentence what each
   version is for.
5. Build a 200 × 200 array and sum it twice: once with the last subscript innermost, once with the
   loops swapped. Both give the same total. Which do you expect to be faster, and why?
