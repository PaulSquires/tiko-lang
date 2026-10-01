# Inheritance and Polymorphism

A drawing program has circles, rectangles and squares, and somewhere in it a loop that has to ask
each one for its area. Written with the tools of Chapter 11, every shape is its own type, and the
loop needs a `select case` on some "kind" field to know which code to run. The next shape means
editing that loop, and every other loop like it.

**Inheritance** lets one type start as another and add to it. **Polymorphism** lets a single call
reach the right code for whatever object is really there, so the loop asks "what is your area?"
and never needs to know what it is talking to. This chapter builds both, then covers the three
places they go wrong: an object deleted through the wrong pointer, an object passed by value, and
a relationship that was never really "is a".

## Extending a type

```tiko
{{#include ../examples/ch13/extends.tiko}}
```

```text
{{#include ../examples/ch13/extends.out}}
```

`type Bicycle extends Vehicle` makes a `Bicycle` a `Vehicle` with more fields. It has `wheels` and
`speed` without declaring them, and the offsets show where they live: the base's fields come first,
exactly as they are laid out in a `Vehicle`, and `gears` follows them. That layout is the point. A
`Bicycle` *starts with* a complete `Vehicle`, so anything that works on a `Vehicle` can be handed one.

**`base( 2 )` runs the base's constructor first.** The `Vehicle` part of a `Bicycle` is built
before the `Bicycle` constructor's own body runs, and `base( … )` chooses which `Vehicle`
constructor builds it and with what. Written without a `base( … )` call, the base's default
constructor runs instead.

`base.Describe( )` calls the base's version of a method from inside the derived one. `Bicycle`'s
`Describe` has the same name as `Vehicle`'s and **hides** it: on a `Bicycle`, `Describe` means
`Bicycle.Describe`. Reusing the base's text through `base.` means the two descriptions cannot
drift apart.

### A base without a default constructor

`Vehicle`'s constructor takes `wheels = 4` as a default, so it can be called with nothing at all.
That default is load-bearing:

```tiko
{{#include ../examples/ch13/nodefault.tiko}}
```

```
nodefault.tiko(13,1): error TKO0926: 'bicycle' needs a copy constructor: its base has no constructor that takes no argument, so none can be made for it
     |
  13 | type Bicycle extends Vehicle
     | ^
```

A derived type gets a copy constructor for free, and that free one works by building a fresh base
part with the base's default constructor, then copying every field across. With no default
constructor in the base, there is nothing to build the fresh part with, so the derived type must
write its own copy constructor. fbc refuses the same program with its error 188.

Give the base a constructor that takes no arguments, or default its parameters as `extends.tiko`
does, and every type derived from it can be copied without writing anything.

`base( … )` passes whatever the base's constructors take, chosen the way any overloaded call is.
Here it hands a label up, and the base's default value for it, `"unnamed"`, is what keeps
`Sensor` copyable:

```tiko
{{#include ../examples/ch13/basestring.tiko}}
```

```text
{{#include ../examples/ch13/basestring.out}}
```

## Calling through the base

A `Bicycle` can be handed to anything that takes a `Vehicle`. What happens to its methods when it
is?

```tiko
{{#include ../examples/ch13/hiding.tiko}}
```

```text
{{#include ../examples/ch13/hiding.out}}
```

`Show` declares its parameter as a `Vehicle`, so inside `Show` the compiler knows only that it has
a `Vehicle`, and `v.Kind( )` is compiled as a call to `Vehicle.Kind`. Which object arrives at run
time does not enter into it. Hiding a method changes what the name means on the derived type; it
changes nothing for code that sees the object as its base.

That is the right behaviour for most methods, and it costs nothing. But it is exactly wrong for the
drawing program's loop, which sees every shape as "a shape" and needs each one's own answer.

## Virtual methods

```tiko
{{#include ../examples/ch13/shapes.tiko}}
```

```text
{{#include ../examples/ch13/shapes.out}}
```

Four words do the work.

