[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -o**

# Compiler Option: -o

Set object file path/name

Syntax

`-o < output file >`

Parameters

`output file`

The name, with optional path, of the object file to create.

Description

The `-o` option can be used to specify the file name for the object file created while compiling an input file. By default, the name for the object file (and other temporaries like assembly files) is based on the name of the corresponding input file, but with an `.o` extension. This option is useful for example in combination with [`-c`](Compiler-Option-C), or to force the compiler to create temporary object files in other directories (if, for example, the source code directory is or should be treated as read-only).

 Given `-o` options are only assigned to input files that need to be compiled, namely `*.bas`, `*.rc`, `*.res` and `*.xpm`.

 Note: `-o` options can appear in front of or behind the input file they correspond to, but there cannot be multiple `-o` options for one input file. For example, these are all accepted:

`fbc 1.bas -o 1.o`  
 `fbc -o 1.o 1.bas`  
 `fbc 1.bas -o 1.o 2.bas -o 2.o`  
 `fbc 1.bas -o 1.o -o 2.o 2.bas`

However, this is an error:

`fbc 1.bas 2.bas -o 1.o -o 2.o`

The [`-v`](Compiler-Option-V) option makes the compiler show the actual file names that it uses.

See also

- [Compiler Option: -b](Compiler-Option-B)
- [Compiler Option: -c](Compiler-Option-C)
- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
