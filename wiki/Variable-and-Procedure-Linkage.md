[Home](Home) › [Tutorials](Category-Tutorials) › **Variable and Procedure Linkage**

# Variable and Procedure Linkage

Name visibility within and between modules
 *Linkage* refers to the visibility of the name of a variable, object or procedure between one or more modules of a program. In other words, a linkage dictates how a name is shared between modules. There are two main types of linkage a name can have: *internal* and *external*.

Internal linkage

Names with *internal linkage* only refer to variables, objects or procedures defined within their own module; they are not outwardly visible to other modules. This means that two or more modules can refer to different things using the same name. Note that linkage only refers to visibility of a name, and depending on storage class and lifetime, a variable, object or procedure with internal linkage may be shared between modules using its address.

Module-scope declarations

Variable and object names declared at module-scope have internal linkage unless otherwise declared with [`Extern`](Extern) or [`Common`](Common). For example, variable names first introduced with [`Dim`](Dim) or [`Static`](procedures-Static) have internal linkage, and those variables can only be referred to by name within the module in which they are defined. Note that using [`Shared`](Shared) only allows name visibility within the module's procedures, and does not contribute to the name's linkage.  
 Procedure names declared with [`Private`](Private) have internal linkage.

Local-scope declarations

All variable and object names declared at local-scope (in a [`Do`](Do) loop, or procedure body, for instance) have internal linkage.

External linkage

Names with *external linkage* may refer to variables, objects or procedures defined within their module or in another module. Having external linkage means that a name is outwardly visible to other modules, and all modules that use that same external name all refer to the same variable, object or procedure. Thus, only one module may define an external name (the compiler will complain about a duplicated definition if it finds an additional definition of a name with external linkage).

Module-scope declarations

Variable and object names declared at module-scope are declared to have external linkage with [`Extern`](Extern) or [`Common`](Common).  
 [`Extern`](Extern) declares the variable having external linkage, but does not define it. This external declaration must come before any definition of the same name (a declaration without [`Extern`](Extern) specifies internal linkage, and currently, any further external declarations of that name signify a duplicated definition). Variable and object names with external linkage declared using [`Extern`](Extern) are always in the shared scope, and so can be referred to within procedure bodies.  
 [`Common`](Common) declares the variable having external linkage as well as defining the variable. But, it is different from [`Extern`](Extern) in that the [`Common`](Common) definition of the variable may appear in more than one module. When used with arrays, only variable-length arrays without subscripts may be declared, and the array must be sized at run-time using [`Dim`](Dim) or [`ReDim`](Redim) before it can be used. Variable and object names with external linkage declared using [`Common`](Common) are only in the shared scope if the [`Shared`](Shared) scope specifier is also given. Shared variables can be referred to within procedure bodies.  
 When both [`Extern`](Extern) and [`Common`](Common) are both used to declare and define a variable, the effect is that the meaning of [`Common`](Common) statement is altered to behave as though it were a [`Dim`](Dim) declaration. So it is generally, not recommended to mix [`Extern`](Extern) and [`Common`](Common) on the same variable in the same module. However, variables may be declared and defined with [`Common`](Common) in one module and then referenced with [`Extern`](Extern) in another module without confusion.

 Procedure names are declared to have external linkage by default. Declarations using [`Public`](Public) explicitly specify external linkage.

Local-scope declarations

Currently, names declared at local-scope cannot have external linkage.

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
