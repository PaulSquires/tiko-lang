# Suffixes and string types

In older code a variable often had no declaration at all: a **suffix** on its
name gave it a type, `%` an integer, `&` a long, `!` a single, `#` a double,
`$` a string. tiko needs every variable declared with its type:

```tiko
{{#include ../../examples/compat/suffix.bas}}
```

```text
suffix.bas(3,5): warning TKO0206: suffix ignored in 'count%'
suffix.bas(3,13): warning TKO0206: suffix ignored in 'title$'
...
suffix.bas(3,5): error TKO0320: 'count' has no type; tiko-lang implements #lang "fb" only, where default types and suffixes are not valid
suffix.bas(3,13): error TKO0320: 'title' has no type; tiko-lang implements #lang "fb" only, where default types and suffixes are not valid
```

(The warnings repeat for each use, and each line comes with its source
excerpt, left out here.) Each warning is a suffix being thrown away; the
errors stop the build, because without its suffix the variable has no type.
The fix is a declaration: `dim as int32 count` and `dim as ustring title`.

The `$` suffix stood for `string`, which tiko still has. It is the legacy
string type, and it holds **bytes**. Modern tiko code uses `ustring`, which
holds **text**:

```tiko
{{#include ../../examples/compat/strings.bas}}
```

**Output**

```text
{{#include ../../examples/compat/strings.out}}
```

The source is UTF-8, so the accented letter `é` (U+00E9) is two bytes. A
`string` stores those two bytes and counts them: `len` is 5, `asc` reads the
first byte, 195, and `ucase` cannot see a letter in them. A `ustring` stores
characters: `len` is 4, `asc` reads the code point, 233, and `ucase` turns `é`
into `É`.

Old code that treats a `string` as a byte buffer (file records, binary
protocols) keeps working. Code that handles text, typed by people or read from
UTF-8 files, should move to `ustring`; the [Strings](../strings/index.md)
section shows it in full.

### Activities

1. Declare the two variables in `suffix.bas` properly and make it compile.
2. Print `mid( bytes, 4, 1 )` and `mid( text, 4, 1 )` and explain the
   difference.
