'' A GENERIC'S FIELD INITIALISER NAMES ITS TYPE PARAMETER, and a module-level variable is spelled the
'' same: the parameter wins, as it does in a method body. tiko bound 'T' to the variable 't' and
'' every instance read sizeof( double ).
type Buf( of T )
    as long plain = sizeof( T )
    as long twice = sizeof( T ) * 2
    declare function Inside( ) as long
end type

function Buf( of T ).Inside( ) as long
    return sizeof( T )
end function

dim as double t
dim as Buf( of byte ) a
dim as Buf( of short ) b
print a.plain; a.twice; a.Inside( ); b.plain; b.twice; b.Inside( ); sizeof( t )
