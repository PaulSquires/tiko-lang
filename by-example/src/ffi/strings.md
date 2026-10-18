# C strings

A C string is a run of bytes ending in a zero byte, reached through a
`char *`. In tiko that is a `zstring ptr`. Text crosses the boundary in both
directions, and each direction has one rule to remember.

```tiko
{{#include ../../examples/ffi/cstrings.tiko}}
```

**Output**

```text
{{#include ../../examples/ffi/cstrings.out}}
```

**Into C.** `strptr( s )` is a pointer to a `string`'s own bytes, which end in a
zero, so C can read them in place. It stays valid until the string next
changes. A string literal passes straight to a `const zstring ptr`. A `ustring`
passed where C wants a `const zstring ptr` is converted to UTF-8 for the call,
which is why `café` has 4 characters for `len` and 5 bytes for `strlen`.

**Out of C.** A `zstring ptr` that C returns points at C's memory. `*p` reads
the characters into a tiko string, which copies them; copy at once, because C
may reuse or free that memory. Pointer arithmetic works as in C: `eq + 1` is
the character after the `=`. A C function that finds nothing usually returns a
null pointer, so compare with `nullptr` before reading through it.

**Memory C allocates, C must free.** The example copies the text into memory
from `malloc`, reads it into a `ustring` (a copy) and only then calls `free`.
A C library's documentation says who frees what it returns; the C runtime's
`free` is right only for the C runtime's `malloc`.

### Activities

1. Declare C's `strrchr` and print what follows the last `=` in `"a=b=c"`.
2. Declare `toupper` and use it to upper-case a `zstring * 16` in place.
