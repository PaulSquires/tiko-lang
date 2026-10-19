[Home](Home) › [Function Finder](Function-Finder) › **Money and finance**

# Money and finance

The functions to calculate interest, returns and schedules with exact decimals, grouped by what you want to do. The **From** column says what a program needs before it can call one:

- `std/money`: `#import "std/money"`, then `using money` to call it by its bare name.

Jump to: [Make a money value](#make-a-money-value) · [Check and convert a value](#check-and-convert-a-value) · [Zero, one, limits and Invalid](#zero-one-limits-and-invalid) · [Round and split amounts](#round-and-split-amounts) · [Total many amounts without rounding drift](#total-many-amounts-without-rounding-drift) · [Choose a rounding policy](#choose-a-rounding-policy) · [Handle a finance error](#handle-a-finance-error) · [Convert interest rates](#convert-interest-rates) · [Simple interest and day counts](#simple-interest-and-day-counts) · [Grow and discount over periods](#grow-and-discount-over-periods) · [Present value, future value and payments](#present-value-future-value-and-payments) · [Set up a loan and its payment](#set-up-a-loan-and-its-payment) · [Walk an amortization schedule](#walk-an-amortization-schedule) · [Loan totals, payoff and extra payments](#loan-totals-payoff-and-extra-payments) · [Appraise cash flows: NPV, IRR and payback](#appraise-cash-flows-npv-irr-and-payback) · [Depreciate an asset](#depreciate-an-asset) · [Measure investment returns](#measure-investment-returns) · [Measure risk and drawdowns](#measure-risk-and-drawdowns) · [Compare a portfolio with its benchmark](#compare-a-portfolio-with-its-benchmark) · [Find a root of your own function](#find-a-root-of-your-own-function)

## Make a money value

| Function | What it does | From |
|---|---|---|
| [Currency](Modern-Finance-Currency) | Holds an exact amount with four decimal places, for money that needs no more. | `std/money` |
| [Decimal](Modern-Finance-Decimal) | Holds an exact decimal number with up to 28 places, for rates, prices and results. | `std/money` |
| [DecimalParse](Modern-Finance-DecimalParse) | Parses text into a Decimal exactly; returns empty on bad input or over 28 places. | `std/money` |
| [CurrencyParse](Modern-Finance-CurrencyParse) | Parses text into a Currency exactly; returns empty on bad input or over four places. | `std/money` |
| [CurrencyFromInt](Modern-Finance-CurrencyFromInt) | Returns a Currency of a whole number of units, exactly. | `std/money` |
| [CurrencyFromParts](Modern-Finance-CurrencyFromParts) | Returns a Currency from whole units and a ten-thousandths part, exactly. | `std/money` |
| [CurrencyFromRaw](Modern-Finance-CurrencyFromRaw) | Returns a Currency from its stored integer, which is the amount times 10000. | `std/money` |
| [CurrencyFromDouble](Modern-Finance-CurrencyFromDouble) | Converts a double to a Currency, rounded to four decimal places. | `std/money` |
| [DecimalFromInt](Modern-Finance-DecimalFromInt) | Returns a 64-bit integer as a Decimal, exactly. | `std/money` |
| [DecimalFromUInt](Modern-Finance-DecimalFromUInt) | Returns an unsigned 64-bit integer as a Decimal, exactly. | `std/money` |
| [DecimalFromScaled](Modern-Finance-DecimalFromScaled) | Returns a whole number over a power of ten as a Decimal: 1999 at scale 2 is 19.99. | `std/money` |
| [DecimalFromParts](Modern-Finance-DecimalFromParts) | Builds a Decimal from three 32-bit mantissa words, a sign flag and a scale. | `std/money` |
| [DecimalFromDouble](Modern-Finance-DecimalFromDouble) | Converts a double to a Decimal of 15 significant digits; NaN or infinity gives Invalid. | `std/money` |
| [DecimalFromCurrency](Modern-Finance-DecimalFromCurrency) | Converts a Currency to a Decimal, exactly. | `std/money` |

## Check and convert a value

| Function | What it does | From |
|---|---|---|
| [Currency.IsValid](Modern-Finance-IsValid) | Returns false if the Currency is Invalid; the only reliable test for a bad value. | `std/money` |
| [Currency.Raw](Modern-Finance-Raw) | Returns the stored integer, the amount times 10000, for saving to a file or database. | `std/money` |
| [Currency.ToDouble](Modern-Finance-ToDouble) | Returns the amount as a double, which loses precision above about 900 billion. | `std/money` |
| [DecimalCompare](Modern-Finance-DecimalCompare) | Returns -1, 0 or 1 comparing two Decimals by value, or -2 if either is Invalid. | `std/money` |

## Zero, one, limits and Invalid

| Function | What it does | From |
|---|---|---|
| [DecimalZero](Modern-Finance-DecimalZero) | Returns zero, the same value a new Decimal starts with. | `std/money` |
| [DecimalOne](Modern-Finance-DecimalOne) | Returns one as a Decimal. | `std/money` |
| [DecimalMinusOne](Modern-Finance-DecimalMinusOne) | Returns minus one as a Decimal. | `std/money` |
| [DecimalMinValue](Modern-Finance-DecimalMinValue) | Returns the most negative value a Decimal can hold. | `std/money` |
| [DecimalMaxValue](Modern-Finance-DecimalMaxValue) | Returns the largest value a Decimal can hold. | `std/money` |
| [DecimalInvalid](Modern-Finance-DecimalInvalid) | Returns the Invalid Decimal, which overflow and division by zero also produce. | `std/money` |
| [CurrencyInvalid](Modern-Finance-CurrencyInvalid) | Returns the Invalid Currency, which overflow also produces; it never equals anything. | `std/money` |

## Round and split amounts

| Function | What it does | From |
|---|---|---|
| [Currency.Ceiling](Modern-Finance-Ceiling) | Returns the amount rounded up to a whole unit, towards positive infinity. | `std/money` |
| [Currency.RoundMode](Modern-Finance-RoundMode) | Returns the amount rounded to 0 to 4 places by a rounding rule you name. | `std/money` |
| [Apportion](Modern-Finance-Apportion) | Splits a Currency total by weights into parts that add up to it exactly. | `std/money` |
| [DecimalApportion](Modern-Finance-DecimalApportion) | Splits a Decimal total by weights, at a scale you choose, into parts that add up exactly. | `std/money` |

## Total many amounts without rounding drift

| Function | What it does | From |
|---|---|---|
| [CurrencyAccum.AddProduct](Modern-Finance-AddProduct) | Adds an amount times a rate to a running total, rounding only once at the end. | `std/money` |
| [CurrencyAccum.AddScaled](Modern-Finance-AddScaled) | Adds an amount times a fraction, such as one third, to a running total exactly. | `std/money` |
| [CurrencyAccum.Total](Modern-Finance-Total) | Returns the running total as a Currency, rounded once; reading it does not reset it. | `std/money` |

## Choose a rounding policy

| Function | What it does | From |
|---|---|---|
| [MoneyRounding](Modern-Finance-MoneyRounding) | Holds a rounding policy: decimal places, rounding mode, and whether to round each amount. | `std/money` |
| [MoneyRoundingMake](Modern-Finance-MoneyRoundingMake) | Returns a rounding policy with the places, mode and round-each flag you choose. | `std/money` |
| [MoneyRoundingCents](Modern-Finance-MoneyRoundingCents) | Returns the default policy: two places, half-to-even, every posted amount rounded. | `std/money` |
| [MoneyRoundingBankersFour](Modern-Finance-MoneyRoundingBankersFour) | Returns a policy of four places, half-to-even, to match a Currency ledger. | `std/money` |
| [MoneyRoundingExact](Modern-Finance-MoneyRoundingExact) | Returns a policy that never rounds, to keep full precision or see what rounding costs. | `std/money` |
| [MoneyRound](Modern-Finance-MoneyRound) | Rounds a Decimal by a policy, or returns it unchanged if the policy does not round. | `std/money` |

## Handle a finance error

| Function | What it does | From |
|---|---|---|
| [FinanceError](Modern-Finance-FinanceError) | Holds why a finance call failed: a code, a message and, for solvers, how close it got. | `std/money` |
| [FinanceErrorCode](Modern-Finance-FinanceErrorCode) | Lists the failure codes, such as FIN_INVALID_RATE and FIN_NO_SIGN_CHANGE. | `std/money` |
| [FinanceErrorMessage](Modern-Finance-FinanceErrorMessage) | Returns a short, fixed English description of a failure code. | `std/money` |

## Convert interest rates

| Function | What it does | From |
|---|---|---|
| [Compounding](Modern-Finance-Compounding) | Lists how often interest compounds, as periods per year, plus simple and continuous. | `std/money` |
| [RatePerPeriod](Modern-Finance-RatePerPeriod) | Returns a quoted annual rate divided by its compounding periods, exactly. | `std/money` |
| [RateEffectiveFromNominal](Modern-Finance-RateEffectiveFromNominal) | Returns what a quoted annual rate really earns in a year once it compounds. | `std/money` |
| [RateNominalFromEffective](Modern-Finance-RateNominalFromEffective) | Returns the quoted annual rate that earns a given effective yearly return. | `std/money` |
| [RateConvertCompounding](Modern-Finance-RateConvertCompounding) | Restates a quoted annual rate for a different compounding frequency. | `std/money` |
| [RateContinuousFromEffective](Modern-Finance-RateContinuousFromEffective) | Returns the continuously compounded rate that gives an effective yearly return. | `std/money` |
| [RateEffectiveFromContinuous](Modern-Finance-RateEffectiveFromContinuous) | Returns the effective yearly return of a continuously compounded rate. | `std/money` |
| [RatePerPaymentFromNominal](Modern-Finance-RatePerPaymentFromNominal) | Returns the rate per payment when compounding and payment frequency differ. | `std/money` |

## Simple interest and day counts

| Function | What it does | From |
|---|---|---|
| [SimpleInterest](Modern-Finance-SimpleInterest) | Returns principal times rate times a fraction of a year, exactly. | `std/money` |
| [SimpleInterestBetween](Modern-Finance-SimpleInterestBetween) | Returns simple interest between two dates on a day-count basis you choose. | `std/money` |
| [DayCount](Modern-Finance-DayCount) | Lists the six day-count bases, such as actual/365 fixed and 30/360 US. | `std/money` |
| [DayCountDays](Modern-Finance-DayCountDays) | Counts the days between two dates on a day-count basis. | `std/money` |
| [DayCountFraction](Modern-Finance-DayCountFraction) | Returns the fraction of a year between two dates on a basis, as an exact Decimal. | `std/money` |
| [DayCountFractionDouble](Modern-Finance-DayCountFractionDouble) | Returns the fraction of a year between two dates on a basis, as a double. | `std/money` |

## Grow and discount over periods

| Function | What it does | From |
|---|---|---|
| [GrowthFactor](Modern-Finance-GrowthFactor) | Returns what one unit grows to over a whole number of periods at a rate, exactly. | `std/money` |
| [DiscountFactor](Modern-Finance-DiscountFactor) | Returns what one unit due after a whole number of periods is worth today. | `std/money` |
| [GrowthFactorFractional](Modern-Finance-GrowthFactorFractional) | Returns what one unit grows to over a fractional number of periods. | `std/money` |
| [GrowthFactorContinuous](Modern-Finance-GrowthFactorContinuous) | Returns what one unit grows to over a number of years with continuous compounding. | `std/money` |

## Present value, future value and payments

| Function | What it does | From |
|---|---|---|
| [AnnuityTerms](Modern-Finance-AnnuityTerms) | Holds rate, periods, payment, present value, future value and timing for annuity sums. | `std/money` |
| [AnnuityTermsMake](Modern-Finance-AnnuityTermsMake) | Returns annuity terms from the six values; the one being solved for is ignored. | `std/money` |
| [PaymentTiming](Modern-Finance-PaymentTiming) | Lists whether payments fall at the end or at the start of each period. | `std/money` |
| [PresentValue](Modern-Finance-PresentValue) | Returns what a stream of payments plus a final amount is worth today. | `std/money` |
| [FutureValue](Modern-Finance-FutureValue) | Returns what a stream of payments will be worth at the end of the term. | `std/money` |
| [PaymentAmount](Modern-Finance-PaymentAmount) | Returns the level payment per period, negative when the present value is positive. | `std/money` |
| [PresentValueOfLump](Modern-Finance-PresentValueOfLump) | Returns a single future amount discounted back a number of periods. | `std/money` |
| [FutureValueOfLump](Modern-Finance-FutureValueOfLump) | Returns a single amount compounded forward a number of periods. | `std/money` |
| [PeriodsRequired](Modern-Finance-PeriodsRequired) | Returns how many periods a payment takes to clear a balance, as a fractional double. | `std/money` |
| [PeriodsRequiredWhole](Modern-Finance-PeriodsRequiredWhole) | Returns how many payments clear a balance, rounded up to a whole number. | `std/money` |
| [SolveRatePerPeriod](Modern-Finance-SolveRatePerPeriod) | Returns the rate per period implied by a known payment, value and term. | `std/money` |
| [AnnuityPresentValueFactor](Modern-Finance-AnnuityPresentValueFactor) | Returns what one unit paid each period is worth today. | `std/money` |
| [AnnuityFutureValueFactor](Modern-Finance-AnnuityFutureValueFactor) | Returns what one unit paid each period grows to by the end of the term. | `std/money` |

## Set up a loan and its payment

| Function | What it does | From |
|---|---|---|
| [LoanTerms](Modern-Finance-LoanTerms) | Holds a loan's principal, rate, term, frequencies, rounding and first payment date. | `std/money` |
| [LoanTermsMake](Modern-Finance-LoanTermsMake) | Returns loan terms with the payment frequency and compounding you choose. | `std/money` |
| [LoanTermsUsMortgage](Modern-Finance-LoanTermsUsMortgage) | Returns loan terms for a US mortgage: monthly compounding and monthly payments. | `std/money` |
| [LoanTermsCanadianMortgage](Modern-Finance-LoanTermsCanadianMortgage) | Returns loan terms for a Canadian mortgage: semi-annual compounding, monthly payments. | `std/money` |
| [PaymentFrequency](Modern-Finance-PaymentFrequency) | Lists how often payments are made, including weekly and accelerated biweekly. | `std/money` |
| [LoanPayment](Modern-Finance-LoanPayment) | Returns a loan's level payment, rounded once; the last payment absorbs the remainder. | `std/money` |
| [LoanImpliedRate](Modern-Finance-LoanImpliedRate) | Returns the annual rate implied by a known principal, payment and term. | `std/money` |
| [LoanAnnualPercentageRate](Modern-Finance-LoanAnnualPercentageRate) | Returns the annual rate once financed fees are counted as a cost of borrowing. | `std/money` |

## Walk an amortization schedule

| Function | What it does | From |
|---|---|---|
| [LoanSchedule](Modern-Finance-LoanSchedule) | Returns a loan's amortization schedule, built lazily, to walk with for each. | `std/money` |
| [AmortizationSchedule](Modern-Finance-AmortizationSchedule) | Holds a loan schedule's terms and gives its scheduled payment count and payment. | `std/money` |
| [AmortizationIterator](Modern-Finance-AmortizationIterator) | Walks a loan schedule row by row, for stopping early or reading a window. | `std/money` |
| [AmortizationRow](Modern-Finance-AmortizationRow) | Holds one period: due date, balances, payment, interest, principal and running totals. | `std/money` |
| [ScheduleToArray](Modern-Finance-ScheduleToArray) | Returns every row of a loan schedule as an Array, for random access. | `std/money` |
| [LoanRowAt](Modern-Finance-LoanRowAt) | Returns one row of a loan schedule, rounded exactly as it would be posted. | `std/money` |
| [LoanBalanceAt](Modern-Finance-LoanBalanceAt) | Returns the balance after a period from a formula, without walking the schedule. | `std/money` |

## Loan totals, payoff and extra payments

| Function | What it does | From |
|---|---|---|
| [LoanInterestBetween](Modern-Finance-LoanInterestBetween) | Returns the interest posted across a range of periods, such as one tax year. | `std/money` |
| [LoanPrincipalBetween](Modern-Finance-LoanPrincipalBetween) | Returns the principal repaid across a range of periods, extra payments included. | `std/money` |
| [LoanPayoffAmount](Modern-Finance-LoanPayoffAmount) | Returns what settles a loan on a date: the balance plus interest accrued since. | `std/money` |
| [LoanSummarize](Modern-Finance-LoanSummarize) | Returns a loan's totals, payment count and payoff date, and what extra payments save. | `std/money` |
| [LoanSummary](Modern-Finance-LoanSummary) | Holds what LoanSummarize returns: payments, totals, effective rate and savings. | `std/money` |
| [ExtraPayment](Modern-Finance-ExtraPayment) | Holds extra principal paid over a range of periods; overlapping ranges add up. | `std/money` |
| [ExtraPaymentOnce](Modern-Finance-ExtraPaymentOnce) | Returns a single extra principal payment made in one period. | `std/money` |
| [ExtraPaymentRecurring](Modern-Finance-ExtraPaymentRecurring) | Returns the same extra principal payment in every period of a range. | `std/money` |

## Appraise cash flows: NPV, IRR and payback

| Function | What it does | From |
|---|---|---|
| [CashFlow](Modern-Finance-CashFlow) | Holds an amount and the date it happens, for the dated value and return functions. | `std/money` |
| [CashFlowMake](Modern-Finance-CashFlowMake) | Returns a cash flow on a date; the dates in a series must ascend. | `std/money` |
| [CashFlowAt](Modern-Finance-CashFlowAt) | Returns a cash flow with no date, placed by its period number. | `std/money` |
| [NetPresentValue](Modern-Finance-NetPresentValue) | Returns the net present value of flows at a rate; the first flow is not discounted. | `std/money` |
| [NetFutureValue](Modern-Finance-NetFutureValue) | Returns the net present value carried forward to the end of the series. | `std/money` |
| [NetPresentValueOnDates](Modern-Finance-NetPresentValueOnDates) | Returns the net present value of dated flows at an annual rate on a day-count basis. | `std/money` |
| [InternalRateOfReturn](Modern-Finance-InternalRateOfReturn) | Returns the rate at which the net present value of a series of flows is zero. | `std/money` |
| [InternalRateOfReturnOnDates](Modern-Finance-InternalRateOfReturnOnDates) | Returns the internal rate of return of flows on irregular dates. | `std/money` |
| [ModifiedInternalRateOfReturn](Modern-Finance-ModifiedInternalRateOfReturn) | Returns a rate of return with one answer, from separate finance and reinvestment rates. | `std/money` |
| [PaybackPeriod](Modern-Finance-PaybackPeriod) | Returns when the running total of flows turns positive, or empty if it never does. | `std/money` |
| [DiscountedPaybackPeriod](Modern-Finance-DiscountedPaybackPeriod) | Returns when the running total of discounted flows turns positive, or empty if never. | `std/money` |
| [ProfitabilityIndex](Modern-Finance-ProfitabilityIndex) | Returns the present value of the later flows divided by the initial outlay. | `std/money` |

## Depreciate an asset

| Function | What it does | From |
|---|---|---|
| [DepreciationTerms](Modern-Finance-DepreciationTerms) | Holds an asset's cost, salvage value, life in periods and declining-balance factor. | `std/money` |
| [DepreciationTermsMake](Modern-Finance-DepreciationTermsMake) | Returns depreciation terms from cost, salvage and life, with a factor of 2 and cents. | `std/money` |
| [DepreciationMethod](Modern-Finance-DepreciationMethod) | Lists the six methods, from straight line to units of production. | `std/money` |
| [DepreciationStraightLine](Modern-Finance-DepreciationStraightLine) | Returns one period's expense, with cost less salvage spread evenly over the life. | `std/money` |
| [DepreciationDecliningBalance](Modern-Finance-DepreciationDecliningBalance) | Returns one period's expense as a fixed fraction of the remaining book value. | `std/money` |
| [DepreciationDoubleDeclining](Modern-Finance-DepreciationDoubleDeclining) | Returns one period's expense at twice the straight-line rate, never below salvage. | `std/money` |
| [DepreciationSumOfYearsDigits](Modern-Finance-DepreciationSumOfYearsDigits) | Returns one period's expense, weighted by how many periods of the life are left. | `std/money` |
| [DepreciationUnitsOfProduction](Modern-Finance-DepreciationUnitsOfProduction) | Returns one period's expense from the units it produced out of the lifetime total. | `std/money` |
| [DepreciationScheduleOf](Modern-Finance-DepreciationScheduleOf) | Returns the full schedule for a method, including declining balance with a switch. | `std/money` |
| [DepreciationSchedule](Modern-Finance-DepreciationSchedule) | Holds every period of a write-off, to walk with for each. | `std/money` |
| [DepreciationScheduleIterator](Modern-Finance-DepreciationScheduleIterator) | Walks a depreciation schedule row by row, for stopping early. | `std/money` |
| [DepreciationRow](Modern-Finance-DepreciationRow) | Holds one period: opening and closing book value, expense and depreciation so far. | `std/money` |
| [DepreciationScheduleToArray](Modern-Finance-DepreciationScheduleToArray) | Returns every row of a depreciation schedule as an Array. | `std/money` |

## Measure investment returns

| Function | What it does | From |
|---|---|---|
| [ReturnFrequency](Modern-Finance-ReturnFrequency) | Lists how many observations make a year: annual, quarterly, monthly, weekly or daily. | `std/money` |
| [HoldingPeriodReturn](Modern-Finance-HoldingPeriodReturn) | Returns the gain plus income over a holding period, as a fraction of the start value. | `std/money` |
| [CompoundAnnualGrowthRate](Modern-Finance-CompoundAnnualGrowthRate) | Returns the steady yearly rate that grows a starting value to an ending value. | `std/money` |
| [AnnualizeReturn](Modern-Finance-AnnualizeReturn) | Converts a return per period to a yearly return by compounding, not multiplying. | `std/money` |
| [AnnualizeReturnOverPeriods](Modern-Finance-AnnualizeReturnOverPeriods) | Converts a total return over a number of observations to a yearly return. | `std/money` |
| [TimeWeightedReturn](Modern-Finance-TimeWeightedReturn) | Returns sub-period returns linked by compounding, ignoring when money moved in or out. | `std/money` |
| [ModifiedDietzReturn](Modern-Finance-ModifiedDietzReturn) | Returns an approximate time-weighted return, weighting each flow by days invested. | `std/money` |
| [MoneyWeightedReturn](Modern-Finance-MoneyWeightedReturn) | Returns the dated internal rate of return of contributions and the closing value. | `std/money` |
| [CumulativeReturnSeries](Modern-Finance-CumulativeReturnSeries) | Returns the compounded return after each observation, as a growth chart plots. | `std/money` |

## Measure risk and drawdowns

| Function | What it does | From |
|---|---|---|
| [Volatility](Modern-Finance-Volatility) | Returns the sample standard deviation of returns, annualized. | `std/money` |
| [DownsideDeviation](Modern-Finance-DownsideDeviation) | Returns the annualized shortfall of returns below a target, ignoring gains. | `std/money` |
| [MaxDrawdown](Modern-Finance-MaxDrawdown) | Returns the worst fall from a peak to a later low, as a positive fraction. | `std/money` |
| [MaxDrawdownPeak](Modern-Finance-MaxDrawdownPeak) | Returns the index of the peak the worst drawdown fell from, or empty if none. | `std/money` |
| [MaxDrawdownTrough](Modern-Finance-MaxDrawdownTrough) | Returns the index of the low point of the worst drawdown, or empty if none. | `std/money` |
| [DrawdownSeries](Modern-Finance-DrawdownSeries) | Returns the fall from the running peak at each observation, zero or negative. | `std/money` |
| [SharpeRatio](Modern-Finance-SharpeRatio) | Returns the annualized return above the risk-free rate per unit of volatility. | `std/money` |
| [SortinoRatio](Modern-Finance-SortinoRatio) | Returns the annualized return above a target per unit of downside deviation. | `std/money` |
| [SummarizeReturns](Modern-Finance-SummarizeReturns) | Returns total and yearly return, volatility, Sharpe, Sortino and drawdown in one call. | `std/money` |
| [ReturnSummary](Modern-Finance-ReturnSummary) | Holds the figures SummarizeReturns computes, one field each. | `std/money` |

## Compare a portfolio with its benchmark

| Function | What it does | From |
|---|---|---|
| [Beta](Modern-Finance-Beta) | Returns how much an asset moves when its benchmark moves by one. | `std/money` |
| [Alpha](Modern-Finance-Alpha) | Returns the annualized return beyond what the asset's beta to its benchmark explains. | `std/money` |
| [TrackingError](Modern-Finance-TrackingError) | Returns the annualized standard deviation of the asset's return less the benchmark's. | `std/money` |
| [InformationRatio](Modern-Finance-InformationRatio) | Returns the return above the benchmark per unit of tracking error. | `std/money` |
| [CorrelationToBenchmark](Modern-Finance-CorrelationToBenchmark) | Returns how closely an asset moves with its benchmark, from -1 to 1. | `std/money` |

## Find a root of your own function

| Function | What it does | From |
|---|---|---|
| [FinSolveRoot](Modern-Finance-FinSolveRoot) | Finds where your function is zero between two bounds, and reports how close it got. | `std/money` |
| [FinObjective](Modern-Finance-FinObjective) | Holds a pointer to the function the root finder calls with a value and a context. | `std/money` |
| [FinSolverOptions](Modern-Finance-FinSolverOptions) | Holds the root finder's bounds, starting guess, tolerances and iteration limits. | `std/money` |
| [FinSolverOptionsDefault](Modern-Finance-FinSolverOptionsDefault) | Returns the standard solver settings: rate bounds, 128 iterations and no guess. | `std/money` |
| [FinSolverOptionsWithGuess](Modern-Finance-FinSolverOptionsWithGuess) | Returns the standard solver settings with a starting guess. | `std/money` |
| [FinSolveResult](Modern-Finance-FinSolveResult) | Holds the root found, its residual, the iteration count and whether it converged. | `std/money` |

## See Also

- [Finance guide](Category-Finance)
- [Result, which fallible finance calls return](Category-Result)
- [Optional, which the parse functions return](Category-Optional)
- [Date and Time, for the dates of dated flows](Category-Date-and-Time-Chrono)
- [Format money](Functions-Text#format-money)

---

[Home](Home) · [Function Finder](Function-Finder) · [Keyword Index](Keyword-Index)

<!-- Generated by tools/wikifinder/finder.py. Edit the data, not this page. -->
