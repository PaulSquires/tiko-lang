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

'' -- MATCHED BUT NOT COMPATIBLE ------------------------------------------------
''
'' A match on PARAMETER TYPES is not yet a legal override. Measured, one probe each --
'' and two that look like they should be refused and are NOT, which is why each of these
'' is its own test rather than "the signatures must be identical":
''
''     derived returns a different WIDTH or CLASS      fbc 225
''     derived is a const member and the base is not   fbc 229 / 230
''     a parameter's byref-ness differs                fbc 231
''
''     a different parameter LIST                      ACCEPTED -- an ordinary OVERLOAD
''     a differing CALLING CONVENTION                  ACCEPTED
''
'' A RETURN TYPE MAY CHANGE ITS SIGNEDNESS AND NOTHING ELSE: 'byte' -> 'ubyte' is
'' accepted, and so is 'integer' -> 'longint', which is the same eight bytes on win64.
'' 'long' -> 'integer' is four against eight and is refused.
type RBase extends object
    declare virtual function width_( ) as long
    declare virtual function signed_( ) as long
    declare virtual sub plain( )
    declare virtual sub byrefParam( byref i as integer )
end type

function RBase.width_( ) as long
    return 0
end function

function RBase.signed_( ) as long
    return 0
end function

sub RBase.plain( )
end sub

sub RBase.byrefParam( byref i as integer )
end sub

'' -- refused ------------------------------------------------------------------
type WrongWidth extends RBase
    declare function width_( ) as integer override
end type

type WrongConst extends RBase
    declare const sub plain( ) override
end type

type WrongMode extends RBase
    declare sub byrefParam( byval i as integer ) override
end type

'' -- accepted -----------------------------------------------------------------
type OnlySignedness extends RBase
    declare function signed_( ) as ulong override
end type

function OnlySignedness.signed_( ) as ulong
    return 0
end function

'' A different parameter LIST is an overload, not a broken override.
type Overloads extends RBase
    declare sub plain( byval i as integer )
end type

sub Overloads.plain( byval i as integer )
end sub
