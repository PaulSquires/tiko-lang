[Home](Home) › [All Categories](Categories) › **Finance**

# Finance

```freebasic
#include once "fb/finance.bi"     ' the whole module -- everything below

using FB
```

Or take only the part you need: `fb/currency.bi` and `fb/decimal.bi` for the money
types, and `fb/finerror.bi`, `fb/fincore.bi`, `fb/finsolve.bi`, `fb/fintvm.bi`,
`fb/finloan.bi`, `fb/fincash.bi`, `fb/findeprec.bi`, `fb/finport.bi` for the finance
functions. Every header is independently includable.

This category is in two halves. **The money types** come first, because everything else
is built on them. **The finance functions** follow -- interest and rate conventions, the
time value of money, loans and amortization schedules, cash-flow appraisal, depreciation,
and portfolio returns and risk.

---

## The money types

FreeBASIC has no money type. Every program that holds an amount holds it in a `DOUBLE`, and `0.1 + 0.2 <> 0.3` in binary floating point -- so every one of them is one rounding away from a penny that does not reconcile. These two headers are the answer, and which one you want is a single question: **is four decimal places enough?**

| | `Currency` | `Decimal` |
|---|---|---|
| representation | `LONGINT` scaled by 10,000 | 96-bit mantissa + scale + sign |
| range | ±922,337,203,685,477.5807 | ±79,228,162,514,264,337,593,543,950,335 |
| decimal places | 4, always | 0..28, per value |
| significant digits | 19 | 28-29 |
| size | 8 bytes | 16 bytes |
| add | one instruction | software multi-precision |
| the type it already is | VB6/VBA `Currency`, COM `CY`, SQL Server `money` | .NET `System.Decimal`, COM `DECIMAL`, SQL Server `decimal(28,s)` |

USE `Currency` WHEN FOUR PLACES IS ENOUGH. It is the cheaper type by a wide margin and this category does not deprecate it. Use `Decimal` when four places is the thing standing in the way -- FX rates quoted to six or eight, per-unit costs, per-mille rates, interest accrual, tax tables. `DecimalFromCurrency( c )` and `d.ToCurrency( )` convert between them.

NEITHER IS A NEW REPRESENTATION. Both are shapes that Windows, COM and SQL Server have used for decades and that FreeBASIC could already NAME and could not COMPUTE with: `win\wtypes.bi` declares `tagCY` at line 326 and `tagDEC` at line 329. Each type here has the matching layout, so the interop boundary is a REINTERPRET rather than a conversion.

NO ARITHMETIC IS DELEGATED TO OleAut32. AfxNova's `CDEC.inc` and `CInt96.inc` wrap `VarCyAdd` / `VarDecMul` and friends, which works and is Windows-only. This compiler ships and gates on linux-x86_64, so the arithmetic is implemented in FreeBASIC and `VarCy*`, `VarDec*` and .NET itself are TEST ORACLES rather than dependencies. Both types behave identically on every target.

ONE SET OF RULES, NOT TWO. The two headers deliberately agree on everything they can:

- **Construction is by free function, not constructor.** A one-argument constructor taking `LONGINT` would also accept a `DOUBLE` through FreeBASIC's implicit conversion, so `Currency( 19.99 )` would have compiled and stored 19. Naming every conversion means the inexact one cannot be reached by accident.
- **Half-to-even is the default,** because half-up biases every tie the same way and across a million lines that is real money. The mode names match: `CUR_HALF_EVEN` / `DEC_HALF_EVEN` and their six siblings.
- **Overflow is `Invalid`, it is infectious, and `Invalid = Invalid` is FALSE** -- the same rule `fb/chrono.bi` uses for `DateTime`. Test with `IsValid( )`. A default-constructed value is ZERO and VALID.
- **Text is exact both ways,** with no `DOUBLE` anywhere in the path, and parsing is STRICT: the whole string must be consumed, and more than the type's decimal places is an ERROR rather than a truncation.
- **`Apportion` splits a total so the parts sum EXACTLY to it.** Largest-remainder, in both types.

============================= fb/currency.bi =============================

```freebasic
dim as Currency price = CurrencyParse( "19.99" ).Value( )
dim as Currency line_ = price * 3            ' EXACT
print line_.ToString( )                      ' 59.9700
```

