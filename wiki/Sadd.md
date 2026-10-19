[Home](Home) › [Memory Functions](Category-Memory-Functions) › **SAdd**

# SAdd

Returns a pointer to the characters of a string.

## Syntax

```freebasic
Declare Function SAdd ( ByRef str As String ) As ZString Ptr
Declare Function SAdd ( ByRef str As WString ) As WString Ptr
Declare Function SAdd ( ByRef str As ZString ) As ZString Ptr
```

## Parameters

- `str`

## Description

Returns the memory offset of the string data in the string variable.

## Return Value

A pointer to the data associated with `str`.

## Remarks

### Usage

`result = SAdd( str )`

### Differences from QB

- QB returned an integer instead of a pointer.

### See also

- [`StrPtr`](Operator-Strptr-String-Pointer)
- [`VarPtr`](Operator-Varptr-Variable-Pointer)
- [`ProcPtr`](Operator-Procptr-Procedure-Pointer-and-Vtable-Index)

## Examples

```freebasic
Dim s As String

Print SAdd(s)

s = "hello"

Print SAdd(s)

s = "abcdefg, 1234567, 54321"

Print SAdd(s)
```

---

**Category:** [Memory Functions](Category-Memory-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
