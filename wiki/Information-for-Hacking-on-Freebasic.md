[Home](Home) › [Hacking on FreeBASIC](Category-Hacking-on-FreeBASIC) › **Information for hacking on FreeBASIC**

# Information for hacking on FreeBASIC

This area of the Wiki is for documenting everything about the compiler and the runtime libraries. It is, however, incomplete. If you find that information provided here does not match what the source is doing then please update the relevant pages here. New pages and articles may be added freely, provided they help understanding what's going on inside FB.

***Developing FreeBASIC Itself***

[Compiling a Development Version of FreeBASIC](Compiling-a-Development-Version-of-Freebasic)

[Getting the source code](Getting-the-Source-Code)  
[Compiling FB for DOS](Compiling-Fb-for-Dos)  
[Compiling FB on Linux](Compiling-Fb-on-Linux)  
[Compiling FB on Windows](Compiling-Fb-on-Windows)  
[Compiling FB with Emscripten](Compiling-Fb-with-Emscripten)  
[Getting source code updates and recompiling FB](Getting-Source-Code-Updates-and-Recompiling-Fb)  
[Debugging FB](Debugging-Fb)  
[FB build configuration options](Fb-Build-Configuration-Options)  
[Known problems when compiling FB](Known-Problems-When-Compiling-Fb)  
[GCC toolchain choice](Gcc-Toolchain-Choice)

[Running the FreeBASIC test suite](Compiling-the-Test-Suite)  
[Normal vs. Standalone](Normal-vs-Standalone-Freebasic)  
[Glossary](Glossary-Common-Terms-Used-in-Fbc-Development)  
[Notes on the creation of FB releases](Notes-on-Making-Fb-Releases)  
[FB and cross-compiling](Fb-and-Cross-Compiling)  
[Bootstrapping/cross-compiling fbc](Bootstrapping-Fbc-on-a-New-System)

[Creating FB bindings for C libraries](Creating-Fb-Bindings-for-C-Libraries)  
[C Header Translation Tutorial](C-Header-Translation-Tutorial)  
[Header Style Guidelines](C-Header-Style-Guide)  
[External Libraries Index (header status)](External-Libraries-Index)

***Compiler internals***

[Quick overview of all modules](Quick-Overview-of-All-Modules)  
[The objinfo feature](Objinfo)  
[Memory management](Memory-Management)  
[Lexer & preprocessor](Lexer-Preprocessor)
**Parser & compiler (fb, parser, symb, rtl)**

[Purpose](Purpose)  
[Top level parsing process](Top-Level-Parsing-Process)  
[Symbols](Symbols)  
[Representation of data types](Representation-of-Data-Types)

[Arrays](Arrays)  
[SELECT CASE](Select-Case)  
[Profiling with fb's profiler](Profiling-with-Fb-S-Profiler)  
[Profiling for gmon/gprof](Profiling-for-Gmon-Gprof)  
[Structure packing/field alignment](Structure-Packing-Field-Alignment)

***Run-time (rtlib) and Graphics (gfxlib2) Libraries***

[Keyboard input: inkey(), multikey(), etc.](Keyboard-Input)  
[Overview of drivers (backends)](Gfxlib-Freebasic-Graphics-Library-Overview)  
[Pixel formats](Internal-Graphics-Formats)

---

**Category:** [Hacking on FreeBASIC](Category-Hacking-on-FreeBASIC)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
