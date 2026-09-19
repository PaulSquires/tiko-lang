[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -gen**

# Compiler Option: -gen

Sets the backend code emitter.

Syntax

`-gen < backend >`

Parameters

`backend`

`gas` for x86 GAS assembly, `gcc` for GNU C, `gas64` for x86_64 GAS assembly, `clang` for clang, `llvm` for LLVM IR.

Description

The `-gen` compiler option sets the backend code emitter and assembler. If this option is not specified, the default is `-gen gas` for x86 and `-gen gcc` for x86_64.

 **-gen gas**

The compiler will emit GAS assembler code to a `.asm` file which will then be compiled to an object file using '`as`'. This is fbc's original x86 code generation backend.

**-gen gas64**

The compiler will emit GAS assembler code (64-bit) to a `.asm` file which will then be compiled to an object file using '`as`'.

**-gen gcc**

The compiler will emit C code to a `.c` file which will then be compiled to an .asm file using '`gcc`' as a high level assembler. The C backend is intended to make FB portable to more platforms than just x86. This requires gcc to be installed so that fbc can invoke it to compile the C code, also see [Installing gcc for -gen gcc](Installing-Gcc-for-Gen-Gcc).

**-gen clang**

The compiler will emit C code to a `.c` file which will then be compiled to an .asm file using '`clang`' as a high level assembler.

**-gen llvm**

The compiler will emit LLVM IR code to a `.ll` file which will then be compiled to an .asm file using '`llc`'. The LLVM backend is still a work in progress. It is intended for the same purpose as the C backend, and could theoretically solve some of the C backend's problems, such as debugging meta data support.

Version

- `-gen clang` added in fbc 1.20.0

See also

- [Tools used by fbc](Tools-Used-by-Fbc)
- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
