'' lowerfieldinit.bas -- 'a as integer = 123' inside a TYPE.
''
'' Split out of lowerimpl.bas, which the 1500-line cap would not hold both halves of.
'' It belongs beside the synthesised constructor all the same: fbc runs a field's
'' declared value INSIDE the constructor -- implicit or written -- which is what makes
'' one implementation serve 'dim', 'dim shared', a field of another type, an element of
'' an array and 'new' alike.
''
'' The parser recorded the value on the field's node and NOTHING downstream read it
'' back: the field was laid out at the right offset and then initialised by TYPE alone,
'' so 'dim as UDT v' printed whatever the stack held where fbc prints 123, and a SHARED
'' one printed 0. No diagnostic either way.
''
'' WHAT IS NOT DONE, counted rather than hidden: a DYNAMIC ARRAY field, and a nested
'' brace/paren initialiser deeper than one level. The second is not a field limit at
'' all -- 'dim as bar x = ( 111, { ( 222, {1,2,3} ) } )' declines at lower.bas as a
'' LOCAL too -- and is recorded here only so the decline is not read as one.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

'' THE '= value' A FIELD WAS DECLARED WITH, or NODE_NONE.
''
'' The parser records it on the N_FIELD payload and Collect records that node on the
'' field symbol, so this is the way back. NOTHING READ IT: 'i as integer = 123' laid
'' out at the right offset and was then initialised by type alone, so 'dim as UDT v'
'' printed whatever the stack held where fbc prints 123 -- and a SHARED one printed 0.
''
'' A BITFIELD IS EXCLUDED because its payload is NOT a node: Resolve overwrites it with
'' the width in bits, and reading that as a node id would index the AST with a 3.
function FieldInitOf_ _
    ( byref c as Ctx, byval f as Tko.Symbol ptr ) as Tko.NodeId

    if f = 0 then return Tko.NODE_NONE
    if (f->flags and Tko.SYMF_BITFIELD) <> 0 then return Tko.NODE_NONE
    dim as Tko.NodeId n = cast( Tko.NodeId, f->payload )
    if n = Tko.NODE_NONE then return Tko.NODE_NONE
    if c.ast->Kind( n ) <> Tko.N_FIELD then return Tko.NODE_NONE
    return StmtOf( c, n )->c
end function

'' The '= value' stored into one field, after that field's default initialisation.
''
'' fbc runs these inside the constructor -- implicit or written -- which is why they
'' live here rather than at the 'dim' site: 'dim as UDT v', 'dim shared as UDT g' and a
'' UDT FIELD of another UDT all get them from the one place.
''
'' WHAT IS NOT DONE, counted rather than hidden: an aggregate destination -- a string, a
'' fixed or dynamic array, a nested UDT. Each of those is an assignment with a runtime
'' call or an element walk behind it, not a store, and inventing one would compile and
'' be wrong. Those decline, and the decline is counted.
sub EmitFieldInit_ _
    ( byref c as Ctx, byref addr as MirValue, byval ft as Tko.TypeId, _
      byval init as Tko.NodeId )

    if addr.kind = cast( ubyte, MV_NONE ) then return
    if init = Tko.NODE_NONE then return

    '' A STRING FIELD IS ASSIGNED, not stored: the descriptor InitMember_ has just
    '' zeroed owns its buffer, and fb_StrAssign is what fills it. A FIXED-LENGTH one
    '' is bytes with no terminator and goes through the zstring path instead.
    '' StrSwapKind_ RATHER THAN IsStringType, and the difference is the whole point:
    '' 'zstring * 8' is an ARRAY of TY_ZSTRING and IsStringType says no to it, so a
    '' declared 'a as zstring * 8 = "abc"' went to the aggregate decline below and the
    '' field stayed empty where fbc prints abc.
    dim as longint sn = 0
    dim as long sk = StrSwapKind_( c, ft, sn )
    if sk >= 0 then
        '' A WIDE SOURCE INTO A NARROW DESTINATION IS ITS OWN CALL, and it is tried
        '' first for both flavours: 'k as string = wstr( "fOoBaR" )' has no narrow term
        '' for the concatenation path to find, so it declined and the field stayed
        '' empty where fbc prints fOoBaR.
        if (sk <> 2) andalso TermIsWide_( c, init ) then
            if LowerWideToNarrowSlot( c, -1, ft, init, true, @addr ) then return
        end if
        if sk = 0 then
            dim as FB.Array( of ulong ) sargs
            PushStrArg( sargs, addr )
            if EmitStrTerm( c, sargs, init ) = false then
                SkipHere( c )
                return
            end if
            sargs.Push( cast( ulong, MV_CONST_INT ) )
            sargs.Push( cast( ulong, 0 ) )
            EmitRtl( c, RTL_STR_ASSIGN, sargs )
            return
        end if
        if (sk = 1) orelse (sk = 3) orelse (sk = 4) then
            if LowerZstrAssignTo( c, addr, sn, init, true, (sk = 4) ) then return
        end if
        '' 'wstring * N' -- its own runtime call again, and its own element count.
        dim as long wn = WideStringElems( c, ft )
        if wn > 0 then
            if LowerWideAssignTo( c, addr, wn, init ) then return
        end if
        SkipHere( c )
        return
    end if

    '' 'f1(0 to 2) as ubyte = { 1, 2, 3 }' -- A BRACE LIST OVER A FIXED ARRAY FIELD,
    '' which is the same element-by-element walk a local array declaration does. The
    '' only thing that differed was the destination: LowerArrayInit took a frame SLOT,
    '' and a field has an address instead. It takes both now, as the UDT-array path
    '' already did for a static local.
    ''
    '' A FIXED-LENGTH STRING is an array too and was answered above, by StrSwapKind_,
    '' before reaching this.
    if (c.types->IsDynArray( ft ) = false) andalso _
       (c.types->Kind( ft ) = Tko.TK_ARRAY) then
        if LowerArrayInit( c, -1, ft, init, @addr ) then return
        SkipHere( c )
        return
    end if

    '' 'f as Inner = ( 1, 2 )' -- A PAREN FIELD LIST OVER A UDT FIELD, which is the
    '' same walk 'dim as Inner x = ( 1, 2 )' does and takes an address already: the
    '' static-local path needed one first.
    if c.types->Kind( c.types->Unqualify( ft ) ) = Tko.TK_UDT then
        if LowerUdtParenInit_( c, -1, ft, init, @addr ) then return
    end if

    dim as MirType mt = LowerType( ft, *c.types )
    dim as boolean aggregate_ = (mt = MT_VOID) orelse (mt = MT_AGG)
    if aggregate_ = false then aggregate_ = c.types->IsDynArray( ft )
    if aggregate_ = false then aggregate_ = (c.types->Kind( ft ) = Tko.TK_ARRAY)
    if aggregate_ then
        SkipHere( c )
        return
    end if

    dim as MirValue v = LowerExpr( c, init )
    if v.kind = cast( ubyte, MV_NONE ) then
        SkipHere( c )
        return
    end if
    v = CoerceTy( c, v, mt, c.info->TypeOf_( init ), ft )
    if v.kind = cast( ubyte, MV_NONE ) then return
    dim as MirInst st
    st.op = cast( ushort, M_STORE )
    st.ty = cast( ubyte, MT_VOID )
    st.a = addr
    st.b = v
    Emit( c, st )
end sub

end namespace