A LONGINT SCALED BY 10,000.  Fifteen digits left of the point, four to the right, every value in range exactly representable.

```freebasic
range        -922,337,203,685,477.5808 .. +922,337,203,685,477.5807
resolution   0.0001 exactly, everywhere
size         8 bytes
```

This IS the VB6/VBA Currency type, the COM CY / VT_CY type, and SQL Server's money.  'CY' is already declared in win\\wtypes.bi:326 as a union whose int64 member is exactly this field, so the interop boundary is a REINTERPRET.

THE COST, UP FRONT: FOUR DECIMAL PLACES, FIXED.  FX rates are quoted to 6 or 8, per-unit costs and per-mille rates often need more, and a Currency cannot hold them.  CurrencyAccum covers the case that actually loses money; it does not cover storage.  If you need to STORE more than four places, this is the wrong type.

CONSTRUCTION IS BY FREE FUNCTION, NOT CONSTRUCTOR

```freebasic
CurrencyFromInt( n )         CurrencyFromRaw( scaled )
CurrencyFromParts( w, tt )   CurrencyFromDouble( d )
CurrencyParse( s ) -> Optional( of Currency )
```

A one-argument constructor taking LONGINT would also accept a DOUBLE through implicit conversion, so 'Currency( 19.99 )' would have compiled and stored 19.  Naming every conversion means the inexact one cannot be reached by accident.

ARITHMETIC

```freebasic
a + b, a - b        EXACT, overflow-checked
a * n  (integer)    EXACT, overflow-checked
a * x  (double)     rounded half-to-even
a / n  (integer)    rounded HALF-TO-EVEN, not truncated
a / b  (Currency)   DOUBLE -- a ratio is not an amount
a MOD b, -a, comparisons
```

'Currency \* Currency' DOES NOT EXIST: money times money is not money.

DIVISION ROUNDS, IT DOES NOT TRUNCATE:

```freebasic
Currency(1) / 3     ' 0.3333
Currency(2) / 3     ' 0.6667      -- truncation would give 0.6666
```

Truncation biases every result downward, systematically, across a ledger.

OVERFLOW IS 'Invalid', INFECTIOUS, AND 'Invalid = Invalid' IS FALSE -- the same rule as DateTime.  Test with IsValid( ).  A default-constructed Currency is ZERO and VALID: zero is the meaningful default for money.

ROUNDING AND APPORTIONING

```freebasic
c.Round( digits )                    half-to-even, digits 0..4
c.RoundMode( digits, mode )          CUR_HALF_EVEN CUR_HALF_UP
                                     CUR_HALF_DOWN CUR_UP CUR_DOWN
                                     CUR_CEILING CUR_FLOOR
c.Floor( ) c.Ceiling( ) c.Truncate( ) c.AbsValue( ) c.Sign( )

Apportion( total, weights( ), result( ) )
```

Apportion is the most useful function here.  Splitting 100.00 three ways gives 33.3333 each, whose sum is 99.9999.  Every accounting system has to decide where the missing unit goes, and doing it ad hoc is how a reconciliation fails.  Largest-remainder: THE PARTS ALWAYS SUM TO THE TOTAL, EXACTLY.

```freebasic
33.3334 + 33.3333 + 33.3333 = 100.0000
```

ACCUMULATING BELOW 0.0001

```freebasic
dim acc as CurrencyAccum
acc.Reset( )
for each line_ in invoice
    acc.AddProduct( line_.amount, taxRate )
next
dim as Currency tax = acc.Total( )        ' quantised ONCE
```

versus the version that loses money, which rounds at every line.  The accumulator carries eight extra decimal places in a 128-bit value. AddScaled( c, num, den ) is the exact form; Add( c ) is exact addition.

TEXT is exact both ways -- no DOUBLE anywhere in the path.  ToString always prints four decimals, invariant separator, no grouping.  MORE THAN FOUR DECIMAL PLACES ON INPUT IS AN ERROR, NOT A TRUNCATION:

```freebasic
CurrencyParse( "1.23456" )      ' empty -- not silently 1.2345
```

============================= fb/decimal.bi =============================

