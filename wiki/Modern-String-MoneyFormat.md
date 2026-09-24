[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **MoneyFormat**

# MoneyFormat

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Renders an amount the way the user's locale writes money. Assign a numeric value, set the properties you care about, read back the string. Every characteristic the locale specifies can be **overridden** or **suppressed** individually.

## Syntax

```freebasic
dim as MoneyFormat m = <longint | double | Currency | Decimal>
m.<property> = <value>
print m.ToString( )
```

## Notes

- In `fb/moneyformat.bi`, not `fb/string.bi`. It is the one member of this library that is a TYPE, because it carries state a function would need six arguments for.
- Whatever you assign becomes an `FB.Decimal`, so there is one render path and one rounding rule. Integers and `Currency` widen exactly; a `double` does not, because a double is not exact to begin with.
- An invalid `Decimal` renders as the empty string rather than as `0.00`.
- Settings: `Symbol`, `DecimalPoint`, `ThousandsSep`, `Grouping`, `FracDigits`, `SymbolPrecedes`, `SpaceBySymbol`, `Negative`, `BlankIfZero`, `ZeroText`, `ForcePlus`, `Rounding`. A getter reports the EFFECTIVE value: your override if you made one, otherwise the locale's.
- Setting a property ALWAYS marks it as yours, so `m.Symbol = ""` SUPPRESSES the symbol. Only [UseLocale](Modern-String-MoneyFormat) gives it back. `FracDigits = -1` is the numeric spelling of the same thing.
- Rounding is half-even by default, matching `FB.Decimal` and `fb/finance.bi` so the printed figure never disagrees with the computed one. `Rounding = DEC_HALF_UP` gives the accounting and Windows convention.
- Overrides are per instance and never touch the process locale.
- About 96 bytes; it touches the heap only for the string it produces.

## Examples

```freebasic
#include once "fb/moneyformat.bi"
using FB

dim as MoneyFormat m = DecimalParse( "-1234.5" ).Value( )
print m.ToString( )                  '' -$1,234.50   on en-CA

m.Negative = MONEY_NEG_PARENS
print m.ToString( )                  '' ($1,234.50)

m.ThousandsSep = ""                  '' SUPPRESSED, not "use the locale"
print m.ToString( )                  '' ($1234.50)

m.UseLocale( MONEY_F_THOUSANDSSEP )  '' back to the locale's separator

'' a ledger column: blank zeros, parenthesised negatives, no grouping
dim as MoneyFormat cell = someCurrency
cell.BlankIfZero = true
cell.Negative = MONEY_NEG_PARENS
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** Money Formatting  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
