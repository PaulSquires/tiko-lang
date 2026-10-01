# Procedures

A procedure is the unit you give a name to, and naming a piece of work is most of what programming
is. tiko's are ordinary — until you look at how arguments get in and results get out, where three
things behave differently from what the syntax suggests.

Start with the reason parameters exist at all. A procedure cannot see the variables around it:

```tiko
{{#include ../examples/ch06/sealed.tiko}}
```

```text
sealed.tiko(5,11): error TKO0743: 'counter' is not declared
     |
   5 |     print counter        '' error: procedures start with an empty slate
     |           ^
```

A module-level variable is visible to the module's own statements and to nothing else. Adding
`shared` to the declaration would open it up to every procedure in the file, which is the reason
this book almost never does: a procedure whose inputs all arrive as parameters can be read on its
own, and tested on its own.

## Subs, functions, and three ways to answer

```tiko
{{#include ../examples/ch06/basics.tiko}}
```

```text
{{#include ../examples/ch06/basics.out}}
```

A `sub` does something. A `function` answers something, and has three spellings for handing that
answer back:

- **`return value`** — sets the result and leaves immediately.
- **`function = value`** — sets the result and carries on. Useful when the answer is refined
  further down.
- **`Name = value`**, the function's own name — the oldest form, and the one most likely to be
  misread as a recursive call.

They compile to the same thing. This book uses `return`, and `function =` only where the procedure
really does keep working after the answer is settled.

A function may also be called and its answer discarded, as `Noisy( )` is above — nothing forces you
to use it.

The answer is usually a single value, but it can be a whole array: write `( )` after the result type,
as in `function Squares( ... ) as int32( )`. Chapter 7 covers what such a function may return and who
owns the result.

```admonish note
A function that reaches `end function` without ever setting its result returns a zero-initialised
value, silently. There is no warning. If a branch can fall off the end, put an explicit `return`
there and say what the answer should be.
```

## declare, for a name the compiler has not read yet

The compiler reads a file once, top to bottom, and a name has to exist before it is used. Two
procedures that call each other cannot both be written first:

```tiko
{{#include ../examples/ch06/forward.tiko}}
```

```text
{{#include ../examples/ch06/forward.out}}
```

`declare` states the signature and nothing else. Once it has been seen, the name can be called
anywhere below, and the body can arrive whenever it likes. Without the `declare`, the call is
`TKO0743: '…' is not declared` — the same error a typo gets, because to the compiler it is the same
mistake.

```admonish note
When you name a procedure you are competing with the names the compiler predeclares.
`function Double( )` does not compile — `double` is one of the classic type names — and it fails
with `TKO0600: 'double' is already declared in this scope` rather than with anything about types.
Appendix A lists the names that collide.
```

## How arguments get in

This is the part to read twice. tiko lets you write a parameter with no `byval` or `byref`, and
**what that means depends on the parameter's type**:

```tiko
{{#include ../examples/ch06/passing.tiko}}
```

```text
{{#include ../examples/ch06/passing.out}}
```

With no keyword, an `int32` was **copied** — the caller still holds 1. A `ustring` was **shared** —
the caller's text changed under it. Both procedures are written identically.

The rule the compiler applies:

| Parameter type | Default |
|---|---|
| Numbers, `boolean`, pointers, enums | `byval` — a copy |
| `string`, `ustring` | `byref` — the caller's own variable |
| Types you define | `byref` — the caller's own variable |

```admonish danger title="Pitfall"
**An omitted keyword means two different things.** The same spelling copies a number and aliases a
string, so a procedure that tidies up its own parameter is harmless with an `int32` and quietly
corrupts the caller's data with a `ustring`.

It is the direction of the surprise that makes it expensive. Nobody writes
`sub Fix( n as int32 )` expecting to change the caller's number. Plenty of people write
`sub Fix( s as ustring )` and use `s` as scratch space — and the damage then appears somewhere
else entirely, in a variable they were not thinking about.

**Write `byval` or `byref` on every parameter.** Every listing in this book does. It costs six
characters and it removes the question.
```

`byref` is not a wart to be avoided — it is how you pass something large without copying it, and
how a procedure reports more than one answer. Exercise 1 builds a `MinMax` that returns two values
that way, which is the tool to reach for until Chapter 19 introduces tuples.

### const, for a reference you promise not to write through

`byref` gives speed and gives up safety: the callee can now write to the caller's variable. Adding
`const` takes the safety back while keeping the speed.

```tiko
{{#include ../examples/ch06/constparam.tiko}}
```

