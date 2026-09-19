[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalParse**

# DecimalParse

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
DecimalParse( s )
```

## Examples

```freebasic
#include once "fb/decimal.bi"
using FB

'' Parses text exactly, with no double anywhere in the path
var r = DecimalParse( "12.34" )
print r.HasValue( )          '' true
print r.Value( ).ToString( ) '' 12.34

'' An Optional, so bad input is absence rather than a wrong number.
'' STRICT: the whole string must be consumed
print DecimalParse( "12abc" ).HasValue( )     '' false -- not a prefix parse
print DecimalParse( " 1" ).HasValue( )        '' false
print DecimalParse( "1e3" ).HasValue( )       '' false -- no exponent grammar

'' 28 decimal places is the limit, and a 29th is an ERROR rather than a
'' silent truncation -- dropping a digit the caller wrote is how a decimal
'' type loses money
print DecimalParse( "1.2345678901234567890123456789" ).HasValue( )  '' true
print DecimalParse( "0.00000000000000000000000000001" ).HasValue( ) '' false
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the tiko-lang repository.
