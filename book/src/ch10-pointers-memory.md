# Pointers, References and Memory

Every variable so far has lived somewhere the compiler chose and lasted as long as the compiler
decided. That is the right default, and most of a tiko program never needs anything else.

This chapter is about the rest: memory you ask for while the program runs, structures that link to
each other, and addresses you hand to code that expects them — C libraries, the operating system, a
buffer shared between two parts of a program. A **pointer** is the address of a value, and with it
comes the responsibility the compiler was carrying for you: knowing that the address is valid, and
giving the memory back.

Chapter 20 shows the tools that carry most of that responsibility again — destructors, `defer`,
shared pointers. Learn the raw form first, because every one of those tools is built on it.

## An address, and what lives at it

```tiko
{{#include ../examples/ch10/basics.tiko}}
```

```text
{{#include ../examples/ch10/basics.out}}
```

| Written | Means |
|---|---|
| `int32 ptr` | the type: an address of an `int32` |
| `@n` or `varptr( n )` | the address of `n` |
| `*p` | the value at `p` — readable and writable |
| `p->x` | field `x` of the type at `p`; the same as `( *p ).x` |
| `0` | the null pointer: an address of nothing |

Writing through `*p` changed `n`, because `p` holds `n`'s address — there is one value and two ways
to reach it. That sharing is the whole point of a pointer, and the source of every pointer bug.

## Arithmetic counts elements

```tiko
{{#include ../examples/ch10/arithmetic.tiko}}
```

```text
{{#include ../examples/ch10/arithmetic.out}}
```

`p + 1` does not mean "one byte later". It means **the next element**, so on an `int32 ptr` it moves
four bytes, on a `uint8 ptr` one, and on an `any ptr` — which has no element size — one. `p[2]` is
`*( p + 2 )`, which is why a pointer to an array's first element can be indexed like the array.

```admonish danger title="Pitfall"
**`@v + 3` is not three bytes past `v`.** If `v` is an `int32`, `@v` is an `int32 ptr`, and `+ 3`
moves three *`int32`s* — twelve bytes, well outside `v`. Reading there returns whatever happens to
be next in memory, and nothing reports it.

To step in bytes, step through a byte pointer: `cast( uint8 ptr, @v ) + 3`. The `peekpoke.tiko`
listing later in this chapter does exactly that — and its first draft did not, which is how this
pitfall got its example.
```

Comparison works as you would expect — `q <= last_` walks a run of elements — and subtracting two
pointers into the same array gives the distance between them in elements. Comparing pointers into
*different* blocks of memory tells you nothing useful.

## Changing what a pointer points at

```tiko
{{#include ../examples/ch10/conversions.tiko}}
```

```text
{{#include ../examples/ch10/conversions.out}}
```

`any ptr` is an address with no type attached. Every pointer converts to it, and it converts back
to any pointer type without a cast — which is what lets one procedure accept the address of
anything, and what `allocate` returns.

Between two *typed* pointers the compiler wants you to say what you mean. `cptr( T ptr, p )` and
`cast( T ptr, p )` reinterpret the address; without one, assigning a `float64 ptr` from an
`int32 ptr` draws `TKO0830: suspicious pointer assignment` — a warning, because sometimes it is
exactly what you want, and usually it is a bug.

The listing reads the four bytes of 70000 and then the two 16-bit halves. Both show the low part
first: on every target in this book the least significant byte has the lowest address.

```admonish danger title="Pitfall"
**Do not dereference an `any ptr`.** It has no element type, so there is nothing defined to read —
and at this version tiko does not stop you. `dim as int32 v = *a` compiles and reads garbage, `*a =
7` compiles and writes nothing, and `print *a` silently swallows the rest of the line.

fbc refuses all three with `Incomplete type`, which is the right answer. Tracked as **T31**. Convert
to a typed pointer first: `*cptr( int32 ptr, a )`.
```

```admonish note
The warning above names the types as `double ptr` and `long ptr`, though the source said `float64`
and `int32`. Diagnostics use the older spellings — they are the same types, as Chapter 3 said. It
is tracked with other wording issues as **T34**.
```

### const on either side

```tiko
{{#include ../examples/ch10/constptr.tiko}}
```

```text
constptr.tiko(11,1): error TKO0617: cannot modify 'fixed_': it is a constant
     |
  11 | fixed_ = @m                             '' refused
     | ^
constptr.tiko(10,1): error TKO0617: cannot modify '': it is a constant
     |
  10 | *readOnly = 1                           '' refused
     | ^
```

