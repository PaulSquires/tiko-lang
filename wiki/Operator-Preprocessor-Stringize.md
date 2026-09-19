[Home](Home) › [Operators](Category-Operators) › **Operator # (Preprocessor Stringize)**

# Operator # (Preprocessor Stringize)

Preprocessor operator to convert macro arguments to strings

## Syntax

```freebasic
#macro_argument
```

## Description

This operator converts the `macro_argument` into a string whose value is the name of the argument. This substitution is made during the macro expansion, previous to compilation.

 *Note: because of this feature, care should be taken when using file-handling statements in a macro. Because of potential ambiguity with file-handling statements that take a "`#`*filenum*" parameter, if*filenum*is one of the macro parameters, it may be necessary to wrap the*filenum*expression in parenthesis (e.g. "`#(`*filenum*)"), to separate it from the `#` sign. Otherwise,*filenum*will be stringized in the macro.*

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [Preprocessor](Preprocessor)

## Examples

```freebasic
#define SEE(x) Print #x ;" = "; x

Dim variable As Integer, another_one As Integer

variable=1

another_one=2

SEE(variable)

SEE(another_one)
```

 Output:

```freebasic
variable = 1
another_one = 2
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
