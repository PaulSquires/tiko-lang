# Visibility

A module decides which of its names are its interface. The default is the
cautious one: a name you forget to mark stays inside the module, so you can
change it later without breaking anyone.

This module has two files. `scores.tiko` holds the interface:

```tiko
{{#include ../../examples/modules/scores/scores.tiko}}
```

and `rules.tiko` the helpers it calls:

```tiko
{{#include ../../examples/modules/scores/rules.tiko}}
```

The program can use only `Grade`:

```tiko
{{#include ../../examples/modules/visibility.tiko}}
```

**Output**

```text
{{#include ../../examples/modules/visibility.out}}
```

| You write | Visible to |
|---|---|
| `public` | every file that imports the module |
| nothing | every file of this module, and no importer |
| `private` | this module only; outside it the name does not exist |

`Grade` in one file calls `Letter_` and `Clamp_` from the other: the files of a
module see each other's names, whatever their visibility. From outside, the two
helpers are refused in different ways. A module-private name is known but
closed:

```tiko
{{#include ../../examples/modules/notpublic.tiko}}
```

```text
notpublic.tiko(3,14): error TKO0860: 'letter_' is not public in module 'main.scores'
     |
   3 | print scores.Letter_( 95 )      '' refused: Letter_ is not public
     |              ^
```

`main.scores` is the module's full name: a program with no `tiko.toml` is the
package `main`. A `private` name is not there at all:

```tiko
{{#include ../../examples/modules/notvisible.tiko}}
```

```text
notvisible.tiko(3,14): error TKO0745: the namespace 'scores' has no member named 'clamp_'
     |
   3 | print scores.Clamp_( 130 )      '' refused: private names are not seen
     |              ^
```

The trailing `_` on the helpers' names is a convention, not a rule: a
reminder in the code that a name is not part of the interface.

### Activities

1. Mark `Letter_` `public` and call it from the program.
2. Add a public function whose result type is a `type` declared without
   `public`, and read what the compiler says about it.
