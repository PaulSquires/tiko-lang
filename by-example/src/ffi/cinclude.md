# Reading a C header

Writing a binding by hand means copying every type and declaration out of a
header and getting each one right. **`#cinclude`** reads the header itself: it
hands the header to clang, the C compiler, and turns what clang reports into
tiko declarations, for the platform being built.

```tiko
{{#include ../../examples/ffi/cinclude.tiko}}
```

**Output**

```text
{{#include ../../examples/ffi/cinclude.out}}
```

The example has no `type`, no `declare` and no `extern`. `div_t`, `div`,
`strlen`, `qsort` and the constant `RAND_MAX` all come from the C runtime's
own headers, as they are written on the platform being built. C's `int`
becomes a 32-bit integer and its `long` becomes `clong`, so the
[types](ctypes.md) are right on every platform without your having to think
about them.

What comes across: structs and unions, enums, `typedef`s, functions, function
pointer types, global variables, and `#define`s that are constants. Macros with
parameters do not, since they are C code rather than declarations. Every name
keeps its C spelling through `alias`, and a name that would collide with a tiko
keyword or function gets an underscore: C's field `rem` is `rem_`, and C's
`abs` is `abs_`, so `abs` stays tiko's own.

A quoted header is looked for under the directory the compiler runs in, then
beside the file that says `#cinclude`, and then among the system's headers.
`-cinclude dir` adds a directory to search, and
`tiko -cimport header.h -cimport-out -` prints the declarations a header
becomes, without compiling anything.

The layout of every imported struct is checked against clang's, field by field,
so a struct comes across correctly or not at all.

### Activities

1. `#cinclude` `"ctype.h"` and call `isdigit` on each character of `"a1b2"`.
2. Run `tiko -cimport string.h -cimport-out -` and find `strlen` in the output.
