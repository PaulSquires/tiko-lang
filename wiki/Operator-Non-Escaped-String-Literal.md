[Home](Home) › [Operators](Category-Operators) › **Operator $ (Non-Escaped String Literal)**

# Operator $ (Non-Escaped String Literal)

Explicitly indicates that a string literal should not be processed for escape sequences.

## Syntax

```freebasic
$"text"
```

## Description

This operator explicitly indicates that the string literal following it (wrapped in double quotes) should not be processed for escape sequences. This a preprocessor operator and can only be used with string literals at compile time.

 The default behavior for string literals is that they not be processed for escape sequences. However, [`Option Escape`](Option-Escape) in the *[-lang fblite](Compiler-Option-Lang)* dialect can be used to override this default behaviour causing all strings to be processed for escape sequences.

 Use the [! Operator (Escaped String Literal)](Operator-Escaped-String-Literal) to explicitly indicate that a string should be processed for escape sequences.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [Operator ! (Escaped String Literal)](Operator-Escaped-String-Literal)
- [`Option Escape`](Option-Escape)
- [Preprocessor](Preprocessor)
- [Literals](Literals)
- [Escape Sequences](Escape-Sequences)

## Examples

```freebasic
'' Compile with -lang fblite or qb

#lang "fblite"

Print "Default"

Print "Backslash  : \\"

Print !"Backslash !: \\"

Print $"Backslash $: \\"

Print

Option Escape

Print "Option Escape"

Print "Backslash  : \\"

Print !"Backslash !: \\"

Print $"Backslash $: \\"

Print

'' OUTPUT:

'' Default

'' Backslash  : \\

'' Backslash !: \

'' Backslash $: \\

'' Option Escape

'' Backslash  : \

'' Backslash !: \

'' Backslash $: \\
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
