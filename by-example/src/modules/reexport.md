# Re-exporting

An import belongs to the file that writes it. A module that uses `scores`
internally does not hand `scores` to its own importers, so it is free to
replace it later. When a module *does* want to pass one of its imports on, it
adds `public` to the `#import`:

```tiko
{{#include ../../examples/modules/kit/kit.tiko}}
```

```tiko
{{#include ../../examples/modules/reexport.tiko}}
```

**Output**

```text
{{#include ../../examples/modules/reexport.out}}
```

The program imports only `kit`. Because `kit` re-exports `greet`, the program
reaches it as `kit.greet.Hello`. `kit` imports `scores` without `public`, so
that one stays out of reach:

```tiko
{{#include ../../examples/modules/noleak.tiko}}
```

```text
noleak.tiko(3,11): error TKO0745: the namespace 'kit' has no member named 'scores'
     |
   3 | print kit.scores.Grade( 88 )    '' refused: kit did not re-export scores
     |           ^
```

A program that needs `scores` imports it itself. Re-export a module when your
own interface is incomplete without it: when a type from that module appears
in your public procedures, for example.

### Activities

1. Add `public` to `kit`'s import of `scores` and make `noleak.tiko` compile.
2. Import `greet` directly in `reexport.tiko` as well, and call it both ways.
