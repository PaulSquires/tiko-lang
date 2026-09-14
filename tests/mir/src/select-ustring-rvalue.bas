'' SELECT CASE OVER A USTRING RVALUE copies the subject into a ustring temporary. The
'' temporary 'lcase( name_ )' built was compared once and RELEASED by fb_UStrCompare, so
'' every later case compared against freed memory: tracks' reader matched '#tradedb' and
'' nothing after it. Measured, fbc-modern prints ' 1 2 0'.
function Kind( byref name_ as ustring ) as long
    select case lcase( name_ )
    case "#tradedb" : return 1
    case "trade"    : return 2
    end select
    return 0
end function
print Kind( "#TradeDB" ); Kind( "Trade" ); Kind( "x" )
