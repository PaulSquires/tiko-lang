'' lowerclosure.bas -- a CAPTURING LAMBDA's object.
''
'' The parser desugars 'sub[ byref acc ]( byval v as long ) ... end sub' into an
'' N_CLOSURE naming a generated TYPE and an invoke procedure whose first parameter is
'' the object; Resolve builds the type, because only it can see the captures' own
'' scope. What is left here is the OBJECT: a temporary of that type with one field
'' written per capture -- the ADDRESS for a byref capture and the VALUE for a byval
'' one -- which is what fbc emits:
''
''   struct $25LF...E TMP$3$0;
''   __builtin_memset( &TMP$3$0, 0, 8ll );
''   *(int32**)&TMP$3$0 = &ACC$0;
''   __builtin_memcpy( &C$0, &TMP$3$0, 8 );
''
'' Split into its own file rather than added to lowerexpr.bas, which is near the
'' 1500-line cap; included from there inside the same namespace.

'' THE CLOSURE OBJECT, as a value: a temporary is built and loaded, which is the same
'' shape a UDT literal already hands back.
function LowerClosure_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CLOSURE then return false
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    dim as Tko.TypeId ct = c.info->TypeOf_( id )
    if ct = Tko.TYPE_NONE then return false
    dim as Tko.TypeId cu = c.types->Unqualify( ct )
    if c.types->Kind( cu ) <> Tko.TK_UDT then return false
    dim as long sz = SizeOfType( c, cu )
    if sz <= 0 then return false
    dim as long slot = NewTempLocal( c, MT_AGG, sz )
    if slot < 0 then return false

    dim as MirValue base_
    base_.kind = cast( ubyte, MV_LOCAL )
    base_.ty = cast( ubyte, MT_PTR )
    base_.id = slot

    for k as long = 0 to sp->count - 1
        dim as Tko.NodeId cn = cast( Tko.NodeId, c.ast->children[sp->first + k] )
        if c.ast->Kind( cn ) <> Tko.N_IDENT then return false
        dim as Tko.InternId fnm = c.names->Fold( c.names->GetString( _
            "__CAP_" & c.names->Spelling( _
                c.ast->idents[cast( long, c.ast->nodes[cast( long, cn )].data )].name ) ) )
        dim as boolean found = false
        dim as long off = c.udts->FieldOffset( cu, fnm, found )
        if found = false then return false

        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = base_
        fa.imm = off
        dim as MirValue dst = Emit( c, fa )

        dim as MirValue v
        if (c.ast->nodes[cast( long, cn )].flags and Tko.NF_BYREF) <> 0 then
            '' A BYREF CAPTURE STORES THE ADDRESS TAKEN AT CREATION -- fbc writes
            '' '*(int32**)&TMP = &ACC' and does nothing about lifetime.
            v = LowerAddr( c, cn )
            if v.kind = cast( ubyte, MV_NONE ) then return false
            v = Coerce( c, v, MT_PTR, false )
        else
            '' ...and a BYVAL capture a COPY made there, which the body then mutates
            '' IN THE OBJECT. Measured by running it: two calls to a 'sub[ byval n ]'
            '' doing 'n += v' print 11 then 12 while the outer n stays 10.
            v = LowerExpr( c, cn )
            if v.kind = cast( ubyte, MV_NONE ) then return false
        end if

        dim as MirInst st
        st.op = cast( ushort, M_STORE )
        st.a = dst
        st.b = v
        Emit( c, st )
    next

    outv = LowerExprLoad( c, base_, MT_AGG )
    return true
end function
