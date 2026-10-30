# Operator Overloading

Chapter 10 left a gap: two `Point`s could be copied but not compared, because the compiler would not
guess what equality meant. Chapter 12 gave types methods, so a vector could have an `Add` method —
and code that reads `a.Add( b.Scale( 2 ) )` where a mathematician would write `a + 2b`.

An **operator overload** is a procedure that the compiler calls when it sees an operator applied to
your type. It is ordinary code with an unusual name, and it costs exactly what the same code costs
as a method. What it buys is notation: a type that behaves like a number can be written like one.

The chapter ends with the other side of that — what not to overload — because notation that lies
about what it does is worse than a method name that tells the truth.

## A value type that reads like a number

```tiko
{{#include ../examples/ch13/vec2.tiko}}
```

```text
{{#include ../examples/ch13/vec2.out}}
```

An operator is defined like a function whose name is the operator: `operator + ( a, b ) as Vec2`.
From then on, `a + b` on two `Vec2`s is a call to it.

A few things in that listing are deliberate:

- **Scaling needs both orders.** `a * 2` and `2 * a` are two different operators — the left operand's
  type differs — so the second is defined in terms of the first. Leave one out and the other order
  does not compile.
- **Unary minus is its own operator**, with one parameter.
- **`=` and `<>` are separate.** Defining one does not define the other, and they must agree, so
  `<>` is written as `not ( a = b )`.
- **`abs` is overloadable**, and for a vector the natural meaning is the length.
- **Precedence does not change.** `a + b * 2` still multiplies first, because the compiler parses
  the expression before it decides which procedures to call.

`operator cast( ) as ustring` is what makes `print a + b` work: `print` takes the vector's conversion
to text. It is also what makes `"x" & v` work, an assignment to a `ustring`, and the string
functions — `ucase( v )`, `left( v, 2 )` — treat the vector as its text.

## Member or global

Some operators are declared inside the type and some outside it, and the compiler enforces which:

```tiko
{{#include ../examples/ch13/wrongplace.tiko}}
```

```text
wrongplace.tiko(5,13): error TKO0790: operator '+' cannot be a member of a type
     |
   5 |     declare operator +( byref o as Vec2 ) as Vec2   '' refused
     |             ^
```

The rule follows from what each operator acts on:

| Kind | Where | Why |
|---|---|---|
| `+ - * / \ mod ^`, comparisons, `and or xor`, unary `- not`, `abs` | global | neither operand is privileged; either side may be another type |
| `+=` and the other compound assignments | member | they change the object on the left |
| `let`, `cast` | member | they assign *into* or convert *from* this object |
| `[]`, `@` | member | they reach into this object |
| `->`, `*` (dereference) | global | they take the object as their operand |
| `for`, `step`, `next` | member | the loop's counter is the object |
| `new`, `delete`, `new[]`, `delete[]` | member | they allocate for this type |

`@` is the opposite case from `+`: as a global it is refused with
`TKO0697: operator '@' must be a member of a type`.

A global operator is not a method, so it sees only the public parts of the type. That is usually
right — an operator built from the type's public interface cannot break its invariants — and when
it is not, the operator can call a method that does the work.

## Conversions in both directions

```tiko
{{#include ../examples/ch13/fixedpoint.tiko}}
```

```text
{{#include ../examples/ch13/fixedpoint.out}}
```

`Fixed` stores an amount as a whole number of thousandths, so 0.1 + 0.2 is exactly 300 thousandths
and compares equal to 0.3. The `float64` line beside it compares unequal — although **`print` shows
it as 0.3**, because `print` rounds to fifteen significant digits. The difference is real and
invisible; that is the whole case for a fixed-point type.

Two conversions make it convenient:

- **`operator let( byval v as float64 )`** lets a `float64` be assigned to a `Fixed`. The rounding
  happens once, there, and nowhere else.
- **`operator cast( ) as float64`** lets a `Fixed` be used where a `float64` is wanted.
  `cast( float64, price * qty )` calls it explicitly; passing a `Fixed` to a procedure that takes a
  `float64` calls it implicitly.

A type may have several `cast` operators — `Fixed` has two — distinguished by the type they produce.

The built-in maths functions take it too. `sqr`, `abs`, `int` and the rest accept a type with a
numeric `cast`, convert, and work on the number:

```tiko
{{#include ../examples/ch13/castmath.tiko}}
```

```text
{{#include ../examples/ch13/castmath.out}}
```

A type with no numeric `cast` — and no `operator sqr` of its own — is refused: `TKO0928`.

```admonish danger title="Pitfall"
**A `cast` operator is an implicit conversion, like a one-parameter constructor.** Chapter 12's
warning applies in the other direction: once `Fixed` converts to `float64`, it converts wherever a
`float64` would be accepted, including places nobody intended.

Two conversions are worse than one. Give a type casts to both `float64` and `int64`, call a procedure
overloaded for both, and the call is genuinely ambiguous — there is no reason to prefer either — so
it is refused, `TKO0660`. Adding a second `cast` can therefore turn a line that compiled into one
that does not.

Give a type the conversions its users genuinely need, and prefer a named method — `ToFloat( )` —
for the rest.
```

## Reaching into an object

```tiko
{{#include ../examples/ch13/indexing.tiko}}
```

```text
{{#include ../examples/ch13/indexing.out}}
```

`operator []` returning **`byref`** is what lets `g[4]` appear on the left of an assignment: the
caller receives the element itself, not a copy of it. A `[]` that returns by value gives a read-only
index.

