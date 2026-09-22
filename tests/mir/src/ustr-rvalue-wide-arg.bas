'' A USTRING RVALUE PASSED TO A WIDE PARAMETER IS COPIED, AND ITS DATA POINTER PASSED.
'' Measured, fbc writes the same four steps for every spelling below, against 'byval as
'' wstring ptr' and 'byref as wstring' alike:
''
''     FBUSTRING* vr$3 = _ZN1T4GETUEi( &O$0, 0 );
''     fb_UStrAssign( (void*)&TMP$10$0, -1ll, (void*)vr$3, -1ll, 0 );
''     TAKEW( 1, (uint16*)*(uint16**)&TMP$10$0 );
''     fb_UStrDelete( (FBUSTRING*)&TMP$10$0 );
''
'' tiko handed a PAREN-LESS call or a property the procedure's own address, and loaded its
'' first eight bytes of machine code as the data pointer -- fbx's CISaveFileDialog example
'' died in 'OutputDebugStringW( psfd.GetResultString )'. Every other rvalue went through
'' fb_StrAssign as if it were narrow, and the callee saw one character: 'x:uhello0' came
'' out 'x'. A 'byval as ustring' parameter got the code address as a DESCRIPTOR.
''
'' fbc prints, one per line:
''     1 [ 7] uhello0     2 [ 4] free     3 [ 7] uhello0     4 [ 9] x:uhello0
''     5 [ 9] x:uhello0   6 [ 4] abcd     7 [ 2] AB          8 [ 4] prop
''     9 [ 7] uhello0     10 [ 7] uhello0 11 [ 7] uhello0    12 [ 7] uhello0
''     13 [ 2] ab
type T
    dim as long x
    declare function GetU( byval n as long = 0 ) as ustring
    declare property PU( ) as ustring
end type

function T.GetU( byval n as long = 0 ) as ustring
    return "uhello" & n
end function

property T.PU( ) as ustring
    return "prop"
end property

function FreeU( ) as ustring
    return "free"
end function

sub TakeW( byval tag as long, byval p as wstring ptr )
    print tag; " ["; len( *p ); "] "; str( *p )
end sub

sub TakeWR( byval tag as long, byref w as wstring )
    print tag; " ["; len( w ); "] "; str( w )
end sub

sub TakeU( byval tag as long, byval u as ustring )
    print tag; " ["; len( u ); "] "; str( u )
end sub

sub TakeUR( byval tag as long, byref u as const ustring )
    print tag; " ["; len( u ); "] "; str( u )
end sub

dim as T o
dim as ustring u1 = "ab", u2 = "cd"
TakeW( 1, o.GetU )
TakeW( 2, FreeU )
TakeW( 3, o.GetU( ) )
TakeW( 4, "x:" & o.GetU( ) )
TakeW( 5, "x:" & o.GetU )
TakeW( 6, u1 & u2 )
TakeW( 7, ucase( u1 ) )
TakeW( 8, o.PU )
TakeWR( 9, o.GetU )
TakeWR( 10, o.GetU( ) )
TakeU( 11, o.GetU )
TakeUR( 12, o.GetU )
'' A ustring LVALUE is not copied: its own data pointer is already UTF-16.
TakeW( 13, u1 )
