[Home](Home) › [Operating System Functions](Category-Operating-System-Functions) › **Fre**

# Fre

Returns the amount of free memory available

## Syntax

```freebasic
Declare Function Fre ( ByVal value As Long = 0 ) As UInteger
```

## Parameters

- `value`

## Description

Returns the free memory (ram) available, in bytes.

## Return Value

Returns the amount of free memory, in bytes.

## Remarks

### Usage

`result = Fre( [ value ] )`

### Differences from QB

- The "value" argument is not checked, `Fre` will always return the free physical memory available

### See also

- [`Dim`](Dim)
- [`ReDim`](Redim)
- [`Allocate`](Allocate)

## Examples

```freebasic
Dim mem As UInteger = Fre

Print "Free memory:"

Print

Print mem; " bytes"

Print mem  \ 1024; " kilobytes"

Print mem  \ (1024 * 1024); " megabytes"
```

---

**Category:** [Operating System Functions](Category-Operating-System-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