```freebasic
dim as Decimal price = DecimalParse( "19.99" ).Value( )
dim as Decimal line_ = price * 3             ' 59.97   EXACT
dim as Decimal rate  = DecimalParse( "0.0825" ).Value( )
print ( line_ * rate ).ToString( )           ' 4.947525  EXACT, six places
```

A 96-BIT INTEGER, A SCALE, AND A SIGN.  The value is `( -1 ^ sign ) * mantissa / 10 ^ scale`, with mantissa in 0 .. 2^96-1 and scale in 0 .. 28.

```freebasic
range        -79,228,162,514,264,337,593,543,950,335
              .. +79,228,162,514,264,337,593,543,950,335
precision    28-29 significant decimal digits
smallest     0.0000000000000000000000000001   (1e-28)
size         16 bytes
```

This IS the .NET System.Decimal of C# and VB.NET, the COM DECIMAL / VT_DECIMAL type, and SQL Server's decimal(28,s).  win\wtypes.bi:329 has declared 'tagDEC' for twenty years and FB.Decimal has the same sixteen bytes in the same order, so the interop boundary is a REINTERPRET rather than a conversion.

WHY, GIVEN fb/currency.bi ALREADY EXISTS.  Currency is four decimal places, fixed, in eight bytes, and its own header says up front that this is its central limitation.  FX rates quoted to six or eight places, per-unit costs, per-mille rates and interest accrual all need more.

```freebasic
Currency    +-922,337,203,685,477.5807      4 places, always      8 bytes
Decimal     +-7.9228162514264337e28         0..28, per value     16 bytes
```

The cost is size and speed: Currency's add is one instruction, Decimal's is software multi-precision.  IF FOUR PLACES IS ENOUGH, USE Currency -- this header does not deprecate it, and `DecimalFromCurrency( c )` / `d.ToCurrency( )` convert between them.

THE SCALE IS PART OF THE VALUE, NOT PART OF THE FORMATTING.  1.10 and 1.1 are EQUAL, print DIFFERENTLY, and report different scales -- exactly as in .NET.  That is what lets a price read back from a file print the way it was written.

```freebasic
DecimalParse( "1.10" ).Value( ).ToString( )       ' 1.10
DecimalParse( "1.1"  ).Value( ).ToString( )       ' 1.1
DecimalParse( "1.10" ).Value( ) = _
    DecimalParse( "1.1" ).Value( )                ' TRUE
```

CONSTRUCTION IS BY FREE FUNCTION, NOT CONSTRUCTOR

```freebasic
DecimalZero( )      DecimalOne( )        DecimalMinusOne( )
DecimalMinValue( )  DecimalMaxValue( )   DecimalInvalid( )
DecimalFromInt( n )                   DecimalFromUInt( u )
DecimalFromScaled( mantissa, scale )  DecimalFromParts( lo, mid, hi, neg, scale )
DecimalFromDouble( d )                DecimalFromCurrency( c )
DecimalParse( s ) -> Optional( of Decimal )
```

A one-argument constructor taking LONGINT would also accept a DOUBLE through implicit conversion, so 'Decimal( 19.99 )' would have compiled and stored 19.  Naming every conversion means the inexact one cannot be reached by accident.

ARITHMETIC

```freebasic
a + b, a - b        EXACT.  Scale = max( scale a, scale b ).
-a                  EXACT
a * b               EXACT at scale a + scale b
a / b               the terminating quotient when there is one, 28 digits
                    when there is not, rounded HALF-TO-EVEN
a MOD b             EXACT.  Sign follows the DIVIDEND.
a <op> n            n as LONGINT, on either side, for + - * /
```

UNLIKE Currency, 'Decimal \* Decimal' AND 'Decimal / Decimal' EXIST.  Currency is an AMOUNT and money times money has the wrong units; Decimal is a NUMBER that happens to be decimal -- which is what .NET's type is -- and rates, factors and ratios are its ordinary business.  There is deliberately NO Decimal-and-DOUBLE operator: a DOUBLE is inexact, and DecimalFromDouble has to be written out so that it can be seen.

DIVISION ROUNDS, IT DOES NOT TRUNCATE:

