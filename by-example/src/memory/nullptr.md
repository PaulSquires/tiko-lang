# nullptr

`nullptr` is the null pointer: an address of nothing. It converts to every
pointer type, and it is how a pointer says "there is no value here", such as
the end of a linked list.

```tiko
{{#include ../../examples/memory/nullptr.tiko}}
```

**Output**

```text
{{#include ../../examples/memory/nullptr.out}}
```

The list's last node holds `nullptr` in `nextNode`, and the loop tests for it
before following the link. That test is the whole discipline of null
pointers: **test a pointer that may be null before you follow it.**

`0` works as a null pointer too, but `0` is an integer, and wherever the
compiler has to choose a type, it chooses an integer's. Given an `integer`
overload and an `any ptr` one, `Show( 0 )` picks the integer and
`Show( nullptr )` the pointer, and `var` copies the same choice. Write
`nullptr` whenever you mean a pointer.

Following a null pointer is a bug, and under `-exx` the program stops at the
access instead of crashing somewhere further on:

```tiko
{{#include ../../examples/memory/nullcheck.tiko}}
```

```text
{{#include ../../examples/memory/nullcheck.out}}
```

The check covers `*p`, `p->x` and `p[i]`. The program ends with runtime error
7, and 7 is its exit status. Without `-exx` the same program crashes with an
access violation. Runtime errors in general are covered in
[Runtime errors](../errors/runtime.md).

### Activities

1. Add a fourth node to the front of the list.
2. In `nullcheck.tiko`, replace `p->x` with `*cptr( int32 ptr, p )`. Does the
   check still catch it?