```text
constparam.tiko(3,5): error TKO0617: cannot modify 'n': it is a constant
     |
   3 |     n += 1               '' error: that is what const forbids
     |     ^
```

`byref x as const T` is the right shape for any parameter you only intend to read, and it is
documentation the compiler checks.

```admonish warning title="Status in this version"
**`const` is not enforced on `string` or `ustring` parameters** at the pinned compiler. A procedure
declared `byref s as const ustring` may assign to `s`; it compiles without a word, and the caller's
variable changes. The check works correctly for numbers, as above, and for types you define.

This is tiko's own gap — fbc refuses the same program — and it is tracked as work item **T18**.
Until it lands, `const` on a string parameter states your intent to a reader without being
verified, so read the body rather than trusting the signature.
```

## Arguments you can leave out

```tiko
{{#include ../examples/ch06/optional.tiko}}
```

```text
{{#include ../examples/ch06/optional.out}}
```

A parameter with `= value` may be omitted at the call. Optional parameters must come after the
required ones, and an argument in the *middle* can be skipped by leaving its slot empty —
`Label( "marked", , "?" )` takes the default for `times` and supplies `mark`.

The empty slot is easy to misread. Two of them in a row, `Label( "x", , )`, is legal and tells the
reader nothing; when a call needs more than one hole, the parameters are in the wrong order.

## One name, several signatures

```tiko
{{#include ../examples/ch06/overloads.tiko}}
```

```text
{{#include ../examples/ch06/overloads.out}}
```

`overload` says that a name is deliberately shared. It is required: declaring a second `Area`
without it is `TKO0600: 'area' is already declared in this scope`, the same error as any duplicate
name — which is the right default, because most repeated names are accidents.

Note what happened to `Area( 3 )`. There is no `int32` overload, so the argument was converted to
`float64` and the one-parameter version ran. The compiler scores the conversions each candidate
would need and takes the cheapest total. When two candidates tie, it refuses rather than guessing:

```tiko
{{#include ../examples/ch06/ambiguous.tiko}}
```

```text
ambiguous.tiko(17,11): error TKO0660: the call to 'pick' matches more than one overload
     |
  17 | print Pick( 1, 1 )       '' error: int32 converts to float64 either way
     |           ^
```

Scoring counts conversions; it does not rank them by whether they can lose information. Exercise 2
shows an `int64` argument picking an `int32` overload — narrowing — in preference to widening to
`float64`. If a width matters, give it an overload of its own.

## Recursion, and locals that remember

```tiko
{{#include ../examples/ch06/gcd.tiko}}
```

```text
{{#include ../examples/ch06/gcd.out}}
```

A procedure may call itself; each call gets its own parameters and its own locals. `static` is the
exception — a `static` local is created once, keeps its value between calls, and so is shared by
every level of a recursion. That is what makes it usable as a call counter, and it is also why
`Gcd` has to reset it before returning: the count belongs to one top-level call, and nothing else
will clear it.

`static` initialisers run once, on the first call. A `static` is the smallest thing that gives a
procedure memory, and the smallest thing that stops it being safe to call from two threads at once
— Chapter 22 returns to that.

## Returning a place instead of a value

A function can hand back a reference to storage, which the caller may then assign *to*. Write
`byref` after the parameter list:

```tiko
{{#include ../examples/ch06/byrefresult.tiko}}
```

```text
{{#include ../examples/ch06/byrefresult.out}}
```

Read the second line of that output before the third.

````admonish danger title="Pitfall"
**`SlotAt( 0 ) = 42` does nothing, and says nothing.**

Inside an argument list `=` is the equality operator, so the compiler reads `SlotAt( 0 = 42 )`: a
call with one `boolean` argument, whose result is thrown away. It is a complete, legal statement.
The assignment you wrote is gone, and the program carries on with the old value.

Two spellings work, both in the listing above:

```tiko
( SlotAt( 0 ) ) = 42                        '' parenthesise the call
```

```tiko
dim byref as int32 slot = SlotAt( 1 )       '' or bind it to a name
slot = 7
```

The second is worth preferring. It names the thing being modified, and it cannot be broken later by
someone removing a pair of parentheses that looked redundant.

**fbc warns about this and tiko does not** — work item **T19**. Until that lands, nothing at all
tells you the assignment was dropped.
````

## Any number of arguments

```tiko
{{#include ../examples/ch06/varargs.tiko}}
```

```text
{{#include ../examples/ch06/varargs.out}}
```

`...` as the last parameter accepts any number of further arguments. It is C's mechanism, with C's
consequences: the procedure must be `cdecl`, there is no type checking, and the count is recorded
nowhere — `SumOf` is *told* how many to read because there is no other way for it to find out.
Reading one argument too many reads whatever happened to be next.

