[Home](Home) › **Compiler Option: -arch**

# Compiler Option: -arch

Set target architecture for improved/restricted code generation or cross-compiling

Syntax

`-arch < architecture >`

Parameters

`architecture`

The target architecture. Recognized values:

Description

The `-arch` compiler option sets the target CPU architecture. This can be used for multiple purposes:

The exact impact which the `-arch` setting has on code generation depends on the [code generation backend](Compiler-Option-Gen) that is being used. The x86 ASM backend (`-gen gas`) handles the `-arch` setting and adjusts code generation accordingly in some cases. When using the GCC backend (`-gen gcc`), the specified architecture will be passed on to gcc via `gcc -march=<...>`, causing gcc to generate code for the specified architecture.

 However, `-arch` only affects newly generated code, but not pre-compiled code such as the FreeBASIC runtime libraries, or any other library from the `lib/` directory. For example, using `-arch 386` is not necessarily enough to get a pure i386 executable -- it also depends on how all the libraries that will be linked in were compiled.

 The `-arch 32` and `-arch 64` shortcuts are similar to gcc's `-m32/-m64` options. On 32bit architectures, `-arch 64` is an abbreviation for cross-compiling to the default 64bit version of the architecture (e.g. from 32bit x86 to 64bit x86_64, or 32bit ARM to 64bit AArch64, or 32bit PowerPC to 64bit PowerPC), and `-arch 32` does nothing. On 64bit systems, it is the other way round: `-arch 32` cross-compiles to the default 32bit architecture, while `-arch 64` does nothing.

 The `-arch native` shortcut is similar to gcc's `-march=native` option. On x86, it causes the compiler to try and detect the host CPU automatically based on the `cpuid` instruction and its availability or results. On other architectures, this will currently simply use the architecture which the compiler itself was built for. Under -gen gcc this will use `gcc -march=native`.

 Specifying an `-arch` setting incompatible to the native architecture will trigger cross-compilation, just like the [`-target`](Compiler-Option-Target) option, except that only the target architecture, but not the target operating system, is changed.

Version


See also

- [Using the Command Line](Quick-Start#compile-a-program)
- [-target](Compiler-Option-Target)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
