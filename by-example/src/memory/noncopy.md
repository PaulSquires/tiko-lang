# Non-copyable types

A type that owns a resource has to decide what a copy means. If a `Buffer`
that owns a block of memory were copied field by field, two objects would
hold the same address, and two destructors would free it twice. For a
resource with one owner, the right answer is usually to refuse copies.

```tiko
{{#include ../../examples/memory/buffer.tiko}}
```

**Output**

```text
{{#include ../../examples/memory/buffer.out}}
```

The constructor allocates and the destructor frees, so the code that uses a
`Buffer` contains no cleanup at all: `block` is freed at `end scope`.

The two `private` declarations are what make it safe. The copy constructor
and `operator let` are declared and never defined, and because they are
private, no code outside the type can reach them. Passing the buffer
`byref`, as `Total` does, makes no copy, so it is allowed. Anything that
would make a second owner is refused when the program is compiled:

```tiko
{{#include ../../examples/memory/nocopy.tiko}}
```

```text
nocopy.tiko(13,5): error TKO0633: 'b' needs a constructor or destructor that is not accessible here
     |
  13 | dim b as Buffer = a                     '' a second owner? refused
     |     ^
```

Assigning one buffer to another, `b = a`, reaches the private `operator let`
instead and is refused with `TKO0746: the operator let of 'buffer' is private
or protected and cannot be reached from here`. Passing a `Buffer` `byval`
would copy it and is refused with `TKO0633` too.

A type that owns something can copy it properly, be built from parts that copy
themselves, or refuse to be copied. For a resource the system gives you once,
such as a block of memory, a lock or a handle, refusing is usually right.

### Activities

1. Add a `Fill( byval value as uint8 )` method and use it before `Total`.
2. Write a `Total` that takes the buffer `byval`, and read the error.
