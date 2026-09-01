'' RETURN AND 'FUNCTION =' CANNOT BE MIXED when the result is a UDT WITH CONSTRUCTORS --
'' fbc errors 178 and 179. The two styles construct the result differently. MEASURED: the
'' type is half the rule -- the same mix over an INTEGER result is accepted -- and 'exit
'' function' counts as the assignment style.
''
'' ...and a parameter default that names nothing is fbc error 42.
type Ctor
    as integer a
    declare constructor( )
end type
constructor Ctor( )
end constructor

function okReturn( ) as Ctor
    dim as Ctor x
    return x
end function

function okAssign( ) as Ctor
    dim as Ctor x
    function = x
end function

function okInt( byval i as integer ) as integer
    if i = 0 then
        return 1
    end if
    function = 2
end function

function badMix( byval i as integer ) as Ctor
    dim as Ctor x
    if i = 0 then
        return x
    end if
    function = x
end function

function badExit( byval i as integer ) as Ctor
    dim as Ctor x
    if i = 0 then
        exit function
    end if
    return x
end function

sub badDefault( byval n as integer = notDeclaredAnywhere )
end sub
