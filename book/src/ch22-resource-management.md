# Resource Management

A program borrows things from the system it runs on: memory, open files, sockets, locks, window
handles. Each one has to be given back, exactly once, after the last use — and the code paths
between taking and giving back multiply with every `if`, every early `return` and every runtime
error.

tiko's answer is **deterministic destruction**: an object is destroyed at a point you can read off
the source, when the block that owns it ends. This chapter builds on that rule. It recaps the rule,
then shows how to choose between `defer` and a type with a destructor, how to write a handle type
that owns one resource, and how to share ownership of an object between several owners with
`SharedPtr` and `WeakPtr`.

## The rule

Chapter 6 introduced `defer` and Chapter 12 destructors. They follow one rule:

```tiko
{{#include ../examples/ch22/cleanuporder.tiko}}
```

```text
{{#include ../examples/ch22/cleanuporder.out}}
```

When a block ends, everything it set up is undone **in reverse order** — destructors and deferred
statements interleaved, newest first. `b` was opened after `deferred 1` was scheduled, so it is
closed before that statement runs. The order is the order you wrote things in, reversed; nothing
depends on a collector, a timer or the order objects happen to be found in memory.

Every way out of a block follows the rule: falling off its end, `exit sub`, `return`, `exit for`.
The one exception is the runtime error that leaves a procedure for a handler further out, which
skips that procedure's cleanup — Chapter 18 showed it, and it is the reason to keep handlers close
to the resources they protect.

## defer, or a type with a destructor

Both run cleanup at the end of a block. They differ in where the knowledge of the cleanup lives.

- **`defer` keeps it at the call site.** `open … as #f` followed by `defer close #f` is right when
  the resource is used in one procedure and nowhere else: the release is one line, next to the
  acquisition, and there is nothing to name or declare.
- **A destructor keeps it in a type.** When the same resource is acquired in many places, passed
  between procedures or stored in other objects, writing `defer` at every acquisition is the same
  line repeated — and a line someone will forget. A type whose destructor releases the resource
  makes the release impossible to forget, because there is nothing to write.

The rule of thumb: **`defer` for a one-off, a type for a resource your program has more than one
of.**

## Writing a handle type

A handle type owns one resource for exactly as long as it lives. A file is the usual example:

```tiko
{{#include ../examples/ch22/filehandle.tiko}}
```

```text
{{#include ../examples/ch22/filehandle.out}}
```

The constructor opens the file and the destructor closes it, so `SaveReport` contains no cleanup
code at all and still closes the file on every way out. The program then reads the file back —
which it can only do because `SaveReport` has already closed it.

The two `private` declarations matter as much as the destructor. A `TextWriter` that could be
copied would give two objects the same channel, and two destructors would close it twice — the
double-release from Chapter 12, wearing a file instead of memory. Declaring the copy constructor
and `operator let` private, and never defining them, means there is only ever one owner:

```tiko
{{#include ../examples/ch22/nocopy.tiko}}
```

```
nocopy.tiko(12,5): error TKO0633: 'b' needs a constructor or destructor that is not accessible here
```

This is the third answer to Chapter 12's rule of three. A type that owns something can **copy it
properly**, be **built from parts that copy themselves**, or **refuse to be copied**. For a handle
to something the system gave you once — a file, a socket, a lock — refusing is usually right.

## Shared ownership: SharedPtr

Sometimes one object really does have several owners — a session that several connections use, a
texture several sprites draw — and none of them knows when the others are finished. `SharedPtr( of
T )` answers that with a **count of owners**: each copy of the pointer adds one, each copy that goes
away subtracts one, and the object is destroyed when the count reaches zero.

