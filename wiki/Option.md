[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Option()**

# Option()

Specifies additional attributes and/or characteristics of symbols.

## Syntax

```freebasic
Option( "literal-text" )
```

## Parameters

- `literal-text`

## Description

`Option()` allows the programmer to specify additional attributes or characteristics. Enclosing the string into quotes and parentheses is required in the syntax. Unrecognized options are ignored.

 `Option` can also be used as a statement to specify other compile time options. See [Compiler Switches](Compiler-Switches).

 Individual options are explained below.

## Remarks

### SSE Option("SSE") indicates that a floating point value (Single or Double) returned from a function is stored in the xmm0 register. Option("Sse") is ignored unless the source is compiled with the -fpu SSE command line option. This option may be used immediately after the return type in a function declaration or function definition. This option is an optimization only and not required to compile programs using the -fpu SSE command line option. Declare Function ValueInXmm0 () As Double Option("sse") FPU Option("FPU") indicates that a floating point value (Single or Double) returned from a function is stored in the st(0) register. This option may be used immediately after the return type in a function declaration or function definition. Declare Function ValueInStZero () As Double Option("fpu") Differences from QB

- New to FreeBASIC

### See also

- [Compiler Option: -fpu](Compiler-Option-Fpu)
- [Compiler Switches](Compiler-Switches)

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
