'' 'override' IS A PROMISE -- fbc error 223, "Not overriding any virtual method". The
'' parser used to consume the word with the rest of the trailing modifiers, so a promise
'' that was not kept said nothing at all.
''
'' It is checked against what the vtable builder already worked out while MATCHING, which
'' is why the four reasons fbc raises 223 for all come out the same way: the name matches
'' nothing, the parameters differ so the match fails, the base method is not virtual, or
'' the type has no base at all.
type Base_ extends object
    declare virtual sub kept( )
    declare sub notVirtual( )
end type

sub Base_.kept( )
end sub

sub Base_.notVirtual( )
end sub

'' -- refused ------------------------------------------------------------------
type NoBase extends object
    declare sub f( ) override
end type

type WrongName extends Base_
    declare sub misspelled( ) override
end type

type WrongParams extends Base_
    declare sub kept( byval i as integer ) override
end type

type BaseNotVirtual extends Base_
    declare sub notVirtual( ) override
end type

'' -- accepted -----------------------------------------------------------------
type Good extends Base_
    declare sub kept( ) override
end type

sub Good.kept( )
end sub

'' An override need not SAY so: what makes a procedure occupy a slot is matching an
'' inherited one.
type Silent extends Base_
    declare sub kept( )
end type

sub Silent.kept( )
end sub
