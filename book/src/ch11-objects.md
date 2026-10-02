# Objects

Chapter 9's types held data and left every rule about that data to the code around them. An account
balance could be set negative from anywhere; a buffer's length could disagree with its memory; a
record could be built half-filled. Nothing in the type said otherwise, because the type could not
say anything.

An **object** is a type that carries its rules with it. It has procedures of its own, it decides how
it is created and destroyed, and it can keep its fields to itself so that the only way to change
them is through code that keeps them consistent. None of that costs anything at run time: a method
is an ordinary procedure with the object passed in, and an object is exactly as large as its fields.

## A type with its own procedures

```tiko
{{#include ../examples/ch11/account.tiko}}
```

```text
{{#include ../examples/ch11/account.out}}
```

A **method** is declared inside the type and defined outside it, named `Type.Member`. Inside, the
object it was called on is `this`, and `this.` may be left off when nothing else has the same name —
`balance_` and `this.balance_` are the same field.

The **constructor** runs when an object is created and the **destructor** when it is destroyed. For
an object in a scope, that is at the end of the scope, in the reverse order of creation: Grace was
opened after Ada and closed before her. That ordering is deliberate — something created later may
depend on something created earlier, never the other way round.

The trailing underscore on the fields is a convention, not syntax. It marks the data the methods
look after, and keeps names free for the methods that expose it.

## Constructors

```tiko
{{#include ../examples/ch11/constructors.tiko}}
```

```text
{{#include ../examples/ch11/constructors.out}}
```

A type may have as many constructors as it needs, distinguished by their parameters like overloaded
procedures. The one with no parameters is the **default constructor**, used by a plain `dim`.

One constructor may hand its work to another: `this.constructor( val( text ) )` runs the `float64`
constructor and then carries on. Put shared setup in one constructor and delegate to it, rather
than repeating it.

```admonish danger title="Pitfall"
**A one-parameter constructor is also an implicit conversion.** Because `Temp` has a constructor
taking a `float64`, the compiler will call it on its own whenever a `float64` appears where a `Temp`
is wanted — `dim as Temp d = 7.5` and `Show( 12.0 )` both did, silently, in the listing.

That is convenient for a type that genuinely *is* a number with extra meaning, and surprising for
one that merely takes a number to get started. A `Buffer( 1024 )` constructor makes `Show( 1024 )`
compile for a procedure that wants a buffer. Nothing turns the conversion off, so give such a
constructor a second parameter, or create the object through a named function instead.

`declare explicit constructor` is accepted at this version and **does nothing** — the conversion
still happens. fbc rejects the syntax outright. Tracked as **T38**; do not rely on it.
```

## Copying an object that owns something

Chapter 9's types copied themselves correctly: every field was copied, strings included. That stops
being true the moment a type holds a **pointer** to memory it owns. Copying the pointer gives two
objects the same block — and two destructors that each free it.

Measured, with a `Buffer` that has a constructor and destructor but nothing else, after
`dim as Buffer b = a`:

```text
a.data_[0] = 99   same block: true
  freeing 31008
  freeing 31008
```

The write through `b` appeared in `a`, both destructors freed the same address — the number printed
differs from run to run; that it is the same number twice does not — and the process then
died — `0xC0000374`, heap corruption, on Windows, and `free(): double free` on Linux. fbc behaves
identically: this is the language's rule, not a defect.

The fix is to say what copying means:

```tiko
{{#include ../examples/ch11/copying.tiko}}
```

```text
{{#include ../examples/ch11/copying.out}}
```

Two procedures are involved, because there are two ways an object gets a copy:

- The **copy constructor** builds a new object from an existing one — `dim as Buffer b = a`, or
  passing `byval`. There is nothing to clean up first, because the object did not exist.
- **`operator let`** assigns into an object that already exists — `c = a`. It must release what the
  object holds before taking the copy, and it must **do nothing when assigned to itself**, or it
  frees the very data it is about to copy.