- **`extends Object`.** `Object` is the built-in root type. Extending it gives every object of the
  type one hidden field, a pointer to the type's table of virtual methods, and that pointer is how a
  call finds the right code at run time.
- **`virtual`** marks a method that derived types may replace. A call to it looks the method up in
  the object's table, so it reaches the version belonging to the object that is really there.
- **`override`** marks a method that replaces a virtual one. The compiler checks that there is
  something to replace: `override` on a method the base did not make virtual is `TKO0621`.
- **`abstract`** declares a virtual method with no body at all. `Shape` cannot say what its area is,
  so it says only that every shape has one.

`Shape.Describe` is not virtual, yet its output is different for every shape, because the two calls
*inside* it are. That is a common and useful shape: the base writes the procedure once, and the
derived types supply the parts that differ.

**An override is not itself virtual.** `Circle.Kind` replaces `Shape.Kind`, but a type derived
from `Circle` could not override it again. `Rect` declares its `Kind` as `virtual … override`,
which both replaces `Shape`'s and opens it to `Rect`'s own descendants. That is what lets `Square`
override it in turn. `Square` keeps `Rect`'s `Area`, because a square's area is a rectangle's.

Leave `virtual` off, and the next level down cannot override:

```tiko
{{#include ../examples/ch13/notvirtual.tiko}}
```

```text
{{#include ../examples/ch13/notvirtual.out}}
```

`Dog.Speak` is an override but not virtual, so `Puppy`'s `Speak` hides it without replacing it.
Called on a `Puppy` directly it answers `yip`; called through an `Animal` it reaches `Dog`'s.
Writing `override` on `Puppy.Speak` would not help: there is no open slot for it to fill, and the
compiler says so (`TKO0621`). The fix is one word in `Dog`, `virtual … override`, exactly as
`Rect` does in `shapes.tiko`.

C++ programmers expect the opposite, because there an override stays virtual all the way down.
tiko follows fbc, where it does not, so code moves between the two compilers unchanged.

### Abstract types

```tiko
{{#include ../examples/ch13/abstract.tiko}}
```

```
abstract.tiko(7,14): error TKO0620: 's' has an abstract type, which cannot be instantiated
     |
   7 | dim as Shape s
     |              ^
```

A type with an abstract method is incomplete on purpose, so it cannot be created: there would be
nothing to run when someone asked for its area. A derived type that fills in every abstract method
can be created, and one that leaves any of them unwritten is abstract too, with the same error.
What *can* exist is a `Shape ptr` or a `byref` `Shape` parameter, pointing at a complete type.

### Seeing the table

`tiko --dump-vtable` prints each type's table of virtual methods. For `shapes.tiko`:

```
object vtable 0 slot(s)
shape vtable 2 slot(s)
  slot 0 <abstract>
  slot 1 _ZN5SHAPE4KINDEv
circle vtable 2 slot(s)
  slot 0 _ZN6CIRCLE4AREAEv
  slot 1 _ZN6CIRCLE4KINDEv
rect vtable 2 slot(s)
  slot 0 _ZN4RECT4AREAEv
  slot 1 _ZN4RECT4KINDEv
square vtable 2 slot(s)
  slot 0 _ZN4RECT4AREAEv
  slot 1 _ZN6SQUARE4KINDEv
vtables: 5
```

Every type in the family has the same two slots in the same order, `Area` then `Kind`. A derived
type copies its base's table and replaces the entries it overrides, so a call through a `Shape`
always looks in slot 0 for `Area`, whichever table it finds. `Shape`'s slot 0 is `<abstract>`,
which is why a `Shape` cannot exist; `Square`'s slot 0 still names `Rect.Area`, which it inherited.
The names are mangled the way C++ mangles them: `_ZN6SQUARE4KINDEv` is `SQUARE::KIND()`.

The dump is the place to look when a call reaches the wrong method. It shows what the compiler
built, and comparing it with what you meant is usually enough to find the mistake.

