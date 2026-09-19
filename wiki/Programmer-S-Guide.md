[Home](Home) › [Programmer's Guide](Category-Programmer-s-Guide) › **Programmer's Guide**

# Programmer's Guide

FreeBASIC programmer's guide.

 *Work in Progress: **New pages created for this guide should use the ProPg\* prefix.***

***Getting Started***

[Hello World](Hello-World)  
[FreeBASIC Primer #1](Freebasic-Primer-1)

***Source Files***

[Source Files (.bas)](Source-Files-Bas)  
[Header Files (.bi)](Header-Files-Bi)  
[Using Prebuilt Libraries](Using-Prebuilt-Libraries)  
[Manage Reusable Procedures by Including Source vs Compiled Modules](Manage-Reusable-Procedures-by-Including-Source-vs-Compiled-Modules)

***Lexical Conventions***

[Comments](Comments)  
[Identifier Rules](Identifier-Rules)  
[Literals](Literals)  
[Labels](Labels)  
[Line Continuation](Line-Continuation)  
[Line Separator](Line-Separator)

***Variables and Datatypes***

[Constants and Enumerations](Constants-and-Enumerations)  
[Numeric Types](Numeric-Types)  
[Strings (string, zstring, and wstring)](Strings-String-Zstring-and-Wstring)  
[Coercion and Conversion](Coercion-and-Conversion)  
[Constants](Constants)  
[Variables](Variables)

**Arrays**

[Overview](programmer-s-guide-Arrays)  
[Fixed-length Arrays](Fixed-Length-Arrays)  
[Variable-length Arrays](Variable-Length-Arrays)  
[Array Indexing](Array-Index)  
[Passing Arrays to Procedures](Passing-Arrays-to-Procedures)

**Pointers**

[Overview](Pointers)  
[Pointer Arithmetic](Pointer-Arithmetic)

**References**

[From Pointers to References](From-Pointers-to-References)  
[Using References](Using-References)

***Declarations***

[Implicit Declarations](Implicit-Declarations)  
[Initialization](Variable-Initializers)  
[Storage Classes](Storage-Classes)  
[Variable Scope](Variable-Scope)  
[Simple Variable Lifetime vs Scope](Simple-Variable-Lifetime-vs-Scope)  
[Dynamic Object and Data Lifetime](Dynamic-Object-and-Data-Lifetime)  
[Namespaces](Namespaces)  
[Variable and Procedure Linkage](Variable-and-Procedure-Linkage)

***User Defined Types***

[Overview](User-Defined-Types)  
[Type Aliases](Type-Aliases)  
[Temporary Types](Type-Temporary)  
[Type (UDT/Alias/Temporary) and Union](Type-Udt-Alias-Temporary-and-Union)  
[Constructors and Destructors (basics)](Constructors-and-Destructors-Basics)  
[Member Procedures](Member-Procedures)  
[Properties](Properties)  
[Variable-length member data](Variable-Length-Member-Data)  
[Member Access Rights and Encapsulation](Member-Access-Rights-and-Encapsulation)  
[Operator Overloading](Operator-Overloading)  
[Iterators](Iterators)  
[New and Delete](New-and-Delete)  
[Types as Objects](Types-as-Objects)  
[Composition, Aggregation, Inheritance](Composition-Aggregation-Inheritance)  
[Inheritance Polymorphism](Inheritance-Polymorphism)  
[Constructors, '=' Assignment-Operators, and Destructors (advanced, part #1)](Constructors-Assignment-Operators-and-Destructors-Advanced-Part-1)  
[Constructors, '=' Assignment-Operators, and Destructors (advanced, part #2)](Constructors-Assignment-Operators-and-Destructors-Advanced-Part-2)

***Statements and Expressions***

[Differences between Expressions and Statements](Differences-Between-Expressions-and-Statements)  
[Constant Expressions](Constant-Expressions)  
[Assignments](Assignments)  
[Operator List](Operators)  
[Operator Precedence](Operator-Precedence)  
[Control Flow Statements](programmer-s-guide-Control-Flow-Statements)

***Procedures***

[Procedures Overview](Procedures-Overview)  
[Passing Arguments to Procedures](Passing-Arguments-to-Procedures)  
[Returning Values](Returning-Values)  
[Procedure Scopes](Procedure-Scopes)  
[Calling Conventions](Calling-Conventions)  
[Recursion](Recursion)  
[Callback](Callback)  
[Constructors and Destructors](Constructors-and-Destructors)  
[Pointers to Procedures](Pointers-to-Procedures)  
[Variadic Arguments](Variadic-Arguments)

***Graphics***

[FreeBASIC GfxLib overview](Gfxlib-Freebasic-Graphics-Library-Overview)  
[Graphics Mode Refresh and Anti-Flickering](Graphics-Mode-Refresh-and-Anti-Flickering)  
[Internal Graphics Formats](Internal-Graphics-Formats)  
[External Graphics File Formats](External-Graphics-File-Formats-Page-to-Be-Completed) `(page to be completed)`  
[Lite regulation function to be integrated into user loop for FPS control](Lite-Regulation-Function-to-Be-Integrated-Into-User-Loop-for-Fps-Control)  
[Fine-grain procedure for waiting and in-loop procedure for fine-regulating FPS](Fine-Grain-Procedure-for-Waiting-and-in-Loop-Procedure-for-Fine-Regulating-Fps)

***Multi-Threading***

[Overview](Multi-Threading)  
[Threads](Threads)  
[Mutual Exclusion](Mutual-Exclusion)  
[Conditional Variables](Conditional-Variables)  
[Critical Sections](Critical-Sections)  
[Critical Sections FAQ](Critical-Sections-Faq)

***Making Binaries***

[Executables](Executables)  
[Static Libraries](Static-Libraries)  
[Shared Libraries (DLLs)](Shared-Libraries)  
[Profiling with fb's profiler](Profiling-with-Fb-S-Profiler)  
[Profiling for gmon/gprof](Profiling-for-Gmon-Gprof)

***Preprocessor***

[Overview](programmer-s-guide-Preprocessor)  
[Conditional Compilation](Conditional-Compilation)  
[Macros](programmer-s-guide-Macros)

***Other Topics***
(And topics that need to get placed elsewhere)

[ASCII](Table-of-Ascii-Characters)  
[Date Serials](Date-Serials)  
[Radians](Radian-System-of-Measuring-Angles)  
[Error Handling](Error-Handling)  
[Event Handling](Event-Handling)  
[Intrinsic Defines](Intrinsic-Defines)  
[Identifier Look-ups in namespaces and types](Identifier-Look-Ups-in-Namespaces-and-Types)

***Technical Articles***

[Inline Asm](Asm)  
[C Standard Library Functions](C-Standard-Library-Functions)  
[File I/O with FreeBASIC](File-I-O-with-Freebasic)  
[Dynamic memory management with FreeBASIC](Dynamic-Memory-Management-with-Freebasic)  
[Replace Recursion with Iteration](Replace-Recursion-with-Iteration)  
[OBJECT built-in and RTTI info](Object-Built-in-and-Rtti-Info)  
[Embed and Access binary Data in Executable](Embed-and-Access-Binary-Data-in-Executable)  
[Use Implicit / Overload New(\[\]) and Delete(\[\]) Operators with Inheritance Polymorphism](Use-Implicit-Overload-New-and-Delete-Operators-with-Inheritance-Polymorphism)  
[Emulate a TLS (Thread Local Storage) and a TP (Thread Pooling) feature](Emulate-a-Tls-Thread-Local-Storage-and-a-Tp-Thread-Pooling-Feature)

NOTE: Existing CatPg pages should be recreated as ProPg pages providing a general overview to the grouping of keywords.

---

**Category:** [Programmer's Guide](Category-Programmer-s-Guide)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
