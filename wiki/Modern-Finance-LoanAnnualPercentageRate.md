[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanAnnualPercentageRate**

# LoanAnnualPercentageRate

## Syntax

```freebasic
LoanAnnualPercentageRate( loanTerms, financedFees )
```

## Examples

```freebasic
#import "std/money"
using FB

'' The rate implied once financed fees are counted as part of the cost of
'' borrowing: the borrower receives less but repays the same.
''
'' THIS IS THE ARITHMETIC, NOT ANY JURISDICTION'S DISCLOSURE RULE.
'' Regulation Z and the Canadian Cost of Borrowing regulations each
'' prescribe WHICH fees count; this takes the total you decide on.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

print LoanAnnualPercentageRate( t, DecimalZero( ) ).Value( ).Round( 4 ).ToString( )   '' 0.0595

'' Fees raise it, monotonically.
dim as Decimal withFees = LoanAnnualPercentageRate( t, DecimalParse( "8000" ).Value( ) ).Value( )
print withFees.ToStringFixed( 6 )        '' 0.061389
dim as boolean higher = ( withFees > LoanAnnualPercentageRate( t, DecimalZero( ) ).Value( ) )
print higher                             '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
