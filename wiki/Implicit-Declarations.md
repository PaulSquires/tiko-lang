[Home](Home) › [Tutorials](Category-Tutorials) › **Implicit Declarations**

# Implicit Declarations

Lazy declaration of variables.

 The *[qb](Compiler-Option-Lang)* and *[fblite](Compiler-Option-Lang)* FreeBASIC language dialects allow variable names to be used without declaring them first. This is called implicit or lazy declaration since the actual declaration is inferred from how the name is first used.

Variable Type

When a variable is implicitly declared, its type depends on one of two things: the most recent default implicit type directive, if any, or the variable type suffix symbol used, if any.

Default type

In the *[qb](Compiler-Option-Lang)* dialect, implicitly declared variables default to [`Single`](Single) type, while in the *[fblite](Compiler-Option-Lang)* dialect they default to [`Integer`](Integer) type.

Default implicit type directives

"`DEFxxx`" directives dictate the new default type for any following implicit variable declarations. These directives are: [`DefByte`](Defbyte), [`DefUByte`](Defubyte), [`DefShort`](Defshort), [`DefUShort`](Defushort), [`DefInt`](Defint), [`DefUInt`](Defuint), [`DefLng`](Deflng), [`DefSng`](Defsng), [`DefDbl`](Defdbl) and [`DefStr`](Defstr).

Variable type suffix symbols

Variable names suffixed with one of a certain set of symbols will be implicitly declared of a certain type. These symbols are: `'%'` for [`Integer`](Integer), `'&'` for [`Long`](Long), `'!'` for [`Single`](Single), `'#'` for [`Double`](Double) and `'$'` for [`String`](String). These symbols override previous "`DEFxxx`" directives, if any.

Implicit Array Declaration

Currently, FreeBASIC does not support implicit declaration of arrays.

Debugging

For full debugging support, all variables must be explicitly declared and suffixes should not be used. The use of [`Option Explicit`](Option-Explicit) is recommended to turn of support for implicit declarations, so that mistyped variable names are caught at compile time by the compiler.

See also

- [`Option Explicit`](Option-Explicit)
- [FreeBASIC Language Dialects](Compiler-Option-Lang)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
