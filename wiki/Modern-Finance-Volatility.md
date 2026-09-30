[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **Volatility**

# Volatility

## Syntax

```freebasic
Volatility( periodReturns( ), frequency )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The SAMPLE standard deviation of the returns, annualized.
''
'' IT SCALES BY THE SQUARE ROOT of the frequency, not by the frequency --
'' variance scales with time, standard deviation with its square root.
dim as double r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as double b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print Volatility( r( ), RETURN_MONTHLY ).Value( )        '' 0.07088723439378913

'' Which is why monthly and quarterly differ by exactly sqrt( 3 ).
dim as double vm = Volatility( r( ), RETURN_MONTHLY ).Value( )
dim as double vq = Volatility( r( ), RETURN_QUARTERLY ).Value( )
print vm / vq                                            '' 1.732050807568877

'' A single observation has no sample variance -- n-1 is zero.
dim as double one_( 0 to 0 ) = { 0.02 }
print Volatility( one_( ), RETURN_MONTHLY ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
