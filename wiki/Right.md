[Home](Home) › [String Functions](Category-String-Functions) › **Right**

# Right

Returns the last n characters.

## Syntax

```freebasic
Declare Function Right ( ByRef str As Const String, ByVal n As Integer ) As String
Declare Function Right ( ByRef str As Const WString, ByVal n As Integer ) As WString
```

## Parameters

- `str`
- `n`

## Description

Returns the rightmost `n` characters starting from the right (end) of `str`. If `str` is empty, then the null string (`"``"`) is returned. If `n <= 0` then the null string (`"``"`) is returned. If `n > len(str)` then the entire source string is returned.

## Return Value

Returns the rightmost substring from `str`.

## Remarks

### Usage

`result = Right[$]( str, n )`

### Platform Differences

- DOS does not support the wide-character string version of **`Right`**.

### Dialect Differences

- The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### Differences from QB

- QB does not support Unicode.

### See also

- [`Left`](Left)
- [`Mid (Function)`](Mid-Function)

## Examples

```freebasic
Dim text As String = "hello world"

Print Right(text, 5)
```

 will produce the output:

```freebasic
world
```

An Unicode example:

dim text as wstring\*20  
text = "Привет, мир!"  
print right(text, 5) 'displays " мир!"

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
