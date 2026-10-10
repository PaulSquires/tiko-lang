'' std/money, a real module: Decimal and Currency, their procedures and operators, and an
'' enum member, qualified and through 'using'.
#import "std/money"
private function Show( byref d as money.Decimal ) as string
    return d.ToString( )
end function
dim as money.Decimal a = money.DecimalFromInt( 12 )
print Show( a ); " "; money.DecimalCompare( a, money.DecimalFromInt( 13 ) )
dim as money.Currency c = money.CurrencyFromParts( 3, 2500 ) + money.CurrencyFromInt( 1 )
print c.ToString( ); " "; money.PAY_BEGIN_OF_PERIOD = money.PaymentTiming.PAY_BEGIN_OF_PERIOD
scope
    using money
    print CurrencyFromRaw( 12345 ).ToString( )
end scope
