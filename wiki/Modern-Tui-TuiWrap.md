[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Unicode Width](Category-Terminal-TUI-Library) › **TuiWrap**

# TuiWrap

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiWrap( byref s as ustring, byval cols as long ) as TuiStringArray
```

## Description

Word-wraps to a column width, returning the lines. Embedded chr(10) starts a new line. This is what TuiParagraph uses, which is why paragraph wrapping is correct for CJK.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiStringArray lines_ = TuiWrap( "the quick brown fox jumps", 10 )
for i as long = 0 to lines_.Count( ) - 1
    print "["; lines_[i]; "]"
next
'' [the quick ]
'' [brown fox ]
'' [jumps]
''
'' NOTE THE TRAILING SPACE: the break space stays on the line it broke after,
'' so a wrapped line can measure one column wider than you expect. Right-align
'' or box wrapped text and you will see it.

'' a newline is honoured, not swallowed
print TuiWrap( "a" & chr( 10 ) & "b", 40 ).Count( )     '' 2
```

## See also

[TuiCharWidth](Modern-Tui-TuiCharWidth) · [TuiStringWidth](Modern-Tui-TuiStringWidth) · [TuiTruncate](Modern-Tui-TuiTruncate) · [TuiSetAmbiguousWide](Modern-Tui-TuiSetAmbiguousWide) · [TuiAmbiguousWide](Modern-Tui-TuiAmbiguousWide)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Unicode Width  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)