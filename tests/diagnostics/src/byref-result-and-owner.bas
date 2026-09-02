'' FOUR RULES MEASURED AGAINST FBC.
''   A byref function must set its result somewhere (error 316); assigning in a single
''   branch, or returning, is enough.
''   A byref result must be assigned something with an address: a literal, an address-of
''   and a type literal are error 24, an arithmetic expression error 3; a string literal
''   into a 'byref as zstring' is accepted.
''   A qualified 'declare' or definition into a TYPE that never declared the name is
''   error 158, and so is a second 'declare' of a declared member; the definition of a
''   declared member is the ordinary use.
''   The alias on a definition must match its declaration's (error 311).
type UDT
    i as integer
    declare sub aaa( )
end type
sub UDT.aaa( )
end sub
dim shared g as integer

function okBranch( ) byref as integer
    if g then function = g
end function
function okReturn( ) byref as integer
    return g
end function
function okStr( ) byref as zstring
    function = "text"
end function
declare sub aliased alias "foo"( )
sub aliased alias "foo"( )
end sub

function neverSet( ) byref as integer
end function
function badLit( ) byref as integer
    function = 123
end function
function badAddr( ) byref as integer
    function = @g
end function
function badExpr( ) byref as integer
    function = g + 1
end function
declare sub UDT.bbb( )
declare sub UDT.aaa( )
declare sub aliased2 alias "foo"( )
sub aliased2 alias "bar"( )
end sub
