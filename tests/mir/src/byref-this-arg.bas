'' 'this' PASSED TO A BYREF PARAMETER OF ITS OWN TYPE is the object it points at. Typed
'' as the pointer it is held in, it looked like an argument needing a conversion, none
'' could be built, and the WHOLE CALL was dropped -- no diagnostic, and the build went
'' on. fb/currency.bi's CurrencyAccum adds through 'hAccAdd( this, ... )', so every Add
'' was lost and Total( ) was zero. Measured, fbc passes THIS$1, the pointer's value.
''
'' fbc prints: 12 3
type Acc
    as longint v
    as longint w
    declare sub Add( byval x as longint )
    declare sub AddP( byval x as longint )
end type
private sub hAdd( byref a as Acc, byval x as longint )
    a.v += x
end sub
private sub hAddP( byval a as Acc ptr, byval x as longint )
    a->w += x
end sub
private sub Acc.Add( byval x as longint )
    hAdd( this, x )
end sub
private sub Acc.AddP( byval x as longint )
    hAddP( @this, x )
end sub
dim a as Acc
a.Add( 5 )
a.Add( 7 )
a.AddP( 3 )
print a.v, a.w
