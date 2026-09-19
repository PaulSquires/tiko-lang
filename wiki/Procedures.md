[Home](Home) › [Procedures](Category-Procedures) › **Procedures**

# Procedures

Keywords that work with procedures.

Description

These keywords control the declaration and definition of both module-level procedures and member procedures, how they are called, how arguments are passed and how their names are seen externally to other modules. Procedures can also be declared to be executed automatically before any module-level code is executed.

**Declaration**

Keywords that declare and define procedures.

**Linkage**

Keywords that specify how procedure names are seen by external modules.

**Calling conventions**

Keywords that specify how arguments are used when calling procedures.

**Parameter passing conventions**

Keywords that specify how arguments are passed to procedures.

**Variadic Procedures**

Macros that allow for an arbitrary number of arguments to be passed to a procedure.

**Automatic execution**

Keywords that specify automatic execution of procedures.

**Miscellaneous**

Miscellaneous keywords.

***Declaration***

**[Declare](Declare)**

Declares a module-level or member procedure.

**[Sub](Sub)**

Specifies a procedure that does not return an argument.

**[Function](procedures-Function)**

Specifies a procedure that returns an argument.

**[Overload](Overload)**

Specifies that the procedure name can be used in other procedure declarations.

**[Static](procedures-Static)**

Specifies static storage for all variables and objects in the procedure body.

**[Const (Member)](Const-Member)**

Specifies a const member procedure in user-defined type definitions.

**[Static (Member)](Static-Member)**

Specifies a static member procedure in user-defined type definitions.

***Linkage***

**[Public](Public)**

Specifies external linkage for a procedure.

**[Private](Private)**

Specifies internal linkage for a procedure.

**[Alias](Alias-Name)**

Specifies an alternate external name for a procedure.

**[Export](Export)**

Specifies a procedure is to be exported from a shared library.

**[Lib](Lib)**

Specifies automatic loading of a library.

***Calling conventions***

**[stdcall](Stdcall)**

Specifies the standard calling convention for BASIC languages, including FreeBASIC.

**[cdecl](Cdecl)**

Specifies the standard calling convention in the C and C++ languages.

**[pascal](Pascal)**

Specifies the standard calling convention in the Fortran, Pascal and Microsoft QuickBASIC/QBasic languages.

**[Fastcall](Fastcall)**

Specifies the fastcall calling convention for 32-bit procedures.

**[Thiscall](Thiscall)**

Specifies the thiscall calling convention for 32-bit member procedures.

***Parameter passing conventions***

**[ByRef](Byref-Parameters)**

Specifies passing an argument by reference.

**[ByVal](Byval)**

Specifies passing an argument by value.

**[Any](Any)**

Disables type-checking on arguments.

***Variadic Procedures***

**[... (Ellipsis)](Ellipsis)**

Indicates a variadic procedure in a declaration.

**[Cva_Arg](Cva-Arg)**

Macro to obtain the next argument from a variadic argument list object

**[Cva_Copy](Cva-Copy)**

Macro to copy a variadic argument list object variable

**[Cva_End](Cva-End)**

Macro to end using a variadic argument list object variable

**[Cva_List](Cva-List)**

Variadic argument list object type

**[Cva_Start](Cva-Start)**

Macro to initialize variadic argument list object variable

**[va_first](Va-First)**

Macro to obtain the argument list in a variadic procedure.

**[va_arg](Va-Arg)**

Macro to obtain the current argument in a variadic procedure.

**[va_next](Va-Next)**

Macro to move to the next argument in a variadic procedure.

***Automatic execution***

**[Constructor (Module)](Constructor-Module)**

Indicates a procedure is to be executed before module-level code.

**[Destructor (Module)](Destructor-Module)**

Indicates a procedure is to be executed after module-level code.

***Miscellaneous***

**[Byref (Function Results)](Byref-Function-Results)**

Specifies that a function returns by reference rather than by value.

**[Call](Call)**

Invokes a procedure.

**[Naked](Naked)**

Specifies that a function body is not to be given any prolog/epilog code

---

**Category:** [Procedures](Category-Procedures)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
