'' lowerwstr.bas -- WIDE STRINGS.
''
'' Split out of lowerstr.bas when that file passed the 1500-line lint cap, by subject:
'' the wide runtime is a separate family from the narrow one and shares none of its
'' shapes. A wstring VALUE is always a bare uint16* -- there is no descriptor type, and
'' no var-length wide string exists at all ('dim as wstring w' is fbc error 28) -- so
'' none of this needs a wide fb_StrInit and no wide local registers a scope cleanup.
''
'' The whole ABI was measured out of fbc's own C; tools/gen/check-rtl.sh holds every
'' signature.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' Defined in lowerstr.bas; the narrow classifier the wide code needs for a mixed
'' operand.
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long

'' A WIDE STRING, and how many elements it holds. Returns 0 when the type is not one.
''
'' A 'wstring * N' is modelled as an ARRAY of the WSTRING builtin -- which is what it
'' is -- so the count comes off the array. There is no var-length wide string to
'' consider: 'dim as wstring w' is fbc error 28, so a wide value is always a bare
'' pointer to N elements and never a descriptor.
'' IS THIS A WIDE STRING? Not the same question as "how many characters", and keeping
'' them apart is the point: a 'byref as wstring' parameter is a wide string with NO
'' DECLARED LENGTH, so WideStringElems answers 0 for it -- which is exactly the length
'' fbc passes ('fb_WstrAssign( C$1, 0ll, ... )') and exactly the wrong answer to
'' "is it wide". Every 'WideStringElems( ... ) > 0' guard was therefore saying no to
'' byref wstring parameters, and every operation on one declined.
function IsWideString_( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) = Fbx.TK_BUILTIN then
        return (c.types->BuiltinOf( t ) = Fbx.TY_WSTRING)
    end if
    '' NOT IsWideString_: the SIZED form is an ARRAY of the builtin, and asking this
    '' function again is the infinite recursion that a blind rewrite of every
    '' 'WideStringElems( ... ) > 0' in the tree introduced here once already -- it
    '' caught this line, which was the new function's own body.
    return (WideStringElems( c, t ) > 0)
end function


function WideStringElems( byref c as Ctx, byval t as Fbx.TypeId ) as long
    if t = Fbx.TYPE_NONE then return 0
    if c.types->Kind( t ) <> Fbx.TK_ARRAY then return 0
    dim as Fbx.TypeId el = c.types->Inner( t )
    if el = Fbx.TYPE_NONE then return 0
    if c.types->Kind( el ) <> Fbx.TK_BUILTIN then return 0
    if c.types->BuiltinOf( el ) <> Fbx.TY_WSTRING then return 0
    dim as long n = c.types->ElemCount( t )
    if n <= 0 then return 0
    return n
end function

'' Assignment INTO a wide string. Returns false when the target is not one.
''
'' Measured from fbc's own C, and the entry point depends on what the SOURCE is:
''
''     w = w2       fb_WstrAssign( (uint16*)W, 50ll, (uint16*)W2 )
''     w = "abc"    fb_WstrAssignFromA( (uint16*)W, 50ll, (void*)"abc", 4ll )
''     w = s        fb_WstrAssignFromA( (uint16*)W, 50ll, (void*)&S, -1ll )
''
'' The length is the declared ELEMENT COUNT, not bytes, and a narrow literal passes its
'' byte length INCLUDING the NUL while a descriptor passes -1. A plain "abc" is NOT
'' widened at compile time in a bare assignment -- that only happens where the target is
'' already a uint16*.
function LowerWideAssign _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean

    '' THE COUNT IS 0 FOR A 'byref as wstring' PARAMETER, and that is the length fbc
    '' passes for one -- 'fb_WstrAssign( C$1, 0ll, ... )'. Reading 0 as "not a wide
    '' string" is what made every operation on a byref wstring parameter decline.
    if IsWideString_( c, c.info->TypeOf_( target ) ) = false then return false
    dim as long n = WideStringElems( c, c.info->TypeOf_( target ) )

    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false
    return LowerWideAssignTo( c, dst, n, value )
