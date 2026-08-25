type UDT1
    as long a, b
end type
print sizeof( typeof( integer ) )
print sizeof( typeof( long ptr ) )
print sizeof( typeof( UDT1 ) )
dim as typeof( zstring * 5 ) z
print sizeof( z )
dim as typeof( double ) d
print sizeof( d )
