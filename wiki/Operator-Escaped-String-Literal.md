[Home](Home) › [Operators](Category-Operators) › **Operator ! (Escaped String Literal)**

# Operator ! (Escaped String Literal)

Explicitly indicates that a string literal should be processed for escape sequences.

## Syntax

```freebasic
!"text"
```

## Description

This operator explicitly indicates that the string literal following it (wrapped in double quotes) should be processed for escape sequences. This a preprocessor operator and can only be used with string literals at compile time.

 The default behavior for string literals is that they not be processed for escape sequences. `Option Escape` can be used in the *[-lang fblite](Compiler-Option-Lang)* dialect to override this default behaviour causing all strings to be processed for escape sequences.

 Use the [$ Operator (Non-Escaped String Literal)](Operator-Non-Escaped-String-Literal) operator to explicitly indicate that a string should not be processed for escape sequences.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [Operator $ (Non-Escaped String Literal)](Operator-Non-Escaped-String-Literal)
- [Preprocessor](Preprocessor)
- [Literals](Literals)
- [Escape Sequences](Escape-Sequences)

## Examples

```freebasic
Print "Some escape sequence examples:"

Print !"1.\tsingle quote (\\\') : \'"

Print !"2.\tdouble quote (\\\") : \""

Print !"3.\tbackslash    (\\\\) : \\"

Print !"4.\tascii char   (\\65): \65"

'' OUTPUT:

''

'' Some escape sequence examples:

'' 1. single quote (\') : '

'' 2. double quote (\") : "

'' 3. backslash    (\\) : \

'' 4. ascii char   (\65): A
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
