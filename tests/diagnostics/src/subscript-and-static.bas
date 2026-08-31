'' TWO RULES, both measured.
''
'' AN ARRAY IS NOT A SUBSCRIPT -- fbc error 73, "Array access, index expected".
'' 'a1( a2 )' over two arrays is refused; 'a1( i )' over an integer is the ordinary
'' access. ONLY WHEN THE TARGET IS A VARIABLE: the same node shape is a CALL, and passing
'' a whole array to a 'bydesc' parameter -- 'f( a( ) )' -- is exactly how one is passed.
''
'' AND A STATIC MEMBER VARIABLE IS ONLY ALLOWED IN A TOP-LEVEL UDT -- fbc error 264.
'' "Nested" means INSIDE A PROCEDURE and nothing else:
''
''     type Outer : type Inner : static i as integer : end type : end type   OK
''     sub t( ) : type U : static i as integer : end type : end sub          error 264
''     type Top : static i as integer : end type                             OK
''
'' A static member is an N_VAR, not an N_FIELD -- it has storage of its own and no place
'' in the layout -- so its symbol is a VARIABLE living in the TYPE's scope.
declare sub takesArray( a( ) as string )

dim shared as string a1( 0 to 0 )
dim shared as string a2( 0 to 0 )
dim shared as integer i

type TopLevel
    dummy as integer
    static ok_ as integer
end type

dim as integer TopLevel.ok_

'' -- refused ------------------------------------------------------------------
sub refused( )
    print a1( a2 )
    type Nested
        dummy as integer
        static bad as integer
    end type
end sub

'' -- accepted -----------------------------------------------------------------
sub accepted( )
    print a1( i )
    takesArray( a1( ) )
end sub
