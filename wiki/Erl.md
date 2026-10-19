[Home](Home) › [Error Handling Functions](Category-Error-Handling-Functions) › **Erl**

# Erl

Returns the source line of the last runtime error, or 0 if there was none.

## Syntax

```freebasic
Declare Function Erl ( ) As Long
```

## Description

`Erl` will return the line number where the last error occurred. If no error has occurred, `Erl` will return 0.

 `Erl` cannot always be used effectively -- QB-like error handling must be enabled.

## Return Value

An [`Long`](Long) return value containing the line number where the last error occurred.

## Remarks

### Usage

`result = Erl`

### Differences from QB

- FreeBASIC returns the source code line number and ignores the values of all explicit line numbers, where as QB returns the last encountered explicit line number, and will return zero (0) when explicit line numbers are not used.

### See also

- [Error Handling](Error-Handling)
- [`Err`](Err)

## Examples

```freebasic
'' compile with -ex

on error goto errorhandler

'' generate an explicit error
error 100

end

errorhandler:

  dim num as long = err

  print "Error "; num; " on line "; erl

  end 1

'' Expected output:
'' Error  100 on line  6
```

---

**Category:** [Error Handling Functions](Category-Error-Handling-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
