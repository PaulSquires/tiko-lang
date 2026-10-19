[Home](Home) › [String Functions](Category-String-Functions) › **RSet**

# RSet

Copies a string into another, right-justified and padded with spaces.

## Syntax

```freebasic
Declare Sub RSet ( ByRef dst As String, ByRef src As Const String )
Declare Sub RSet ( ByVal dst As WString Ptr, ByVal src As Const WString Ptr )
```

## Parameters

- `dst`
- `src`

## Description

`RSet` right justifies text into the string buffer `dst`, filling the right part of the string with `src` and the left part with spaces. The string buffer size is not modified.

 If text is too long for the string buffer size, `RSet` truncates characters from the right.

## Remarks

### Usage

`RSet dst, src`

### Differences from QB

- In QBasic the syntax was `RSet dst = src`. That syntax is also supported by FB.

### See also

- [`LSet`](Lset)
- [`Space`](Space)
- [`Put (File I/O)`](Put-File-I-O)
- [`MKD`](Mkd)
- [`MKI`](Mki)
- [`MKL`](Mkl)
- [`MKS`](Mks)

## Examples

```freebasic
Dim buffer As String

buffer = Space(10)

RSet buffer, "91.5"

Print "-[" & buffer & "]-"
```

 The example above outputs:

```freebasic
-[      91.5]-
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
