[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Stop**

# Stop

Halts program execution, and waits for a key press before ending the program.

## Syntax

```freebasic
Declare Sub Stop ( ByVal retval As Long = 0 )
```

## Parameters

- `retval`

## Description

Halts the execution of the program and stands by. It's provided as a help to debugging, as it preserves the memory and doesn't close files. For normal program termination the [`End (Statement)`](End-Statement) keyword should be used. An optional return value, an integer, can be specified to return an error code to the system. If no return value is given, a value of 0 is automatically returned.

 Note: STOP is not implemented properly yet; currently it is the same as [System](System).

## Remarks

### Usage

`Stop`

### Differences from QB

- None

### See also

- [`End (Statement)`](End-Statement)

## Examples

```freebasic
Print "this text is shown"

Sleep

Stop

Print "this text will never be shown"
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
