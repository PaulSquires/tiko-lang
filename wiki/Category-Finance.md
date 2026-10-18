[Home](Home) › [All Categories](Categories) › **Finance**

# Finance

```freebasic
#import "std/money"

using money
```

A module is imported whole. Its files, in `pkg/std/money/`, are `currency.tiko` and
`decimal.tiko` for the money types, and `finerror.tiko`, `fincore.tiko`, `finsolve.tiko`,
`fintvm.tiko`, `finloan.tiko`, `fincash.tiko`, `findeprec.tiko`, `finport.tiko` for the
finance functions.

This category is in two halves. **The money types** come first, because everything else
is built on them. **The finance functions** follow -- interest and rate conventions, the
time value of money, loans and amortization schedules, cash-flow appraisal, depreciation,
and portfolio returns and risk.

---

## The money types

An amount held in a `DOUBLE` is one rounding away from a penny that does not reconcile, because `0.1 + 0.2 <> 0.3` in binary floating point. These two types are the answer, and which one you want is a single question: **is four decimal places enough?**

| | `Currency` | `Decimal` |
|---|---|---|
| representation | `LONGINT` scaled by 10,000 | 96-bit mantissa + scale + sign |
| range | ±922,337,203,685,477.5807 | ±79,228,162,514,264,337,593,543,950,335 |
| decimal places | 4, always | 0..28, per value |
| significant digits | 19 | 28-29 |
| size | 8 bytes | 16 bytes |
| add | one instruction | software multi-precision |
| the type it already is | VB6/VBA `Currency`, COM `CY`, SQL Server `money` | .NET `System.Decimal`, COM `DECIMAL`, SQL Server `decimal(28,s)` |

**Use `Currency` when four places is enough.** It is the cheaper type by a wide margin and this category does not deprecate it. Use `Decimal` when four places is the thing standing in the way -- FX rates quoted to six or eight, per-unit costs, per-mille rates, interest accrual, tax tables. `DecimalFromCurrency( c )` and `d.ToCurrency( )` convert between them.

**Neither is a new representation.** Both are shapes that Windows, COM and SQL Server have used for decades: `win\wtypes.bi` declares `tagCY` at line 326 and `tagDEC` at line 329. Each type here has the matching layout, so the interop boundary is a reinterpret rather than a conversion.

**No arithmetic is delegated to OleAut32.** This compiler ships and gates on linux-x86_64, so the arithmetic is implemented in tiko and `VarCy*`, `VarDec*` and .NET itself are test oracles rather than dependencies. Both types behave identically on every target.

**One set of rules, not two.** The two types deliberately agree on everything they can:

- **Construction is by free function, not constructor.** A one-argument constructor taking `LONGINT` would also accept a `DOUBLE` through implicit conversion, so `Currency( 19.99 )` would have compiled and stored 19. Naming every conversion means the inexact one cannot be reached by accident.
- **Half-to-even is the default,** because half-up biases every tie the same way and across a million lines that is real money. The mode names match: `CUR_HALF_EVEN` / `DEC_HALF_EVEN` and their six siblings.
- **Overflow is `Invalid`, it is infectious, and `Invalid = Invalid` is FALSE** -- the same rule `std/chrono` uses for `DateTime`. Test with `IsValid( )`. A default-constructed value is zero and valid.
- **Text is exact both ways,** with no `DOUBLE` anywhere in the path, and parsing is strict: the whole string must be consumed, and more than the type's decimal places is an error rather than a truncation.
- **`Apportion` splits a total so the parts sum exactly to it.** Largest-remainder, in both types.

### Currency

Defined in `currency.tiko`.

```freebasic
dim as Currency price = CurrencyParse( "19.99" ).Value( )
dim as Currency line_ = price * 3            ' EXACT
print line_.ToString( )                      ' 59.9700
```

**A LONGINT scaled by 10,000.** Fifteen digits left of the point, four to the right, every value in range exactly representable.

