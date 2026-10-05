'' aggctorfield.bas -- UdtHasCtorField_, #included from latesweeps3.bas above its one caller.

'' A FIELD WHOSE TYPE HAS A CONSTRUCTOR, at any depth -- the enclosing type then has an implicit
'' one, and a parenthesised list cannot fill it: measured on fbc-modern, 'dim as H h = ( 7, 1 )'
'' and '( 7 )' over a type holding a T with constructors are errors 7 and 24. tiko filled the
'' fields. A tuple and a type declaring its own constructor are not this question.
private function UdtHasCtorField_ ( byref c as Ctx, byval t as TypeId, byval depth as long ) as Symbol ptr
    if depth > 8 then return 0
    dim as TypeId u = ValueType_( c, t )
    if (u = TYPE_NONE) orelse (c.types->Kind( u ) <> TK_UDT) then return 0
    if TupleLike_( c, u ) then return 0
    dim as Symbol ptr ts = UdtSymbolOf_( c, u )
    if (ts = 0) orelse (ts->inner = SCOPE_NONE) then return 0
    for i as long = 0 to c.syms->symbols.Count - 1
        dim as Symbol ptr f = @c.syms->symbols[i]
        if f->parent <> ts->inner then continue for
        if f->kind <> cast( ubyte, SYM_FIELD ) then continue for
        if f->type_ = TYPE_NONE then continue for
        dim as TypeId ft = c.types->Unqualify( f->type_ )
        if c.types->Kind( ft ) = TK_ARRAY then ft = c.types->Unqualify( c.types->Inner( ft ) )
        if c.types->Kind( ft ) <> TK_UDT then continue for
        if TupleLike_( c, ft ) then continue for
        if DeclaresAnywhere_( c, ft, "__ctor" ) then return f
        if UdtHasCtorField_( c, ft, depth + 1 ) <> 0 then return f
    next
    return 0
end function