`operator let( byval fill as int32 )` is `let` from a different type: `g = 7` fills every cell.
`let` from the type's own type is the copy assignment Chapter 12 covered; `let` from anything else
is a conversion into the object.

`GridHandle` forwards `->` and `*` to the `Grid` it holds, which is the shape of every "smart"
handle — a type that behaves like a pointer while doing something extra, such as counting references,
which Chapter 21's `SharedPtr` does.

The middle of the listing is a warning about `@`. Because `Grid` overloads `@` to return its cells,
`@g` no longer means the address of `g` — and assigning it to a `Grid ptr` hands the handle the
cells instead of the grid. The compiler noticed:

```text
indexing.tiko(61,1): warning TKO0830: suspicious pointer assignment: a 'grid ptr' from a 'int32 ptr'
```

`varptr( g )` is never overloaded, and always means the address of `g`, which is why the listing uses
it for the real assignment.

## A type that counts

```tiko
{{#include ../examples/ch13/rangecounter.tiko}}
```

```text
{{#include ../examples/ch13/rangecounter.out}}
```

`for e as T = first to last step s` works for any type that implements the counting protocol:

| Operator | Called | Job |
|---|---|---|
| `for` | once, before the first pass | prepare; usually nothing |
| `next( last )` | before each pass | return non-zero to keep going |
| `step` | after each pass | advance |

Each comes in two forms, with and without the step value, matching whether the `for` has a `step`
clause. Nothing in the protocol assumes a direction or even a number — `next` decides when to stop —
so a counter can walk dates, a range of keys or a countdown, as Exercise 2 does.

For walking the *elements* of a container rather than counting, Chapter 20's `for each` and its
iterator protocol are the better tool.

## Taking over allocation

```tiko
{{#include ../examples/ch13/allocators.tiko}}
```

```text
{{#include ../examples/ch13/allocators.out}}
```

`operator new` and `operator delete` replace the allocation step for one type. They do not construct
or destroy — the constructor and destructor still run, before and after — they only decide where the
bytes come from and go back to. That makes them the place for a memory pool, an allocation counter
as here, or a check that every object was freed.

They are implicitly `static`: in `new` the object does not exist yet, and in `delete` it no longer
does, so there is no `this` — and neither `this` nor a bare field may be used in either
(`TKO0937`).

## What not to overload

An operator is a promise about meaning that the reader will hold you to without reading the code.
Break it and every expression using the type becomes a puzzle.

- **Keep the meaning.** `+` combines, `-` takes away, `=` is equality and nothing else. A `+` that
  appends to a log or a `*` that means "repeat" makes correct-looking code wrong.
- **Keep the algebra where it applies.** If `a + b` exists, `a - b`, `-a` and `a += b` should exist
  and agree with it. If `=` exists, `<>` must be its negation.
- **Keep the cost obvious.** `a + b` reads as cheap. If it allocates, copies a megabyte or touches a
  disk, give it a name that says so.
- **Do not overload `@`** unless the type genuinely is a handle to something else — the listing above
  shows what it does to every `@` in the program.
- **Do not overload `and`, `or` and `not` for logic.** The built-in `andalso` and `orelse`
  short-circuit; an overloaded `and` cannot, and a reader cannot tell which they are looking at.
- **When the operation has no single obvious meaning, use a method.** `Dot( a, b )` and
  `Cross( a, b )` are better than picking one of them to be `*`.

## What it costs

- **An operator is a procedure call** with the same cost as the method it replaces, and short ones
  are inlined. Notation is free.
- **Returning a type by value copies it.** For a small value type like `Vec2` that is the right
  design; for a type that owns memory, each `a + b` constructs a temporary and runs its copy
  constructor.
- **Conversions run silently.** An implicit `cast` or `let` in a loop is a call per iteration that
  nothing in the source shows.

## Summary

- `operator +` and its kind are procedures the compiler calls for your type. Precedence and
  associativity never change.
- **Binary and unary arithmetic, comparisons, `->` and `*` are global; compound assignment, `let`,
  `cast`, `[]`, `@`, the `for` protocol and `new`/`delete` are members** — the compiler enforces it
  (`TKO0790`, `TKO0697`).
- Define both orders of a mixed-type operator, and define `<>` alongside `=`.
- **`cast( ) as ustring` makes a type printable**, and usable with `&` and the string functions.
- `let` from another type and `cast` to another type are conversions in and out; the built-in maths
  functions use a numeric `cast`.
- `[]` returning `byref` gives an assignable index.
- **Overloading `@` changes the meaning of every `@`**; `varptr` is never overloaded.
- `for`, `step` and `next` make a type a `for` counter, in either direction.
- `operator new`/`delete` choose where memory comes from; construction and destruction still happen
  around them.
- **Overload only where the meaning is the obvious one**, and keep the algebra and the cost honest.

## Exercises

1. Write `Money`, stored in whole cents, with `+`, `-`, multiplication by a count, `<`, `=` and a
   `cast` to text like `$15.30`. Add a thousand ten-cent amounts and check the total is exactly
   $100. Why is there no `Money * Money`? {solution="ex13-01"}
2. Write a `Countdown` type that a `for` loop counts *down* with, printing `liftoff` at zero. What
   happens when the start is below the end? {solution="ex13-02"}
3. Add `operator *` to `Vec2` as a dot product, then try to add a second `*` for the cross product.
   What stops you, and what does that tell you about overloading `*` here at all?
4. Give `Fixed` an `operator /`. What should `1 / 3` give, and where exactly does the rounding
   happen?
5. Remove `operator <>` from `vec2.tiko` and keep the `a <> b` line. What does the compiler say, and
   would you rather it had derived `<>` from `=` for you?
