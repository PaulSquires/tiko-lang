# Tuples, Iterators and For Each

Two small problems turn up in almost every program. A function has two answers to give — a
minimum and a maximum, a quotient and a remainder — and a procedure returns one value. And a
loop over a collection needs an index it does not care about, with a lower bound and an upper
bound to get wrong.

This chapter solves both. A **tuple** is a value made of other values, with no type to declare
first: a function can return `(lo, hi)` and the caller can take it apart in one line. **`for
each`** walks arrays, strings and collections without an index, and the **iterator protocol** lets
your own types be walked the same way — including sequences that are computed as they are walked
and never stored.

## Returning more than one value

```tiko
{{#include ../examples/ch19/minmax.tiko}}
```

```text
{{#include ../examples/ch19/minmax.out}}
```

`MinMax` returns `(lo as int32, hi as int32)`, a **tuple type**: a parenthesised list of two or
more types, written wherever a type can go. `return (lo, hi)` builds a value of it. The caller has
two ways to receive it:

- **Destructure it.** `var (lo, hi) = MinMax( … )` declares two variables and gives each one
  element, in order.
- **Keep it whole.** `var r = MinMax( … )` holds the tuple, and its elements are reached by the
  names the function's declaration gave them, `r.lo` and `r.hi`, or by position, `r._1` and
  `r._2`. The positional names `_1` … `_N` always work, named or not.

A tuple has at least two elements. `(x)` is an expression in parentheses, as it always was, and
there is no one-element tuple to write.

## Tuple types

A tuple type can be written anywhere a type can: a variable, a parameter, a field, an array
element, a function result. Elements nest, `((int32, int32), ustring)`, and a typedef gives a
tuple type a name when it is used often: `type Point as (x as int32, y as int32)`.

Underneath, a tuple is an ordinary record with the same size, alignment and field offsets as the
equivalent `type`. A `ustring` element is constructed, copied and destroyed exactly as a
`ustring` field is.

### Identity is structural

Two tuple types are **the same type** when they have the same element types in the same order.
What the elements are called, and whether the type was spelled through a typedef, does not enter:

```tiko
{{#include ../examples/ch19/tupleidentity.tiko}}
```

```text
{{#include ../examples/ch19/tupleidentity.out}}
```

`Point`, `(lo as int32, hi as int32)` and `(int32, int32)` are one type, so each assigns to the
others without a conversion. Each variable is read with the names of its own declaration: `span`
has `lo` and `hi`, `plain` only `_1` and `_2`. `=` and `<>` compare element by element and give
−1 or 0, as any comparison does. `sizeof` takes a tuple type directly or through its typedef.

````admonish danger title="Pitfall"
**Element names are documentation for the reader, not a contract the compiler checks.**

```tiko
{{#include ../examples/ch19/swapnames.tiko}}
```

```text
{{#include ../examples/ch19/swapnames.out}}
```

`ScreenSize` returns `(w, h)`; `s` is declared `(h, w)`. Both are `(int32, int32)`, so the
assignment copies by position — the width into the element `s` calls `h` — and both lines print
the dimensions the wrong way round. Destructuring is positional in the same way: the names in
`var (h, w)` are new variables, not a request for the elements called `h` and `w`.

A tuple groups values *by position at a call boundary*. When the meaning of each element matters
— a width that must never be taken for a height — declare a `type` with named fields: two
different `type`s never convert into each other.
````

### Tuple values

A tuple literal is **built at the type it is assigned to**. Each element is converted as it is
stored, in the four places where the target type is known: a declaration, an assignment, a
`return` and an argument.

```tiko
{{#include ../examples/ch19/tuplevalues.tiko}}
```

```text
{{#include ../examples/ch19/tuplevalues.out}}
```

`(21, "north")` becomes a `float64` and a `ustring`; `return (0, 0)` builds two `float64`s. The
assigning form `(a, b) = …` takes any list of places — variables, fields, array elements — and
**reads the right-hand side completely before writing anything**, which is why `(a, b) = (b, a)`
swaps rather than copying one value into both. The number of places must match the number of
elements exactly: `var (x, y, z) = (1, 2)` is `TKO0825: the tuple has 2 elements, and 3 are
written`.

