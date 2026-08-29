'' The element kinds fb_ArrayRedimTo is told about. Measured, over the same
'' 'dim as A y = x' with only the element type varied:
''
''     double            ( ..., 0,  NULL,        NULL )
''     string            ( ..., -1, NULL,        NULL )
''     E with structors  ( ..., 0,  &_ZN1EC1Ev,  &_ZN1ED1Ev )
''
'' -- the flag says STRING, and the last two are the element's constructor and
'' destructor, which the runtime runs over the elements it grows and drops. An element
'' that assigns itself is also copied one at a time rather than as a byte run.
type SBox
    dim as string arr( any )
end type

type E
    dim as long i
    declare constructor()
    declare destructor()
end type
constructor E() : end constructor
destructor E() : end destructor

type EBox
    dim as E arr( any )
end type

'' An element whose structors are SYNTHESISED, not written: it holds a string, so it
'' needs both, and neither has a symbol to name -- only the name the implicit body
'' will be emitted under.
type Inner
    dim as string s
end type
type IBox
    dim as Inner arr( any )
end type

sub Strings()
    dim as SBox a
    redim a.arr( 0 to 1 )
    a.arr(0) = "hi"
    dim as SBox b = a
    print b.arr(0)
end sub

sub Written()
    dim as EBox a
    redim a.arr( 0 to 1 )
    dim as EBox b = a
    print b.arr(0).i
end sub

sub Synthesised()
    dim as IBox a
    redim a.arr( 0 to 1 )
    dim as IBox b = a
    print b.arr(0).s
end sub

Strings()
Written()
Synthesised()
