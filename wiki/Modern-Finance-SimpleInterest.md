[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **SimpleInterest**

# SimpleInterest

Returns principal times rate times a fraction of a year, exactly.

## Syntax

```freebasic
SimpleInterest( principal, annualRate, yearFraction )
```

## Examples

```freebasic
#import "std/money"
using money

'' Interest that does not compound: principal x rate x time.  EXACT.
dim as Decimal p = DecimalParse( "10000" ).Value( )
dim as Decimal r = DecimalParse( "0.05" ).Value( )

print SimpleInterest( p, r, DecimalOne( ) ).ToString( )                     '' 500.00
print SimpleInterest( p, r, DecimalParse( "0.5" ).Value( ) ).ToString( )    '' 250.000

'' Any zero factor gives exactly zero.
print SimpleInterest( p, r, DecimalZero( ) ).IsZero( )                      '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
