[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Log**

# Log

Returns the natural logarithm; zero gives minus infinity and a negative gives NaN.

## Syntax

```freebasic
Declare Function Log cdecl ( ByVal number As Double ) As Double
```

## Parameters

- `number`

## Description

There can be some confusion with this notation given that in mathematics the natural logarithm function is usually denoted **LN**, while the logarithm of base 10 is often denoted as LOG. FreeBASIC, like most computer programming languages, uses LOG to denote the natural logarithm. The required *number* argument can be any valid numeric expression greater than zero. If `number` is zero, FreeBASIC returns a special value representing "-infinity", printing like "-Inf". If `number` is less than zero, `Log` returns a special value representing "not defined", printing like "NaN" or "IND", exact text is platform dependent. If `number` is an uninitialized variable, -infinity is returned.

 `Log` can be overloaded as operator to accept user-defined types.

## Return Value

Returns the logarithm with the base *e* (also know as the natural logarithm) of `number`.

## Remarks

### Usage

`result = Log( number )`

### Differences from QB

- None

### See also

- [`Exp`](Exp)

## Examples

```freebasic
'Find the logarithm of any base

Function LogBaseX (ByVal Number As Double, ByVal BaseX As Double) As Double

    LogBaseX = Log( Number ) / Log( BaseX )

    'For reference:   1/log(10)=0.43429448

End Function

Print "The log base 10 of 20 is:"; LogBaseX ( 20 , 10 )

Print "The log base 2 of 16 is:"; LogBaseX ( 16 , 2 )

Sleep
```

 The output would look like:

```freebasic
The log base 10 of 20 is: 1.301029995663981
The log base 2 of 16 is: 4
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
