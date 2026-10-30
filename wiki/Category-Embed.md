[Home](Home) › [All Categories](Categories) › **Embed**

# Embed

```freebasic
#embed Logo "assets/logo.png"
#embed Usage "usage.txt"

print "logo: "; ubound( Logo ) + 1; " bytes"
print *cast( zstring ptr, @Usage(0) )
```

`#embed` puts a file's bytes inside the program at compile time. `Logo` is a read-only array holding every byte of `logo.png`; `Usage` holds `usage.txt` and is printed straight from where it lies. The program needs neither file at run time.

## Why It Exists

A program that ships with fonts, icons, themes, shaders, test data or help text otherwise carries them as separate files beside the executable and has to find them when it starts. `#embed` makes them part of the executable, the same way on Windows, Linux and macOS, with no tool outside the compiler. The compiler reads the file once, during code generation, so even a file of several megabytes compiles in a fraction of a second.

## The Directive

```freebasic
[public] #embed NAME "path"
```

It declares, where it stands, the equivalent of

```freebasic
dim shared as const ubyte NAME( 0 to N - 1 )
```

filled with the file's `N` bytes:

- **One element per byte.** `lbound( NAME )` is 0 and `ubound( NAME ) + 1` is the file's size.
- **A NUL after the last byte**, outside the bounds. A text file can therefore be used as a `zstring` without a copy: `*cast( zstring ptr, @NAME(0) )`.
- **Read-only.** The array is `const`, so assigning to an element is a compile error, and the bytes live in the executable's read-only data.
- **Bytes, unchanged.** No encoding is assumed, no byte order mark is removed and no line endings are converted.
- **Aligned.** A file of 8 bytes or more starts on an 8-byte boundary.

`NAME` follows the rules of any other shared variable: it must be unique in its scope, and it can be used from every procedure in the file.

## Where It Can Go

At module level and inside a `namespace`, anywhere a `dim shared` can go. Inside a procedure it is error `TKO0726`, because the variable it declares is shared. A `#embed` in a skipped `#if` branch reads nothing.

In a [module](Packages-and-Modules-Tutorial), the array is private to the module. Write `public #embed` to export it: importers see its name and bounds through the interface, and the bytes stay in the module's object.

```freebasic
' libs/acme/res/res.tiko
#module "res"
public #embed Logo "logo.png"

' main.tiko
#import "acme/res"
print ubound( res.Logo ) + 1
```

## Finding the File

The path is searched exactly as an `#include "..."` path is:

1. the folder of the file that holds the `#embed`. A header that embeds `"data.bin"` finds the file beside the header, wherever the header is included from;
2. the working directory;
3. each `-i` folder, then the toolchain's include folder.

An absolute path is used as written.

## Builds and Caching

An embedded file is a dependency of the code that embeds it, in the same way as an included file. When it changes, `tiko build` and the module cache rebuild that code, and the program gets the new bytes and the new bounds.

## Using the Bytes

Most libraries that load data take a pointer and a size:

```freebasic
#embed Font "fonts/Inter-Regular.ttf"

' SDL_ttf opens a font from memory; nothing is copied
dim as TTF_Font ptr f = TTF_OpenFontIO( SDL_IOFromConstMem( @Font(0), ubound( Font ) + 1 ), true, 14 )
```

A text file used as a string:

```freebasic
#embed Help "help.txt"

dim as string text = *cast( zstring ptr, @Help(0) )   ' a copy, if a string is needed
```

## Errors

| Id | When |
| --- | --- |
| `TKO0341` | The file is not found in any of the folders searched. |
| `TKO0342` | The line is malformed: no name, no quoted path, or anything after the path. |
| `TKO0344` | The file is empty. An array cannot have no elements. |
| `TKO0345` | The file is larger than 256 MiB. |
| `TKO0346` | The file changed between the start of the build and the moment its bytes were read. |

## Names

`embed` is not a keyword. It can be a variable, and `#embed` in the middle of a line is still a file number: `print #embed, "x"` writes to file number `embed`. Only `#embed` at the start of a line is the directive.

See [Compatibility](Compatibility).