```admonish note
**Smart pointers are the `std/memory` module**: `#import "std/memory"`, and its names are written
`memory.SharedPtr`, `memory.MakeShared` and so on (or bare, after `using memory`).
```

```tiko
{{#include ../examples/ch22/shared.tiko}}
```

```text
{{#include ../examples/ch22/shared.out}}
```

| Member | Does |
|---|---|
| `memory.MakeShared( of T )( )` | a new `T` on the heap, owned by the returned pointer |
| `p->field`, `*p` | the object, as through a raw pointer — no check for null |
| `p.Ref( )` | the object, **checked**: a runtime error on an empty pointer |
| `p.UseCount( )` | how many `SharedPtr`s own the object |
| `p.Reset( )` | this pointer stops owning; the object goes if it was the last owner |
| `p.IsNull( )` | whether this pointer owns nothing |
| `p.Get( )` | the raw `T ptr`, for code that needs one |

A pointer can also adopt an object that already exists: `memory.SharedPtr( of T )( new T( … ) )`.
After that, the `SharedPtr` owns it — never `delete` it yourself.

### Passing one around

```tiko
{{#include ../examples/ch22/passing.tiko}}
```

```text
{{#include ../examples/ch22/passing.out}}
```

Passing a `SharedPtr` `byval` makes a copy — a real new owner — and costs an increment on the way
in and a decrement on the way out. A procedure that only uses the object should take it `byref`.
Take it `byval` only when the procedure keeps a copy that outlives the call.

The second half of the listing is `Ref( )` on an empty pointer: runtime error 1, "illegal function
call", which an `on error` handler can catch. `->` and `*` do not check, exactly as a raw pointer
does not; use `Ref( )` where an empty pointer is possible and you want it caught.

`->` reaches a field, so it needs `T` to be a type with fields. Over a `SharedPtr( of int32 )`,
`*count` works and `count->value` does not:

```tiko
{{#include ../examples/ch22/scalararrow.tiko}}
```

```
scalararrow.tiko(5,14): error TKO0739: 'sharedptr' has no member named 'value'
```

## Cycles, and WeakPtr

Reference counting has one failure it cannot detect on its own: two objects that own each other.

```tiko
{{#include ../examples/ch22/treeparents.tiko}}
```

```text
{{#include ../examples/ch22/treeparents.out}}
```

In the first tree, the root owns the kid through `kids` and the kid owns the root through `parent`.
When the scope ends, each local `SharedPtr` lets go — and each node still has one owner: the other
node. Neither count reaches zero, neither destructor runs, and nothing reports it. The memory is
leaked for the rest of the program.

The second tree makes the **back link weak**. A `WeakPtr( of T )` observes an object without owning
it: it does not count, so the kid's `parent` no longer keeps the root alive. When the scope ends,
the root's count reaches zero, the root is destroyed, its `kids` array goes with it, and the kid
follows.

A `WeakPtr` is read through `Lock( )`, which returns a real `SharedPtr` — an owner for as long as
you hold it — or an empty one if the object has already gone. There is no way to reach the object
through a `WeakPtr` without that check, and that is the point: between "is it still there?" and
"use it", the last owner could let go, and `Lock( )` answers both questions at once.

The rule for designing with them: **ownership flows one way.** Pick the direction that owns —
parent to child, container to element, window to control — make every link that way a `SharedPtr`,
and make every link back a `WeakPtr`.

## SpCast and the virtual destructor

A `SharedPtr( of Circle )` does not convert to a `SharedPtr( of Shape )` on its own. The conversion
is written out, with both types named:

```tiko
var s = memory.SpCast( of Circle, Shape )( c )
```

Both pointers now own the same `Circle`, and the count is shared.

````admonish danger title="Pitfall"
**The last owner destroys the object as its own `T`.** If that last owner is a `SharedPtr( of
Shape )`, the object is destroyed as a `Shape`:

```tiko
{{#include ../examples/ch22/spcast.tiko}}
```

```text
{{#include ../examples/ch22/spcast.out}}
```

`Circle`'s destructor never runs. Here it only prints; in a real type, it is where a file is
closed or a buffer freed, and nothing reports that it was skipped. The fix is the one Chapter 14
gave for deleting through a base pointer — **make the base's destructor `virtual`**:

```tiko
{{#include ../examples/ch22/spcastvirtual.tiko}}
```

```text
{{#include ../examples/ch22/spcastvirtual.out}}
```

Any type you intend to share through a pointer to its base needs a virtual destructor. The
compiler cannot check that for you: it is a contract of `SpCast`.
````

## Threads

Under `-mt`, the counts inside a `SharedPtr` are updated with atomic operations, so several
threads may copy and drop pointers to the same object at the same time. Without `-mt` there are no
threads, and the counts are plain arithmetic. That guarantee covers **the count, never the
object**: two threads that change the object itself still need a lock of their own. Chapter 23
covers threads and locks.

## What it costs

- **A handle type costs nothing beyond its resource.** Its destructor is a call at the end of the
  block, the same call you would have written by hand.
- **`defer` costs nothing at run time**; the deferred statement is placed on each way out.
- **A `SharedPtr` is two allocations** — the object and a small block holding the counts — and
  each copy is an increment and, later, a decrement. Under `-mt` those are atomic operations, which
  are slower again. Pass `byref` where the copy is not needed.
- **A `WeakPtr` keeps the count block alive**, though not the object, until the last weak pointer
  goes.

## Summary

- When a block ends, its destructors and deferred statements run in reverse order of setup, on
  every way out except an error that leaves for an outer handler.
- `defer` for a one-off resource in one procedure; a type with a destructor for a resource the
  program has many of or passes around.
- A handle type acquires in its constructor, releases in its destructor, and usually refuses to be
  copied: a private copy constructor and `operator let` (`TKO0633` at any copy).
- `#import "std/memory"` — `memory.MakeShared`, `->`, `*`, `Ref( )`
  (checked), `UseCount( )`, `Reset( )`. Pass `byref` unless the callee keeps a copy.
- **Two objects that own each other are never freed.** Make back links `WeakPtr`s and read them
  with `Lock( )`.
- `memory.SpCast( of Derived, Base )` converts explicitly; **the base needs a virtual
  destructor**, or the derived part is never destroyed.
- Under `-mt` the counts are atomic; the object itself is not protected.

## Exercises

1. Write a `ScratchFile` type that creates a file in its constructor and deletes it in its
   destructor, and cannot be copied. Show that the file exists inside a `scope` and not after it.
   {solution="ex22-01"}
2. Keep a `WeakPtr( of Image )` as a cache entry. Show a hit while an owner exists, and an empty
   `Lock( )` and `Expired( )` after the last owner has gone. {solution="ex22-02"}
3. Rewrite `filehandle.tiko`'s `SaveReport` with `open` and `defer` and no type. Which version
   would you rather have if ten procedures wrote reports?
4. In `treeparents.tiko`, make the root's `kids` weak instead of the kid's `parent`. What is freed
   when, and why is that wrong for a tree?
5. Add a third level to the tree and print each node's path to the root by following `parent`
   links with `Lock( )`.
