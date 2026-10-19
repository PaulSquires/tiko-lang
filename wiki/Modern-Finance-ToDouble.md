[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **ToDouble**

# ToDouble

Returns the amount as a double, which loses precision above about 900 billion.

## Syntax

```freebasic
ToDouble( ) as float64
```

## Notes

- **Loses precision above about ±900 billion**, where the scaled value passes 2^53 and a double can no longer hold every integer.
- **Named, never implicit**: there is no automatic conversion, because a silent one is how exact money arithmetic turns back into floating point without anyone noticing.
- For arithmetic, stay in Currency. This is for handing a value to something that only speaks double.

## Examples

```freebasic
#import "std/money"
using money

dim as Currency c = CurrencyFromParts( 12, 3400 )

print c.ToDouble( )          '' 12.34

'' NAMED, never implicit -- the conversion has to be asked for, so it
'' cannot happen by accident in the middle of an exact calculation
dim as float64 d = c.ToDouble( )
print d * 3                  '' 37.02 -- and now it is floating point again
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Members
