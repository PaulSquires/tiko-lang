[Home](Home) › [Tutorials](Category-Tutorials) › **Procedure Scopes**

# Procedure Scopes

The **Scope** (visibility) of a **Procedure** through the different modules of a program.

 **Preamble:**

 A procedure is a "subroutine" (sub) or a "function" that can be called by code outside the procedure (or internal code in the case of a recursion).  
 A procedure consists of a sequence of instructions that form the body of the procedure.  
 It is possible to pass values or variables to a procedure, and a function may return a value or a reference.

Description

Scopes of procedures in modules follows simple rules:

procedure visible only in its own module (where it is defined).

procedure visible from all modules constituting a compiled program (including static libraries).

when defined in a DLL (dynamically linked library), procedure visible from an external program that has loaded it (statically or dynamically).

Syntax

`[ Public | Private ] { Sub | Function } proc_name ( argumentlist ) [ [ ByRef ] As datatype ] Export`

or

`[ Public ] { Sub | Function } proc_name ( argumentlist ) [ [ ByRef ] As datatype ] Export`

Usage

Private, Public and Export access controls are used in procedure definitions only (forbidden at declaration line level).

 By default, a procedure is Public except if the [`Option Private`](Option-Private) statement (in the module) modifies the default state.  
 That is why both Private and Public access controls are useful, depending on the default state.  
 Export access control is incompatible with Private procedures (implicitly or explicitly defined like this).

 Among the compiled modules, two procedures with the same identifier, but defined inside different modules, may exist if both are Private.

 The compiler removes the Private procedures that are not called, but this does not currently work for Private procedures that are only called by other Private procedures that are not called themselves, because the first one appears as being called.

See also

- [Modularizing](Modularizing)
- [Procedures](Procedures)
- [Variable and Procedure Linkage](Variable-and-Procedure-Linkage)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