`const int32 ptr` is a pointer *to* constant data: it may be pointed elsewhere, but not written
through. `int32 const ptr` is a constant pointer: it always points at the same place, but what is
there may change. Read the declaration from the right — "a const pointer to an int32", "a pointer
to a const int32" — and the rule falls out.

The second diagnostic names `''` rather than `*readOnly`; that is T34 again, not a different rule.

## Asking for memory

```tiko
{{#include ../examples/ch10/buffer.tiko}}
```

```text
{{#include ../examples/ch10/buffer.out}}
```

| Call | Gives |
|---|---|
| `allocate( bytes )` | uninitialised memory, or 0 if there is none |
| `callocate( count, size )` | the same, zeroed |
| `reallocate( p, bytes )` | the block resized, contents kept — **possibly at a new address** |
| `deallocate( p )` | the memory back; `deallocate( 0 )` does nothing |
| `clear( dest, byte, count )` | `count` bytes at `dest` set to `byte` |

Three habits are in that listing, and each prevents a class of bug:

- **Check for 0.** Allocation can fail, and a null pointer used as a buffer fails much later and
  much less clearly.
- **Keep `reallocate`'s result in a new variable.** On failure it returns 0 *and leaves the old
  block alone*; writing the result straight over the only pointer you had leaks that block.
- **Set the pointer to 0 after `deallocate`.** A freed pointer still holds an address, and using it
  is the worst kind of bug: it usually works.

`clear` sets **bytes**, so `clear( *z, 255, … )` makes each `int32` −1, not 255. It is for zeroing
and for byte buffers, not for filling an array with a value.

## Typed allocation

```tiko
{{#include ../examples/ch10/newdelete.tiko}}
```

```text
{{#include ../examples/ch10/newdelete.out}}
```

`new T` allocates one `T`, zeroed; `new T[ n ]` allocates `n` of them. No `sizeof`, no cast, and the
pointer comes back typed. Pair them exactly: memory from `new` goes back with `delete`, memory from
`new[]` with `delete[]`, and memory from `allocate` with `deallocate`. Mixing the families is
undefined, and Chapter 11 shows the version where it visibly breaks — once a type has a destructor,
`delete` runs it and `deallocate` does not.

`new` takes a value too. For a type with no constructor the arguments fill the fields in order, as
`dim … = ( 3, 4 )` does, and any left out are zero:

```tiko
{{#include ../examples/ch10/newargs.tiko}}
```

```text
{{#include ../examples/ch10/newargs.out}}
```

`new int32( 42 )` works the same way for a single value. A type with a constructor takes its
arguments through that instead — Chapter 11.

## Structures that link

```tiko
{{#include ../examples/ch10/linkednodes.tiko}}
```

```text
{{#include ../examples/ch10/linkednodes.out}}
```

A linked list is the canonical heap structure: each node allocated separately, each pointing at the
next, the end marked by a null. `Push` puts a new node at the front in constant time, which is why
the list prints in reverse order of insertion.

Freeing it shows the rule that matters for every linked structure: **read the link before you
delete the node that holds it.** `head->next_` after `delete head` reads freed memory. It will
often produce the right answer, which is exactly why it ships.

## References

```tiko
{{#include ../examples/ch10/references.tiko}}
```

```text
{{#include ../examples/ch10/references.out}}
```

A **reference** is a second name for an existing variable. `byref` parameters are references the
caller sets up; `dim byref` makes one directly, and it must be bound when declared — there is no
null reference and no rebinding.

Underneath, a reference and a pointer are the same machine address. The difference is the promise:
a reference always refers to something, and is used like the variable it names. Prefer a reference
whenever "nothing" is not a valid answer, and a pointer when it is.

## The memory behind a string

```tiko
{{#include ../examples/ch10/emptystrptr.tiko}}
```

```text
{{#include ../examples/ch10/emptystrptr.out}}
```

`strptr( s )` is the address of a string's characters, which is what a C function wants. A string
owns that memory, and moves or frees it whenever it changes — so the pointer is valid only until
the next modification of the string, and only while the string exists.