```admonish danger title="Pitfall"
**The rule of three:** a type that needs a destructor almost always needs a copy constructor and an
`operator let` as well. The destructor is there because the type owns something; the copy operations
decide what happens to that something when the object is duplicated. Write one without the others
and every copy is a double free waiting for its scope to end.

The better answer, where it is available, is the **rule of zero**: build the type from fields that
already copy themselves — strings, other well-behaved objects — so that it needs none of the three.
The string builder later in this chapter does exactly that.
```

## Properties

```tiko
{{#include ../examples/ch11/properties.tiko}}
```

```text
{{#include ../examples/ch11/properties.out}}
```

A **property** is a pair of methods that read and write like a field. `t.Celsius = 21.5` calls the
setter; `t.Celsius` in an expression calls the getter. The point is the setter: it is where the type
enforces its own rules, so asking for −500 °C gives absolute zero rather than an impossible
temperature.

A property with only a getter is read-only — `Fahrenheit` is computed from the same field rather than
stored, so it can never disagree with `Celsius`. A property may take an index, as `Reading( i )`
does, which reads like an array whose elements the type controls.

```admonish note
At this version, a property with only a **setter** can be read anyway: the read compiles and yields
0, and inside a `print` it swallows the rest of the line. fbc refuses the read
(`PROPERTY has no GET method`). Tracked as **T35**; give every property you read a getter.
```

## Keeping fields private

Everything after `private:` in a type is reachable only from the type's own methods:

```tiko
{{#include ../examples/ch11/access.tiko}}
```

```text
access.tiko(13,2): error TKO0625: 'c_' is not accessible here
     |
  13 | t.c_ = 5                           '' refused: c_ is private
     |  ^
```

That refusal is what made the setter's rule real. Without it, `t.c_ = -500` would bypass the clamp
and the type's guarantee would be a suggestion. `public:` reopens access, and `protected:` — private
to everyone except types derived from this one — matters from Chapter 13.

Access applies to the calls the compiler makes for you as well as the ones you write:

```tiko
{{#include ../examples/ch11/privatector.tiko}}
```

```text
privatector.tiko(15,17): error TKO0633: 'f' needs a constructor or destructor that is not accessible here
     |
  15 | dim as Fortress f                 '' needs both, and may call neither
     |                 ^
privatector.tiko(15,17): error TKO0633: 'f' needs a constructor or destructor that is not accessible here
     |
  15 | dim as Fortress f                 '' needs both, and may call neither
     |                 ^
```

A plain `dim` calls the constructor and, at the end of the scope, the destructor — so a type with
both private cannot be declared from outside at all. The message appears once for each. Making a
constructor private is how a type insists on being created through a function of its own choosing.

## Members that belong to the type

```tiko
{{#include ../examples/ch11/statics.tiko}}
```

```text
{{#include ../examples/ch11/statics.out}}
```

A **`static` field** exists once, shared by every object of the type, and needs a definition outside
the type — `dim as int32 Ticket.issued_ = 0` — in exactly one place. A **`static` method** has no
`this` and is called on the type itself, `Ticket.Issued( )`.

A **`const` method** promises not to change the object. It may read fields and call other `const`
methods, and the compiler holds it to the promise:

```tiko
{{#include ../examples/ch11/constmethod.tiko}}
```

```text
constmethod.tiko(8,5): error TKO0664: 'n' cannot be written from a const method
     |
   8 |     n += 1                            '' refused: Bump promised not to
     |     ^
```

```admonish warning title="Status in this version"
**A `const` object can call a method that is not `const`.** Given `dim as const Ticket k`, a plain
method that changes `k` compiles and runs, and `k` changes. The same through a
`byref t as const Ticket` parameter. fbc refuses both (`Const UDT cannot invoke non-const method`).

The half of the rule inside the method works, as the listing above shows; the half at the call site
does not. Tracked as **T36**. Mark every method that does not change the object `const` anyway — the
declaration is still true, and it will be checked once the gap closes.
```

## Objects on the heap

```tiko
{{#include ../examples/ch11/heapobjects.tiko}}
```

```text
{{#include ../examples/ch11/heapobjects.out}}
```

`new T( … )` allocates and runs the matching constructor; `delete` runs the destructor and then
frees. An array of objects in a scope constructs every element, using the default constructor, and
destroys them all — last first — when the scope ends.

