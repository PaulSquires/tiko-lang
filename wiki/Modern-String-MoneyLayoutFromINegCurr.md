[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **MoneyLayoutFromINegCurr**

# MoneyLayoutFromINegCurr

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Maps a Windows `LOCALE_INEGCURR` code (0..15) onto the POSIX `(precedes, sepBySpace, signPosn)` triple. Public so that all sixteen rows can be asserted individually -- a transcription slip here is a wrong string on somebody's machine and on nobody else's.

## Syntax

```freebasic
MoneyLayoutFromINegCurr( v, byref precedes, byref sepBySpace, byref signPosn )
```

## Notes

- The sixteen patterns: `($1.1)` `-$1.1` `$-1.1` `$1.1-` `(1.1$)` `-1.1$` `1.1-$` `1.1$-` `-1.1 $` `-$ 1.1` `1.1 $-` `$ 1.1-` `$ -1.1` `1.1- $` `($ 1.1)` `(1.1 $)`.
- Codes 12 and 13 are the only two needing `sepBySpace = 2`, and they are why the model keeps three values there rather than a boolean.
- Anything out of range falls back to 1, sign before all.
- Compiled on every target, though only Windows ever populates a snapshot from it.

## Examples

```freebasic
dim as boolean pre
dim as long sep, posn
MoneyLayoutFromINegCurr( 12, pre, sep, posn )
print sep                                            '' 2
print MoneyCompose( "1.1", "$", "-", pre, sep, posn ) '' $ -1.1
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** Money Formatting  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