```admonish danger title="Pitfall"
**`strptr` of an empty string is null.** An empty string owns no characters, so there is no address
to give. Assigning `""` releases the characters a string had, so this applies to a string that was
emptied, not only one that started empty.

A C function handed that pointer as "a string" will usually crash on it. Check for an empty string
at the boundary and pass a pointer to a real empty literal instead — Chapter 28 shows the pattern.
```

## Reading and writing raw memory

```tiko
{{#include ../examples/ch10/peekpoke.tiko}}
```

```text
{{#include ../examples/ch10/peekpoke.out}}
```

`peek( T, address )` reads a `T` at an address, and `poke T, address, value` writes one. They are
the explicit spellings of `*cptr( T ptr, address )`, useful when the type at an address is decided
by the code rather than by a declaration — parsing a binary format, for instance.

The output confirms what `conversions.tiko` showed: byte 0 of `&h01020304` is 4. These targets are
little-endian.

## When the pointer is null

```tiko
{{#include ../examples/ch10/nullcheck.tiko}}
```

```text
{{#include ../examples/ch10/nullcheck.out}}
```

Under `-exx`, reading or writing through a null pointer with `*` stops the program with runtime
error 7, and the process exits with status 7, instead of crashing somewhere further on. Without
`-exx` the same program crashes with an access violation.

The same check covers `->` and indexing — `p->x` and `p[i]` through null stop with error 7 too.
That is the common case: a null object pointer is reached through `->` far more often than
through `*`.

```tiko
{{#include ../examples/ch10/nullmember.tiko}}
```

```text
{{#include ../examples/ch10/nullmember.out}}
```

```admonish note
In both listings the error is the only output. A `print` placed before the bad access can appear
**after** the error message when output is redirected, because the message goes to the error
stream immediately and the `print` waits in a buffer. Debugging with a print just before a crash
needs that in mind.
```

## What it costs

- **A pointer costs 8 bytes and one indirection** on every access. Following a chain of them —
  `a->b->c` — is a chain of dependent memory loads, which is slower than walking an array.
- **Every allocation has overhead** in time and bookkeeping. A thousand small `new`s cost more than
  one `new[]` of a thousand.
- **A linked list scatters its nodes** across memory, so walking it misses the cache where an array
  would not. Use one when you need constant-time insertion in the middle, not by default.
- **Memory you allocate is memory you must free.** Every exit path, including errors. Chapter 20
  makes that automatic; here it is your job.

## Summary

- `T ptr` is an address; `@` takes one, `*` follows it, `->` reaches a field, and 0 is null.
- **Pointer arithmetic counts elements**: `p + 1` moves `sizeof( T )` bytes. Step in bytes through a
  `uint8 ptr`.
- `any ptr` converts to and from every pointer type; between typed pointers use `cptr` or `cast`.
- **Never dereference an `any ptr`** — tiko does not stop you at this version (T31).
- `const T ptr` cannot write through; `T const ptr` cannot be moved.
- `allocate`/`callocate`/`reallocate`/`deallocate`: **check for 0, keep `reallocate`'s result
  separately, null the pointer after freeing.** `clear` sets bytes.
- `new`/`delete` and `new[]`/`delete[]` allocate typed and zeroed memory — **pair each family with
  its own release**. `new T( a, b )` fills a constructor-less type's fields in order.
- **Read a node's link before deleting the node.**
- References are bound once and never null; prefer them when "nothing" is not a valid answer.
- **`strptr` of an empty string is null**, and any `strptr` is valid only until the string changes.
- `peek`/`poke` read and write a stated type at an address. The targets are little-endian.
- **`-exx` traps `*p`, `p->x` and `p[i]` through null** with runtime error 7. Still test a pointer
  that may be 0 before you follow it.

## Exercises

1. Write a growable `int32` buffer that doubles its capacity when it fills, using `reallocate`, and
   report each growth. Append twenty items and say how many times the buffer was copied.
   {solution="ex10-01"}
2. Reverse a singly linked list in place by changing the links, not the values. Make sure an empty
   list and a one-node list both survive. {solution="ex10-02"}
3. Print the address of each element of an `int64` array and of a `uint8` array. What is the
   difference between consecutive addresses in each, and why?
4. Allocate a block, free it, and then read through the old pointer. Run it several times. What does
   it print, and why is "it printed the right value" not evidence that the code is correct?
5. Write a procedure that takes a `string` and passes `strptr` of it to a procedure expecting a
   `zstring ptr`, which prints the text. What must it do when the string is empty?
