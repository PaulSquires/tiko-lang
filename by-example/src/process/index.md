# Program and Environment

A program does not run alone. Whoever starts it passes **arguments**, the
process inherits **environment variables** from its parent, and when it ends it
hands back an **exit code** that says whether it succeeded. These are the
channels a command-line tool, a build script or a service uses to talk to the
world around it.

```tiko
{{#include ../../examples/process/overview.tiko}}
```

Run as `overview red "green blue"`:

**Output**

```text
{{#include ../../examples/process/overview.out}}
```

The arguments arrive already split, with the shell's quotes removed: `"green
blue"` is one argument. `setenviron` and `environ` set and read a variable, and
reaching the end of the program is a successful exit, code 0.

The pages in this section take each channel in turn:

- [Command-line arguments](args.md): `command( n )` and its relatives.
- [Environment variables](environment.md): `environ` and `setenviron`.
- [Exit codes](exit.md): `end n`.
- [Running other programs](run.md): `exec`, `shell` and `open pipe`.

Reading and writing files is covered in [its own section](../files/index.md).

### Activities

1. Run the program with no arguments, then with five.
2. Pass an argument that contains a quote character, and see how your shell
   wants it written.
