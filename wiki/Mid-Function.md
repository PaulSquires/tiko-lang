[Home](Home) › [String Functions](Category-String-Functions) › **Mid (Function)**

# Mid (Function)

Returns the characters from a position, optionally for a given length.

## Syntax

```freebasic
Declare Function Mid ( ByRef str as Const String, ByVal start as integer ) as String
Declare Function Mid ( ByVal str as Const WString Ptr, ByVal start as integer ) as WString
Declare Function Mid ( ByRef str as Const String, ByVal start as integer, ByVal n as integer ) as String
Declare Function Mid ( ByVal str as Const WString Ptr, ByVal start as integer, ByVal n as integer ) as WString
```

## Parameters

- `str`
- `start`
- `str`
- `n`

## Description

Returns a substring starting from `start` in `str`. If `str` is empty then the null string (`"``"`) is returned. If `start <= 0` or `start > len(str)` then the null string (`"``"`) is returned.

 In the first form of `Mid`, all of the remaining characters are returned. In the second form, if `n < 0` or `n > len(str) - start` then all of the remaining characters are returned.

## Remarks

### Usage

`result = Mid[$]( str, start [, n ] )`

### Platform Differences

- DOS does not support the wide-character string versions of **`Mid`**.

### Dialect Differences

- The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- QB does not support Unicode.

### See also

- [`InStr`](Instr)
- [`Mid (Statement)`](Mid-Statement)
- [`Left`](Left)
- [`Right`](Right)
- [`Asc`](Asc)

## Examples

```freebasic
Print Mid("abcdefg", 3, 2)

Print Mid("abcdefg", 3)

Print Mid("abcdefg", 2, 1)
```

 will produce the output:

```freebasic
cd
cdefg
b
```

A Unicode example:  
 Wiki: code rendered this way to allow display of the Unicode characters.

dim text as wstring \* 20  
text = "Привет, мир!"  
print mid(text, 6, 4) ' displays "т, м"

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
