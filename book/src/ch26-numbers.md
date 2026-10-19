# Numbers

Chapter 3 introduced the numeric types and their operators. This chapter is about what a program
does with them: the built-in functions, the library that fills the gaps in them, rounding,
overflow, the special floating-point values, random numbers, statistics, and — because binary
floating point cannot hold a cent exactly — the types for money.

Two modules carry the library. **`#import "std/numeric"`** brings in the mathematics: rounding
and selection, exact integer work, the floating-point environment, random numbers, statistics,
and strict conversion between numbers and text. **`#import "std/money"`** brings in `Decimal`,
`Currency` and the financial functions. Both add functions under their own prefix
(`numeric.Round`, `money.Decimal`) and **change nothing that already exists**: `^`, `mod`, `val`,
`str` and `rnd` behave exactly as they always have. Where one of them has a defect, the library
adds a correct neighbour under another name.

## The built-in functions

```tiko
{{#include ../examples/ch26/intrinsics.tiko}}
```

```text
{{#include ../examples/ch26/intrinsics.out}}
```

These need no import:

| Function | Gives |
|---|---|
| `abs( x )`, `sgn( x )` | the magnitude; -1, 0 or 1 |
| `int( x )` | the largest whole number not above `x` — it rounds **down**, so `int( -2.5 )` is -3 |
| `fix( x )`, `frac( x )` | the whole part toward zero, and what is left |
| `sqr( x )` | the square root |
| `sin`, `cos`, `tan`, `asin`, `acos`, `atn`, `atan2` | trigonometry, in radians |
| `exp( x )`, `log( x )` | e to the power `x`, and the **natural** logarithm |

`int` is a floor and `fix` truncates, but the names do not say so, and code that uses `int`
believing it truncates is wrong for every negative number. The library's `Floor`, `Ceil` and
`Truncate` say which they mean.