```freebasic
1 / 3       0.3333333333333333333333333333
2 / 3       0.6666666666666666666666666667      ' truncation gives ...6666
1 / 4       0.25            ' the expansion terminates, so it stops there
100.00 / 4  25.00           ' and the scale the operands implied is kept
1 / 0       Invalid         ' not a trap and not a wrong number
```

OVERFLOW IS 'Invalid', INFECTIOUS, AND 'Invalid = Invalid' IS FALSE -- the same rule as Currency and DateTime.  Test with IsValid( ).  Every ordering comparison against an Invalid is FALSE, and DecimalCompare returns -2, which is no ordering at all.  A default-constructed Decimal is ZERO and VALID.

MEMBERS

```freebasic
IsValid( ) IsZero( ) IsNegative( ) Sign( ) Scale( )
Lo( ) Mid( ) Hi( )                     ' the three mantissa limbs
ToString( )                            ' exact, EXACTLY 'scale' decimals
ToStringFixed( digits )                ' Rescale then ToString
ToDouble( )                            ' BOUNDED, named
ToLongInt( ) -> Optional( of longint ) ' truncates; None if it will not fit
ToCurrency( )                          ' half-to-even to four places
Round( digits )                        ' half-to-even, 0..28
RoundMode( digits, mode )              ' DEC_HALF_EVEN DEC_HALF_UP
                                       ' DEC_HALF_DOWN DEC_UP DEC_DOWN
                                       ' DEC_CEILING DEC_FLOOR
Rescale( digits )                      ' forces the scale, up or down
Normalize( )                           ' strips trailing zeros
Floor( ) Ceiling( ) Truncate( ) AbsValue( )
DecimalCompare( a, b )                 ' -1 0 +1, and -2 for Invalid
DecimalApportion( total, scale, weights( ), result( ) )
```

ROUND NEVER INCREASES THE SCALE, exactly as .NET's decimal.Round does; Rescale is the one that grows it.

Apportion is the most useful function here.  Splitting 100.00 three ways gives 33.33 each, whose sum is 99.99.  Every accounting system has to decide where the missing cent goes, and doing it ad hoc is how a reconciliation fails.  Largest-remainder: THE PARTS ALWAYS SUM TO THE TOTAL, EXACTLY -- 33.34 + 33.33 + 33.33 = 100.00.

There is NO DecimalAccum.  Currency needed one because rounding at every line loses money at four places; Decimal has twenty-eight and its addition is exact, so the accumulator is just '+'.

TEXT IS EXACT BOTH WAYS -- no DOUBLE anywhere in the parse or the print.  PARSING IS STRICT: the whole string must be consumed, and MORE THAN 28 DECIMAL PLACES IS AN ERROR RATHER THAN A TRUNCATION.

```freebasic
DecimalParse( "12abc" )      ' empty -- not a prefix parse
DecimalParse( "1e3" )        ' empty -- there is no exponent grammar
DecimalParse( "0.000000000000000000000000000001" )
                             ' empty -- 29 places, not a silent 28
```

VERIFIED AGAINST .NET ITSELF.  The point of naming an existing type is that an oracle already exists.  24,000 random operand pairs across '+', '-', '\*', '/' and 'MOD': 23,283 IDENTICAL to .NET, value and scale.  The 717 that differ are two deliberate classes -- 657 MOD cases where .NET pre-rounds or throws and this returns the exact remainder (checked against arbitrary precision: THIS IS EXACT IN ALL 657 AND .NET IN 2), and 60 multiplications that underflow to zero, where both answers are zero and only the reported scale differs.  3,000 unary cases -- Round at every digit count, Floor, Ceiling, Truncate, Compare, Abs, Negate, ToString -- are IDENTICAL with zero divergences.

Full detail, including the six-target byte-identity run and what was NOT verified, is in `docs/decimal/decimal.txt`.

---

## The finance functions

FreeBASIC has no financial function of any kind -- no payment, no present value, no rate
conversion, no internal rate of return, no depreciation, no amortization schedule, and no
day-count convention to express any of them in. Every program that needs one writes it,
in `DOUBLE`, once per call site.

Here is what that costs. A $400,000 mortgage at 5.95% over thirty years, amortized the way
everyone amortizes it -- compute the payment, round it to cents, round each period's
interest to cents, subtract:

