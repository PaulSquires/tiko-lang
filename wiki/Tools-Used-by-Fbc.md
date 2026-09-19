[Home](Home) › [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler) › **Tools used by fbc**

# Tools used by fbc

External tools the FreeBASIC compiler (fbc) may invoke during the compilation process.

Description

FreeBASIC uses several tools for compiling source code in addition to the `fbc` compiler. The exact tools used by `fbc` and how they are invoked depends on how `fbc` was configured, the host platform (where fbc is running), the target platform (where the produced executable will be run), and other options (like environment variables and command line options).

 FreeBASIC (`fbc`) may have been configured in one of two ways: either as standalone or prefixed. The standalone version searches directories relative to where the executable is located. The prefixed version has a hardcoded path configured in to the compiler indicating where it expects to find additional tools and libraries. For more information on configuring FreeBASIC, see the `INSTALL` text file located in the src/compiler directory of the FreeBASIC sources.

 You can check if your installed version of `fbc` is "standalone" or "prefixed" by invoking `fbc` with the *[-version](Compiler-Option-Version)* command line option.

***Standalone***

If `fbc` was configured as "standalone", it will search for files relative to where the `fbc` executable is located. `fbc` is at the "top" of the directory tree and searches sub-directories below it. The "top" directory (which defaults to the location where `fbc` is located) can be overridden with the *[-prefix](Compiler-Option-Prefix)* command line option. "topdir" shown in the directories below represents the directory where the `fbc` executable is located, or the directory specified with the *[-prefix](Compiler-Option-Prefix)* command line option (if it was given). "\<target>" refers to the target platform having the same name as specified by the *[-target](Compiler-Option-Target)* option.

 If not cross compiling, `fbc` looks in these locations:

If cross compiling, `fbc` looks in the these locations:

***Prefixed***

If `fbc` was configured as "prefixed", it will search for files relative to the configured prefix (hardcoded in the `fbc` executable). "prefix" shown in the directories below represents the configured prefix, or the directory specified with the *[-prefix](Compiler-Option-Prefix)* command line option (if it was given). "`<target>`" refers to the target platform having the same name as specified by the *[-target](Compiler-Option-Target)* option.

 If not cross compiling, `fbc` looks in these locations:

If cross compiling, `fbc` looks in the these locations:

***GCC Queries***

If `fbc` is unable to locate a file, it may invoke `gcc -print-file-name=<file>` to query the location of the file. The following are files that may be located using gcc:

***Finding Binaries***

`fbc` will invoke additional tools (binary executables) as part of the compiling and linking process. The following is a list of tools (executables) that may be invoked by `fbc` depending on the host platform, target, or type of executable or library to be produced:

`fbc` will search for these tools in the following manner:

"`<target>`" refers to the target platform having the same name as specified by the *[-target](Compiler-Option-Target)* option.

See also

- [Running FreeBASIC](Running)
- [Compiler Command Line Options](Fbc-Command-Line)
- [Compiler FAQ](Frequently-Asked-Questions)

---

**Category:** [Using the FreeBASIC compiler](Category-Using-the-FreeBASIC-compiler)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
