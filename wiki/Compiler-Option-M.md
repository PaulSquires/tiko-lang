[Home](Home) › **Compiler Option: -m**

# Compiler Option: -m

Main file without extension to indicate the main module

Syntax

`-m < source file >`

Parameters

`source file`

The name without extension of the main module source file

Description

The `-m` compiler option specifies a main entry point for a source file; the argument is the name of a source file minus its extension.  
 So the main module file must be called twice in the command line:

**-** after compile option "-m", but without specified extension,
 **-** and also like any module to compile, but there with its specified extension.

WARNING: the spelling of < *source file* > is case-sensitive! (unexpected ERRORS may otherwise occure)  
 If "-m" is not specified, the first source file listed is given a main entry point.

 When using the "-c" or "-r" switch, "-m" must be specified when compiling a main source file.

 The intrinsic macro [`__FB_MAIN__`](Fb-Main) is defined in the main module and not defined in other modules.

See also

- [`__FB_MAIN__`](Fb-Main)
- [Compiler Option: -c](Compiler-Option-C)
- [Compiler Option: -r](Compiler-Option-R)
- [Using the Command Line](Quick-Start#compile-a-program)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
