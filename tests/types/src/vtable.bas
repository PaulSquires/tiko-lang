'' The virtual method table, every rule that is not guessable in one file. Compared
'' against fbc's own '_ZTV' initialisers by tools/gen/check-vtable.py; this golden is
'' the readable form of the same answer.
''
'' Slot 0 here is the FIRST USER SLOT. fbc's table has two more before it -- a null word
'' and the RTTI pointer -- and the stored vptr points past both, so this numbering is
'' the one a call site indexes with.
type A extends object
    declare virtual function vf1( ) as long
    declare virtual sub vf2( )
    '' An ABSTRACT method occupies a slot holding NULL. It is not absent.
    declare abstract sub vabs( )
    '' A non-virtual method and a constructor are NOT in the table at all.
    declare sub plain( )
    declare virtual destructor( )
    declare constructor( )
end type
function A.vf1( ) as long : return 1 : end function
sub A.vf2( ) : end sub
sub A.plain( ) : end sub
destructor A( ) : end destructor
constructor A( ) : end constructor

type B extends A
    '' An OVERRIDE reuses the base's slot. It need not say 'virtual', and this one
    '' does not.
    declare function vf1( ) as long override
    '' ...and an override of an ABSTRACT fills that null slot rather than appending.
    declare sub vabs( ) override
    '' A genuinely new virtual appends AFTER everything inherited.
    declare virtual sub vf4( )
    '' The destructor inherits A's slot -- its position is A's declaration position,
    '' not the end.
    declare destructor( )
end type
function B.vf1( ) as long : return 2 : end function
sub B.vabs( ) : end sub
sub B.vf4( ) : end sub
destructor B( ) : end destructor