```text
range        -922,337,203,685,477.5808 .. +922,337,203,685,477.5807
resolution   0.0001 exactly, everywhere
size         8 bytes
```

This is the VB6/VBA Currency type, the COM CY / VT_CY type, and SQL Server's money. `CY` is already declared in `win\wtypes.bi`, line 326, as a union whose int64 member is exactly this field, so the interop boundary is a reinterpret.

**The cost, up front: four decimal places, fixed.** FX rates are quoted to 6 or 8, per-unit costs and per-mille rates often need more, and a Currency cannot hold them. CurrencyAccum covers the case that actually loses money; it does not cover storage. If you need to *store* more than four places, this is the wrong type.

#### Construction is by free function

```text
CurrencyFromInt( n )         CurrencyFromRaw( scaled )
CurrencyFromParts( w, tt )   CurrencyFromDouble( d )
CurrencyParse( s ) -> Optional( of Currency )
```

A one-argument constructor taking LONGINT would also accept a DOUBLE through implicit conversion, so `Currency( 19.99 )` would have compiled and stored 19. Naming every conversion means the inexact one cannot be reached by accident.

#### Arithmetic

```text
a + b, a - b        EXACT, overflow-checked
a * n  (integer)    EXACT, overflow-checked
a * x  (float64)    rounded half-to-even
a / n  (integer)    rounded HALF-TO-EVEN, not truncated
a / b  (Currency)   DOUBLE -- a ratio is not an amount
a MOD b, -a, comparisons
```

**`Currency * Currency` does not exist**: money times money is not money.

**Division rounds; it does not truncate:**

```freebasic
Currency(1) / 3     ' 0.3333
Currency(2) / 3     ' 0.6667      -- truncation would give 0.6666
```

Truncation biases every result downward, systematically, across a ledger.

**Overflow is `Invalid`, it is infectious, and `Invalid = Invalid` is FALSE** -- the same rule as DateTime. Test with `IsValid( )`. A default-constructed Currency is zero and valid: zero is the meaningful default for money.

#### Rounding and apportioning

```text
c.Round( digits )                    half-to-even, digits 0..4
c.RoundMode( digits, mode )          CUR_HALF_EVEN CUR_HALF_UP
                                     CUR_HALF_DOWN CUR_UP CUR_DOWN
                                     CUR_CEILING CUR_FLOOR
c.Floor( ) c.Ceiling( ) c.Truncate( ) c.AbsValue( ) c.Sign( )

Apportion( total, weights( ), result( ) )
```

Apportion is the most useful function here. Splitting 100.00 three ways gives 33.3333 each, whose sum is 99.9999. Every accounting system has to decide where the missing unit goes, and doing it ad hoc is how a reconciliation fails. Largest-remainder: **the parts always sum to the total, exactly.**

```text
33.3334 + 33.3333 + 33.3333 = 100.0000
```

#### Accumulating below 0.0001

```freebasic
dim acc as CurrencyAccum
acc.Reset( )
for each line_ in invoice
    acc.AddProduct( line_.amount, taxRate )
next
dim as Currency tax = acc.Total( )        ' quantised ONCE
```

versus the version that loses money, which rounds at every line. The accumulator carries eight extra decimal places in a 128-bit value. `AddScaled( c, num, den )` is the exact form; `Add( c )` is exact addition.

#### Text

Text is exact both ways -- no DOUBLE anywhere in the path. ToString always prints four decimals, invariant separator, no grouping. **More than four decimal places on input is an error, not a truncation:**

```freebasic
CurrencyParse( "1.23456" )      ' empty -- not silently 1.2345
```

### Decimal

Defined in `decimal.tiko`.

```freebasic
dim as Decimal price = DecimalParse( "19.99" ).Value( )
dim as Decimal line_ = price * 3             ' 59.97   EXACT
dim as Decimal rate  = DecimalParse( "0.0825" ).Value( )
print ( line_ * rate ).ToString( )           ' 4.947525  EXACT, six places
```

