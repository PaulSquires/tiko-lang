# Environment variables

Every process has a set of named text values, its *environment*, copied from
the process that started it. Settings such as a search path, a language or a
log level often travel this way.

```tiko
{{#include ../../examples/process/environment.tiko}}
```

**Output**

```text
{{#include ../../examples/process/environment.out}}
```

`environ( name )` reads a variable. A variable that is not set reads as an
empty string, the same as one set to nothing, so a program that needs a
default writes a helper like `EnvOr`.

`setenviron "NAME=value"` sets a variable for this process and for the programs
it starts afterwards, which inherit a copy (see
[Running other programs](run.md)). It never changes the environment of the
shell or program that started yours.

`environ` returns a `string`. `EnvOr` stores it in a `ustring` before the
`iif`, because `iif` needs both of its results to be the same kind of string:
mixing them is `TKO0946: iif cannot choose between a narrow string and a
ustring`.

The example sets its own variables rather than reading `PATH` or `HOME`,
because those differ from machine to machine.

### Activities

1. Set `BYEXAMPLE_LEVEL` in your shell before running the program, and watch
   `EnvOr` return it.
2. Print `environ( "PATH" )` and count its entries.
