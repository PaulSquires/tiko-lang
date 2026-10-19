[Home](Home) › [String Functions](Category-String-Functions) › **WChr**

# WChr

Returns a wide string made from one or more Unicode code points.

## Syntax

```freebasic
Declare Function Wchr ( ByVal ch As Integer [, ... ] ) As WString
```

## Parameters

- `ch`

## Description

`WChr` returns a wide-character string containing the character(s) represented by the Unicode values passed to it.

 When `WChr` is used with numerical constants or literals, the result is evaluated at compile-time, so it can be used in variable initializers.

 Not all Unicode characters can be displayed on any machine, the characters available depend on the font presently in use in the console. Graphics modes can't display Unicode characters, as the GfxLib built-in font is not Unicode.

## Return Value

Returns a wide-character string.

## Remarks

### Usage

`result = WChr( ch0 [, ch1 ... chN ] )`

### Platform Differences

- DOS does not support `WChr`.

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Wchr`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Chr`](Chr)
- [`WStr`](Wstr)

## Examples

```freebasic
Print "The character represented by the UNICODE code of 934 is: "; WChr(934)

Print "Multiple UNICODE characters: "; WChr(933, 934, 935)
```

 will produce the output:

The character represented by the UNICODE code of 934 is: Φ  
Multiple UNICODE characters: ΥΦΧ

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
