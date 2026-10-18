# Hello World

This is the source of the traditional first program:

```tiko
{{#include ../../examples/hello/hello.tiko}}
```

**Output**

```text
{{#include ../../examples/hello/hello.out}}
```

A tiko program needs no `main` procedure and no boilerplate around it. The
statements at the top level of the file *are* the program, and they run from
top to bottom. `print` writes its arguments to standard output and ends the
line.

Compile it with the `tiko` command and run the result:

```bash
tiko hello.tiko
./hello
```

The program takes the source file's name, so on Windows it is `hello.exe`.
`-o` names the output yourself, exactly as written: `-o greet` writes a file
called `greet`, so on Windows give it the extension, `-o greet.exe`. tiko produces one self-contained
executable: there is no runtime to install beside it.

### Activities

1. Change the text and print a second line under the first.
2. Compile with `-v` added to the command line and read the steps tiko takes
   to turn the source into a program.