**A 96-bit integer, a scale, and a sign.** The value is `( -1 ^ sign ) * mantissa / 10 ^ scale`, with mantissa in 0 .. 2^96-1 and scale in 0 .. 28.

```text
range        -79,228,162,514,264,337,593,543,950,335
              .. +79,228,162,514,264,337,593,543,950,335
precision    28-29 significant decimal digits
smallest     0.0000000000000000000000000001   (1e-28)
size         16 bytes
```

This is the .NET System.Decimal of C# and VB.NET, the COM DECIMAL / VT_DECIMAL type, and SQL Server's decimal(28,s). `win\wtypes.bi` declares `tagDEC` at line 329, and money.Decimal has the same sixteen bytes in the same order, so the interop boundary is a reinterpret rather than a conversion.

**Why, given Currency already exists?** Currency is four decimal places, fixed, in eight bytes, and its own source says up front that this is its central limitation. FX rates quoted to six or eight places, per-unit costs, per-mille rates and interest accrual all need more.

```text
Currency    +-922,337,203,685,477.5807      4 places, always      8 bytes
Decimal     +-7.9228162514264337e28         0..28, per value     16 bytes
```

The cost is size and speed: Currency's add is one instruction, Decimal's is software multi-precision. **If four places is enough, use Currency** -- Decimal does not deprecate it, and `DecimalFromCurrency( c )` / `d.ToCurrency( )` convert between them.

**The scale is part of the value, not part of the formatting.** 1.10 and 1.1 are equal, print differently, and report different scales -- exactly as in .NET. That is what lets a price read back from a file print the way it was written.

```freebasic
DecimalParse( "1.10" ).Value( ).ToString( )       ' 1.10
DecimalParse( "1.1"  ).Value( ).ToString( )       ' 1.1
DecimalParse( "1.10" ).Value( ) = _
    DecimalParse( "1.1" ).Value( )                ' TRUE
```

#### Construction is by free function

```text
DecimalZero( )      DecimalOne( )        DecimalMinusOne( )
DecimalMinValue( )  DecimalMaxValue( )   DecimalInvalid( )
DecimalFromInt( n )                   DecimalFromUInt( u )
DecimalFromScaled( mantissa, scale )  DecimalFromParts( lo, mid, hi, neg, scale )
DecimalFromDouble( d )                DecimalFromCurrency( c )
DecimalParse( s ) -> Optional( of Decimal )
```

A one-argument constructor taking LONGINT would also accept a DOUBLE through implicit conversion, so `Decimal( 19.99 )` would have compiled and stored 19. Naming every conversion means the inexact one cannot be reached by accident.

#### Arithmetic

```text
a + b, a - b        EXACT.  Scale = max( scale a, scale b ).
-a                  EXACT
a * b               EXACT at scale a + scale b
a / b               the terminating quotient when there is one, 28 digits
                    when there is not, rounded HALF-TO-EVEN
a MOD b             EXACT.  Sign follows the DIVIDEND.
a <op> n            n as LONGINT, on either side, for + - * /
```

**Unlike Currency, `Decimal * Decimal` and `Decimal / Decimal` exist.** Currency is an *amount* and money times money has the wrong units; Decimal is a *number* that happens to be decimal -- which is what .NET's type is -- and rates, factors and ratios are its ordinary business. There is deliberately no Decimal-and-DOUBLE operator: a DOUBLE is inexact, and DecimalFromDouble has to be written out so that it can be seen.

**Division rounds; it does not truncate:**

```text
1 / 3       0.3333333333333333333333333333
2 / 3       0.6666666666666666666666666667      ' truncation gives ...6666
1 / 4       0.25            ' the expansion terminates, so it stops there
100.00 / 4  25.00           ' and the scale the operands implied is kept
1 / 0       Invalid         ' not a trap and not a wrong number
```

**Overflow is `Invalid`, it is infectious, and `Invalid = Invalid` is FALSE** -- the same rule as Currency and DateTime. Test with `IsValid( )`. Every ordering comparison against an Invalid is FALSE, and DecimalCompare returns -2, which is no ordering at all. A default-constructed Decimal is zero and valid.

