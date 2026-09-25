'' HOW DEEP ONE GENERIC INSTANTIATION MAY DRIVE ANOTHER -- fbc's error 339 past
'' -maxinstdepth (fbc-modern 1.20, 2026-09-25). Compiled with -maxinstdepth 1 every use
'' below is refused, and with 2 none is: a field's type is one deeper than its owner, and
'' a member or procedure body replays at depth 1, so what it names is depth 2. fbc
'' reports the first on the header of the generic being expanded and stops; tiko reports
'' each, on the use itself.
type FC( of T )
    as T v
end type
type FA( of T )
    as FC( of T ) v                     ' too deep at 1: a field
end type
type MC( of T )
    as T v
end type
type MA( of T )
    as T v
    declare sub go( )
end type
sub MA( of T ).go( )
    dim as MC( of T ) z                 ' too deep at 1: a member body
end sub
sub PG( of T )( byval x as T )
end sub
sub PF( of T )( byval x as T )
    PG( x )                             ' too deep at 1: a procedure body
end sub
dim as FA( of long ) fa
dim as MA( of long ) ma
ma.go( )
PF( 1 )
dim as FC( of FC( of FC( of long ) ) ) nested   ' a type ARGUMENT costs nothing
