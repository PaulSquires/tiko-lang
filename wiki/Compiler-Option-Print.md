[Home](Home) › **Compiler Option: -print**

# Compiler Option: -print

Print out information

Syntax

`-print option`

Description

The `-print` option can be used to query the compiler for certain information which may be useful especially for build scripts. It does not prevent compilation of input files given besides the `-print` option, but the compiler also can be invoked with only a `-print` option and no input files, in which case it will not compile anything but only respond to the `-print` option.

 Currently, the following -print options are recognized:

| option | effect |
| --- | --- |
| fblibdir | Prints the compiler's lib/ path |
| host | Prints the host system on which the compiler is running |
| target | Prints the target system for which the compiler is compiling (can be affected by the -target option) |
| x | Prints the file name of the output executable or library that the compiler will or would generate (named after the -x option), depending on other command line options |
| sha-1 | Prints the source code revision sha-1 used to build the compiler if defined at the compiler's build time, or an empty string if it was not defined |
| fork-id | Prints the custom defined project fork identifier name if defined at the compiler's build time, or an empty string if it was not defined |

Example

A [makefile](http://en.wikipedia.org/wiki/Make_(software)) could use `target := $(shell $(FBC) -print target)` to find out the compilation target, which would even work when cross-compiling, with `FBC` set to something like `fbc -target foo`.

 `fbc -print x` alone will print out the executable file extension for the target system.  
 `fbc -print x -dll` on the other hand will print out the dynamic library file name format.  
 `fbc -print x -m foo` will print out the executable file name that would be used when compiling a module called foo.bas.  
 `fbc 1.bas 2.bas -lib -print x` will compile 1.bas and 2.bas into a library, whose file name will be displayed.

See also

- [-x](Compiler-Option-X)
- [-target](Compiler-Option-Target)
- [Using the Command Line](Quick-Start#compile-a-program)
- [`__FB_BUILD_SHA1__`](Fb-Build-Sha1)
- [`__FB_BUILD_FORK_ID__`](Fb-Build-Fork-Id)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