```freebasic
' COMPILES TODAY, AND THE LAST ROW IS WRONG
dim as double pmt = p * i / ( 1.0 - ( 1.0 + i ) ^ ( -n ) )
pmt = int( pmt * 100.0 + 0.5 ) / 100.0
for k as long = 1 to 360
    dim as double interest = int( bal * i * 100.0 + 0.5 ) / 100.0
    bal = bal - ( pmt - interest )
next
print bal                    ' -0.9699999996669249
```

The borrower overpaid **97 cents**, and the closing balance is not zero -- and not even a
clean -0.97 to apologise for. Three separate defects sit in those six lines and only one
is floating point: the payment is rounded once but the *residual* is never absorbed, the
interest is rounded independently of the principal so the row does not add up, and the
last period is treated like every other.

```freebasic
#include once "fb/finance.bi"
using FB

var t     = LoanTermsCanadianMortgage( principal, rate, 25 )
var sched = LoanSchedule( t )
for each row in sched.Value( )
    print row.Period_, row.Interest_.ToStringFixed( 2 ), _
                       row.ClosingBalance_.ToStringFixed( 2 )
next                          ' the final ClosingBalance_ is EXACTLY zero
```

### Compounding and payment frequency are separate parameters

This is the decision the rest of the module follows from. A loan has **two** frequencies:
how often interest **compounds**, which is a property of how the rate is quoted, and how
often a **payment** is made, which is a property of the contract.

In the United States a mortgage compounds monthly and pays monthly, so the two collapse
and the distinction is invisible -- which is why almost every finance library elides it.
In Canada the *Interest Act* requires the rate to be quoted **semi-annually, not in
advance**, while payments are monthly, biweekly or weekly. The two differ, and a library
that assumed one number is wrong by dollars a month and thousands over the term.

So there is no `CanadianMortgagePayment` beside an American one. There is one code path,
and the two markets differ in **one enum**:

```freebasic
dim as Decimal p = DecimalParse( "400000" ).Value( )
dim as Decimal r = DecimalParse( "0.0595" ).Value( )

print LoanPayment( LoanTermsUsMortgage( p, r, 25 ) ).Value( ).ToStringFixed( 2 )        ' 2564.99
print LoanPayment( LoanTermsCanadianMortgage( p, r, 25 ) ).Value( ).ToStringFixed( 2 )  ' 2547.35
```

$17.64 a month, about $5,292 over the term.

### Exact where it matters, `double` where it cannot be

`fb/decimal.bi` has no `Pow`, `Exp`, `Log` or `Sqrt`, so anything needing a power is
either built from multiplication or is not exact. The boundary is drawn once and every
function states which side it is on, in its own doc comment:

| | |
|---|---|
| **Exact** | growth and discount over an **integer** number of periods; every sum, product and quotient of money; day-count fractions |
| **`double`** | fractional exponents -- nominal-from-effective, the Canadian sixth root, dated discounting; continuous compounding; every solver; all of `fb/finport.bi` |

A rate that crosses into `double` crosses back at a fixed scale, and **everything
downstream of it is exact again**. A Canadian mortgage crosses once, at the rate
conversion; the 300-row schedule that follows is exact `Decimal` arithmetic.

### Errors have a type

Every fallible call returns `Result( of T, FinanceError )`. `Optional` is used only where
absence *is* the answer -- `PaybackPeriod` on a project that never pays back -- and plain
values only where the function is total.

The distinction worth knowing: **`FIN_NO_SIGN_CHANGE` means no root can exist**, so
retrying with a better guess cannot help. `FIN_NO_CONVERGENCE` means the range was right
and the tolerance was not reached. Two different remedies, so two codes -- and a solver
failure carries how many iterations it ran and how close it got.

### What the schedules guarantee

The amortization rounding order is **normative**, not a matter of taste, because this is
where real implementations go wrong. The load-bearing rule is that **principal is the
residual** -- payment minus interest, never computed independently -- which makes
`Payment = Interest + Principal` an identity rather than a coincidence that fails on a few
rows out of 360. The final payment absorbs the remainder **by assignment**, so the closing
balance lands on exactly zero rather than on 0.0000000001.