end function

'' The same lowering addressed by DESTINATION rather than by target node, so that a
'' DIM INITIALISER -- which has a slot and no target expression -- reaches it too.
'' 'dim rt as wstring * 50 = trim( t )' was otherwise declining in a corpus file that
'' does it 814 times.
function LowerWideAssignTo _
    ( byref c as Ctx, byref dst as MirValue, byval n as long, _
      byval value as Fbx.NodeId ) as boolean

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, n ) )

    '' 'w = w1 & w2' INTO A FIXED WSTRING is not one call: fbc assigns the first term
    '' and CONCAT-ASSIGNS the rest, because the destination already has storage.
    ''
    ''     fb_WstrAssign( W, 64ll, W1 )
    ''     fb_WstrConcatAssign( W, 64ll, W2 )
    ''
    '' fb_WstrConcat proper is only for a genuine rvalue, which needs a temporary
    '' whose lifetime fbx does not model yet.
    if c.ast->Kind( value ) = Fbx.N_BINARY then
        dim as Fbx.BinaryPayload ptr vb = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, value )].data )]
        dim as Fbx.TokenKind vop = cast( Fbx.TokenKind, vb->op )
        if (vop = Fbx.TK_AMP) orelse (vop = Fbx.TK_PLUS) then
            if LowerWideAssignTo( c, dst, n, vb->lhs ) then
                if LowerWideConcatAssignTo( c, dst, n, vb->rhs ) then return true
                '' The first half is already emitted; declining now would leave the
                '' target holding only the left term, which is worse than saying so.
                SkipHere( c )
                return true
            end if
        end if
    end if

    '' A wide RVALUE -- trim( w ), mid( w, n ) -- is tried BEFORE the type test rather
    '' than inside it: these callees are unbound, so TypeOf_ on the call is empty and a
    '' type-first test would never reach them. The recogniser keys off the shape and
    '' the FIRST ARGUMENT's type instead.
    '' A WIDE source goes through fb_WstrAssign, whether it is a variable, a
    '' 'wstr( x )' temporary or a 'trim( ... )' result. This is tried BEFORE the type
    '' tests: those callees are unbound, so TypeOf_ on the call is empty and a
    '' type-first test would never reach them.
    dim as MirValue rv
    if WideOperand_( c, value, rv ) then
        args.Push( cast( ulong, rv.kind ) ) : args.Push( cast( ulong, rv.id ) )
        EmitRtl( c, RTL_WSTR_ASSIGN, args )
        return true
    end if

    dim as Fbx.TypeId st = c.info->TypeOf_( value )

    if c.ast->Kind( value ) = Fbx.N_STRING_LIT then
        dim as string lit = StringLitText_( c, value )
        args.Push( cast( ulong, MV_GLOBAL ) )
        args.Push( cast( ulong, c.m->AddStringLiteral( lit, *c.names ) ) )
        '' The literal's byte length INCLUDING its NUL, which is what fbc passes.
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, len( lit ) + 1 ) )
        EmitRtl( c, RTL_WSTR_ASSIGN_FROMA, args )
        return true
    end if

    if IsStringType( c, st ) then
        dim as MirValue src = LowerAddr( c, value )
        if src.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        EmitRtl( c, RTL_WSTR_ASSIGN_FROMA, args )
        return true
    end if

    '' A ZSTRING * N source passes its own element count rather than -1.
    dim as longint zn
    if StrSwapKind_( c, st, zn ) = 1 then
        dim as MirValue src = LowerAddr( c, value )
        if src.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, zn ) )
        EmitRtl( c, RTL_WSTR_ASSIGN_FROMA, args )
        return true
    end if

    return false
end function

'' 'w &= x' -- append to a fixed wide string in place. The entry point depends on
'' whether the source is wide or narrow, exactly as assignment does:
''
''     w &= w2      fb_WstrConcatAssign( W, 64ll, W2 )
''     w &= "lit"   fb_WstrConcatWA( W, (void*)"lit", 4ll ) then assign the temp
''
'' Only the WIDE source is lowered here; a narrow one needs the temporary's lifetime.
function LowerWideConcatAssign _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval n as long, _
      byval value as Fbx.NodeId ) as boolean

    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false
    return LowerWideConcatAssignTo( c, dst, n, value )
