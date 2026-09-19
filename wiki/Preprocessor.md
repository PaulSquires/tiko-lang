[Home](Home) › [Preprocessor](Category-Preprocessor) › **Preprocessor**

# Preprocessor

Commands that control the preprocessor.

Description

Preprocessor commands are sent to the compiler to control what gets compiled and how. They can be used to choose to compile one block of code rather than another for cross-platform compatibility, include headers or other source files, define small inline functions called macros, or alter how the compiler handles variables.

**Conditional Compilation**

Commands that allow for branches in compilation based on conditions.

**Text Replacement**

Commands that create text-replacement macros.

**File Directives**

Commands that indicate to the compiler how other files relate to the source file.

**Control Directives**

Commands that set compile options, control compilation, and report compile time information.

**Metacommands**

Commands that are kept for backward compatibility.

***Conditional Compilation***

**[#if](If)**

Compiles the following code block based on a condition.

**[#ifdef](Ifdef)**

Compiles the following code block if a symbol is defined.

**[#ifndef](Ifndef)**

Compiles the following code block if a symbol is not defined.

**[#elseif](procedures-Elseif)**

Compiles the following code block if a condition is true and the previous conditions was false.

**[#elseifdef](Elseifdef)**

Compiles the following code block if a symbol is defined and the previous conditions was false.

**[#elseifndef](Elseifndef)**

Compiles the following code block if a symbol is not defined and the previous conditions was false.

**[#else](procedures-Else)**

Compiles the following code block if previous conditions were false.

**[#endif](Endif)**

Signifies the end of a code block.

**[defined](Defined)**

Returns "-1" if a symbol is defined, otherwise "0".

***Text Replacement***

**[#define](Define)**

Creates a single-line text-replacement macro.

**[#macro](Macro-Endmacro) and [#endmacro](Macro-Endmacro)**

Creates a multi-line text-replacement macro.

**[#undef](Undef)**

Undefines a symbol.

**[# Preprocessor Stringize](Operator-Preprocessor-Stringize)**

Converts text into a string literal.

**[## Preprocessor Concatenate](Operator-Preprocessor-Concatenate)**

Concatenates two pieces of text.

**[! Escaped String Literal](Operator-Escaped-String-Literal)**

Indicates string literal immediately following must be processed for escape sequences.

**[$ Non-Escaped String Literal](Operator-Non-Escaped-String-Literal)**

Indicates string literal immediately following must not be processed for escape sequences.

***File Directives***

**[#include](procedures-Include)**

Inserts text from a file.

**[#inclib](Inclib)**

Includes a library in the linking processes.

**[#libpath](Libpath)**

Includes a path to search for libraries in the linking process.

***Control Directives***

**[#pragma](Pragma)**

Sets compiling options.

**[#Pragma Reserve](Pragma-Reserve)**

Reserves symbol name.

**[#Cmdline](Cmdline)**

Sets compiler command options from source.

**[#lang](procedures-Lang)**

Sets dialect from source.

**[#print](freebasic-Print)**

Outputs a messages to standard output while compiling.

**[#error](procedures-Error)**

Outputs a messages to standard output and stops compilation.

**[#assert](procedures-Assert)**

Stops compilation with an error message if a given condition is false.

**[#line](procedures-Line)**

Sets the current line number and file name.

***Metacommands***

**['$Include](Include)**

Alternate form of the [#include](procedures-Include) directive.

**['$Dynamic](Dynamic)**

Alternate form of the [Option Dynamic](Option-Dynamic) statement.

**['$Static](Static)**

Alternate form of the [Option Static](Option-Static) statement.

**['$Lang](Lang)**

Alternate form of the [#lang](procedures-Lang) directive.

See also

- [Intrinsic Defines](Intrinsic-Defines)

---

**Category:** [Preprocessor](Category-Preprocessor)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
