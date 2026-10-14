[Home](Home) › **Compiler Option: -buildprefix**

# Compiler Option: -buildprefix

Set the internal buildprefix option.

Syntax

`-buildprefix < name >`

Parameters

`name`

name to override the internal buildprefix option.

Description

The `-buildprefix` command line option overrides the internal buildprefix option.

 *Detailed behavior if using `-buildprefix`, [`-prefix`](Compiler-Option-Prefix), [`-target`](Compiler-Option-Target) command line options*

The compiler's default options should work for native builds.  
 When building for other platforms or developing and building with multiple tool chains, these command line options can help ease the needs of various non-native or uncommon compilations:

**-** prefix may have been compiled in when the compiler itself was compiled, in which case the default prefix is determined by the compiler's build/makefile option 'ENABLE_PREFIX'

If the compiler was not compiled with 'ENABLE_PREFIX':

**-** standalone: prefix = \<compiler path>/
 **-** normal : prefix = \<compiler path>/../

**-** if the '-prefix \<path>' command line option given, overrides the default prefix

**-** determined by target build for the compiler itself by the compiler's makefile

**-** if the '-target \<target>' command line option given, overrides the default target

**-** always empty

**-** if the '-buildprefix \<name>' command line option given, overrides the default build prefix

**-** binary path: where tools are located (AS, LD, AR, etc)
 **-** include path: location of the compiler's '\*.bi' files
 **-** library path: where the compiler's libraries are located (static libraries and import libraries)
 **-** toolname: the name of a specific tool, which may include the path for a specific location, or the name of the tool only if relying on PATH environment variable

standalone compiler:

**-** binary path = \<prefix>/bin/\<target>/
 **-** toolname = \<binary path> + \<buildprefix> + \<tool name>\[.exe\]
 **-** include path = \<prefix>/inc
 **-** library path = \<prefix>/lib/\<target>

normal compiler:

**-** default binary path:

**-** binary path = \<prefix>/bin/\<target->

**-** or if '-buildprefix' given:

**-** binary path = \<prefix>/bin/\<buildprefix>

**-** toolname = \<binary path> + \<tool name>\[.exe\]
 **-** If binary tool not found, then rely on PATH environment variable to find:

**-** toolname = \<target-|buildprefix> + \<tool name>

**-** include path = prefix/include/freebasic
 **-** library path = prefix/lib\[64\]/freebasic/target

**-** environment variables can override the tool name and path completely
 **-** 'AS' overrides gnu assembler tool
 **-** 'AR' overrides gnu archiver tool
 **-** 'LD' overrides gnu linker
 **-** 'GCC' overrides gnu C compiler
 **-** 'LLC' overrides LLVM compiler
 **-** 'CLANG' overrides clang C compiler (currently never used)
 **-** 'DLLTOOL' overrides gnu dlltool (GAS)
 **-** 'GORC' overrides resource tool (if the compiler was compiled with ENABLE_GORC)
 **-** 'WINDRES' overrides resource tool (if the compiler was compiled without ENABLE_GORC)
 **-** 'CXBE' overrides xbox xbe generator tool
 **-** 'DXE3GEN' overrides djgpp DOS dll tool
 **-** 'EMAR' overrides emscripten archiver ool
 **-** 'EMCC' overrides emscripten assember, compiler, and linker tools

The tool name prefix (stored in the binary path) is set by default with 'target' + '-'.  
 '-buildprefix \<name>' overrides the tool name prefix.

 When 'binary path' is set (internally in the compiler), it includes the prefix of the tool name.

 For examples:

fbc -prefix /pppp/ -target tttt source.bas

gnu-AS invoked is: /pppp/bin/tttt-as

fbc -prefix /pppp/ -target tttt -buildprefix bbbbX source.bas

gnu-AS invoked is: /pppp/bin/bbbbXas

'-prefix' command line option controls top level path for the compiler.  
 '-target' command line option controls code generation and many related options including the default tool name prefix.  
 '-buildprefix' command line option overrides the default tool name prefix.

Version


See also

- [-prefix](Compiler-Option-Prefix)
- [-target](Compiler-Option-Target)
- [Using the Command Line](Quick-Start#compile-a-program)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