## Virtual destructors

An object created with `new` and deleted through a pointer to its base is destroyed by whichever
destructor that pointer's type names:

```tiko
{{#include ../examples/ch13/vdtor.tiko}}
```

```text
{{#include ../examples/ch13/vdtor.out}}
```

```admonish danger title="Pitfall"
**`delete` through a base pointer skips the derived destructor unless the base's is virtual.**
`delete p` ran `~Plain` and nothing else. `PlainFile`'s destructor, the one that closes the file,
never ran, and nothing said so: the program compiled cleanly, and the leaked handle surfaces
somewhere else, later.

With `declare virtual destructor( )` in the base, `delete q` finds the right destructor through the
table, runs it, and then runs the base's, in that order. **A type meant to be derived from and
deleted through its base declares a virtual destructor**, even an empty one.
```

The rule from the previous section applies to destructors as well, and this is where it costs most.
A destructor is virtual only if it says so, so a middle level that declares a plain one closes the
chain below it:

```tiko
{{#include ../examples/ch13/vdtormiddle.tiko}}
```

```text
{{#include ../examples/ch13/vdtormiddle.out}}
```

`LogFile`'s destructor never ran, although `Resource`'s is virtual and `LogFile` declares one of its
own. `File` declared a destructor without `virtual`, and from there down nothing overrides.
`SafeFile` says `virtual` again, and its descendant is destroyed properly. The same happens when
the middle type declares no destructor at all: the one the compiler writes for it is not virtual.
**Every level that may be deleted through a base pointer declares `virtual destructor`.**

## Asking what an object really is

Sometimes the code holding an `Animal` needs something only a `Dog` has:

```tiko
{{#include ../examples/ch13/isdown.tiko}}
```

```text
{{#include ../examples/ch13/isdown.out}}
```

`a is Dog` is true when the object is a `Dog` **or anything derived from one**, which is why the
puppy passes both tests. Once it is true, `cast( Dog ptr, @a )` treats the same object as a `Dog`.
The cast itself checks nothing, so always guard it with `is`.

`is` needs the type to extend `Object`, because the answer is read from the hidden table pointer,
and it only accepts a type derived from the variable's own type: asking whether an `Animal` *is*
an `Animal` is refused (`TKO0798`), and asking it of a type with no table is `TKO0799`. fbc refuses
both too.

Use `is` sparingly. A chain of `if a is Dog … elseif a is Cat …` is the `select case` this chapter
set out to remove, wearing different clothes. If the question is "what should this animal do", the
answer is a virtual method.

## Passing by value

```tiko
{{#include ../examples/ch13/slicing.tiko}}
```

```text
{{#include ../examples/ch13/slicing.out}}
```

```admonish danger title="Pitfall"
**Passing a derived object by value keeps only its base part.** `ByValue` received a fresh
`Animal`, made by copying the `Animal` part of `rex`, and that copy is an `Animal` through and
through. It speaks `...`, it is not a `Dog`, and `tricks` is gone. The same happens on assignment:
`dim as Animal copy = rex` is a plain `Animal`.

Nothing warns about this, because nothing is wrong with the program from the compiler's point of
view: an `Animal` was asked for and an `Animal` was made. **Pass an object of a type with virtual
methods `byref`, or by pointer**, never `byval`.
```

The last line of the output is the hidden field from the previous section made visible. `Object`
is eight bytes, the table pointer and nothing else. `Animal` adds `legs` and rounds up to 16, and
`Dog` adds `tricks` and rounds to 24.

## Composition, and abstract types as contracts

Inheritance says "is a". A `Bicycle` is a `Vehicle`, and a `Square` is a `Rect`. When the
relationship is "has a" or "uses a", inheritance is the wrong tool, even when it would save typing:
a `Circle` that extends a `Point` to borrow its `x` and `y` can be passed to every procedure that
expects a point, and none of them meant a circle. Give the `Circle` a `Point` field instead.

