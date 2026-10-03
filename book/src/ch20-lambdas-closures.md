# Lambdas and Closures

A sort needs to know which of two elements comes first. A callback needs to know what to do when
it is called. Both are a few lines of code that only make sense at one place in the program, and
until now each of them had to be a named procedure written somewhere else, with any state it
needed passed in by hand or left in a global.

A **lambda** is a procedure written where it is used, as an expression. One that uses only its
parameters is an ordinary procedure with an address. One that uses variables from around it —
**captures** them — becomes a **closure**: a small object that carries those variables, or
references to them, along with the code. This chapter covers both, the rule that every capture
states how it is held, and where the two kinds can and cannot go.

## Lambdas in expressions

```tiko
{{#include ../examples/ch20/lambdas.tiko}}
```

```text
{{#include ../examples/ch20/lambdas.out}}
```

A lambda is spelled like a procedure without a name: `function( parameters ) as Type … end
function`, or `sub( parameters ) … end sub` when there is nothing to return. It can appear wherever
an expression can:

- **assigned to a procedure-pointer variable** whose type it matches, like `twice`;
- **given to `var`**, which takes its type from it, like `square` and `greet`;
- **passed as an argument**, like the one `Apply` receives.

The body is ordinary statements. Because `:` separates statements, a short body fits on one line:
`function( byval x as int32 ) as int32 : return x * x : end function`. A lambda is called like any
procedure: `square( 7 )`.

## A lambda that captures nothing is a procedure pointer

A lambda that uses only its own parameters and locals is compiled to an ordinary procedure, and the
expression's value is that procedure's address. It is interchangeable with `@SomeProcedure` and
converts to any procedure-pointer type with the same signature — which is exactly what a C library
callback wants:

```tiko
{{#include ../examples/ch20/qsortcallback.tiko}}
```

```text
{{#include ../examples/ch20/qsortcallback.out}}
```

`qsort` takes the address of a comparison function that returns a negative number, zero or a
positive number. The lambda is that function, written at the one place it is needed. A calling
convention goes after the keyword, as on a declared procedure: `function cdecl( … )`. On both of
tiko's targets the C convention is the only one in use, so `cdecl` here states what the C
library expects rather than changing the code; write it anyway, because it is part of the contract
the callback signs.

## Capturing variables

A lambda that needs a variable from the code around it lists it in square brackets after the
keyword, and says **how** it holds it:

```tiko
{{#include ../examples/ch20/captures.tiko}}
```

```text
{{#include ../examples/ch20/captures.out}}
```

| Capture | The closure holds | Changes the lambda makes |
|---|---|---|
| `byref total` | the address of the caller's `total` | reach the caller's variable |
| `byval rate` | its own copy of `rate`, taken when the lambda is evaluated | stay in the copy |

The first `ForEach` adds every price into the caller's `total`. The second captures `rate` by value
and `taxed` by reference, and mixes the two freely. Its parameter `p` is `byref`, so `p += p *
rate` changes the array's elements themselves; that is the parameter's doing, not the capture's.

**There is no default mode.** A capture written without `byval` or `byref` is refused:

```tiko
{{#include ../examples/ch20/nomode.tiko}}
```

```
nomode.tiko(2,17): error TKO0413: every lambda capture needs an explicit 'byval' or 'byref'
```

The mode is not a detail to infer. `byref` means the closure holds an address, and an address is
only good while the variable exists; `byval` means the closure is self-contained. One word at the
capture puts that decision where the next reader will look for it. An empty list, `sub[ ]( … )`,
captures nothing and means exactly what `sub( … )` means.

````admonish danger title="Pitfall"
**A `byval` capture is a snapshot, taken when the lambda is evaluated — not when it is called.**

```tiko
{{#include ../examples/ch20/snapshot.tiko}}
```

```text
{{#include ../examples/ch20/snapshot.out}}
```

`bias` is 1000 by the time either lambda runs. `addBias` copied it when the `var` line ran, so it
still adds 10; `addBiasNow` holds the variable's address and sees 1000. Both are correct
programs, and only one of them is the program you meant. A lambda written early and called late —
a handler, a comparer kept for later — is where this bites. Capture `byref` when the lambda must
see the variable as it is at the call, and `byval` when it must not.

A `byval` capture of a container is a copy of the whole container, made when the lambda is
evaluated. A lambda that pushes onto it changes its copy, and the caller's container keeps its
old contents.
````

A capture must name a variable that exists. In `sub[ byref totl ]( … )`, where only `total`
exists, the capture itself is `TKO0743: 'totl' is not declared`, and a use of `total` in the body
is reported too, because the capture did not bring it in.

### A closure is not a procedure pointer

A lambda that captures something cannot become a procedure pointer: a pointer is an address and
nothing else, and a closure has state that the address has nowhere to keep.

```tiko
{{#include ../examples/ch20/notaptr.tiko}}
```

```
notaptr.tiko(3,5): error TKO0738: no conversion between these two types
```

A closure reaches a procedure through a **generic parameter** instead. `ForEach` and `SortBy` take
their callable as `byref f as F`, with `F` a type parameter, so they accept a closure and a plain
lambda alike — each call instantiates the procedure for the exact type it was given. Your own
procedures that take callbacks should do the same; `Repeat` below is one.

## Closures carry state

```tiko
{{#include ../examples/ch20/counter.tiko}}
```

```text
{{#include ../examples/ch20/counter.out}}
```

