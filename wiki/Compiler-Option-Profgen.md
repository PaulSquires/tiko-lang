[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Compiler Option: -profgen**

# Compiler Option: -profgen

Enable function profiling by selecting a specific profiler

Syntax

`-profgen < profiler >`

Description

The `-profgen` compiler option enables function profiling by selecting a specific profiler among different profiler code generation backends.

 **-profgen fb**

Enable function call profiling using fb's profiler. After running an executable compiled with this option, a `<filename[.exe]>.prf` file containing the profiling report will be created in the program directory.

**-profgen cycles**

Enable cycle count profiling on some targets using fb's profiler. After running an executable compiled with this option, it can generate a basic report of cycle counts.  
 (currently a work in progress on `-gen gas64` only)

**-profgen gmon**

Enable profiling code generation for gmon/gprof. After running an executable compiled with this option, a `gmon.out` file will be created in the program directory, allowing use of GPROF for analysis of the program's execution.

Version

- Since fbc 1.20.0

See also

- [Compiler Option: -profile](Compiler-Option-Profile)
- [Profiling with fb's profiler](Profiling-with-Fb-S-Profiler)
- [Profiling for gmon/gprof](Profiling-for-Gmon-Gprof)
- [Using the Command Line](Fbc-Command-Line)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