end function

'' As above, addressed by destination.
function LowerWideConcatAssignTo _
    ( byref c as Ctx, byref dst as MirValue, byval n as long, _
      byval value as Fbx.NodeId ) as boolean

    if IsWideString_( c, c.info->TypeOf_( value ) ) = false then return false
    dim as MirValue src = LowerAddr( c, value )
    if src.kind = cast( ubyte, MV_NONE ) then return false
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, n ) )
    args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
    EmitRtl( c, RTL_WSTR_CONCAT_ASSIGN, args )
    return true
end function

'' Assignment FROM a wide string into a narrow one: 's = w' and 'z = w'.
''
''     fb_WstrAssignToA( (void*)&S, -1ll, (uint16*)W, 0 )
''     fb_WstrAssignToA( (void*)Z, 64ll, (uint16*)W, 0 )
''
'' The trailing int32 was 0 in every probe.
declare function UserCastToWide_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

function LowerWideToNarrow _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean

    '' THE SOURCE NEED NOT BE A WIDE VARIABLE. A UDT with 'operator cast' to a wstring
    '' is one too, and 'r = wv' over one is 'fb_WstrAssignToA( &R, -1ll, vr, 0 )' with
    '' vr the operator's result. Testing the TYPE alone said no to it.
    dim as boolean wideSrc = (IsWideString_( c, c.info->TypeOf_( value ) ))
    dim as MirValue castv
    dim as boolean viaCast = false
    if wideSrc = false then
        viaCast = UserCastToWide_( c, value, castv )
        if viaCast = false then return false
    end if

    dim as Fbx.TypeId dt = c.info->TypeOf_( target )
    dim as longint dn = -1
    if IsStringType( c, dt ) = false then
        if StrSwapKind_( c, dt, dn ) <> 1 then return false
    end if

    dim as MirValue dst = LowerAddr( c, target )
    dim as MirValue src = castv
    if viaCast = false then src = LowerAddr( c, value )
    if (dst.kind = cast( ubyte, MV_NONE )) orelse (src.kind = cast( ubyte, MV_NONE )) then
        return false
    end if

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, dn ) )
    args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_WSTR_ASSIGN_TOA, args )
    return true
end function



'' A WIDE OPERAND as a bare uint16* value, however it is spelled.
''
'' Three shapes, tried in order, because a wide string has no descriptor and every one
'' of them ends as the same kind of pointer:
''
''     an addressable wide variable      @w
''     'wstr( x )'                       the temporary it builds
''     'trim( ... )' and its family      the temporary the runtime returns
''
'' Only the first was accepted before, so 'dim wr as wstring * 50 = trim( wstr(t) )'
'' declined -- 2,496 statements across four corpus files, all of them this one shape.
declare function WideIifArm_ _
    ( byref c as Ctx, byref slotAddr as MirValue, byval e as Fbx.NodeId ) as boolean

