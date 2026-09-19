[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **fbc command-line**

# fbc command-line

Using the **fbc** command-line.

The official FreeBASIC distribution comes with **fbc**, FreeBASIC's flagship compiler. **fbc** is a command line compiler, and can be launched from the console - from DOS, the Windows command prompt or a Linux shell. Running **fbc** from the console without any arguments displays a list of available options, or command-line switches, that can be used to adjust the behavior of the compiler.

 At its simplest, **fbc** takes a source file as a command-line argument and produces an executable file. It does this by compiling the source file (.bas) into an assembly (.asm) file, then compiling this into an object file (.o) using GAS and finally linking using LD this object file to other object files and libraries it needs to run, producing the final executable file. The assembly and compiled object files are deleted at this point by default. For example, the following command,

`fbc foo.bas`

produces the executable `foo.exe` in DOS and Windows, and `./foo` in Linux. **fbc** can accept multiple source files at once, compile and link them all into one executable. For example, the following command,

`fbc foo.bas bar.bas baz.bas`

produces the executable `foo.exe` in DOS and Windows, and `./foo` in Linux. Since `foo.bas` was listed first, it will be the main entry point into the executable, and also provide its name. To specify a different entry point or executable name, use the "-m" and "-x" switches, respectively. To have, for example, `baz.bas` provide the main entry point into an executable called `foobar.exe`, you would use

`fbc -x foobar.exe -m baz foo.bas bar.bas baz.bas`

The "-x" switch names the executable verbatim, so in Linux, the executable produced from the above command would be called `./foobar.exe`.

Syntax

`fbc [ options ] [ input_list ]`

 Where *input_list* is a list of filenames. Accepted files are:

| File extension | Description |
| --- | --- |
| .bas | FreeBASIC source file |
| .a | Library |
| .o | Object file |
| .rc | Resource script (Windows only) |
| .res | Compiled resource (Windows only) |
| .xpm | X icon pixmap (Linux only) |

***Source code***

**[-b < name >](Compiler-Option-B)**

Add a source file to compilation

**[-i < name >](Compiler-Option-I)**

Add a path to search for include files

**[-include < name >](Compiler-Option-Include)**

Include a header file on each source compiled

**[-d < name=val >](Compiler-Option-D)**

Add a preprocessor's define

**[-lang < name >](Compiler-Option-Lang)**

Select language mode: `fb`, `fblite`, `qb`, `deprecated`

**[-forcelang < name >](Compiler-Option-Forcelang)**

Select language mode: `fb`, `fblite`, `qb`, `deprecated` (overrides statements in code)

***Code generation***

**[-target < platform >](Compiler-Option-Target)**

Set the target platform for cross compilation

**[-gen < backend >](Compiler-Option-Gen)**

Sets the compiler backend (default is 'gas' for x86 and 'gcc' for x86_64)

**[-asm < format >](Compiler-Option-Asm)**

Sets the assembler format for Asm block

**[-arch < type >](Compiler-Option-Arch)**

Set target architecture

**[-O < level >](Compiler-Option-O-2)**

Set the optimization level (-gen gcc)

**[-vec < level >](Compiler-Option-Vec)**

Set level of vector optimizations enabled by the compiler (default: `0`)

**[-fpu < type >](Compiler-Option-Fpu)**

Set the floating point arithmetics unit (default: `X87`)

**[-fpmode < type >](Compiler-Option-Fpmode)**

Select between fast and accurate floating-point operations (default: `PRECISE`)

**[-z < value >](Compiler-Option-Z)**

Sets miscellaneous or experimental options

**[-pic](Compiler-Option-Pic)**

Generate position-independent code (non-x86 Unix shared libs)

***Compilation***

**[-m < name >](Compiler-Option-M)**

Define main file (without extension), the entry point (default is the first .bas file on the command line)

**[-entry < name >](Compiler-Option-Entry)**

Override public exported name of implicit user main function

**[-g](Compiler-Option-G)**

Add debug info

**[-profgen < profiler >](Compiler-Option-Profgen)**

Enable function profiling by selecting a specific profiler

**[-profile](Compiler-Option-Profile)**

Enable function profiling for gmon/gprof

**[-e](Compiler-Option-E)**

Add error checking

**[-ex](Compiler-Option-Ex)**

Add error checking with RESUME support

**[-exx](Compiler-Option-Exx)**

Same as `-ex`, plus array bounds and dimensions, null-pointer, and error location reporting

**[-eunwind](Compiler-Option-Eunwind)**

Enable stack unwind information

**[-Wa < opt >](Compiler-Option-Wa)**

Pass options to GAS (separated by commas)

**[-Wc < opt >](Compiler-Option-Wc)**

Pass options to GCC (separated by commas)

**[-o < name >](Compiler-Option-O)**

Set object file path/name (must be passed after the .bas file)

**[-earray](Compiler-Option-Earray)**

Enable array bounds checking

**[-earraydims](Compiler-Option-Earraydims)**

Enable array dimensions checking

**[-eassert](Compiler-Option-Eassert)**

Enable assert() and assertwarn() checking

**[-edebug](Compiler-Option-Edebug)**

Enable [`__FB_DEBUG__`](Fb-Debug)

**[-edebuginfo](Compiler-Option-Edebuginfo)**

Add debug information

**[-elocation](Compiler-Option-Elocation)**

Enable full error location reporting

**[-enullptr](Compiler-Option-Enullptr)**

Enable null-pointer checking

***Linking***

**[-a < name >](Compiler-Option-a)**

Add an object file to linker's list

**[-l < name >](Compiler-Option-L)**

Add a library file to linker's list

**[-p < name >](Compiler-Option-P)**

Add a path to search for libraries

**[-mt](Compiler-Option-Mt)**

Link with thread-safe runtime library

**[-nodeflibs](Compiler-Option-Nodeflibs)**

Do not include the default libraries

**[-nolib < name(s) >](Compiler-Option-Nolib)**

Do not include specific library(s)

**[-static](Compiler-Option-Static)**

Prefer static libraries over dynamic ones when linking

**[-map < name >](Compiler-Option-Map)**

Save the linking map to file name

**[-Wl < opt >](Compiler-Option-Wl)**

Pass options to LD (separated by commas)

**[-export](Compiler-Option-Export)**

Export symbols for dynamic linkage

**[-lib](Compiler-Option-Lib)**

Create a static library

**[-dylib](Compiler-Option-Dylib)**

Create a DLL, including the import library

**[-dll](Compiler-Option-Dll)**

Create a DLL, including the import library. (Same as `-dylib`)

**[-x < name >](Compiler-Option-X)**

Set executable/library path/name

**[-nostrip](Compiler-Option-Nostrip)**

Do not strip symbol information from the output file

**[-strip](Compiler-Option-Strip)**

Omit all symbol information from the output file

**[-sysroot < path >](Compiler-Option-Sysroot)**

Tell the linker where to find libraries (needed by some toolchains)

***Behaviour***

**[-prefix < path >](Compiler-Option-Prefix)**

Set the compiler prefix path

**[-buildprefix < name >](Compiler-Option-Buildprefix)**

Set the internal buildprefix option

**[-version](Compiler-Option-Version)**

Show compiler version on the command line, do not compile or link

**[-v](Compiler-Option-V)**

Be verbose

**[-print < option >](Compiler-Option-Print)**

Display certain information (`fblibdir`, `host`, `target`, `x`)

**[-pp](Compiler-Option-Pp)**

Emit the preprocessed input file only, do not compile

**[-r](Compiler-Option-R)**

Compile into intermediate file(s) only, do not assemble or link

**[-rr](Compiler-Option-Rr)**

Compile into asm file(s) only, do not assemble or link

**[-c](Compiler-Option-C)**

Compile and assemble source file only, do not link

**[-R](Compiler-Option-R-2)**

Do not delete the intermediate file(s)

**[-RR](Compiler-Option-Rr-2)**

Do not delete the asm file(s)

**[-C](Compiler-Option-C-2)**

Do not delete the object file(s)

**[-w < value >](Compiler-Option-W)**

Set min warning level: `all`, `none`, `param`, `escape`, `pedantic`, `next`, `funcptr`, `constness`, `suffix`, `error`, `upcast` or a value

**[-maxerr < val >](Compiler-Option-Maxerr)**

Only stop parsing if \<val> errors occurred

**[-noerrline](Compiler-Option-Noerrline)**

Do not show source line where error occurred

**[-noobjinfo](Compiler-Option-Noobjinfo)**

Do not read/write compile-time info from/to .o and .a files

**[-showincludes](Compiler-Option-Showincludes)**

Display a tree of file names of #included files

***Target specific***

**[-s < name >](Compiler-Option-S)**

Set subsystem (`gui`, `console`)

**[-t < value >](Compiler-Option-T)**

Set stack size in kbytes (default: 1 MB or 2 MB)

***Meta***

**[@< file >](Compiler-Option-File)**

Read (additional) command-line options from a file

Example

`fbc myfile.bas`

*(With DOS version of FBC, compile and link a DOS executable `MYFILE.EXE`.)*

`fbc -s gui myfile.bas`

*(With Windows version of FBC, compile and link a Windows executable `myfile.exe`. Running the program will not show the console window ("MS-DOS Prompt"))*

`fbc -lib module1.bas module2.bas module3.bas -x libmylib.a`

*(Compile and link a static library `libmylib.a` from the three source files)*

`fbc -m main_module -c main_module.bas`

*(Compile an object file `main_module.o` and mark it as an entry point)*

`fbc -c sub_module.bas`

*(Compile an object file `sub_module.o`)*

`fbc -x application.exe main_module.o sub_module.o`

*(Link an executable `application.exe`)*

**Note:** How to include an icon in a FB executable program

There is a simple command line option to compile a FB program into an executable with an Icon:

**-** Create a \*.rc file, for example appicon.rc, with this info:

FB_PROGRAM_ICON ICON "appicon.ico"

(where appicon.ico is the name of icon)

**-** Then when compiling program, add appicon.rc in the list of files to compile.

See also

- [Compiler Options](Compiler-Options)
- [Installing FreeBASIC](Installing)
- [Invoking the FreeBASIC compiler](Running)
- [`#Cmdline`](Cmdline)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
