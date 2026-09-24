[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **ToDouble**

# ToDouble

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The amount as a double.

## Syntax

```freebasic
ToDouble( ) as double
```

## Notes

- **Loses precision above about ±900 billion**, where the scaled value passes 2^53 and a double can no longer hold every integer.
- **Named, never implicit**: there is no automatic conversion, because a silent one is how exact money arithmetic turns back into floating point without anyone noticing.
- For arithmetic, stay in Currency. This is for handing a value to something that only speaks double.

## Examples

```freebasic
#include once "fb/currency.bi"
using FB

dim as Currency c = CurrencyFromParts( 12, 3400 )

print c.ToDouble( )          '' 12.34

'' NAMED, never implicit -- the conversion has to be asked for, so it
'' cannot happen by accident in the middle of an exact calculation
dim as double d = c.ToDouble( )
print d * 3                  '' 37.02 -- and now it is floating point again
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
