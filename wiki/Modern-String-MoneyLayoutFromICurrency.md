[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **MoneyLayoutFromICurrency**

# MoneyLayoutFromICurrency

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Maps a Windows `LOCALE_ICURRENCY` code (0..3) onto the POSIX `(precedes, sepBySpace)` layout pair. Public so that the mapping can be asserted a row at a time.

## Syntax

```freebasic
MoneyLayoutFromICurrency( v, byref precedes, byref sepBySpace )
```

## Notes

- `0` is `$1.1`, `1` is `1.1$`, `2` is `$ 1.1`, `3` is `1.1 $`.
- Anything out of range falls back to `0` rather than inventing a layout.
- Compiled on every target, though only Windows ever populates a snapshot from it.
- `LOCALE_ICURRENCY` describes the POSITIVE layout; [MoneyLayoutFromINegCurr](Modern-String-MoneyLayoutFromINegCurr) is the negative one.

## Examples

```freebasic
dim as boolean pre
dim as long sep
MoneyLayoutFromICurrency( 2, pre, sep )
print MoneyCompose( "1.1", "$", "", pre, sep, 1 )   '' $ 1.1
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** Money Formatting  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