#### Members

```text
IsValid( ) IsZero( ) IsNegative( ) Sign( ) Scale( )
Lo( ) Mid( ) Hi( )                     ' the three mantissa limbs
ToString( )                            ' exact, EXACTLY 'scale' decimals
ToStringFixed( digits )                ' Rescale then ToString
ToDouble( )                            ' BOUNDED, named
ToLongInt( ) -> Optional( of int64 )   ' truncates; None if it will not fit
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

**Round never increases the scale**, exactly as .NET's decimal.Round does; Rescale is the one that grows it.

Apportion is the most useful function here. Splitting 100.00 three ways gives 33.33 each, whose sum is 99.99. Every accounting system has to decide where the missing cent goes, and doing it ad hoc is how a reconciliation fails. Largest-remainder: **the parts always sum to the total, exactly** -- 33.34 + 33.33 + 33.33 = 100.00.

There is no DecimalAccum. Currency needed one because rounding at every line loses money at four places; Decimal has twenty-eight and its addition is exact, so the accumulator is just `+`.

#### Text

Text is exact both ways -- no DOUBLE anywhere in the parse or the print. **Parsing is strict**: the whole string must be consumed, and more than 28 decimal places is an error rather than a truncation.

```freebasic
DecimalParse( "12abc" )      ' empty -- not a prefix parse
DecimalParse( "1e3" )        ' empty -- there is no exponent grammar
DecimalParse( "0.000000000000000000000000000001" )
                             ' empty -- 29 places, not a silent 28
```

#### Verified against .NET

The point of naming an existing type is that an oracle already exists. 24,000 random operand pairs across `+`, `-`, `*`, `/` and `MOD`: 23,283 identical to .NET, value and scale. The 717 that differ are two deliberate classes -- 657 MOD cases where .NET pre-rounds or throws and this returns the exact remainder (checked against arbitrary precision: this is exact in all 657, and .NET in 2), and 60 multiplications that underflow to zero, where both answers are zero and only the reported scale differs. 3,000 unary cases -- Round at every digit count, Floor, Ceiling, Truncate, Compare, Abs, Negate, ToString -- are identical, with zero divergences.


---

## The finance functions

Without this module, every program that needs a payment, a present value, a rate
conversion, an internal rate of return, a depreciation or an amortization schedule writes
it, in `DOUBLE`, once per call site.

Here is what that costs. A $400,000 mortgage at 5.95% over thirty years, amortized the way
everyone amortizes it -- compute the payment, round it to cents, round each period's
interest to cents, subtract:

```freebasic
' COMPILES TODAY, AND THE LAST ROW IS WRONG
dim as float64 pmt = p * i / ( 1.0 - ( 1.0 + i ) ^ ( -n ) )
pmt = int( pmt * 100.0 + 0.5 ) / 100.0
for k as int32 = 1 to 360
    dim as float64 interest = int( bal * i * 100.0 + 0.5 ) / 100.0
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
#import "std/money"
using money

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

### Exact where it matters, `float64` where it cannot be

`Decimal` has no `Pow`, `Exp`, `Log` or `Sqrt`, so anything needing a power is
either built from multiplication or is not exact. The boundary is drawn once and every
function states which side it is on, in its own doc comment:

| | |
|---|---|
| **Exact** | growth and discount over an **integer** number of periods; every sum, product and quotient of money; day-count fractions |
| **`float64`** | fractional exponents -- nominal-from-effective, the Canadian sixth root, dated discounting; continuous compounding; every solver; all of `finport.tiko` |

A rate that crosses into `float64` crosses back at a fixed scale, and **everything
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

The suites are fbcunit suites, vendored in tiko-lang at `tests/vendor/fbc-tests/finance/` and
run against the module from `tests/std/finance/`: deprec, flows, loan, loanextra, portfolio,
rates, solve and tvm.

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

**Money types — `currency.tiko`, `decimal.tiko`**