Declaring the procedure without `cdecl` is refused: `TKO0781: '...' needs a 'cdecl' procedure, and
this one is 'stdcall'`.

Variadics exist mainly so that C libraries can be called; `printf` is the reason the machinery is
there. In tiko code, prefer an overload, an optional parameter or an array. Chapter 28 covers
`cva_list` in full, alongside the rest of C interoperation.

```admonish warning title="Status in this version"
**A variadic procedure does not link on linux-x86_64** with the pinned toolchain. tiko emits the
`llvm.va_start.p0` spelling of the intrinsic, which exists only from LLVM 19; the Linux clang is
18.1.3 and treats it as an ordinary symbol, so the link fails with an undefined reference. The
Windows host's clang is newer, which is the only reason that side works. Tracked as **T20**;
`varargs.tiko` is marked blocked on that target rather than rewritten.
```

## Procedures as values

```tiko
{{#include ../examples/ch06/callbacks.tiko}}
```

```text
{{#include ../examples/ch06/callbacks.out}}
```

A procedure has a type, spelled the way it is declared minus the names:
`function( byval as float64 ) as float64`. A variable or parameter of that type holds any procedure
matching the shape, and is called with ordinary call syntax.

Two spellings get the address: `@Twice` and `procptr( Twice )`. They are the same thing, and
`procptr` is the one to use for an overloaded name, where the signature picks which one you meant.

A procedure pointer is the plainest form of the idea that the caller decides *what* to do and the
procedure decides *when*. Chapter 20 extends it to lambdas, which add the ability to capture
variables from around them — the one thing a procedure pointer cannot do, because a pointer is a
single address with no room for anything else.

## What it costs

A call is cheap and not free: arguments are placed, a return address is pushed, the callee may save
registers. None of that matters at ordinary granularity, and all of it matters in a loop running
millions of times.

The costs worth knowing are the ones you choose:

- **`byval` on a large value copies it**, every call. That is what `byref ... as const` is for.
- **`byref` on a small value** adds an indirection to save copying eight bytes. It is a loss.
- **A procedure pointer cannot be inlined**, because the target is not known until it runs. A direct
  call can be.
- **`static` locals make a procedure stateful**, which is a correctness cost before it is ever a
  performance one.

## Summary

- A procedure sees only what it is given; module-level variables need `shared`, which is rarely
  worth it.
- `return`, `function =` and assigning the procedure's own name are three spellings of one thing. A
  function that sets no result returns zero, silently.
- `declare` introduces a name before its body, which mutual recursion requires.
- **With no keyword, numbers are passed `byval`, and strings and your own types `byref`.** Write the
  keyword on every parameter.
- `byref x as const T` is a reference you cannot write through — **except for `string`/`ustring` at
  this version (T18)**.
- Optional parameters follow the required ones, and a middle argument can be left empty.
- `overload` is required to share a name; resolution scores conversions and refuses ties with
  `TKO0660`. It does not avoid narrowing.
- `static` locals persist between calls and are shared by every level of a recursion.
- **Assigning to a `byref` function result needs `( f( x ) ) = v` or a `dim byref` name** — the bare
  form parses as an equality test and is silently discarded (T19).
- `...` needs `cdecl`, does no type checking, and does not link on linux-x86_64 yet (T20).
- Procedure pointers hold any procedure of a matching shape; `@P` and `procptr( P )` are the same.
- The costs you choose: a `byval` copy of something large, a `byref` indirection to save eight
  bytes, a procedure pointer that cannot be inlined, and a `static` that makes a procedure
  stateful.

## Exercises

1. Write `MinMax`, which takes three `int32` values and reports the smallest and largest through
   `byref` parameters. Which of its five parameters are `byval` and which `byref`, and what happens
   if you omit the keywords entirely? {solution="ex06-01"}
2. Overload `Describe` for `int32`, `float64` and `ustring`, then call it with an `int16` and an
   `int64`. Predict which overload each picks before you run it. {solution="ex06-02"}
3. Write a function with a `byref` result, then assign to it with the bare `f( i ) = v` form. Before
   running the program, say what you expect; afterwards, explain what the compiler actually
   compiled.
4. Give a recursive procedure a `static` call counter and *don't* reset it. Call the procedure twice
   and explain the second number.
5. Take `Tabulate` from `callbacks.tiko` and add a third operation without touching `Tabulate`. Then
   do the same with an overload instead of a procedure pointer. Which change would you rather
   review?
