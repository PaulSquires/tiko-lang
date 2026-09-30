'' A store through the address of a temporary -- fbc's error 24 on the refused line.
type UDT
    i as integer
end type
dim x as UDT
*@type<UDT>( 1 ) = x                                '' 24
dim p as UDT ptr = @type<UDT>( 1 )                  '' fine