### What tuples do not do

A literal adapts to its target, but **two tuple values of different types never convert**:

```tiko
{{#include ../examples/ch19/tuplemismatch.tiko}}
```

```
tuplemismatch.tiko(2,35): error TKO0738: no conversion between these two types
```

The rest of the limits, each one measured:

| Written | Result |
|---|---|
| `a = b` with `a` an `(int32, int32)` and `b` a `(float64, float64)` | `TKO0720: no operator = compares this type` |
| `a = (1, 2)` with `a` an `(int32, int32)` | `TKO0720` too: the literal's numbers are `integer`s, and a comparison has no target type to build it at |
| `a < b`, and `<=`, `>`, `>=` | `TKO0720`: tuples have equality, not order |
| `print a` | `TKO0871: a '(int32, int32)' has no printable form` |

The missing ordering is deliberate. "Compare the first elements, then the second" is only
sometimes what a program means, and a sort that silently used it the rest of the time would be
wrong without a word. Write the comparison you mean. To compare against fixed values, declare
them at the tuple's type first: `dim target as (int32, int32) = (1, 2)`.

## The shapes of for each

`for each` walks a collection without an index. The loop declares its own variable, which exists
only inside the loop body:

```tiko
{{#include ../examples/ch19/foreachshapes.tiko}}
```

```text
{{#include ../examples/ch19/foreachshapes.out}}
```

| Form | The loop variable is |
|---|---|
| `for each x in c` | a copy of each element, its type inferred |
| `for each x as E in c` | a copy converted to `E`, as `dim x as E = …` would |
| `for each byref x in c` | the element itself; writing to `x` writes to the collection |
| `for each byref x as E in c` | the same, with the type stated |

The loop ends with a plain `next`. Naming the variable after it is
`TKO0819: 'next' cannot name a FOR EACH variable`, because the variable is not a counter and does
not exist after the loop. `exit for` and `continue for` work as they do in any `for` loop.

An array is walked in index order from its lower bound, whatever that bound is. A
multi-dimensional array is refused with `TKO0608`: there is no order that would be right for
every program, so you choose one with ordinary `for` loops.

The collection expression is evaluated **once**, before the first pass. Over an array, `for each`
compiles to the same counted loop you would have written by hand.

### Strings

A `ustring` cannot be walked:

```tiko
{{#include ../examples/ch19/ustringwalk.tiko}}
```

```
ustringwalk.tiko(2,1): error TKO0688: 'for each' cannot walk a ustring; index it with 'for' and 'mid' instead
```

A `string` can — and that is the trap.

````admonish danger title="Pitfall"
**`for each` over a `string` yields bytes, not characters.**

```tiko
{{#include ../examples/ch19/stringbytes.tiko}}
```

```text
{{#include ../examples/ch19/stringbytes.out}}
```

The word has four letters and the loop runs five times: `é` is two bytes in UTF-8, 195 and 169.
Each `b` is a `ubyte`, so the loop is right for parsing bytes and wrong for anything a reader
would call a letter, and no diagnostic says so. For text, keep the `ustring` and index it with
`for` and `mid`, as the `TKO0688` message says.
````

Binding a string's bytes by reference is refused: `for each byref b in word` is `TKO0941: 'for each
byref' cannot walk a string: a character has no stable address`.

### Taking pairs apart

When a collection's elements are tuples, `for each` can destructure each one into names:

```tiko
{{#include ../examples/ch19/pairs.tiko}}
```

```text
{{#include ../examples/ch19/pairs.out}}
```

`Pairs( )` yields `(key, value)` tuples, and `for each (who, age)` declares one variable per
element. Iterating the map itself yields a pair record with named fields, `key` and `value`. An
`OrderedMap` walks its keys in sorted order; a plain `containers.Map` walks them in an order you
must not depend on.

