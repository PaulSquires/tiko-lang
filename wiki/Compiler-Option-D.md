[Home](Home) › **Compiler Option: -d**

# Compiler Option: -d

Add a preprocessor definition

Syntax

```freebasic
-d < name=value >

-d < name >
```

Parameters

`name`

Name of the preprocessor macro to define. No parameters are allowed.

`value`

Value to give to the macro. If omitted, it will be defined as 1

Description

The `-d` compiler option adds a preprocessor macro to all source files. The same as using the preprocessor directive [`#define`](Define) or [`#macro`](Macro-Endmacro).

See also

- [#define](Define)
- [#macro](Macro-Endmacro)
- [Intrinsic Defines](Intrinsic-Defines)
- [Using the Command Line](Quick-Start#compile-a-program)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
