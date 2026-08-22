'' 'erase this.items' -- ERASE OF A MEMBER ARRAY.
''
'' The descriptor is a FIELD, so its address is a computed value and not a local slot --
'' and the erase path took a SLOT NUMBER, so every one declined. A container that clears
'' its own storage is the commonest place ERASE appears at all: fb/array.bi's own Clear
'' is exactly this line, and every type built on it inherits the gap.

type T
    items( any ) as long
    strs( any ) as string
    declare sub Clear( )
end type

sub T.Clear( )
    erase this.items
    erase this.strs
end sub

sub P( )
    '' The local forms, which already worked, kept beside it: a scalar array through
    '' fb_ArrayErase and a string one through fb_ArrayStrErase.
    dim as long a( any )
    dim as string s( any )
    erase a
    erase s
end sub