Depreciation follows the same discipline: the salvage floor is absolute, and the book
value lands on exactly salvage.

### Verification

The suites are fbc's own fbcunit suites for these headers, vendored in tiko-lang at
`tests/vendor/fbc-tests/finance/`. Under tiko **all 8 of 8 match fbc**
(`build/suiterun.sh`, which builds each suite with both compilers and compares the
results tables; measured 2026-09-24 at origin/master 50c71751).

Where an oracle exists it is named: the IRS MACRS 200%-declining-balance five-year
schedule is reproduced **exactly**; ISDA's 30/360 and 30E/360 rules are applied including
the case that separates them. Where one does not, the tests assert **properties** instead
-- the time-value identity balancing, an IRR verified by substituting it back, a rate that
must compound back to the one it came from, and the five amortization invariants on every
row of every scenario.

**Not verified:** the published MACRS *percentage tables* carry display rounding that is
deliberately not reproduced -- only the arithmetic beneath them.

## API reference

One page per entry, 150 in all, each with a compilable example.

**Money types — `fb/currency.bi`, `fb/decimal.bi`**

[Currency](Modern-Finance-Currency) · [CurrencyFromInt](Modern-Finance-CurrencyFromInt) · [CurrencyFromParts](Modern-Finance-CurrencyFromParts) · [CurrencyFromRaw](Modern-Finance-CurrencyFromRaw) · [CurrencyFromDouble](Modern-Finance-CurrencyFromDouble) · [CurrencyParse](Modern-Finance-CurrencyParse) · [CurrencyInvalid](Modern-Finance-CurrencyInvalid) · [Raw](Modern-Finance-Raw) · [Apportion](Modern-Finance-Apportion) · [AddProduct](Modern-Finance-AddProduct) · [AddScaled](Modern-Finance-AddScaled) · [Total](Modern-Finance-Total) · [Decimal](Modern-Finance-Decimal) · [DecimalZero](Modern-Finance-DecimalZero) · [DecimalOne](Modern-Finance-DecimalOne) · [DecimalMinusOne](Modern-Finance-DecimalMinusOne) · [DecimalMinValue](Modern-Finance-DecimalMinValue) · [DecimalMaxValue](Modern-Finance-DecimalMaxValue) · [DecimalInvalid](Modern-Finance-DecimalInvalid) · [DecimalFromInt](Modern-Finance-DecimalFromInt) · [DecimalFromUInt](Modern-Finance-DecimalFromUInt) · [DecimalFromScaled](Modern-Finance-DecimalFromScaled) · [DecimalFromParts](Modern-Finance-DecimalFromParts) · [DecimalFromDouble](Modern-Finance-DecimalFromDouble) · [DecimalFromCurrency](Modern-Finance-DecimalFromCurrency) · [DecimalParse](Modern-Finance-DecimalParse) · [DecimalCompare](Modern-Finance-DecimalCompare) · [DecimalApportion](Modern-Finance-DecimalApportion) · [IsValid](Modern-Finance-IsValid) · [Ceiling](Modern-Finance-Ceiling) · [RoundMode](Modern-Finance-RoundMode) · [ToDouble](Modern-Finance-ToDouble)

**Errors — `fb/finerror.bi`**

[FinanceError](Modern-Finance-FinanceError) · [FinanceErrorCode](Modern-Finance-FinanceErrorCode) · [FinanceErrorMessage](Modern-Finance-FinanceErrorMessage)

**Conventions, day count and rates — `fb/fincore.bi`**

