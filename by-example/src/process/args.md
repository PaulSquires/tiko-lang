# Command-line arguments

`command( n )` returns the `n`-th argument the program was started with,
counting from 1. There is no count to read first: past the last argument,
`command( n )` is an empty string, so a loop stops at the first empty one.

```tiko
{{#include ../../examples/process/args.tiko}}
```

Run as `args --verbose "two words" 3`:

**Output**

```text
{{#include ../../examples/process/args.out}}
```

| Expression | Gives |
|---|---|
| `command( n )` | argument `n`, or `""` past the last |
| `command( )` | all the arguments in one string, separated by spaces |
| `command( 0 )` | the program's own path, as it was started |
| `__FB_ARGC__` | the number of arguments, counting the program itself |
| `__FB_ARGV__` | the arguments as a C array, a `zstring ptr ptr` |

`command( )` loses the boundaries between arguments: `two words` cannot be told
apart from two arguments `two` and `words`. Loop over `command( n )` when the
boundaries matter.

`command( 0 )` is whatever path the program was started by, absolute or
relative, so the example prints only that it is there.

`__FB_ARGC__` and `__FB_ARGV__` are the form a C library that parses its own
command line expects. They belong to the top level of the main file; inside a
procedure they are not declared. `*__FB_ARGV__[ 2 ]` reads the third entry,
counting the program as entry 0.

### Activities

1. Make the program print `usage: args NAME` and stop when it is given no
   arguments.
2. Accept `--verbose` anywhere in the arguments and print the others.