|   |   |   |   |   |
|---|---|---|---|---|
| [Currency](Modern-Finance-Currency) | [Raw](Modern-Finance-Raw) | [DecimalOne](Modern-Finance-DecimalOne) | [DecimalFromScaled](Modern-Finance-DecimalFromScaled) | [IsValid](Modern-Finance-IsValid) |
| [CurrencyFromInt](Modern-Finance-CurrencyFromInt) | [Apportion](Modern-Finance-Apportion) | [DecimalMinusOne](Modern-Finance-DecimalMinusOne) | [DecimalFromParts](Modern-Finance-DecimalFromParts) | [Ceiling](Modern-Finance-Ceiling) |
| [CurrencyFromParts](Modern-Finance-CurrencyFromParts) | [AddProduct](Modern-Finance-AddProduct) | [DecimalMinValue](Modern-Finance-DecimalMinValue) | [DecimalFromDouble](Modern-Finance-DecimalFromDouble) | [RoundMode](Modern-Finance-RoundMode) |
| [CurrencyFromRaw](Modern-Finance-CurrencyFromRaw) | [AddScaled](Modern-Finance-AddScaled) | [DecimalMaxValue](Modern-Finance-DecimalMaxValue) | [DecimalFromCurrency](Modern-Finance-DecimalFromCurrency) | [ToDouble](Modern-Finance-ToDouble) |
| [CurrencyFromDouble](Modern-Finance-CurrencyFromDouble) | [Total](Modern-Finance-Total) | [DecimalInvalid](Modern-Finance-DecimalInvalid) | [DecimalParse](Modern-Finance-DecimalParse) |  |
| [CurrencyParse](Modern-Finance-CurrencyParse) | [Decimal](Modern-Finance-Decimal) | [DecimalFromInt](Modern-Finance-DecimalFromInt) | [DecimalCompare](Modern-Finance-DecimalCompare) |  |
| [CurrencyInvalid](Modern-Finance-CurrencyInvalid) | [DecimalZero](Modern-Finance-DecimalZero) | [DecimalFromUInt](Modern-Finance-DecimalFromUInt) | [DecimalApportion](Modern-Finance-DecimalApportion) |  |

**Errors — `finerror.tiko`**

[FinanceError](Modern-Finance-FinanceError) · [FinanceErrorCode](Modern-Finance-FinanceErrorCode) · [FinanceErrorMessage](Modern-Finance-FinanceErrorMessage)

**Conventions, day count and rates — `fincore.tiko`**

|   |   |   |
|---|---|---|
| [Compounding](Modern-Finance-Compounding) | [MoneyRound](Modern-Finance-MoneyRound) | [SimpleInterestBetween](Modern-Finance-SimpleInterestBetween) |
| [PaymentFrequency](Modern-Finance-PaymentFrequency) | [DayCountDays](Modern-Finance-DayCountDays) | [RatePerPeriod](Modern-Finance-RatePerPeriod) |
| [PaymentTiming](Modern-Finance-PaymentTiming) | [DayCountFraction](Modern-Finance-DayCountFraction) | [RateEffectiveFromNominal](Modern-Finance-RateEffectiveFromNominal) |
| [DayCount](Modern-Finance-DayCount) | [DayCountFractionDouble](Modern-Finance-DayCountFractionDouble) | [RateNominalFromEffective](Modern-Finance-RateNominalFromEffective) |
| [MoneyRounding](Modern-Finance-MoneyRounding) | [GrowthFactor](Modern-Finance-GrowthFactor) | [RateConvertCompounding](Modern-Finance-RateConvertCompounding) |
| [MoneyRoundingMake](Modern-Finance-MoneyRoundingMake) | [DiscountFactor](Modern-Finance-DiscountFactor) | [RateContinuousFromEffective](Modern-Finance-RateContinuousFromEffective) |
| [MoneyRoundingCents](Modern-Finance-MoneyRoundingCents) | [GrowthFactorFractional](Modern-Finance-GrowthFactorFractional) | [RateEffectiveFromContinuous](Modern-Finance-RateEffectiveFromContinuous) |
| [MoneyRoundingBankersFour](Modern-Finance-MoneyRoundingBankersFour) | [GrowthFactorContinuous](Modern-Finance-GrowthFactorContinuous) | [RatePerPaymentFromNominal](Modern-Finance-RatePerPaymentFromNominal) |
| [MoneyRoundingExact](Modern-Finance-MoneyRoundingExact) | [SimpleInterest](Modern-Finance-SimpleInterest) |  |

