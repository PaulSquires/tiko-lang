[Home](Home) › [String Functions](Category-String-Functions) › **LSet**

# LSet

Left-justifies a string

## Syntax

```freebasic
Declare Sub LSet ( ByRef dst As String, ByRef src As Const String )
Declare Sub LSet ( ByVal dst As WString Ptr, ByVal src As Const WString Ptr )
```

## Parameters

- `dst`
- `src`
- `dst_udt`
- `src_udt`

## Description

`LSet` left justifies text into the string buffer `dst`, filling the left part of the string with `src` and the right part with spaces. The string buffer size is not modified.  
 If text is too long for the string buffer size, `LSet` truncates characters from the right.

 For compatibility with QBasic, `LSet` can also copy a user defined type variable into another one. The copy is made byte for byte, without any care for fields or alignment. It's up to the programmer to take care for the validity of the result.

## Remarks

### Usage

```freebasic
LSet dst, src

LSet dst_udt, src_udt
```

### Differences from QB

- In QB, the syntax was `LSet dst = src`. That syntax is also supported by FB.

### See also

- [`RSet`](Rset)
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

LSet buffer, "91.5"

Print "-[" & buffer & "]-"
```

 Output:

```freebasic
-[91.5      ]-
```

```freebasic
Type mytype1

    x As Integer

    y As Integer

End Type

Type mytype2

    z As Integer

End Type

Dim a As mytype1 , b As mytype2

b.z = 1234

LSet a, b

Print a.x
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
