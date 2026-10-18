# Compile-time checks

Some mistakes can be caught before the program ever runs: a record whose
layout changed, a build made without a setting it needs. The preprocessor can
test these while it reads the source, and stop the build when the answer is
wrong.

```tiko
{{#include ../../examples/preprocessor/checks.tiko}}
```

**Output**

```text
{{#include ../../examples/preprocessor/checks.out}}
```

While it compiles, the program also reports its `#print` line:

```text
checks.tiko(23,1): note TKO0315: #print the Header layout is checked
     |
  23 | #print the Header layout is checked
     | ^
```

- **`#assert cond`** stops the build when `cond` is false. Change the `8` to
  `12` and the build fails with `TKO0604`, "#assert condition failed". A
  record that is written to files is a good place for one: the build stops
  before a file in the old layout is misread.
- **`#if typeof( a ) = typeof( b )`** compares two types exactly: `int32` is
  not `int64`.
- **`#print text`** reports its text as a note, `TKO0315`, and the build goes
  on.

**`#error`** stops the build with a message of your own:

```tiko
{{#include ../../examples/preprocessor/needconfig.tiko}}
```

```text
needconfig.tiko(3,5): error TKO0309: #error: "build with -d CONFIG=1 (development) or -d CONFIG=2 (release)"
     |
   3 |     #error "build with -d CONFIG=1 (development) or -d CONFIG=2 (release)"
     |     ^
```

Built with `-d CONFIG=2`, the same file prints `configuration 2`. Keep the
code that needs the setting in the `#else` branch: the compiler reads on past
an `#error` to report everything it can, so code after the `#endif` that used
`CONFIG` would add a second error.

For checks on values while the program runs, see
[Error Handling](../errors/index.md).

### Activities

1. Add a `flags as uint16` field to `Header` and read the error.
2. Write an `#if` that stops the build with `#error` unless `__FB_64BIT__` is
   defined.