**The root finder — `finsolve.tiko`**

[FinSolverOptions](Modern-Finance-FinSolverOptions) · [FinSolverOptionsDefault](Modern-Finance-FinSolverOptionsDefault) · [FinSolverOptionsWithGuess](Modern-Finance-FinSolverOptionsWithGuess) · [FinObjective](Modern-Finance-FinObjective) · [FinSolveResult](Modern-Finance-FinSolveResult) · [FinSolveRoot](Modern-Finance-FinSolveRoot)

**Time value of money — `fintvm.tiko`**

|   |   |   |   |
|---|---|---|---|
| [AnnuityTerms](Modern-Finance-AnnuityTerms) | [FutureValue](Modern-Finance-FutureValue) | [FutureValueOfLump](Modern-Finance-FutureValueOfLump) | [PeriodsRequired](Modern-Finance-PeriodsRequired) |
| [AnnuityTermsMake](Modern-Finance-AnnuityTermsMake) | [PaymentAmount](Modern-Finance-PaymentAmount) | [AnnuityPresentValueFactor](Modern-Finance-AnnuityPresentValueFactor) | [PeriodsRequiredWhole](Modern-Finance-PeriodsRequiredWhole) |
| [PresentValue](Modern-Finance-PresentValue) | [PresentValueOfLump](Modern-Finance-PresentValueOfLump) | [AnnuityFutureValueFactor](Modern-Finance-AnnuityFutureValueFactor) | [SolveRatePerPeriod](Modern-Finance-SolveRatePerPeriod) |

**Loans and amortization — `finloan.tiko`**

|   |   |   |   |
|---|---|---|---|
| [LoanTerms](Modern-Finance-LoanTerms) | [AmortizationIterator](Modern-Finance-AmortizationIterator) | [LoanInterestBetween](Modern-Finance-LoanInterestBetween) | [ExtraPaymentRecurring](Modern-Finance-ExtraPaymentRecurring) |
| [LoanTermsMake](Modern-Finance-LoanTermsMake) | [ScheduleToArray](Modern-Finance-ScheduleToArray) | [LoanPrincipalBetween](Modern-Finance-LoanPrincipalBetween) | [LoanPayoffAmount](Modern-Finance-LoanPayoffAmount) |
| [LoanTermsUsMortgage](Modern-Finance-LoanTermsUsMortgage) | [LoanPayment](Modern-Finance-LoanPayment) | [LoanSummarize](Modern-Finance-LoanSummarize) | [LoanImpliedRate](Modern-Finance-LoanImpliedRate) |
| [LoanTermsCanadianMortgage](Modern-Finance-LoanTermsCanadianMortgage) | [LoanSchedule](Modern-Finance-LoanSchedule) | [LoanSummary](Modern-Finance-LoanSummary) | [LoanAnnualPercentageRate](Modern-Finance-LoanAnnualPercentageRate) |
| [AmortizationRow](Modern-Finance-AmortizationRow) | [LoanRowAt](Modern-Finance-LoanRowAt) | [ExtraPayment](Modern-Finance-ExtraPayment) |  |
| [AmortizationSchedule](Modern-Finance-AmortizationSchedule) | [LoanBalanceAt](Modern-Finance-LoanBalanceAt) | [ExtraPaymentOnce](Modern-Finance-ExtraPaymentOnce) |  |

**Cash flows and appraisal — `fincash.tiko`**

