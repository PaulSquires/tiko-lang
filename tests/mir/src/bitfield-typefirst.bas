#lang "fb"

'' BOTH SPELLINGS fbc ACCEPTS, side by side. 'a as ulong : 3' is its error 14.
type NameFirst
    a : 3 as ulong
    b : 5 as ulong
end type

type TypeFirst
    as ulong a : 3
    as ulong b : 5
    as ulong c : 24
end type

'' A ':' AFTER A FIELD IS NORMALLY A SEPARATOR, not a width.
type TwoOnOneLine
    as integer x : as integer y
end type

print sizeof( NameFirst ); sizeof( TypeFirst ); sizeof( TwoOnOneLine )

dim as TypeFirst v
v.a = 5 : v.b = 17 : v.c = 999
print v.a; v.b; v.c
