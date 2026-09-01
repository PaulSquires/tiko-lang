'' TWO RULES ABOUT A BYREF RESULT, both measured.
''
'' IT CANNOT RETURN A LOCAL -- fbc error 272, "Local symbols can't be referenced". The
'' caller is handed a reference, and the frame it points into is gone by the time it is
'' read:
''
''     function = x.i           x a local UDT               error 272
''     function = array( i )    array a local array         error 272
''     function = f1( )         a call's RESULT is a temp   error 272
''     function = g             g SHARED                    OK
''     function = byref_( )     when byref_ returns BYREF   OK
''
'' THE BASE OF THE CHAIN IS WHAT MATTERS: 'x.i' is local because x is, and 'array( i )'
'' because array is -- so the walk goes down to the head of the member and index chain.
''
'' AND A DEFINITION MUST REPEAT THE DECLARATION'S 'byref' -- fbc error 20, and it is
'' SYMMETRIC: declaring BYREF and defining byval is refused, and so is the reverse.
type UDT
    i as integer
end type

dim shared as integer g
dim shared as UDT gu

declare function plain_( ) as integer
declare function byref_( ) byref as integer

'' -- refused ------------------------------------------------------------------
function localField( ) byref as integer
    dim x as UDT
    function = x.i
end function

function localArray( ) byref as integer
    dim arr( 0 to 1 ) as integer
    dim i as integer
    function = arr( i )
end function

function callResult( ) byref as integer
    function = plain_( )
end function

declare function mismatch_( ) byref as integer

function mismatch_( ) as integer
    function = g
end function

'' -- accepted -----------------------------------------------------------------
function sharedOk( ) byref as integer
    function = g
end function

function sharedFieldOk( ) byref as integer
    function = gu.i
end function

function byrefCallOk( ) byref as integer
    function = byref_( )
end function