|   |   |   |   |
|---|---|---|---|
| [CashFlow](Modern-Finance-CashFlow) | [NetPresentValue](Modern-Finance-NetPresentValue) | [ModifiedInternalRateOfReturn](Modern-Finance-ModifiedInternalRateOfReturn) | [PaybackPeriod](Modern-Finance-PaybackPeriod) |
| [CashFlowMake](Modern-Finance-CashFlowMake) | [NetFutureValue](Modern-Finance-NetFutureValue) | [NetPresentValueOnDates](Modern-Finance-NetPresentValueOnDates) | [DiscountedPaybackPeriod](Modern-Finance-DiscountedPaybackPeriod) |
| [CashFlowAt](Modern-Finance-CashFlowAt) | [InternalRateOfReturn](Modern-Finance-InternalRateOfReturn) | [InternalRateOfReturnOnDates](Modern-Finance-InternalRateOfReturnOnDates) | [ProfitabilityIndex](Modern-Finance-ProfitabilityIndex) |

**Depreciation — `findeprec.tiko`**

|   |   |   |
|---|---|---|
| [DepreciationTerms](Modern-Finance-DepreciationTerms) | [DepreciationDecliningBalance](Modern-Finance-DepreciationDecliningBalance) | [DepreciationScheduleIterator](Modern-Finance-DepreciationScheduleIterator) |
| [DepreciationTermsMake](Modern-Finance-DepreciationTermsMake) | [DepreciationDoubleDeclining](Modern-Finance-DepreciationDoubleDeclining) | [DepreciationScheduleOf](Modern-Finance-DepreciationScheduleOf) |
| [DepreciationRow](Modern-Finance-DepreciationRow) | [DepreciationSumOfYearsDigits](Modern-Finance-DepreciationSumOfYearsDigits) | [DepreciationScheduleToArray](Modern-Finance-DepreciationScheduleToArray) |
| [DepreciationMethod](Modern-Finance-DepreciationMethod) | [DepreciationUnitsOfProduction](Modern-Finance-DepreciationUnitsOfProduction) |  |
| [DepreciationStraightLine](Modern-Finance-DepreciationStraightLine) | [DepreciationSchedule](Modern-Finance-DepreciationSchedule) |  |

**Returns and risk — `finport.tiko`**

|   |   |   |   |
|---|---|---|---|
| [ReturnFrequency](Modern-Finance-ReturnFrequency) | [AnnualizeReturnOverPeriods](Modern-Finance-AnnualizeReturnOverPeriods) | [MaxDrawdown](Modern-Finance-MaxDrawdown) | [SortinoRatio](Modern-Finance-SortinoRatio) |
| [ReturnSummary](Modern-Finance-ReturnSummary) | [TimeWeightedReturn](Modern-Finance-TimeWeightedReturn) | [MaxDrawdownPeak](Modern-Finance-MaxDrawdownPeak) | [Beta](Modern-Finance-Beta) |
| [SummarizeReturns](Modern-Finance-SummarizeReturns) | [ModifiedDietzReturn](Modern-Finance-ModifiedDietzReturn) | [MaxDrawdownTrough](Modern-Finance-MaxDrawdownTrough) | [Alpha](Modern-Finance-Alpha) |
| [HoldingPeriodReturn](Modern-Finance-HoldingPeriodReturn) | [MoneyWeightedReturn](Modern-Finance-MoneyWeightedReturn) | [Volatility](Modern-Finance-Volatility) | [TrackingError](Modern-Finance-TrackingError) |
| [CompoundAnnualGrowthRate](Modern-Finance-CompoundAnnualGrowthRate) | [CumulativeReturnSeries](Modern-Finance-CumulativeReturnSeries) | [DownsideDeviation](Modern-Finance-DownsideDeviation) | [InformationRatio](Modern-Finance-InformationRatio) |
| [AnnualizeReturn](Modern-Finance-AnnualizeReturn) | [DrawdownSeries](Modern-Finance-DrawdownSeries) | [SharpeRatio](Modern-Finance-SharpeRatio) | [CorrelationToBenchmark](Modern-Finance-CorrelationToBenchmark) |