'' A WIDE 'iif'. Measured from fbc, and it is NOT the narrow shape with wide entry
'' points substituted:
''
''     if( CT == 0 ) goto label$4;
''     int64  vr$4 = fb_WstrLen( (uint16*)A );
''     uint16* vr$5 = fb_WstrAlloc( vr$4 );
''     TMP$2 = vr$5;
''     fb_WstrAssign( TMP$2, 0ll, (uint16*)A );
''     goto label$6;
''   label$4:
''     ... the same three calls for B ...
''   label$6:
''     fb_WstrAssign( (uint16*)C, 32ll, (uint16*)TMP$2 );
''     fb_WstrDelete( (uint16*)TMP$2 );
''
'' THE TEMPORARY IS A POINTER, not storage: each arm MEASURES its operand, ALLOCATES
'' that many characters and assigns into what it got back. A wide string has no
'' descriptor, so there is nothing to init in place the way the narrow form does -- and
'' the destination length in the arm's assign is 0, not -1 and not a count, because the
'' target was just allocated to fit.
''
'' The allocation is released with fb_WstrDelete once the consuming statement is done,
'' which is the same statement-temporary list the narrow form uses.
function LowerWideIif_ _
    ( byref c as Ctx, byval condE as Fbx.NodeId, byval thenE as Fbx.NodeId, _
      byval elseE as Fbx.NodeId, byref outv as MirValue ) as boolean

    dim as MirValue cond = LowerExpr( c, condE )
    if cond.kind = cast( ubyte, MV_NONE ) then return false

    '' A POINTER slot, not an aggregate one: what the arms produce is an allocation.
    dim as long slot = NewTempLocal( c, MT_PTR, c.types->target.pointerBits \ 8 )
    if slot < 0 then return false
    dim as MirValue taddr
    taddr.kind = cast( ubyte, MV_LOCAL )
    taddr.ty = cast( ubyte, MT_PTR )
    taddr.id = slot

    dim as long thenB = NewBlock( c, "wiif.then" )
    dim as long elseB = NewBlock( c, "wiif.else" )
    dim as long joinB = NewBlock( c, "wiif.join" )
    Terminate( c, MTERM_CONDBR, thenB, elseB, cond )

    c.curBlock = thenB
    if WideIifArm_( c, taddr, thenE ) = false then return false
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )

    c.curBlock = elseB
    if WideIifArm_( c, taddr, elseE ) = false then return false
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )

    c.curBlock = joinB
    c.wstrTemps.Push( cast( ulong, slot ) )
    outv = LowerExprLoad( c, taddr, MT_PTR )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' One arm: measure, allocate, assign. The slot holds the allocation's ADDRESS, so the
'' store is into it and every later use loads through it.
private function WideIifArm_ _
    ( byref c as Ctx, byref slotAddr as MirValue, byval e as Fbx.NodeId ) as boolean

    dim as MirValue src
    if WideOperand_( c, e, src ) = false then return false

    dim as FB.Array( of ulong ) la
    la.Push( cast( ulong, src.kind ) ) : la.Push( cast( ulong, src.id ) )
    dim as MirValue n = EmitRtl( c, RTL_WSTR_LEN, la )
    if n.kind = cast( ubyte, MV_NONE ) then return false

    dim as FB.Array( of ulong ) aa
    aa.Push( cast( ulong, n.kind ) ) : aa.Push( cast( ulong, n.id ) )
    dim as MirValue buf = EmitRtl( c, RTL_WSTR_ALLOC, aa )
    if buf.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirInst st
    st.op = cast( ushort, M_STORE )
    st.ty = cast( ubyte, MT_VOID )
    st.a = slotAddr
    st.b = buf
    Emit( c, st )

    '' THE DESTINATION LENGTH IS 0 here, not -1 and not a count: the target was just
    '' allocated to fit, and fbc passes 0 to say so.
    dim as MirValue dst = LowerExprLoad( c, slotAddr, MT_PTR )
    if dst.kind = cast( ubyte, MV_NONE ) then return false
    dim as FB.Array( of ulong ) wa
    wa.Push( cast( ulong, dst.kind ) ) : wa.Push( cast( ulong, dst.id ) )
    wa.Push( cast( ulong, MV_CONST_INT ) ) : wa.Push( 0 )
    wa.Push( cast( ulong, src.kind ) ) : wa.Push( cast( ulong, src.id ) )
    EmitRtl( c, RTL_WSTR_ASSIGN, wa )
    return true
end function

