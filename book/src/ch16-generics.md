# Generics

A `Stack` of integers and a `Stack` of names are the same code twice. Before generics you had
three ways to avoid writing it twice, and all of them cost something: a macro, which the compiler
checks only after it has been pasted somewhere; a container of `any ptr`, which forgets what it
holds and makes you remember; or copy and paste, which works until the two copies drift.

A generic is the fourth way. You write the code once with a placeholder for the type, and the
compiler produces a real, separately checked version for each type you ask for. The code inside a
generic is ordinary tiko — the same parser, the same type checking, the same errors — and what
comes out is as fast and as strongly typed as the version you would have written by hand.

## A type with a parameter

`of T` after the type's name declares a type parameter, and `T` is then usable anywhere a type
can appear:

```tiko
{{#include ../examples/ch16/box.tiko}}
```

```text
{{#include ../examples/ch16/box.out}}
```

`Box( of int32 )` and `Box( of ustring )` are **two distinct types**, as unrelated as any two
types you wrote by hand. One will not assign to the other and one will not pass where the other is
expected. Nesting is ordinary too: `Box( of Box( of int32 ) )` is a box holding a box.

Each distinct argument list produces one instantiation, and writing `Box( of int32 )` in two
different files produces the same type in both — they link.

## A procedure with a parameter

Procedures take type parameters the same way, and you usually do not have to state them:

```tiko
{{#include ../examples/ch16/minmax.tiko}}
```

```text
{{#include ../examples/ch16/minmax.out}}
```

The first call says nothing about `T`; the compiler infers `int32` from the arguments. The second
states it, `Larger( of float64 )( … )`, which you need when the arguments would infer something
else — here, two literals that would otherwise have been integers.

**Inference reads the arguments, and nothing else.** It cannot work backwards from what you do
with the result, so a generic whose type parameter appears only in the return type must always be
given its argument explicitly.

## Members, and bodies written out of line

A generic type can declare the full range of members — methods, properties, constructors,
operators — and their bodies can live away from the declaration, which is how you keep a long type
readable. The body repeats the `( of T )`:

```tiko
{{#include ../examples/ch16/stack.tiko}}
```

```text
{{#include ../examples/ch16/stack.out}}
```

Two details in that listing are worth naming. `redim preserve this.items( … )` grows the storage,
so `T` must be a type an array can hold — which every type is. And `declaration order does not
matter`: the member bodies come after the type, and a generic may be used before its bodies are
written, because the body is not compiled until something asks for an instantiation.

More than one parameter is the obvious extension:

```tiko
{{#include ../examples/ch16/pair.tiko}}
```

```text
{{#include ../examples/ch16/pair.out}}
```

## Inheritance and virtual methods

An instantiation is an ordinary type, so it can extend another type, and it can override virtual
methods. Dispatch through a base pointer reaches the instantiation's override:

```tiko
{{#include ../examples/ch16/virtual.tiko}}
```

```text
{{#include ../examples/ch16/virtual.out}}
```

This is what makes a generic usable inside an object-oriented design rather than beside one: a
`Holder( of int32 )` is a `Base_`, and code that knows only about `Base_` can hold one.

## A type parameter promises nothing

This is the part of generics that surprises people coming from languages with constraints, and it
shapes how you design with them.

`of T` does not say what `T` can do. It is a blank. The compiler therefore cannot check the body
of a generic when it reads it — it has no idea whether `T` has a `>` operator — and instead checks
the body **once per instantiation**, against the real type. A demand the type cannot meet is an
error at that point:

```tiko
{{#include ../examples/ch16/unconstrained.tiko}}
```

That program does not build:

```text
unconstrained.tiko(9,10): error TKO0720: no operator > compares this type
     |
   9 |     if a > b then return a        '' needs '>' on T
     |          ^
unconstrained.tiko(17,10): note: in instantiation of 'ranked( of opaque_ )'
     |
  17 | dim r as Ranked( of Opaque_ )     '' Opaque_ has no '>'
     |          ^
```

```admonish danger title="Pitfall"
**The error is in the generic's body; the cause is usually the instantiation.** The first line
points at `Ranked`'s `>`, which is correct code. The mistake is line 17, where `Opaque_`, a type
with no `>`, was handed to it. Read only the first line and you start editing a generic that was
never wrong.

The `note: in instantiation of` line underneath names the instantiation and the line that wrote it.
Read to the end of an error before you edit. And comment a generic's demands where a reader will
see them, "`T` needs `>`" above the type, so the next person reaches line 17 first.
```

The upside of the same rule is that a generic costs nothing to declare. `Stack( of T )` works for
every type that can be copied, and you never had to enumerate what those are.

## Making your own type fit a generic's demands

The standard containers state their demands in their documentation rather than in the language.
`Map( of K, V )` needs two things of a key: that `K = K` compiles, and that `FB.HashOf( k )`
resolves. You supply both:

```tiko
{{#include ../examples/ch16/hashkey.tiko}}
```

```text
{{#include ../examples/ch16/hashkey.out}}
```

The `HashOf` overload goes **inside `namespace FB`**, because that is where the container looks it
up from; an overload in the global namespace is invisible to it. It also needs `private`, matching
the ones the header itself declares.