The name list has its own rules:

| Written | Diagnostic |
|---|---|
| `for each (k, v) as int32 in …` | `TKO0410`: each name is typed by its own element, so there is no `as` |
| `for each byref (k, v) in …` | `TKO0411`: bind the whole element `byref` instead and reach through `_1`, `_2` |
| `for each (k) in …` | `TKO0412`: a name list needs at least two names |

The names are copies. Destructuring costs one copy of each element.

## The iterator protocol

`for each` walks your own types too, and there is nothing to inherit to make that happen. A type
is **iterable** when it has a `GetIterator( )` function, and what that returns is an **iterator**
when it has three members:

| Member | Job |
|---|---|
| `function GetIterator( ) as I` | on the collection: hand out a new iterator `I` |
| `function IsValid( ) as boolean` | on the iterator: is there a current element? |
| `function Value( ) as E` | the current element; `E` is the loop variable's type |
| `sub MoveNext( )` | advance to the next element |

```tiko
{{#include ../examples/ch19/countdown.tiko}}
```

```text
{{#include ../examples/ch19/countdown.out}}
```

The loop calls `GetIterator( )` once, then, for as long as `IsValid( )` is true, binds `Value( )`
to the loop variable, runs the body and calls `MoveNext( )`. Three rules make an iterator behave:

- **A new iterator is already on the first element**, or `IsValid( )` is false at once for an
  empty collection. There is no "before the first element" state and no initial `MoveNext( )`.
- **`IsValid( )` is a question, not an action.** Asking twice without a `MoveNext( )` between
  gives the same answer, and `Value( )` may be read more than once for the same element.
- **`Value( )` decides what `byref` can do.** Declared `byref as E`, it hands out the element
  itself and a `for each byref` loop can write to it. Declared by value, it hands out a copy.

The protocol is matched by name, at compile time. There is no interface and no virtual call: the
loop calls the three members directly, exactly as if you had written the calls yourself. An
iterator is an ordinary value returned by value — usually a pointer and a count — and if it holds
a resource, its destructor runs when the loop ends, by `exit for` or otherwise.

### Near misses

Matching by name has one cost: a misspelling does not produce a "you meant" message from a
type system — it produces a type that does not match. tiko says which member is missing:

```tiko
{{#include ../examples/ch19/nearmiss.tiko}}
```

```
nearmiss.tiko(23,1): error TKO0607: 'ticker' is not an iterator: it has no 'MoveNext( )'
```

A collection with no `GetIterator( )` at all gets `TKO0606: 'bag' cannot be walked by 'for each':
it has no GetIterator( )`. Both point at the loop, and both name the member to add.

`Ticker` is also its own iterator: its `GetIterator( )` returns a copy of itself. That is a
reasonable shape for a one-shot sequence. It is a poor one for a collection, because the
"collection" and its cursor are then the same object.

## Writing an iterable generic collection

With generics, the iterator is written once for every element type. A ring buffer keeps the newest
N values and forgets the oldest:

```tiko
{{#include ../examples/ch19/ring.tiko}}
```

```text
{{#include ../examples/ch19/ring.out}}
```

`Ring( of T )`'s `GetIterator( )` returns a `RingIterator( of T )` — an instance of a *different*
generic, which is the usual shape and the one the standard containers use. The iterator holds a
pointer to the storage, where to start, and how many elements are left; it knows nothing about
how they got there. Because `Value( )` is `byref as T`, the second loop multiplies the stored
numbers in place. And the empty ring needs no special case: its iterator starts with nothing
left, so the loop body never runs.

## Laziness

An iterator does not have to walk anything stored. `Value( )` can compute the element, and
`MoveNext( )` can compute the next one:

```tiko
{{#include ../examples/ch19/fibseq.tiko}}
```

```text
{{#include ../examples/ch19/fibseq.out}}
```