[Compounding](Modern-Finance-Compounding) · [PaymentFrequency](Modern-Finance-PaymentFrequency) · [PaymentTiming](Modern-Finance-PaymentTiming) · [DayCount](Modern-Finance-DayCount) · [MoneyRounding](Modern-Finance-MoneyRounding) · [MoneyRoundingMake](Modern-Finance-MoneyRoundingMake) · [MoneyRoundingCents](Modern-Finance-MoneyRoundingCents) · [MoneyRoundingBankersFour](Modern-Finance-MoneyRoundingBankersFour) · [MoneyRoundingExact](Modern-Finance-MoneyRoundingExact) · [MoneyRound](Modern-Finance-MoneyRound) · [DayCountDays](Modern-Finance-DayCountDays) · [DayCountFraction](Modern-Finance-DayCountFraction) · [DayCountFractionDouble](Modern-Finance-DayCountFractionDouble) · [GrowthFactor](Modern-Finance-GrowthFactor) · [DiscountFactor](Modern-Finance-DiscountFactor) · [GrowthFactorFractional](Modern-Finance-GrowthFactorFractional) · [GrowthFactorContinuous](Modern-Finance-GrowthFactorContinuous) · [SimpleInterest](Modern-Finance-SimpleInterest) · [SimpleInterestBetween](Modern-Finance-SimpleInterestBetween) · [RatePerPeriod](Modern-Finance-RatePerPeriod) · [RateEffectiveFromNominal](Modern-Finance-RateEffectiveFromNominal) · [RateNominalFromEffective](Modern-Finance-RateNominalFromEffective) · [RateConvertCompounding](Modern-Finance-RateConvertCompounding) · [RateContinuousFromEffective](Modern-Finance-RateContinuousFromEffective) · [RateEffectiveFromContinuous](Modern-Finance-RateEffectiveFromContinuous) · [RatePerPaymentFromNominal](Modern-Finance-RatePerPaymentFromNominal)

**The root finder — `fb/finsolve.bi`**

[FinSolverOptions](Modern-Finance-FinSolverOptions) · [FinSolverOptionsDefault](Modern-Finance-FinSolverOptionsDefault) · [FinSolverOptionsWithGuess](Modern-Finance-FinSolverOptionsWithGuess) · [FinObjective](Modern-Finance-FinObjective) · [FinSolveResult](Modern-Finance-FinSolveResult) · [FinSolveRoot](Modern-Finance-FinSolveRoot)

**Time value of money — `fb/fintvm.bi`**

[AnnuityTerms](Modern-Finance-AnnuityTerms) · [AnnuityTermsMake](Modern-Finance-AnnuityTermsMake) · [PresentValue](Modern-Finance-PresentValue) · [FutureValue](Modern-Finance-FutureValue) · [PaymentAmount](Modern-Finance-PaymentAmount) · [PresentValueOfLump](Modern-Finance-PresentValueOfLump) · [FutureValueOfLump](Modern-Finance-FutureValueOfLump) · [AnnuityPresentValueFactor](Modern-Finance-AnnuityPresentValueFactor) · [AnnuityFutureValueFactor](Modern-Finance-AnnuityFutureValueFactor) · [PeriodsRequired](Modern-Finance-PeriodsRequired) · [PeriodsRequiredWhole](Modern-Finance-PeriodsRequiredWhole) · [SolveRatePerPeriod](Modern-Finance-SolveRatePerPeriod)

**Loans and amortization — `fb/finloan.bi`**

[LoanTerms](Modern-Finance-LoanTerms) · [LoanTermsMake](Modern-Finance-LoanTermsMake) · [LoanTermsUsMortgage](Modern-Finance-LoanTermsUsMortgage) · [LoanTermsCanadianMortgage](Modern-Finance-LoanTermsCanadianMortgage) · [AmortizationRow](Modern-Finance-AmortizationRow) · [AmortizationSchedule](Modern-Finance-AmortizationSchedule) · [AmortizationIterator](Modern-Finance-AmortizationIterator) · [ScheduleToArray](Modern-Finance-ScheduleToArray) · [LoanPayment](Modern-Finance-LoanPayment) · [LoanSchedule](Modern-Finance-LoanSchedule) · [LoanRowAt](Modern-Finance-LoanRowAt) · [LoanBalanceAt](Modern-Finance-LoanBalanceAt) · [LoanInterestBetween](Modern-Finance-LoanInterestBetween) · [LoanPrincipalBetween](Modern-Finance-LoanPrincipalBetween) · [LoanSummarize](Modern-Finance-LoanSummarize) · [LoanSummary](Modern-Finance-LoanSummary) · [ExtraPayment](Modern-Finance-ExtraPayment) · [ExtraPaymentOnce](Modern-Finance-ExtraPaymentOnce) · [ExtraPaymentRecurring](Modern-Finance-ExtraPaymentRecurring) · [LoanPayoffAmount](Modern-Finance-LoanPayoffAmount) · [LoanImpliedRate](Modern-Finance-LoanImpliedRate) · [LoanAnnualPercentageRate](Modern-Finance-LoanAnnualPercentageRate)