**Placement `new`** — `new( address ) T( … )` — runs a constructor in memory you already have,
without allocating. It is for memory pools and for objects that must live at a particular address.
Because nothing was allocated, `delete` is wrong here: you call the destructor yourself, explicitly,
and free the memory the way you got it.

`new T[ n ]` and `delete[]` do the same for an array on the heap: a constructor for each element,
then a destructor for each, last first.

```tiko
{{#include ../examples/ch11/deletearray.tiko}}
```

```text
{{#include ../examples/ch11/deletearray.out}}
```

`delete[]` knows how many elements there are because, for a type with a destructor, `new[]`
recorded the count just before the first one. That is one more reason the families must not be
mixed: `delete` or `deallocate` on such memory starts at the wrong address.

## A builder that needs none of the three

```tiko
{{#include ../examples/ch11/stringbuilder.tiko}}
```

```text
{{#include ../examples/ch11/stringbuilder.out}}
```

Joining text with `&=` in a loop copies everything built so far on every pass. `StringBuilder` keeps
spare room in its buffer, writes each piece into it with Chapter 8's `mid` statement — which
overwrites in place and copies nothing — and grows by doubling, so growth is rare.

The copy at the end is the point. `StringBuilder` owns a buffer, and yet it has no copy constructor,
no `operator let` and no destructor — because its buffer is a `string`, which already knows how to
copy and free itself. That is the rule of zero in practice: let each field manage its own resource,
and the type composed of them needs no management at all.

## What it costs

- **A method call is a procedure call** with the object passed by reference. No lookup, no
  indirection — until Chapter 13 adds `virtual`, which adds one.
- **An object is the size of its fields.** Methods, properties and `static` fields add nothing to
  each instance.
- **A property is a call**, but a short one that the optimiser usually inlines. Use them freely.
- **A copy constructor runs on every `byval` pass and every return.** For a type that owns memory,
  that is an allocation each time — pass it `byref ... as const`.
- **Constructors and destructors run in scope order** — free at run time, but only correct if they
  are written to be.

## Summary

- Methods are declared in the type and defined as `Type.Member`; `this` is the object, and `this.`
  is optional.
- Constructors run on creation, destructors at the end of the scope, **in reverse order of
  creation**.
- Constructors overload; `this.constructor( … )` delegates. **A one-parameter constructor is an
  implicit conversion**, with no way to switch it off.
- **Rule of three:** a type with a destructor needs a copy constructor and an `operator let`, and the
  `let` must survive self-assignment. **Rule of zero:** better still, build from fields that copy
  themselves.
- Properties are methods that read like fields; the setter enforces the type's rules. **Give every
  property you read a getter (T35).**
- `private:` fields are reachable only from the type's own methods; access is enforced on the
  constructor and destructor calls the compiler makes too.
- `static` fields are shared and defined once; `static` methods have no `this`.
- `const` methods may not change the object — **but a `const` object can still call a non-`const`
  method at this version (T36)**.
- `new`/`delete` run constructor and destructor; placement `new` constructs in existing memory, and
  you call the destructor yourself. `new[]`/`delete[]` run them for every element.

## Exercises

1. Write an `IntStack` that keeps its items in memory from `reallocate`, with a constructor,
   destructor, copy constructor and `operator let`. Show that a copied stack and an assigned stack
   are both independent of the original. Route both copy paths through one private helper.
   {solution="ex11-01"}
2. Write a `Temperature` that stores kelvin and exposes `Celsius` and `Fahrenheit` as read-write
   properties, with the absolute-zero check in exactly one place. {solution="ex11-02"}
3. Give `Account` a private constructor and a `static function Create( … ) as Account` that refuses
   a negative opening balance. What can callers no longer do, and why is that the point?
4. Remove the self-assignment check from `copying.tiko`'s `operator let` and run `c = c`. What
   happens, and which line of `let` is responsible?
5. `Temp` converts silently from `float64`. Write a procedure taking a `Temp`, call it with a plain
   number, and decide whether that call should have compiled. How would you redesign `Temp` if not?
