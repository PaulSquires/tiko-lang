[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **MoneyFormat**

# MoneyFormat

Renders an amount the way the user's locale writes money. Assign a numeric value, set the properties you care about, read back the string. Every characteristic the locale specifies can be **overridden** or **suppressed** individually.

## Syntax

```freebasic
dim as MoneyFormat m = <int64 | float64 | Currency | Decimal>
m.<property> = <value>
print m.ToString( )
```

## Notes

- In `std/money` (`moneyformat.tiko`), not `std/strings`. It is the one member of this library that is a TYPE, because it carries state a function would need six arguments for.
- Whatever you assign becomes a `money.Decimal`, so there is one render path and one rounding rule. Integers and `Currency` widen exactly; a `float64` does not, because a double is not exact to begin with.
- An invalid `Decimal` renders as the empty string rather than as `0.00`.
- Settings: `Symbol`, `DecimalPoint`, `ThousandsSep`, `Grouping`, `FracDigits`, `SymbolPrecedes`, `SpaceBySymbol`, `Negative`, `BlankIfZero`, `ZeroText`, `ForcePlus`, `Rounding`. A getter reports the EFFECTIVE value: your override if you made one, otherwise the locale's.
- Setting a property ALWAYS marks it as yours, so `m.Symbol = ""` SUPPRESSES the symbol. Only [UseLocale](Modern-String-MoneyFormat) gives it back. `FracDigits = -1` is the numeric spelling of the same thing.
- Rounding is half-even by default, matching `money.Decimal` and the rest of `std/money` so the printed figure never disagrees with the computed one. `Rounding = DEC_HALF_UP` gives the accounting and Windows convention.
- Overrides are per instance and never touch the process locale.
- About 96 bytes; it touches the heap only for the string it produces.

## Examples

```freebasic
#import "std/money"
using money

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

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** Money Formatting
