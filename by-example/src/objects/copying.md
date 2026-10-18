# Copying

`dim as Contact b = a` makes `b` a copy of `a`. For most types that needs no
thought: the compiler copies every field, and each field knows how to copy
itself. A type that owns something through a pointer is different, and must
say what a copy means.

```tiko
{{#include ../../examples/objects/copying.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/copying.out}}
```

**The default copy copies each field.** `Contact` is two `ustring`s, and a
`ustring` copies its text, so changing `b.phone` leaves `a` alone. A type
built only from fields like these, numbers, strings and other well-behaved
objects, needs no copying code at all.

**A pointer field is copied as a pointer.** Without its own copy code,
`Samples` would give `y` the same `items` block as `x`: a write through one
would show in the other, and both destructors would free the same memory.
Two procedures prevent that:

| Procedure | Runs for | Must |
|---|---|---|
| copy constructor, `constructor( byref other as Samples )` | `dim as Samples y = x`, and every `byval` argument | make a new block and copy the values |
| `operator let( byref other as Samples )` | `z = x`, on an object that already exists | free the old block first, and do nothing when assigned to itself |

The self-assignment check in `operator let` matters: without it, `z = z`
would free `z`'s block and then copy from the memory it had freed.

The output shows the costs as well. `Inspect( x )` takes its parameter
`byval`, so a whole copy was made to call it. Pass an object `byref`, or
`byref as const` when the procedure only reads it, and no copy is made.

```admonish danger title="Pitfall"
A type that needs a destructor almost always needs a copy constructor and
an `operator let` too: the destructor is there because the type owns
something, and the other two decide what happens to that something when the
object is duplicated. Write all three or none.
```

### Activities

1. Remove the `if @this = @other` line, run `z = z`, and print `z.items[ 0 ]`.
   What did you get, and why is it not reliable?
2. Change `Inspect` to take `byref as const Samples` and check that the copy
   constructor no longer runs for it.