`mod` truncates too: the remainder takes the sign of the left-hand side, so `-7 mod 3` is -1,
not the 2 that a wrapping index or a day-of-week calculation wants. `\` is integer division
with the same rule.

## Exact integer arithmetic

```tiko
{{#include ../examples/ch26/intmath.tiko}}
```

```text
{{#include ../examples/ch26/intmath.out}}
```

**`^` always works in `float64`**: it converts both sides, calls the floating-point power
function and converts back. A `float64` has 53 bits of precision, so above 2^53 the answer is
rounded, even when the true result fits in an `int64`. `IPow` multiplies integers and is exact.

```admonish danger title="Pitfall"
**`^` on integers is not exact above 2^53.** `3 ^ 38` is off by 89 in the listing, and nothing
says so. A literal such as `2 ^ 62` happens to come out right because the compiler works it out
before the program runs, so the bug appears only once the operands are variables. Use
`numeric.IPow` for integer powers.
```

The three remainders differ only for negative operands, and each is named for its rule:
`FloorMod` takes the sign of the divisor, `EuclidMod` is never negative, and `mod` takes the sign
of the dividend. `FloorDiv` and `EuclidDiv` are the matching quotients. `DivMod( a, b )` returns
the quotient and remainder together as a tuple (Chapter 19). `ISqrt` is the exact integer square
root, which `int( sqr( n ) )` is not for large `n`; `GCD` and `LCM` complete the set.

### Overflow

```tiko
{{#include ../examples/ch26/overflow.tiko}}
```

```text
{{#include ../examples/ch26/overflow.out}}
```

Integer arithmetic **wraps** when a result does not fit: one past the largest `int32` is the
smallest. Nothing reports it. The library offers three ways to say what should happen instead,
for every integer type:

- **Checked** — `AddChecked`, `SubChecked`, `MulChecked`, `DivChecked`, `NegChecked`,
  `AbsChecked`, `IPowChecked` — return an `Optional` (Chapter 17) that is empty on overflow.
- **Saturating** — `AddSaturating` and its siblings — stop at the end of the range.
- **Wrapping** — `AddWrapping` and its siblings — do exactly what the operators do. They exist so
  that deliberate wrapping, in a hash or a checksum, says it is deliberate.

`abs` of the most negative value is the classic case: it has no positive partner, so `abs`
returns the same negative number. `AbsChecked` reports it.

These protect the calls a programmer thought to protect. Overflow elsewhere is still silent.

The bit functions work on the unsigned types: `PopCount`, `LeadingZeros`, `TrailingZeros`,
`BitWidth`, `Parity`, `RotateLeft`, `RotateRight`, `ByteSwap`, `BitReverse`, `IsPow2` and
`NextPow2`.

## Rounding and selection

```tiko
{{#include ../examples/ch26/rounding.tiko}}
```

```text
{{#include ../examples/ch26/rounding.out}}
```

`Round` takes a half away from zero. `RoundHalfEven` takes a half to the even neighbour, which is
banker's rounding: across many values it rounds up as often as down, where `Round` always pushes
the halves outward. Both take an optional number of decimal places.

```admonish danger title="Pitfall"
**`Round( 2.675, 2 )` is 2.68, though the nearest `float64` to 2.675 is slightly below it.**
Rounding to places multiplies by a power of ten first, and 2.675 × 100 comes out at exactly
267.5, which is a tie. No scale-and-round method avoids this. For amounts of money, use
`Decimal`, below.
```

`Min`, `Max` and `Clamp( v, lo, hi )` work on every numeric type. `Lerp( a, b, t )` moves from
`a` toward `b` by the fraction `t`. `Sign` is like `sgn` but always returns an `int32`, so its
result can index an array or drive a `select case`. `numeric.PI`, `TAU`, `E`, `SQRT2`, `LN2` and
`LN10` are the usual constants.

## The special values

```tiko
{{#include ../examples/ch26/special.tiko}}
```

```text
{{#include ../examples/ch26/special.out}}
```

A `float64` can hold more than numbers: positive and negative infinity, a NaN ("not a number",
the result of 0/0 and similar), and a zero with a sign. `numeric.NaN( )` and
`numeric.Infinity( )` make them; they are functions because a constant cannot be initialised by
dividing by zero.

**A NaN is not equal to anything, itself included**, so `x = x` is false for a NaN. Ask
`IsNaN( x )`. `IsInfinite`, `IsFinite`, `IsNormal` and `IsSubnormal` complete the questions, and
`Classify( x )` names the kind: `FP_NAN`, `FP_INFINITE`, `FP_ZERO`, `FP_SUBNORMAL` or
`FP_NORMAL`.

The library **passes a NaN on** rather than dropping it: `Min( NaN, 1 )` is NaN. Losing the NaN
there would turn an error that could be found into a wrong answer that cannot.

`-0.0` and `0.0` are equal as numbers and differ in the sign bit; `IsNegative` reads the bit.

How `print` shows a NaN or an infinity depends on the platform's runtime, so print a test of the
value, as the listing does, rather than the value itself.

## The floating-point environment

```tiko
{{#include ../examples/ch26/fenv.tiko}}
```

```text
{{#include ../examples/ch26/fenv.out}}
```

The processor rounds every floating-point result to the nearest `float64` unless told otherwise.
`ScopedRounding( mode )` changes that for as long as the variable lives and puts the old mode
back when it goes out of scope, however the scope is left. The modes are `ROUND_TO_NEAREST`,
`ROUND_TOWARD_POSITIVE`, `ROUND_TOWARD_NEGATIVE` and `ROUND_TOWARD_ZERO`. Rounding the same
calculation both ways gives a lower and an upper bound for the true value, which is the basis of
interval arithmetic.

The processor also keeps **exception flags**: invalid operation, division by zero, overflow,
underflow and inexact result. They do not stop the program; they record that something happened.
`ClearFpExceptions( )` resets them, `TestFpException( flag )` reads one, with `FP_INVALID`,
`FP_DIVBYZERO`, `FP_OVERFLOW`, `FP_UNDERFLOW` and `FP_INEXACT`.

The rounding mode belongs to the thread that set it. And because the optimiser may move
calculations, a change of mode is only reliable around work the compiler cannot move past it —
which is why the listing puts the division in its own function.

## Random numbers

```tiko
{{#include ../examples/ch26/random.tiko}}
```

```text
{{#include ../examples/ch26/random.out}}
```

The classic pair still works: `randomize` seeds the generator and `rnd` returns a value from 0 up
to but not including 1. `#include "fbprng.bi"` adds a second argument to `randomize` that picks
one of several algorithms. Two things are wrong with that pair for serious use. There is **one**
generator for the whole program, so a test cannot have a reproducible stream of its own without
disturbing everyone else's. And the usual way to get a whole number, `int( rnd * n )`, is very
slightly **biased**: some results come up more often than others.

`numeric.Rng` fixes both. **An `Rng` is a value**: each one is its own stream, and copying one
makes a second stream that continues from the same point. `RngSeeded( seed )` gives the same
numbers every time, on every platform, which is what tests and simulations need;
`RngFromEntropy( )` seeds from the operating system for a different stream each run.

| Member | Gives |
|---|---|
| `NextInt( lo, hi )` | a whole number from `lo` to `hi`, **both included**, without bias |
| `NextDouble( )` | a `float64` from 0 up to but not including 1 |
| `NextBoolean( )`, `NextBooleanP( p )` | true half the time, or with probability `p` |
| `NextNormal( )`, `NextNormalP( mean, sd )` | the bell curve |
| `NextExponential( λ )`, `NextPoisson( λ )` | waiting times and counts |

`Shuffle( rng, a( ) )` puts an array in random order with every order equally likely, and
`Choice( rng, a( ) )` picks one element. For keys and tokens, where unpredictability matters
more than reproducibility, use `CryptoBytes` and `CryptoULongInt` instead: they have no seed and
are not an `Rng`.

## Identifiers

A record that is made in more than one place — two servers, an offline phone, a program that
merges files — cannot be numbered by a counter, because no one counter sees every record. A
**UUID** is a 128-bit number chosen so that the chance of two being equal is negligible, made
anywhere with no coordination:

```tiko
{{#include ../examples/ch26/ids.tiko}}
```

```text
{{#include ../examples/ch26/ids.out}}
```

`uuids.NewV4( )` fills 122 bits from the operating system's secure generator, the one behind
`CryptoBytes`: nothing about the value can be predicted from another. `uuids.NewV7( )` puts the time
in milliseconds first and random bits after, so identifiers made later **sort later**. As database
keys, v7 values arrive in order and keep an index compact where v4 values scatter across it; within
one program, each `NewV7` is greater than the one before even when many are made in the same
millisecond. The price is that a v7 value tells anyone who sees it when it was made —
`UnixMillis( )` reads it back.

`Parse` accepts the common spellings — with or without hyphens and braces, any case, or a
`urn:uuid:` prefix — and `ToString( )` always writes the lower-case 8-4-4-4-12 form. A `Uuid` has
`=` and `<` and a hash, so it is a `Map` or `Set` key like any built-in type.

## Statistics

```tiko
{{#include ../examples/ch26/dice-stats.tiko}}
```

```text
{{#include ../examples/ch26/dice-stats.out}}
```

The statistics functions take a `containers.Array` (Chapter 23) of numbers: `Mean`, `Median`,
`Percentile`, `Variance` and `StdDev` (sample, dividing by n - 1), `VariancePopulation` and
`StdDevPopulation` (dividing by n), `MinOf`, `MaxOf`, `Range`, `Covariance` and `Correlation`.
`Median` and `Percentile` copy the data before sorting it, so asking a question does not reorder
the array. The mean of an empty array is NaN, not zero, because zero is a real mean.

```tiko
{{#include ../examples/ch26/running.tiko}}
```

```text
{{#include ../examples/ch26/running.out}}
```

**`RunningStats`** sees each value once and keeps only a few numbers, so it can summarise a
stream too large to hold. `Add`, then `Count`, `Mean`, `Variance`, `StdDev`, `MinValue` and
`MaxValue`; `Merge` combines two accumulators exactly, so separate threads can each summarise a
share and then combine the results.

**`Sum` is not a loop.** Adding a small number to a large `float64` can lose the small one
entirely: 1e16 + 1 is 1e16. A plain loop, and `NaiveSum`, lose all hundred thousand ones in the
listing. `Sum` keeps a running correction and gets the exact answer, at a few extra operations
per element.

## Numbers as text

```tiko
{{#include ../examples/ch26/numtext.tiko}}
```

```text
{{#include ../examples/ch26/numtext.out}}
```

`val` cannot fail. It reads as much of the text as looks like a number and ignores the rest, so
`"42abc"` is 42 and `"abc"` is 0 — the same as a real zero. **`TryParseDouble`** and its
siblings `TryParseSingle`, `TryParseLong`, `TryParseLongInt` and the unsigned forms return an
`Optional` that is empty unless the **whole** text is a number. They do not trim spaces unless
asked: a second argument of `PARSE_TRIM` or `PARSE_ALLOW_TRAILING` relaxes them.

`str` rounds a `float64` to fewer digits than it holds, which is easy to read and does not
always read back as the same value: `0.1 + 0.2` prints as `0.3`, which is a different number.
**`numeric.ToString( x )`** writes the shortest text that reads back exactly. For display,
`ToString( x, format )` takes a `NumFormat` that sets the style (`NUM_FIXED`, `NUM_SCIENTIFIC`,
`NUM_PERCENT` and others), the number of digits, thousands grouping and the separators. The
separators are whatever the program says — never the machine's locale, so a file written on one
machine reads correctly on another.

## Money

```tiko
{{#include ../examples/ch26/money.tiko}}
```

```text
{{#include ../examples/ch26/money.out}}
```

A `float64` stores binary fractions, and most decimal fractions are not one: 0.1 is stored as a
nearby value, and 0.1 + 0.2 is not quite 0.3. For measurements that error is far too small to
matter. For money it is a cent that does not reconcile.

```admonish danger title="Pitfall"
**Never keep money in a `float64`.** Each amount is very slightly wrong, and the errors add up
across a ledger until a total is off by a cent — or, in the loan below, by 97 of them.
```

`#import "std/money"` provides two exact types:

| | `Currency` | `Decimal` |
|---|---|---|
| holds | an `int64` counting ten-thousandths | a 96-bit whole number, a scale and a sign |
| decimal places | 4, always | 0 to 28, per value |
| size | 8 bytes | 16 bytes |
| speed | as fast as an integer | slower: done in software |

Use **`Currency`** when four places are enough; use **`Decimal`** for exchange rates, tax rates
and anything else that needs more. `DecimalFromCurrency` and `ToCurrency( )` convert between them.

Both are made by **named functions**, not constructors: `DecimalParse( text )` and
`CurrencyParse( text )` return an `Optional`, and `DecimalFromInt`, `CurrencyFromInt`,
`DecimalFromDouble` and `CurrencyFromDouble` say what they convert from. A constructor taking
an `int64` would also accept a `float64` without a word and drop its fraction. Parsing is strict:
`CurrencyParse( "1.23456" )` is refused rather than cut to four places.

The arithmetic follows the same rules in both:

- **Addition, subtraction and multiplication by a whole number are exact.**
- **Division rounds half to even**, never truncates: 2 / 3 is 0.6667.
- **A `Decimal` keeps its scale.** 59.97 × 0.0825 is 4.947525, exactly; `Round( 2 )` makes it
  cents when cents are wanted. `1.10` and `1.1` are equal and print differently.
- **Overflow gives an Invalid value**, which absorbs arithmetic and equals nothing, as chrono's
  does (Chapter 25). Test with `IsValid( )`. A value declared with no initialiser is zero.

`Currency × Currency` does not exist: money times money is not money. `Decimal` is a number that
happens to be decimal, and it multiplies and divides by itself freely.

**Splitting an amount** is where hand-written code goes wrong: 100.00 in three is 33.33 three
times, which is 99.99. `DecimalApportion( total, scale, weights( ), parts( ) )` and `Apportion`
for `Currency` hand the leftover cents out so the parts always add up to the total. The weights
are an array of `int64`.

A `Decimal` array passed for the weights is refused:
`TKO0687: a bydesc parameter takes an array of exactly its element type`.

### Loans

```tiko
{{#include ../examples/ch26/loan-payment.tiko}}
```

```text
{{#include ../examples/ch26/loan-payment.out}}
```

The first half of the listing is how a loan is usually computed: work out the payment, round it
to cents, round each month's interest to cents, subtract. The payment is right. After 360
payments the balance is not zero but a negative 97 cents, plus a trace of binary error — the
borrower has overpaid, because the rounding of each payment was never accounted for.

`money.LoanSchedule` does the same calculation in `Decimal` and lets the final payment absorb
whatever is left, so the closing balance is exactly zero. Each row's principal is the payment
minus the interest, so every row adds up. `LoanPayment( terms )` gives the payment alone;
`LoanTermsUsMortgage` and `LoanTermsCanadianMortgage` set up the two common cases, which differ
in how often interest compounds — monthly in the United States, half-yearly in Canada — though
both are paid monthly.

`std/money` goes much further: present and future value, internal rate of return, depreciation
schedules, day-count conventions and portfolio returns. The calls that can fail return a
`Result` (Chapter 17) whose error says why.

## What it costs

- **The `numeric` functions are ordinary function calls.** None of them is worked out when the
  program is compiled, even on constant arguments.
- **`IPow` multiplies**: about as many multiplications as the exponent has bits.
- **Checked arithmetic adds a comparison** to each operation it guards.
- **`Sum` costs a few more operations per element than a loop**; `Median` copies and sorts.
- **`Currency` adds like an `int64`. `Decimal` arithmetic is done in software**, and is many
  times slower; it is still fast compared with anything a program does with the result.
- **Integer, `Currency`, `Decimal` and `Rng` results are the same on every platform.** Square
  roots, logarithms and trigonometry come from each platform's maths library and may differ in
  the last bit.

## Summary

- The intrinsics need no import. `int` is a floor, `fix` truncates, and `mod` takes the sign of
  the dividend.
- `#import "std/numeric"`: `Round`, `RoundHalfEven`, `Floor`, `Ceil`, `Truncate`, `Min`, `Max`,
  `Clamp`, `Lerp`, `Sign`, and the constants.
- `^` works in `float64`; `IPow` is exact. `FloorMod`, `EuclidMod`, `DivMod`, `ISqrt`, `GCD`.
- Overflow wraps silently. `*Checked` returns an empty `Optional`; `*Saturating` stops at the
  limit; `*Wrapping` says the wrap is meant.
- A NaN equals nothing: use `IsNaN` and `Classify`. NaN survives `Min` and `Max`.
- `ScopedRounding` sets the rounding mode for a scope; the exception flags record what happened.
- `Rng` is a value: `RngSeeded` for reproducible streams, `NextInt` with both ends included.
- `#import "std/uuids"`: `NewV4` is random, `NewV7` sorts by creation time; `Parse`,
  `ToString`, and `Uuid` works as a map key.
- Statistics take a `containers.Array`; `RunningStats` works in one pass; `Sum` is exact where a
  loop is not.
- `TryParseDouble` takes the whole text or nothing; `ToString` reads back exactly.
- `#import "std/money"`: never keep money in a `float64`. `Currency` for four places, `Decimal`
  for up to 28; division rounds half to even; `DecimalApportion` splits exactly;
  `LoanSchedule` ends at exactly zero.

## Exercises

1. Put 1000.00 in a savings account at 4% a year, credit and round the interest to cents each
   year, and print the balance for ten years in `Decimal`. {solution="ex26-01"}
2. Estimate π by throwing a million random points at a unit square and counting how many land
   inside the quarter circle. Use a seeded `Rng`, so the answer is the same every run.
   {solution="ex26-02"}
3. Rewrite `dice-stats.tiko` with `RunningStats` instead of an array. Which of its three
   statistics can no longer be computed, and why?
4. Write `Average( a, b )` for two `int32` values that cannot overflow, and test it with both
   values near the top of the range.
5. Change the `float64` loop in `loan-payment.tiko` so its last payment absorbs the remainder.
   Does the balance now end at exactly zero?
6. Make 1000 `NewV7` identifiers in an ordinary array, put them in random order with
   `numeric.Shuffle` and a seeded `Rng`, copy them into a `containers.Array` and `Sort` it, and
   check they come back in the order they were made. What would the same test show for `NewV4`?