'' A WIDE CONCATENATION as an operand -- 'iif( c, a + b, w )'.
''
'' fb_WstrConcat takes the two POINTERS and gives back a temporary of its own, released
'' with fb_WstrDelete once the consuming statement is done. That is the same lifetime a
'' wide iif's own temporary has, so it goes on the same list.
''
'' Only the TWO-TERM form, because fb_WstrConcat takes exactly two operands.
function WideConcatToTemp_ _
    ( byref c as Ctx, byval e as Fbx.NodeId, byref outv as MirValue ) as boolean

    if e = Fbx.NODE_NONE then return false
    if c.ast->Kind( e ) <> Fbx.N_BINARY then return false
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, e, terms )
    if terms.Count < 2 then return false

    '' LEFT-FOLDED, because fb_WstrConcat takes exactly TWO operands: 'a & b & c' is
    '' 'fb_WstrConcat( fb_WstrConcat( A, B ), C )', with a temporary per step and a
    '' delete for each. Measured; that is what fbc emits.
    dim as MirValue acc
    if WideOperand_( c, cast( Fbx.NodeId, terms[0] ), acc ) = false then return false

    for k as long = 1 to terms.Count - 1
        dim as MirValue r
        if WideOperand_( c, cast( Fbx.NodeId, terms[k] ), r ) = false then return false

        dim as FB.Array( of ulong ) args
        args.Push( cast( ulong, acc.kind ) ) : args.Push( cast( ulong, acc.id ) )
        args.Push( cast( ulong, r.kind ) ) : args.Push( cast( ulong, r.id ) )
        dim as MirValue got = EmitRtl( c, RTL_WSTR_CONCAT, args )
        if got.kind = cast( ubyte, MV_NONE ) then return false

        '' Each result is an allocation the caller owns, so it goes in a slot and on
        '' the statement-temporary list -- exactly as a wide iif's own temporary does.
        dim as long slot = NewTempLocal( c, MT_PTR, c.types->target.pointerBits \ 8 )
        if slot < 0 then return false
        dim as MirValue saddr
        saddr.kind = cast( ubyte, MV_LOCAL )
        saddr.ty = cast( ubyte, MT_PTR )
        saddr.id = slot
        dim as MirInst st
        st.op = cast( ushort, M_STORE )
        st.ty = cast( ubyte, MT_VOID )
        st.a = saddr
        st.b = got
        Emit( c, st )
        c.wstrTemps.Push( cast( ulong, slot ) )

        acc = LowerExprLoad( c, saddr, MT_PTR )
        if acc.kind = cast( ubyte, MV_NONE ) then return false
    next

    outv = acc
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

function WideOperand_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    '' A LITERAL IS A WIDE ONE HERE. fbc writes '(uint16*)L"x"' for a literal compared
    '' against a wstring -- a genuinely wide global, not a narrow one widened at
    '' runtime -- so it takes the wide literal pool the DATA statement already uses.
    if c.ast->Kind( id ) = Fbx.N_STRING_LIT then
        outv.kind = cast( ubyte, MV_GLOBAL )
        outv.ty = cast( ubyte, MT_PTR )
        outv.id = c.m->AddWideStringLiteral( StringLitText_( c, id ), *c.names )
        return true
    end if

    '' A CONCATENATION BEFORE THE TYPE TEST: a wide concat IS wide-typed, so the
    '' branch below would claim it and then ask for its ADDRESS, which it has not
    '' got. The same ordering trap the narrow paths set four times.
    if WideConcatToTemp_( c, id, outv ) then return true

    if IsWideString_( c, c.info->TypeOf_( id ) ) then
        outv = LowerAddr( c, id )
        if outv.kind <> cast( ubyte, MV_NONE ) then return true
    end if
    if LowerWstrOf( c, id, outv ) then return true
    if LowerWideRvalue( c, id, outv ) then return true

    '' A WIDE 'iif'. Structural, like the narrow one: an iif reached from a WIDE
    '' context is a wide iif whatever its arms look like, because Check computes no
    '' type for an iif call and an arm may be an intrinsic with no type either.
    dim as Fbx.NodeId iC, iT, iE
    if IsIifCall_( c, id, iC, iT, iE ) then
        if LowerWideIif_( c, iC, iT, iE, outv ) then return true
    end if

    '' A UDT WITH 'operator cast' TO A WSTRING, converted implicitly -- the wide half of
    '' what UserCastToStr_ does for narrow strings. A byref wstring result is a bare
    '' uint16*, which is exactly what every wide entry point wants, so unlike the narrow
    '' case there is no descriptor to borrow: 'fb_WstrAssign( Z, 50ll, vr )' takes the
    '' operator's result directly.
    ''
    '' Hooked in HERE rather than at each call site, because everything wide already
    '' comes through this function: assignment both ways, comparison, and the trim
    '' family all follow from the one hook.
    if UserCastToWide_( c, id, outv ) then return true
    return false
