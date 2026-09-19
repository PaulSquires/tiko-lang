[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **PaybackPeriod**

# PaybackPeriod

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
PaybackPeriod( flows( ) )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' When the cumulative cash flow first turns positive, INTERPOLATED
'' inside the crossing period.
''
'' IT RETURNS AN Optional, not a Result: a project that never pays back
'' has NO payback period, and that is the FINDING rather than a failure.
dim as Decimal f( 0 to 4 ) = { DecimalParse( "-1000" ).Value( ), _
                               DecimalParse( "300" ).Value( ), _
                               DecimalParse( "400" ).Value( ), _
                               DecimalParse( "500" ).Value( ), _
                               DecimalParse( "200" ).Value( ) }

print PaybackPeriod( f( ) ).HasValue( )  '' true
print PaybackPeriod( f( ) ).Value( )     '' 2.6

'' A project whose inflows never cover the outlay returns ABSENCE.
dim as Decimal never_( 0 to 3 ) = { DecimalParse( "-1000" ).Value( ), _
                                    DecimalFromInt( 100 ), DecimalFromInt( 100 ), _
                                    DecimalFromInt( 100 ) }
print PaybackPeriod( never_( ) ).HasValue( )             '' false
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincash.bi` in the tiko-lang repository.
