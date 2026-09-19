[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **MoneySetLocale**

# MoneySetLocale

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Forces the monetary settings to a named locale instead of the user's own. `""` means the user's. Returns false if the system does not know the name.

## Syntax

```freebasic
MoneySetLocale( localeName ) as boolean
```

## Notes

- Names are platform-spelled: `"de-DE"` on Windows, `"de_DE.UTF-8"` on Linux.
- On Linux glibc only knows locales that have been GENERATED, so a perfectly valid name can still be rejected. That is what the false is for.
- When it returns false the formatter falls back to `.`, `,`, `3;0` repeating, two fraction digits, symbol first, no space and sign before all. A symbol is never invented.
- It rewrites the process-wide snapshot, so it is NOT thread-safe against a concurrent format. Call it at start-up, or while nothing is formatting.
- On Linux it asks for `LC_MONETARY` alone, never `LC_ALL`: widening it would move `LC_NUMERIC` too, and `DecimalFromDouble` parses `snprintf( "%.14e" )` output, so under a German `LC_NUMERIC` every double assigned to a MoneyFormat would silently become an invalid Decimal.

## Examples

```freebasic
if MoneySetLocale( "de-DE" ) then
    dim as MoneyFormat m = DecimalParse( "-1234.5" ).Value( )
    print m.ToString( )              '' -1.234,50 €
end if

MoneySetLocale( "" )                  '' back to the user's own
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** Money Formatting  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
