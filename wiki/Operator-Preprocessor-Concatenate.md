[Home](Home) › [Operators](Category-Operators) › **Operator ## (Preprocessor Concatenate)**

# Operator ## (Preprocessor Concatenate)

Preprocessor operator to concatenate strings

## Syntax

```freebasic
text##text
```

## Description

This operator creates a new token by concatenating the texts at both sides of it. This text can be recognized by other macros and further expanded. One use, is to create a macro that expands to different macro names, variable names, and function names depending on the arguments received.

 **Note:**

In macro/define's use '##\_' to escape line continuation character '\_' to allow multiple lines of macro expanded code to be combined into a single statement.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [Preprocessor](Preprocessor)

## Examples

```freebasic
#define Concat(t,n) t##n

Print concat (12,34)

Dim Concat (hello,world) As Integer

Concat (hello,world)=99

Print helloworld
```

 Output:

```freebasic
1234
99
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
