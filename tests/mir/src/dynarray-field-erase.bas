'' A DYNAMIC ARRAY FIELD IS ERASED THE WAY 'erase' ERASES ONE. For an element with
'' structors that means fb_ArrayEraseObj carrying the element's constructor and
'' destructor -- measured, the generated destructor of a 'Box( of E )' is
''
''     fb_ArrayEraseObj( THIS, (void*)&_ZN1EC1Ev, (void*)&_ZN1ED1Ev );
''
'' With the bare fb_ArrayErase the field used to emit, NO ELEMENT WAS EVER DESTRUCTED,
'' so every string an element held leaked -- in a destructor that verified and counted
'' as lowered. The LOCAL 'dim as E a( any )' already got this right; only the FIELD did
'' not, which is why a container generic was where it showed.
type E
    dim as string s
    declare constructor()
    declare destructor()
end type
constructor E() : end constructor
destructor E() : end destructor

type Box( of T )
    dim as T items( any )
    dim as long num
    declare sub Shrink( )
end type

sub Box( of T ).Shrink( )
    if( this.num = 0 ) then
        erase this.items
        exit sub
    end if
    redim preserve this.items( 0 to this.num - 1 )
end sub

'' A PLAIN element type keeps the bare erase: there is nothing to run per element.
type Plain
    dim as double v( any )
end type

'' AN ELEMENT THAT DECLARES NO STRUCTORS BUT NEEDS THEM. StructorOf answers only
'' for a WRITTEN structor, so a type whose MEMBERS need one -- this holds a string,
'' FB.AmortizationRow holds nine Decimals -- looked structor-less, and the array
'' went to the plain fb_ArrayErase and fb_ArrayRedimPresvEx: the bytes moved and
'' nothing ran.
type Implicit
    dim as string s
end type
type IBox2
    dim as Implicit rows( any )
end type


'' A USTRING ELEMENT HAS ITS OWN ERASE. The narrow fb_ArrayStrErase over one frees
'' FBSTRING descriptors across FBUSTRING data; measured, fbc emits fb_ArrayUStrErase.
type UBox
    dim as ustring u( any )
end type

sub go()
    dim as Box( of E ) b
    b.Shrink( )
    dim as Plain p
    redim p.v( 0 to 3 )
    dim as UBox ub
    redim ub.u( 0 to 3 )
    dim as IBox2 ib
    redim ib.rows( 0 to 3 )
    redim preserve ib.rows( 0 to 5 )
end sub
go()
