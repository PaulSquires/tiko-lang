# using and import names

Writing `containers.` in front of every name is clear, but it gets long in a
file that uses one module heavily. Two tools shorten it: `#import … as` gives
the module another name in this file, and `using` makes a module's public names
usable with no prefix at all.

```tiko
{{#include ../../examples/modules/using.tiko}}
```

**Output**

```text
{{#include ../../examples/modules/using.out}}
```

- **`#import "std/strings" as txt`** renames the module for this file only.
  The module is still `strings`; only the spelling here changes. Use it when
  two imports end in the same name, or when a name is long. The new name must
  not be a keyword or a built-in: `as str` is refused, because `str` is a
  built-in function.
- **`using containers`** makes `Array` a bare name from that line to the end of
  the file. Written inside a procedure, it lasts to the end of the procedure.
  The qualified spelling, `containers.Array`, keeps working.

`using` makes names *available*; it never chooses between two of them. When two
modules you are using both supply a name, a bare use of it is refused:

```tiko
{{#include ../../examples/modules/ambiguous.tiko}}
```

```text
ambiguous.tiko(7,7): error TKO0919: 'contains' is ambiguous: more than one USING in effect declares it; qualify it
     |
   7 | print Contains( "tiko", "k" )      '' refused: which Contains?
     |       ^
```

Write `strings.Contains` and the question has an answer in the source.

### Activities

1. Remove `using containers` and fix the program by qualifying `Array`.
2. Move `using containers` inside a `sub` and find the first line where
   `Array` is no longer a bare name.
