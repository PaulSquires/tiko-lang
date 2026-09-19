[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **MoneyLocaleName**

# MoneyLocaleName

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The name of the locale the monetary settings were read from, as the system reported it.

## Syntax

```freebasic
MoneyLocaleName( ) as ustring
```

## Notes

- Windows reports an NLS name such as `en-CA`. Linux reports whatever `setlocale` returned for `LC_MONETARY`.
- Empty, or a C-locale name, when the system rejected the locale. Check [MoneyLocaleIsValid](Modern-String-MoneyLocaleIsValid) rather than reading anything into the name.
- Reads the snapshot, loading it on first use.

## Examples

```freebasic
print "money formatted as "; MoneyLocaleName( )
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** Money Formatting  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