end function

'' The 'operator cast' overload that yields a WSTRING, called on 'id'. Returns the
'' uint16* it gives back.
private function UserCastToWide_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    dim as Fbx.TypeId t = c.info->TypeOf_( id )
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_UDT then return false

    dim as Fbx.SymbolId cs = UdtMemberNamed_( c, t, "cast" )
    if cs = Fbx.SYMBOL_NONE then return false

    '' THE OVERLOAD THAT YIELDS A WSTRING. 'operator cast' may be declared several
    '' times over different targets, so the chain is walked rather than its head taken.
    dim as Fbx.SymbolId cur = cs
    dim as Fbx.SymbolId want = Fbx.SYMBOL_NONE
    while cur <> Fbx.SYMBOL_NONE
        dim as Fbx.Symbol ptr cse = c.syms->SymbolAt( cur )
        if cse = 0 then exit while
        dim as Fbx.TypeId rt = cse->type_
        if rt <> Fbx.TYPE_NONE then
            '' BYREF makes it a POINTER to the wstring, so both spellings count.
            dim as Fbx.TypeId inner = rt
            if c.types->Kind( inner ) = Fbx.TK_POINTER then
                inner = c.types->Inner( inner )
            end if
            if IsWideString_( c, inner ) then
                want = cur
                exit while
            end if
            if inner <> Fbx.TYPE_NONE then
                if c.types->Kind( inner ) = Fbx.TK_BUILTIN then
                    if c.types->BuiltinOf( inner ) = Fbx.TY_WSTRING then
                        want = cur
                        exit while
                    end if
                end if
            end if
        end if
        cur = cse->nextOverload
    wend
    if want = Fbx.SYMBOL_NONE then return false

    dim as MirValue self_ = LowerAddr( c, id )
    if self_.kind = cast( ubyte, MV_NONE ) then return false
    outv = EmitMemberCall( c, want, self_, MT_PTR )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function