`click` and `ping` are two closures, each holding the address of its own counter, and each call
increments the counter it holds. `Repeat( of F )` calls whatever it is given, the number of times
it is told; it neither knows nor cares that `action` carries state.

A closure is an ordinary value. `var again = click` copies it — and copying a closure copies its
captures. `again` holds the same address `click` does, so calling `again` increments `clicks`.
A `byval` capture would have been copied instead, and the two closures would then count
separately.

### How long a closure lives

The closure object lives in the scope where the lambda was written, like any local variable, and
is destroyed with it. There is no heap allocation and nothing to free.

A `byref` capture holds the address of a variable in some frame, and is only valid while that
frame is running. tiko's closures are built so that the usual way of breaking that rule cannot be
written: a closure's type has no name, so no function can declare that it returns one. Closures
travel *down*, into the procedures they are passed to, which return before the frame that made the
closure does. They do not travel *up*, out of the frame whose variables they reference.

Two things remain your responsibility. A pointer to a closure, taken with `@`, carries no such
protection: it can be stored, and it is invalid once the closure's scope ends. And the same holds
for anything a closure is copied into that you keep beyond that scope.

## Comparers and predicates

The standard containers take callables wherever a decision belongs to the caller: `SortBy` and
`StableSortBy` take a **comparer**, `ForEach` takes an **action**, and an action that tests and
counts is a **predicate** in all but name:

```tiko
{{#include ../examples/ch20/sortpeople.tiko}}
```

```text
{{#include ../examples/ch20/sortpeople.out}}
```

A comparer answers one question — "does `a` come before `b`?" — with `true` or `false`, and the
sort does the rest. It must answer consistently: if `a` comes before `b`, then `b` must not come
before `a`, and nothing comes before itself. Returning `true` for equal elements breaks that, and
a sort given such a comparer may put elements in any order.

The second comparer captures `oldestFirst`, so the direction is decided by the code around it
rather than written into the lambda. That is the everyday use of a capture: a fixed piece of logic
with one setting supplied from outside.

## Lambdas inside generics

A lambda written inside a generic procedure is instantiated with it, so it can use the generic's
type parameter:

```tiko
{{#include ../examples/ch20/ingeneric.tiko}}
```

```text
{{#include ../examples/ch20/ingeneric.out}}
```

`SortDown`'s comparer captures nothing, so its parameters may be of type `T`. `CountAbove`'s lambda
captures a `T` — `limit` — and that is allowed too. What a **capturing** lambda cannot do is take a
parameter of type `T`:

```tiko
{{#include ../examples/ch20/genericlimit.tiko}}
```

```
genericlimit.tiko(3,25): error TKO0921: the capturing lambda's parameter 'x' cannot be of the generic's type parameter 't'
```

A capturing lambda is itself built as a generic, over the types of its captures, and its parameter
list cannot also refer to the enclosing generic's `T`. The workaround is the one `CountAbove`
uses: give the lambda's parameter a concrete type the elements convert to — `float64` for any
number — or call it from an ordinary loop over the collection.

## What it costs

- **A lambda that captures nothing costs what a named procedure costs**, and calling it through a
  pointer costs what any indirect call costs.
- **A closure is a small record** — one address per `byref` capture, one copy per `byval` capture —
  on the stack of the scope that wrote it. Making one allocates nothing.
- **A `byval` capture copies when the lambda is evaluated.** For a `ustring` or a container, that is
  an allocation and a copy every time the lambda expression runs; capture `byref` when the copy is
  not the point.
- **Each generic call site is instantiated for the closure's type.** Passing ten different closures
  to `Repeat` makes ten copies of `Repeat`, as passing ten different types to any generic does.
  That is also why the call is direct and can be inlined.

## Summary

- A lambda is `function( … ) as T … end function` or `sub( … ) … end sub`, written as an
  expression; `var` takes its type, and `:` fits a short body on one line.
- A lambda that captures nothing is a procedure and its address: it converts to a matching
  procedure-pointer type and serves as a C callback. A calling convention follows the keyword.
- `sub[ byref a, byval b ]( … )` captures. **Every capture says `byref` or `byval`** (`TKO0413`).
  `byref` holds the variable's address; `byval` copies it **when the lambda is evaluated**.
- A capturing lambda is not a procedure pointer (`TKO0738`). It reaches procedures through a
  generic `of F` parameter, as `ForEach` and `SortBy` take it.
- A closure is a value; copying it copies its captures. It lives in the scope that wrote it, and
  because its type has no name, no function can return one.
- A comparer answers "does `a` come before `b`?" consistently; capture its settings.
- Inside a generic, a capturing lambda may capture a `T` but not take one as a parameter
  (`TKO0921`).

## Exercises

1. Count the words in a `containers.Array( of ustring )` that are at least `minLen` letters long,
   with `ForEach` and one closure. Which capture is `byref`, which `byval`, and why?
   {solution="ex20-01"}
2. Sort names by length, and names of equal length alphabetically, with one comparer.
   {solution="ex20-02"}
3. Change `snapshot.tiko` so that both lambdas print 1005 without changing their capture modes.
   What did you have to move?
4. Write `Times( of F )( byval n as int32, byref f as F )` that calls `f( i )` with the counter, and
   use it with a closure that sums the squares of 1 to 10.
5. Give `sortpeople.tiko` a comparer that returns `true` for equal ages too. Run it a few times
   with more people of the same age. What does the order of equal elements depend on now?
