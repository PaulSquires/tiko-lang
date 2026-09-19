[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Assert**

# Assert

Debugging macro that halts program execution if an expression is evaluated to 0 (false).

## Syntax

```freebasic
#define Assert(expression) If (expression) = 0 Then : fb_Assert( __FILE__, __LINE__, __FUNCTION__, #expression ) : End If
```

## Parameters

- `expression`
- `expression`

## Description

The `Assert` macro is intended for use in debugging and works only if the [`-g`](Compiler-Option-Eassert) or [-eassert](Compiler-Option-Eassert)`option is specified on the`fbc`command line. In this case it prints an error message and stops the program execution if`*expression*`evaluates to`0

```freebasic
.

Its normal use is to check the correct value of the variables or expressions during debugging.

If
```

[-g](Compiler-Option-Eassert)`and -eassert` are not passed to fbc, the macro does not generate any code, and has no effect.

 Note: If an `Assert` fails while the program is in a graphics [`Screen (Graphics)`](Screen-Graphics), the error message will not be visible as it will be printed to the graphics screen, which will be closed immediately after.

## Remarks

### Usage

`Assert( expression )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__ASSERT`.

### Differences from QB

- New to FreeBASIC

### See also

- [`#assert`](procedures-Assert)
- [`AssertWarn`](Assertwarn)
- [Compiler Option: -eassert](Compiler-Option-Eassert)
- [Compiler Option: -g](Compiler-Option-G)

## Examples

```freebasic
Sub foo

 Dim a As Integer

 a=0

 Assert(a=1)

End Sub

foo

'' If -g or -eassert is used, this code stops with: test.bas(3): assertion failed at FOO: a=1
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
