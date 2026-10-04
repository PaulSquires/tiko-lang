'' See ../byref-escaped-literal-run.test.
function LU( byref a as ustring ) as integer
    return len( a )
end function
function LS( byref a as string ) as integer
    return len( a )
end function
function LW( byref a as wstring ) as integer
    return len( a )
end function
function F( byref a as ustring, byref b as ustring ) as integer
    return instr( lcase( a ), lcase( b ) )
end function
print LU( !"\u00E4b" ); LU( "plain" ); LU( !"tab\tx" ); LU( !"x\u00E4" & "y" )
print LS( !"\u00E4b" ); LS( "plain" )
print LW( !"\u00E4b" ); LW( "plain" )
print F( !"STRA\u00DFE UND \u00C4RGER", !"\u00E4rger" )
