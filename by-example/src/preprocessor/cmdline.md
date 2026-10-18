# Defines from the build

A switch is most useful when the build sets it, so one source makes several
programs. The `-d` option defines a name before the first line of the file:
`tiko app.tiko -d EDITION=2` behaves as if the file began with
`#define EDITION 2`. A `#cmdline` line puts such options in the source itself:

```tiko
{{#include ../../examples/preprocessor/cmdline.tiko}}
```

**Output**

```text
{{#include ../../examples/preprocessor/cmdline.out}}
```

- **`#cmdline "-d EDITION=2 -d SEATS=25"`** adds those options to the
  compile, as if they had been typed after `tiko cmdline.tiko`. When the
  compiler meets the line, it starts the compile again with them.
- **`#ifndef EDITION`** gives the setting a default, so the program also
  builds when nothing chose a value.
- **The source wins.** With the `#cmdline` line in place,
  `tiko cmdline.tiko -d EDITION=1` still builds the professional edition. Take
  the line out and the same command builds the standard one; with no `-d` at
  all, the default applies and `SEATS` is not defined.

`#cmdline` counts only in the first source file named on the command line;
in any other file it is warning `TKO0334`, "#cmdline is ignored outside the
first source file". It is not limited to `-d`: any compiler
option can go there, which is how the examples on this site carry flags such
as `-exx` (see [Building](../building/index.md)).

A module never sees the defines of the program that imports it, from `-d` or
from `#define`: it is compiled once for every program that uses it. A setting
for a module goes in its package's `tiko.toml` (see
[Packages](../modules/packages.md)).

### Activities

1. Remove the `#cmdline` line and build with `-d EDITION=3`.
2. Add `-d TRIAL=1` to the `#cmdline` line and print a notice under
   `#ifdef TRIAL`.