```admonish note
`operator =` for a key type is not optional. A hash gets you to the right bucket; equality decides
which entry in that bucket is yours, and a hash that agrees while equality disagrees produces a map
that stores duplicates and finds nothing.
```

## Filling a container from a list

A container starts empty, and filling it used to take one statement per element. A brace list says
the same thing at the declaration, the way it does for an array:

```tiko
{{#include ../examples/ch16/fill.tiko}}
```

```text
{{#include ../examples/ch16/fill.out}}
```

Each element becomes one call, in order, after the container is constructed. `primes` gets four
calls to `Push`, `queue` three to `PushBack`, and `ages` two to `Add`. An element that is itself a
brace list supplies the *arguments* of one call, which is how `{ "Ada", 36 }` becomes
`ages.Add( "Ada", 36 )`. They are ordinary calls, so the ordinary conversions apply: `"Ada"` is a
string literal and arrives as the `ustring` key the map wants.

The demand is the same kind this chapter has been describing: **a shape, not a declaration.** A
brace list fills a type that needs constructing and has a member called `Add`, `PushBack` or
`Push`, looked for in that order. Nothing says "I am a collection". `Bag( of T )` takes part
because it has an `Add`, and because its dynamic array is a field that needs constructing.

A type that needs constructing but has none of the three methods is refused:

```tiko
{{#include ../examples/ch16/fillnone.tiko}}
```

```
fillnone.tiko(13,20): error TKO0843: 'c' cannot take an initializer list: its type has no Add, PushBack or Push method
     |
  13 | dim c as Counter = { 1, 2 }         '' refused
     |                    ^
```

## Overloading, and when a second generic is unreachable

Two generic procedures may share a name when they take different numbers of arguments, and the
call picks the right one — the usual overloading rules apply to the instantiations.

Two limits are worth knowing before you lean on it:

- **A second generic with a different number of *type* parameters does not resolve.** Declaring
  both `Make( of T )( a as T )` and `Make( of K, V )( k as K, v as V )` compiles, but the
  two-argument call fails with `TKO0632: no overload of 'make<8>' matches these arguments`.
- **An unconstrained `of T` parameter matches everything**, so an overload that differs only in
  parameter type is unreachable. Given `Widen( of T )( a as T )` and `Widen( of T )( a as T ptr )`,
  a pointer argument still selects the first — `T` binds to the pointer type. Distinguish
  overloads by arity, or give them different names.

## Instantiation has a depth limit

A generic that instantiates itself, directly or through another generic, would otherwise recurse
until memory ran out. The compiler stops at 64 levels:

```tiko
{{#include ../examples/ch16/toodeep.tiko}}
```

```text
toodeep.tiko(6,26): error TKO0829: generic instantiation of 'wrap' is too deep
(the limit is 64; -maxinstdepth raises it)
```

Almost always this means a mistake — a type whose definition mentions itself without a pointer or
an indirection to stop the recursion. When the depth is genuinely needed, `-maxinstdepth` raises
the ceiling.

## What it costs

Each distinct argument list produces its own code, so `Array( of int32 )` and `Array( of ustring )`
are two separate compiled copies. That is the deal generics make: you pay in binary size for code
that runs with no indirection, no boxing and no run-time type checks. A handful of instantiations
is nothing; a generic instantiated over forty types in a large program is worth noticing.

Compared with the alternatives, a generic is checked where an `any ptr` container is not, and it
produces real diagnostics where a macro produces diagnostics about the expansion.

## Summary

- `type Box( of T )` and `function Larger( of T )( … )` declare type parameters; each distinct
  argument list is a separate, fully checked type or procedure.
- Type arguments are inferred from a call's arguments, and stated explicitly when they are not —
  inference never works backwards from the return type.
- Members may be defined out of line, repeating the `( of T )`. Declaration order does not matter.
- An instantiation is an ordinary type: it can extend a base and override virtual methods.
- **A type parameter promises nothing.** The body is checked per instantiation; the error lands
  in the body, and a `note: in instantiation of` names the instantiation that caused it.
- A container states its demands in its docs: `Map`'s key needs `=` and an `FB.HashOf` overload,
  added by re-opening `namespace FB`.
- **A brace list fills a container**: one `Add`, `PushBack` or `Push` per element, after
  construction, and `{ k, v }` supplies one call's arguments. Any type that needs constructing and
  has one of those methods takes part.
- Instantiation stops at 64 levels deep; `-maxinstdepth` raises it.

## Exercises

1. Write `Queue( of T )` — first in, first out — with `Enqueue`, `Dequeue` and a `Count` property,
   and use it with two different element types. {solution="ex16-01"}
2. Write `Swap_( of T )( byref a as T, byref b as T )`. Then try calling it with an `int32` and a
   `float64` in the same call, and read the error: what does it tell you about how inference
   decides `T`? {solution="ex16-02"}
3. Make a `Version_` type with `major` and `minor` fields usable as a `Map` key, so that two
   separately built values of the same version find the same entry. {solution="ex16-03"}
4. Take the `Ranked( of T )` listing above and make it compile by giving `Opaque_` the operator it
   needs. Which line did you have to change — the generic, or the type you put in it?
