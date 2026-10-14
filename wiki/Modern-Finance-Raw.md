[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **Raw**

# Raw

The underlying scaled integer: the amount times 10000.

## Syntax

```freebasic
Raw( ) as int64
```

## Notes

- A Currency **is** this number -- four decimal places held in a `int64`, which is what makes the arithmetic exact.
- The form to store in a database column or a binary record: one integer, no rounding on the way out and none on the way back.
- `CurrencyFromRaw` is the inverse.

## Examples

```freebasic
#import "std/money"
using money

dim as Currency c = CurrencyFromParts( 12, 3400 )

print c.Raw( )               '' 123400
print c.ToString( )          '' 12.3400

'' Round-trips exactly, which a double never promises
print CurrencyFromRaw( c.Raw( ) ).ToString( )          '' 12.3400
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Members
