[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **AssertWarn**

# AssertWarn

Debugging macro that prints a warning if an expression evaluates to 0.

## Syntax

```freebasic
#define AssertWarn(expression) If (expression) = 0 Then : fb_AssertWarn( __FILE__, __LINE__, __FUNCTION__, #expression ) : End If
```

## Parameters

- `expression`
- `expression`

## Description

The `AssertWarn` macro is intended for use in debugging and works only if the `-g` option is selected in the FBC command line. In this case it prints a warning message if `expression` evaluates to `0`. It doesn't stop the program execution like [`Assert`](Assert) does.

 Its normal use is to check the correct value of the variables during debugging.

 If `-g` is not passed to fbc, the macro does not generate any code.

## Remarks

### Usage

`AssertWarn( expression )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__ASSERTWARN`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Assert`](Assert)

## Examples

```freebasic
Sub foo

  Dim a As Integer

  a=0

  AssertWarn(a=1)

End Sub

foo

'' If -g is used this code prints: test.bas(3): assertion failed at FOO: a=1
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