**Cash flows and appraisal — `fb/fincash.bi`**

[CashFlow](Modern-Finance-CashFlow) · [CashFlowMake](Modern-Finance-CashFlowMake) · [CashFlowAt](Modern-Finance-CashFlowAt) · [NetPresentValue](Modern-Finance-NetPresentValue) · [NetFutureValue](Modern-Finance-NetFutureValue) · [InternalRateOfReturn](Modern-Finance-InternalRateOfReturn) · [ModifiedInternalRateOfReturn](Modern-Finance-ModifiedInternalRateOfReturn) · [NetPresentValueOnDates](Modern-Finance-NetPresentValueOnDates) · [InternalRateOfReturnOnDates](Modern-Finance-InternalRateOfReturnOnDates) · [PaybackPeriod](Modern-Finance-PaybackPeriod) · [DiscountedPaybackPeriod](Modern-Finance-DiscountedPaybackPeriod) · [ProfitabilityIndex](Modern-Finance-ProfitabilityIndex)

**Depreciation — `fb/findeprec.bi`**

[DepreciationTerms](Modern-Finance-DepreciationTerms) · [DepreciationTermsMake](Modern-Finance-DepreciationTermsMake) · [DepreciationRow](Modern-Finance-DepreciationRow) · [DepreciationMethod](Modern-Finance-DepreciationMethod) · [DepreciationStraightLine](Modern-Finance-DepreciationStraightLine) · [DepreciationDecliningBalance](Modern-Finance-DepreciationDecliningBalance) · [DepreciationDoubleDeclining](Modern-Finance-DepreciationDoubleDeclining) · [DepreciationSumOfYearsDigits](Modern-Finance-DepreciationSumOfYearsDigits) · [DepreciationUnitsOfProduction](Modern-Finance-DepreciationUnitsOfProduction) · [DepreciationSchedule](Modern-Finance-DepreciationSchedule) · [DepreciationScheduleIterator](Modern-Finance-DepreciationScheduleIterator) · [DepreciationScheduleOf](Modern-Finance-DepreciationScheduleOf) · [DepreciationScheduleToArray](Modern-Finance-DepreciationScheduleToArray)

**Returns and risk — `fb/finport.bi`**

[ReturnFrequency](Modern-Finance-ReturnFrequency) · [ReturnSummary](Modern-Finance-ReturnSummary) · [SummarizeReturns](Modern-Finance-SummarizeReturns) · [HoldingPeriodReturn](Modern-Finance-HoldingPeriodReturn) · [CompoundAnnualGrowthRate](Modern-Finance-CompoundAnnualGrowthRate) · [AnnualizeReturn](Modern-Finance-AnnualizeReturn) · [AnnualizeReturnOverPeriods](Modern-Finance-AnnualizeReturnOverPeriods) · [TimeWeightedReturn](Modern-Finance-TimeWeightedReturn) · [ModifiedDietzReturn](Modern-Finance-ModifiedDietzReturn) · [MoneyWeightedReturn](Modern-Finance-MoneyWeightedReturn) · [CumulativeReturnSeries](Modern-Finance-CumulativeReturnSeries) · [DrawdownSeries](Modern-Finance-DrawdownSeries) · [MaxDrawdown](Modern-Finance-MaxDrawdown) · [MaxDrawdownPeak](Modern-Finance-MaxDrawdownPeak) · [MaxDrawdownTrough](Modern-Finance-MaxDrawdownTrough) · [Volatility](Modern-Finance-Volatility) · [DownsideDeviation](Modern-Finance-DownsideDeviation) · [SharpeRatio](Modern-Finance-SharpeRatio) · [SortinoRatio](Modern-Finance-SortinoRatio) · [Beta](Modern-Finance-Beta) · [Alpha](Modern-Finance-Alpha) · [TrackingError](Modern-Finance-TrackingError) · [InformationRatio](Modern-Finance-InformationRatio) · [CorrelationToBenchmark](Modern-Finance-CorrelationToBenchmark)
