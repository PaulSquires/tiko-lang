[Home](Home) › [String Functions](Category-String-Functions) › **Mid (Statement)**

# Mid (Statement)

Overwrites part of a string in place with other text.

## Syntax

```freebasic
Declare Sub Mid ( ByRef text As String, ByVal start As Integer, ByVal length As Integer, ByRef expression As Const String )
Declare Sub Mid ( ByVal text As WString Ptr, ByVal start As Integer, ByVal length As Integer, ByVal expression As Const WString Ptr )
```

## Parameters

- `text`
- `start`
- `text`
- `length`

## Description

Copies a maximum of `length` characters of `expression` into `text`, starting at `start`.

 If `length` is not specified, all of `expression` is copied. The size of the string `text` is unchanged; if `expression` is too big, as much of it is copied up to the end of `text`.

 `Mid` can also be used as a function to return part of another string. See [Mid (Function)](Mid-Function).

## Remarks

### Usage

```freebasic
Mid( text, start ) = expression

Or

Mid( text, start, length ) = expression
```

### Differences from QB

- None

### See also

- [Mid (Function)](Mid-Function)

## Examples

```freebasic
Dim text As String

text = "abc 123"

Print text 'displays "abc 123"

' replace part of text with another string

Mid(text, 5, 3) = "456"

Print text 'displays "abc 456"
```

---

**Category:** [String Functions](Category-String-Functions)  
**Kind:** statement

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
