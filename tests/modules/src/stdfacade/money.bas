'' std/money (RFC-0009): Decimal and Currency, their procedures and an enum member through
'' the facade, beside fb/decimal.bi included directly -- a money.Decimal IS an FB.Decimal.
#import "std/money"
#include once "fb/decimal.bi"
private function Show( byref d as FB.Decimal ) as string
    return d.ToString( )
end function
dim as money.Decimal a = money.DecimalFromInt( 12 )
print Show( a ); " "; money.DecimalCompare( a, money.DecimalFromInt( 13 ) )
dim as money.Currency c = money.CurrencyFromParts( 3, 2500 ) + money.CurrencyFromInt( 1 )
print c.ToString( ); " "; money.PAY_BEGIN_OF_PERIOD = FB.PaymentTiming.PAY_BEGIN_OF_PERIOD