```tiko
{{#include ../examples/ch13/pluginhost.tiko}}
```

```text
{{#include ../examples/ch13/pluginhost.out}}
```

`Plugin` is all contract: two abstract methods and a virtual destructor, with no data. Any type that
extends it and fills in `Name` and `Apply` is a plugin, and `Host` can run it without knowing what
it is. That is the role an **interface** plays in other languages. In tiko it is an abstract type.

`Host` is the other half. It is not a plugin and does not extend one. It **has** plugins: it owns
them, runs them in order, and deletes them in its destructor. The deletes go through `Plugin ptr`,
which is why `Plugin`'s destructor is virtual. Adding a third plugin means writing one new type;
`Host` does not change.

`implements` is a reserved word, and it does nothing:

```tiko
{{#include ../examples/ch13/implements.tiko}}
```

```
implements.tiko(7,39): error TKO0420: expected the end of the statement
     |
   7 | type Report extends Object implements Printable
     |                                       ^
```

A type extends exactly one base. To be a plugin and something else at once, let it extend the
contract and hold the something else as a field.

## What it costs

- **Every object of a type that extends `Object` carries one pointer**, eight bytes, plus whatever
  padding it causes. A million small objects pay eight megabytes for it.
- **A virtual call is an indirect call**: load the table pointer, load the slot, call through it.
  That is a few instructions, but it prevents the call from being inlined, which matters inside a
  hot loop over small methods.
- **A non-virtual method costs nothing extra**, inherited or not. Make methods virtual because a
  derived type needs to replace them, not by default.
- **`is` walks the chain of base types**, so it costs a little more the deeper the hierarchy.
- **Abstract types and `override` are compile-time only.** They cost nothing at run time.

## Summary

- `type B extends A` starts `B` as a complete `A`, base fields first. `base( … )` chooses the base
  constructor, which runs before the derived body; `base.Method( )` calls the base's version.
- **A base with no default constructor forces every derived type to write a copy constructor**
  (`TKO0926`). Default the base constructor's parameters instead.
- Without `virtual`, a call is chosen by the type the compiler sees. A method of the same name on a
  derived type **hides** the base's; it does not replace it for code that sees the base.
- `extends Object` adds a table pointer. `virtual` methods are looked up in it at run time;
  `override` replaces one (`TKO0621` if there is nothing to replace); `abstract` declares one with
  no body. **An override is not virtual unless you also write `virtual`**, so a type derived from it
  hides the method instead of overriding it.
- A type with an abstract method cannot be created (`TKO0620`). `--dump-vtable` shows the table the
  compiler built.
- **Give a base that will be deleted through a pointer a virtual destructor**, or the derived
  destructor never runs, and **repeat `virtual` at every level below it**: a plain destructor in
  the middle stops the chain.
- `a is T` is true for `T` and anything derived from it; guard every `cast( T ptr, @a )` with it.
  Prefer a virtual method to a chain of `is` tests.
- **Passing by value slices** an object to its base part. Pass objects with virtual methods `byref`.
- Use inheritance for "is a" and composition for "has a". An abstract type with no data is
  tiko's interface; `implements` is reserved and means nothing (`TKO0420`).

## Exercises

1. Add a `Triangle` with a base and a height to the shapes program, without changing `Shape`,
   `Circle` or the loop. What did you have to write, and what did you not? {solution="ex13-01"}
2. Write a `Counter` plugin whose `Apply` appends the length of the text and counts its calls, and
   whose destructor prints the count. Create it with `new`, use it through a `Plugin ptr`, and
   delete it through that pointer. Which line makes the destructor run? {solution="ex13-02"}
3. Remove `virtual` from `vdtor.tiko`'s `Careful` destructor. Predict the output, then run it.
4. Change `ByValue` in `slicing.tiko` to take its parameter `byref`. Which lines of output change,
   and why?
5. A `Stack` that extends `Array`, or a `Stack` that has an `Array` field: argue for one. What can a
   caller do to the first that a stack should not allow?