`Fibonacci` holds one number, its upper limit. Its iterator holds the two most recent terms, and
each `MoveNext( )` computes the next. Nothing is stored, so a sequence bounded only by the largest
`int64` costs the same to set up as one that stops at 100 — the second loop asks for 32 terms,
`exit for` ends it, and the rest are never computed. This is a **lazy sequence**: the work is done
when an element is asked for, and only for the elements that are.

### What invalidates a loop

A loop and the collection it walks share the collection's memory, and changing the collection's
*shape* during the loop breaks that sharing.

```tiko
{{#include ../examples/ch19/grow.tiko}}
```

```text
{{#include ../examples/ch19/grow.out}}
```

Over an array, `for each` reads the bounds **once**, before the first pass, exactly as the counted
loop it compiles to would. Growing the array inside the loop does not extend the walk: the fourth
element exists afterwards and is never visited. The same rule cuts the other way: shrink the
array inside its loop and the loop still runs to the bound it read, past the elements that are
left. And resizing moves the elements, so a `byref` loop variable bound before the resize refers
to where an element used to be.

The rule for collections is the same and stricter. **Changing a collection's structure — adding or
removing elements — while an iterator walks it invalidates the iterator**; the iterator may hold a
pointer into storage that has since moved. Changing an element's *value* through a `byref`
binding is fine; that is what `byref` is for. To add or remove while walking, collect the changes
in a second collection and apply them after the loop.

## What it costs

- **A tuple is a record.** Returning one costs what returning the equivalent `type` costs, and a
  tuple of two `int32`s is eight bytes. Destructuring copies each element once.
- **`for each` over an array is the counted loop**, with the same code at `-O2`.
- **An iterator costs three direct calls per element**, which the optimiser can inline: there is
  no virtual dispatch, because the protocol is matched at compile time.
- **A by-value `Value( )` copies each element.** For a `ustring` or a large record, that is an
  allocation or a copy per pass; a `byref` `Value( )` avoids it.
- **A lazy sequence stores nothing**, and recomputes everything each time it is walked.

## Summary

- A tuple type is `(T1, T2, …)`, at least two elements, written wherever a type can go. A literal
  `(a, b)` is built at its target's type.
- Elements are reached as `_1` … `_N`, or by the names in the declaration the value came from.
  `var (a, b) = …` declares; `(x, y) = …` assigns, reading the right-hand side first.
- **Identity is structural**: same element types, same order, same type. Names are not checked, so
  a tuple is the wrong tool where meaning must be enforced.
- Different tuple types never convert. Tuples have `=` and `<>`, no ordering, and no `print`.
- `for each x in c`, with `as E` and `byref`; `next` alone; `exit for` and `continue for` work.
  Arrays in index order; a multi-dimensional array is refused.
- **A `string` is walked as bytes**; a `ustring` cannot be walked.
- `for each (k, v)` destructures tuple elements, with no `as` and no `byref`.
- The iterator protocol: `GetIterator( )`, then `IsValid( )`, `Value( )`, `MoveNext( )`, matched by
  name. A new iterator is on the first element; a `byref` `Value( )` permits `byref` loops.
  `TKO0606` and `TKO0607` name the missing member.
- An iterator can compute its elements: a lazy sequence.
- Bounds are read once; changing a collection's structure invalidates its iterators.

## Exercises

1. Write `DivMod( a, b )` returning the quotient and remainder as one tuple, and use it both
   destructured and whole. {solution="ex19-01"}
2. Write a `Range` type holding `from`, `upTo` and `stepBy`, walkable by `for each` with a positive
   or negative step, and empty when the step points away from the limit. {solution="ex19-02"}
3. Give `Ring( of T )` a `Count( )` member and test the iterator on a ring that has wrapped round
   more than once. Which field of the iterator does the wrapping?
4. Change `fibseq.tiko`'s `Value( )` to `byref as int64` and write to the loop variable in a
   `byref` loop. What changes, and why is it a poor idea for a computed sequence?
5. Rewrite the `swapnames.tiko` example with a `type Size` holding `w` and `h`. Which line now
   refuses to compile, and what does it say?
