# Money and decimals

A `float64` stores binary fractions, and most decimal fractions are not one:
0.1 is stored as a nearby value, so 0.1 + 0.2 is not quite 0.3. For
measurements that error is too small to matter. For money it is a cent that
does not reconcile. `#import "std/money"` provides two exact decimal types.

```tiko
{{#include ../../examples/numbers/money.tiko}}
```

**Output**

```text
{{#include ../../examples/numbers/money.out}}
```

| | `Currency` | `Decimal` |
|---|---|---|
| holds | an `int64` counting ten-thousandths | a 96-bit whole number and a scale |
| decimal places | always 4 | 0 to 28, per value |
| size | 8 bytes | 16 bytes |

Both are made by named functions: `DecimalParse( text )` and
`CurrencyParse( text )` return an `Optional`, empty when the text is not a
number of the right form, and `DecimalFromInt`, `CurrencyFromInt`,
`DecimalFromDouble` and `CurrencyFromDouble` say what they convert from.

- Addition, subtraction and multiplication by a whole number are exact.
- Division rounds half to even: 2 / 3 is 0.6667 in `Currency`.
- A `Decimal` keeps its scale: 59.97 times 0.0825 is 4.947525, and
  `Round( 2 )` makes it cents.
- Parsing is strict: `"1.23456"` has too many places for `Currency` and is
  refused, not cut off.

Splitting an amount is where hand-written code goes wrong: 100.00 in three is
33.33 three times, which is 99.99. `DecimalApportion( total, scale, weights( ),
parts( ) )` hands out the leftover cent so the parts add up to the total.

```admonish danger title="Pitfall"
**Never keep money in a `float64`.** Each amount is very slightly wrong, and
the errors add up across a ledger until a total is off by a cent.
```

### Activities

1. Add 0.10 to a `Decimal` ten times and compare the total with 1.00.
2. Split 10.00 in the ratio 1 : 2 : 3 with `DecimalApportion`.