'' THE WIDE SUBSTRING AND TRIM FAMILY, as an RVALUE.
''
'' Each of these returns a bare uint16* -- there is no descriptor, which is what makes
'' them lowerable now while their narrow counterparts still are not. fbc releases the
'' result with fb_WstrDelete; fbx does not model that lifetime yet, so EVERY CALL HERE
'' LEAKS ONE TEMPORARY. That is a real defect, recorded rather than hidden, and the
'' alternative is emitting nothing at all for 2,442 corpus statements.
''
'' The mapping was read off fbc's C, not assumed from the narrow forms, and the shapes
'' are NOT uniform:
''
''     trim( w )          fb_WstrTrim( W )
''     trim( w, w2 )      fb_WstrTrimEx( W, W2 )        strip that SUBSTRING
''     trim( w, any w2 )  fb_WstrTrimAny( W, W2 )       strip any of those CHARACTERS
''     mid( w, n )        fb_WstrMid( W, N, -1ll )      no length is -1, not 0
''     ucase( w )         fb_WstrUcase2( W, 0 )         trailing arg is the mode
''
'' 'any' reaches here as a unary KW_ANY wrapper around the second argument.
function LowerWideRvalue _
    ( byref c as Ctx, byval value as Fbx.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( value ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, value )].data )]
    if cp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )
    if (cp->count < 1) orelse (cp->count > 3) then return false

    '' The FIRST argument decides: these names are all overloaded on narrow strings
    '' too, and only the wide overload is lowered here.
    dim as Fbx.NodeId a0 = cast( Fbx.NodeId, c.ast->children[cp->first] )
    dim as MirValue s0
    if WideOperand_( c, a0, s0 ) = false then return false

    '' The second argument, unwrapped from 'any' if it carries one.
    dim as Fbx.NodeId a1 = Fbx.NODE_NONE
    dim as boolean isAny = false
    if cp->count >= 2 then
        a1 = cast( Fbx.NodeId, c.ast->children[cp->first + 1] )
        if c.ast->Kind( a1 ) = Fbx.N_UNARY then
            dim as Fbx.UnaryPayload ptr up = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, a1 )].data )]
            if cast( Fbx.TokenKind, up->op ) = Fbx.KW_ANY then
                isAny = true
                a1 = up->operand
            end if
        end if
    end if

    dim as RtlId r = RTL_NONE
    dim as boolean secondIsWide = false      '' else it is a count
    select case nm
    case "trim", "ltrim", "rtrim"
        secondIsWide = true
        if cp->count = 1 then
            select case nm
            case "trim"  : r = RTL_WSTR_TRIM
            case "ltrim" : r = RTL_WSTR_LTRIM
            case else    : r = RTL_WSTR_RTRIM
            end select
        elseif cp->count = 2 then
            if isAny then
                select case nm
                case "trim"  : r = RTL_WSTR_TRIM_ANY
                case "ltrim" : r = RTL_WSTR_LTRIM_ANY
                case else    : r = RTL_WSTR_RTRIM_ANY
                end select
            else
                select case nm
                case "trim"  : r = RTL_WSTR_TRIM_EX
                case "ltrim" : r = RTL_WSTR_LTRIM_EX
                case else    : r = RTL_WSTR_RTRIM_EX
                end select
            end if
        else
            return false
        end if
    case "left"
        if cp->count <> 2 then return false
        r = RTL_WSTR_LEFT
    case "right"
        if cp->count <> 2 then return false
        r = RTL_WSTR_RIGHT
    case "mid"
        if (cp->count < 2) orelse (cp->count > 3) then return false
        r = RTL_WSTR_MID
    case "ucase"
        if cp->count <> 1 then return false
        r = RTL_WSTR_UCASE
    case "lcase"
        if cp->count <> 1 then return false
        r = RTL_WSTR_LCASE
    case else
        return false
    end select
    if isAny andalso (secondIsWide = false) then return false

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, s0.kind ) ) : args.Push( cast( ulong, s0.id ) )

    if a1 <> Fbx.NODE_NONE then
        if secondIsWide then
            dim as MirValue s1
            if WideOperand_( c, a1, s1 ) = false then return false
            args.Push( cast( ulong, s1.kind ) ) : args.Push( cast( ulong, s1.id ) )
        else
            '' left/right/mid take a 64-bit COUNT; the source expression is whatever
            '' integer width the program used, so it is widened here.
            dim as MirValue n1 = LowerExpr( c, a1 )
            if n1.kind = cast( ubyte, MV_NONE ) then return false
            n1 = Coerce( c, n1, MT_I64, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
            args.Push( cast( ulong, n1.kind ) ) : args.Push( cast( ulong, n1.id ) )
        end if
    end if

    if nm = "mid" then
        '' A 'mid' WITHOUT a length passes -1, not 0 -- measured, and 0 would silently
        '' produce an empty string instead of the rest of the source.
        if cp->count = 3 then
            dim as Fbx.NodeId a2 = cast( Fbx.NodeId, c.ast->children[cp->first + 2] )
            dim as MirValue n2 = LowerExpr( c, a2 )
            if n2.kind = cast( ubyte, MV_NONE ) then return false
            n2 = Coerce( c, n2, MT_I64, IsUnsignedType( c, c.info->TypeOf_( a2 ) ) )
            args.Push( cast( ulong, n2.kind ) ) : args.Push( cast( ulong, n2.id ) )
        else
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        end if
    elseif (r = RTL_WSTR_UCASE) orelse (r = RTL_WSTR_LCASE) then
        '' The trailing int32 is the case-mode; fbc passed 0 in every probe.
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    end if

    outv = EmitRtl( c, r, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function


end namespace
