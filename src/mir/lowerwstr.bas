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

namespace Tko.Mir

'' Defined in lowerstr.bas; the narrow classifier the wide code needs for a mixed
'' operand.
declare sub PushStrArg _
    ( byref args as FB.Array( of ulong ), byref addr as MirValue )
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

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
function IsWideString_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) = Tko.TK_BUILTIN then
        return (c.types->BuiltinOf( t ) = Tko.TY_WSTRING)
    end if
    '' NOT IsWideString_: the SIZED form is an ARRAY of the builtin, and asking this
    '' function again is the infinite recursion that a blind rewrite of every
    '' 'WideStringElems( ... ) > 0' in the tree introduced here once already -- it
    '' caught this line, which was the new function's own body.
    return (WideStringElems( c, t ) > 0)
end function


function WideStringElems( byref c as Ctx, byval t as Tko.TypeId ) as long
    if t = Tko.TYPE_NONE then return 0
    if c.types->Kind( t ) <> Tko.TK_ARRAY then return 0
    dim as Tko.TypeId el = c.types->Inner( t )
    if el = Tko.TYPE_NONE then return 0
    if c.types->Kind( el ) <> Tko.TK_BUILTIN then return 0
    if c.types->BuiltinOf( el ) <> Tko.TY_WSTRING then return 0
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
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean

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
      byval value as Tko.NodeId ) as boolean

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
    '' whose lifetime tiko-lang does not model yet.
    if c.ast->Kind( value ) = Tko.N_BINARY then
        dim as Tko.BinaryPayload ptr vb = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, value )].data )]
        dim as Tko.TokenKind vop = cast( Tko.TokenKind, vb->op )
        if (vop = Tko.TK_AMP) orelse (vop = Tko.TK_PLUS) then
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

    dim as Tko.TypeId st = c.info->TypeOf_( value )

    if c.ast->Kind( value ) = Tko.N_STRING_LIT then
        dim as string lit = StringLitText_( c, value )
        args.Push( cast( ulong, MV_GLOBAL ) )
        args.Push( cast( ulong, c.m->AddStringLiteral( lit, *c.names ) ) )
        '' The literal's byte length INCLUDING its NUL, which is what fbc passes.
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, len( lit ) + 1 ) )
        EmitRtl( c, RTL_WSTR_ASSIGN_FROMA, args )
        return true
    end if

    '' AN ADDRESSABLE narrow string. A string-typed RVALUE -- 'mid( s, 1 )' -- has none,
    '' and returning false here rather than falling through is what kept it from the
    '' descriptor branch at the end: the type test claimed it and then gave up.
    if IsStringType( c, st ) then
        dim as MirValue src = LowerAddr( c, value )
        if src.kind <> cast( ubyte, MV_NONE ) then
            args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, cast( ulongint, -1 ) ) )
            EmitRtl( c, RTL_WSTR_ASSIGN_FROMA, args )
            return true
        end if
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

    '' A NARROW RVALUE -- 'mid( s, 1 )', 'trim( u )', a call, a concatenation, a UDT
    '' with 'operator cast' -- has no address, and every branch above asked for one.
    '' StrDescriptorOf_ knows all of those spellings, and a descriptor passes -1 for
    '' its length exactly as an addressable string does.
    dim as MirValue dsc
    if StrDescriptorOf_( c, value, dsc ) then
        args.Push( cast( ulong, dsc.kind ) ) : args.Push( cast( ulong, dsc.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, cast( ulongint, -1 ) ) )
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
    ( byref c as Ctx, byval target as Tko.NodeId, byval n as long, _
      byval value as Tko.NodeId ) as boolean

    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false
    return LowerWideConcatAssignTo( c, dst, n, value )
end function

'' As above, addressed by destination.
function LowerWideConcatAssignTo _
    ( byref c as Ctx, byref dst as MirValue, byval n as long, _
      byval value as Tko.NodeId ) as boolean

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
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
declare function NarrowDestWideSource_ _
    ( byref c as Ctx, byval value as Tko.NodeId, byref src as MirValue ) as boolean
declare sub EmitWideToNarrow_ _
    ( byref c as Ctx, byref dst as MirValue, byval dn as longint, byref src as MirValue )

function LowerWideToNarrow _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean

    '' THE SOURCE NEED NOT BE A WIDE VARIABLE. A UDT with 'operator cast' to a wstring
    '' is one too, and 'r = wv' over one is 'fb_WstrAssignToA( &R, -1ll, vr, 0 )' with
    '' vr the operator's result. Testing the TYPE alone said no to it.
    '' THE DESTINATION'S TYPE IS CHECKED FIRST AND NOTHING IS EMITTED FOR IT YET.
    '' Taking its ADDRESS here instead left a dead 'load @pc' in front of every
    '' assignment this function then declined -- which is most of them, since it is
    '' tried on the way past.
    dim as Tko.TypeId dt = c.info->TypeOf_( target )
    dim as longint dn = -1
    if IsStringType( c, dt ) = false then
        if StrSwapKind_( c, dt, dn ) <> 1 then return false
    end if

    dim as boolean wideSrc = (IsWideString_( c, c.info->TypeOf_( value ) ))
    dim as MirValue src
    if wideSrc = false then
        if NarrowDestWideSource_( c, value, src ) = false then return false
    end if

    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false
    if wideSrc then src = LowerAddr( c, value )
    if src.kind = cast( ubyte, MV_NONE ) then return false

    EmitWideToNarrow_( c, dst, dn, src )
    return true
end function

'' A WIDE SOURCE for a narrow destination, where the source is NOT a wide variable.
'' Split out because the RESULT-SLOT form needs it too and has no target node.
private function NarrowDestWideSource_ _
    ( byref c as Ctx, byval value as Tko.NodeId, byref src as MirValue ) as boolean

    '' A MIXED CONCATENATION IS A WIDE SOURCE with no address and no type of its
    '' own -- 'r = s & w' is fb_WstrConcatAW into a temporary and then
    '' fb_WstrAssignToA from it -- so it is tried BEFORE the operator-cast case
    '' and before anything asks the value for an address it has not got.
    if ConcatHasWideTerm_( c, value ) then
        if WideConcatToTemp_( c, value, src ) then return true
    end if
    return UserCastToWide_( c, value, src )
end function

private sub EmitWideToNarrow_ _
    ( byref c as Ctx, byref dst as MirValue, byval dn as longint, byref src as MirValue )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, dn ) )
    args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_WSTR_ASSIGN_TOA, args )
end sub

'' THE SAME, INTO A RESULT SLOT. 'function = w' inside a STRING function has no target
'' node to take an address from -- the destination is fb$result -- so the ordinary
'' entry point could not be reached and every one of those declined.
function LowerWideToNarrowSlot _
    ( byref c as Ctx, byval slot as long, byval dt as Tko.TypeId, _
      byval value as Tko.NodeId ) as boolean

    if slot < 0 then return false
    dim as longint dn = -1
    if IsStringType( c, dt ) = false then
        if StrSwapKind_( c, dt, dn ) <> 1 then return false
    end if

    dim as MirValue src
    if IsWideString_( c, c.info->TypeOf_( value ) ) then
        src = LowerAddr( c, value )
    else
        if NarrowDestWideSource_( c, value, src ) = false then return false
    end if
    if src.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot
    EmitWideToNarrow_( c, dst, dn, src )
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
    ( byref c as Ctx, byref slotAddr as MirValue, byval e as Tko.NodeId ) as boolean

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
    ( byref c as Ctx, byval condE as Tko.NodeId, byval thenE as Tko.NodeId, _
      byval elseE as Tko.NodeId, byref outv as MirValue ) as boolean

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
    ( byref c as Ctx, byref slotAddr as MirValue, byval e as Tko.NodeId ) as boolean

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
'' Is this TERM wide? Its TYPE is not the whole answer: Check computes none for
'' 'wstr( x )', so a chain containing one looked entirely narrow and 'print
'' wstr( cmp )' declined outright -- 52 statements in one corpus file, all of them the
'' same macro.
function TermIsWide_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    e = Unparen_( c, e )
    if e = Tko.NODE_NONE then return false
    if IsWideString_( c, c.info->TypeOf_( e ) ) then return true
    '' A UDT WITH 'operator cast' TO A WSTRING is wide too, and asking that costs a
    '' walk rather than an emission -- which is the whole reason this predicate exists
    '' separately from UserCastToWide_.
    if WideCastOverload_( c, c.info->TypeOf_( e ) ) <> Tko.SYMBOL_NONE then return true
    return IsWstrCall_( c, e )
end function

'' Does this concatenation contain a GENUINELY WIDE term? A literal does not count:
'' it follows its context, so 'print "a" & "b"' is a NARROW concatenation and taking
'' it for a wide one printed two wide literals through fb_WstrConcat.
function ConcatHasWideTerm_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    if e = Tko.NODE_NONE then return false
    if c.ast->Kind( e ) <> Tko.N_BINARY then return false
    dim as FB.Array( of ulong ) vt
    FlattenConcat( c, e, vt )
    for k as long = 0 to vt.Count - 1
        if TermIsWide_( c, cast( Tko.NodeId, vt[k] ) ) then return true
    next
    return false
end function

'' One concatenation step: emit the call, put the result in a slot, and register that
'' slot for deletion. Every result is an allocation the CALLER owns -- fbc emits an
'' fb_WstrDelete for each -- so the slot goes on the statement-temporary list.
private function WideConcatStep_ _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), byval r as RtlId, _
      byref acc as MirValue ) as boolean

    dim as MirValue got = EmitRtl( c, r, args )
    if got.kind = cast( ubyte, MV_NONE ) then return false
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
    return (acc.kind <> cast( ubyte, MV_NONE ))
end function

'' And the other way: a WIDE value as a NARROW descriptor, in a temporary of its own.
''
''     fb_WstrAssignToA( (void*)&TMP, -1ll, (uint16*)PFW, 0 );
''     fb_LineInput( (FBSTRING*)&TMP, ... );
''
'' The temporary is a real string descriptor, so it is zeroed first and registered for
'' deletion the way a string local is -- not a wide temp, which is a bare pointer.
function WideToNarrowTemp_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as MirValue src
    if WideOperand_( c, e, src ) = false then return false
    dim as long slot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
    if slot < 0 then return false
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot
    ZeroStrDescriptor( c, tmp )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, tmp.kind ) ) : args.Push( cast( ulong, tmp.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, cast( ulongint, -1 ) ) )
    args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_WSTR_ASSIGN_TOA, args )
    '' fbc DOES delete this one -- unlike the concat temporary, which it leaves to the
    '' runtime -- so it goes on the statement's narrow temporary list.
    c.strTemps.Push( cast( ulong, slot ) )
    outv = tmp
    return true
end function

'' A NARROW string value converted to a WIDE temporary, the way fbc does it where a
'' wide entry point is handed a narrow argument:
''
''     uint16* vr = fb_StrToWstr( (char*)*(char**)&PS );
''     fb_LineInputWstr( (uint16*)vr, W, 10ll, 0, -1 );
''     fb_WstrDelete( (uint16*)vr );
''
'' The temporary is registered for deletion like every other wide one.
function NarrowToWideTemp_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as MirValue dp
    if ZstrDataOf_( c, e, dp ) = false then return false
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dp.kind ) ) : args.Push( cast( ulong, dp.id ) )
    return WideConcatStep_( c, args, RTL_STR_TO_WSTR, outv )
end function

function WideConcatToTemp_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean

    if e = Tko.NODE_NONE then return false
    if c.ast->Kind( e ) <> Tko.N_BINARY then return false
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, e, terms )
    if terms.Count < 2 then return false

    '' LEFT-FOLDED, because each entry point takes exactly TWO operands: 'a & b & c' is
    '' 'fb_WstrConcat( fb_WstrConcat( A, B ), C )', with a temporary per step and a
    '' delete for each. Measured; that is what fbc emits.
    ''
    '' A MIXED CONCATENATION HAS ITS OWN TWO ENTRY POINTS, and without them every
    '' 's & w' declined -- which is most of what the wstring corpus files print:
    ''
    ''     s & w    fb_WstrConcatAW( (void*)&S, -1ll, (uint16*)W )
    ''     w & s    fb_WstrConcatWA( (uint16*)W, (void*)&S, -1ll )
    ''
    '' ONLY A GENUINELY WIDE TERM IS WIDE HERE. A literal is not, and that is measured
    '' rather than assumed: 'w & ", "' is 'fb_WstrConcatWA( W, (void*)", ", 3ll )', the
    '' NARROW entry point, not a wide literal. Nor is a NUMBER -- 'x & ", " & w' folds
    '' the narrow prefix with fb_IntToStr and fb_StrConcat first and only then goes
    '' wide, which is what makes the wstring PRINT files what they are.
    dim as long wi = -1
    for k as long = 0 to terms.Count - 1
        if TermIsWide_( c, cast( Tko.NodeId, terms[k] ) ) then
            wi = k
            exit for
        end if
    next
    if wi < 0 then return false

    dim as MirValue acc
    dim as long start_ = 1
    if wi > 0 then
        '' The narrow prefix, as one (pointer, length) pair: a single term goes
        '' straight in, several fold into a temporary descriptor first.
        dim as FB.Array( of ulong ) args
        if wi = 1 then
            if EmitStrTerm( c, args, cast( Tko.NodeId, terms[0] ) ) = false then return false
        else
            dim as FB.Array( of ulong ) pre
            for k as long = 0 to wi - 1
                pre.Push( terms[k] )
            next
            dim as MirValue pd
            if ConcatTermsToTempDesc_( c, pre, pd ) = false then return false
            PushStrArg( args, pd )
        end if
        dim as MirValue r
        if WideOperand_( c, cast( Tko.NodeId, terms[wi] ), r ) = false then return false
        args.Push( cast( ulong, r.kind ) ) : args.Push( cast( ulong, r.id ) )
        if WideConcatStep_( c, args, RTL_WSTR_CONCAT_AW, acc ) = false then return false
        start_ = wi + 1
    else
        if WideOperand_( c, cast( Tko.NodeId, terms[0] ), acc ) = false then return false
    end if

    for k as long = start_ to terms.Count - 1
        dim as FB.Array( of ulong ) args
        args.Push( cast( ulong, acc.kind ) ) : args.Push( cast( ulong, acc.id ) )
        dim as RtlId which = RTL_WSTR_CONCAT
        if TermIsWide_( c, cast( Tko.NodeId, terms[k] ) ) then
            dim as MirValue r
            if WideOperand_( c, cast( Tko.NodeId, terms[k] ), r ) = false then return false
            args.Push( cast( ulong, r.kind ) ) : args.Push( cast( ulong, r.id ) )
        else
            if EmitStrTerm( c, args, cast( Tko.NodeId, terms[k] ) ) = false then return false
            which = RTL_WSTR_CONCAT_WA
        end if
        if WideConcatStep_( c, args, which, acc ) = false then return false
    next

    outv = acc
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

function WideOperand_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    id = Unparen_( c, id )

    '' A LITERAL IS A WIDE ONE HERE. fbc writes '(uint16*)L"x"' for a literal compared
    '' against a wstring -- a genuinely wide global, not a narrow one widened at
    '' runtime -- so it takes the wide literal pool the DATA statement already uses.
    if c.ast->Kind( id ) = Tko.N_STRING_LIT then
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
    '' 'whex( x )', 'woct', 'wbin' -- the WIDE half of the radix family, whose result is
    '' a bare uint16* rather than a descriptor. Only the wide half is taken here.
    if LowerRadixCall_( c, id, outv, true ) then return true
    if LowerWideRvalue( c, id, outv ) then return true

    '' A WIDE 'iif'. Structural, like the narrow one: an iif reached from a WIDE
    '' context is a wide iif whatever its arms look like, because Check computes no
    '' type for an iif call and an arm may be an intrinsic with no type either.
    dim as Tko.NodeId iC, iT, iE
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
'' THE 'operator cast' OVERLOAD THAT YIELDS A WSTRING, or nothing. Split out because
'' the CONCATENATION and COMPARISON paths have to know whether a term is wide BEFORE
'' anything is emitted for it, and the only way to find out is this walk: 'operator
'' cast' may be declared several times over different targets, so the chain is walked
'' rather than its head taken.
function WideCastOverload_( byref c as Ctx, byval t as Tko.TypeId ) as Tko.SymbolId
    if t = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    if c.types->Kind( t ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.SymbolId cur = UdtMemberNamed_( c, t, "cast" )
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr cse = c.syms->SymbolAt( cur )
        if cse = 0 then exit while
        dim as Tko.TypeId rt = cse->type_
        if rt <> Tko.TYPE_NONE then
            '' BYREF makes it a POINTER to the wstring, so both spellings count.
            dim as Tko.TypeId inner = rt
            if c.types->Kind( inner ) = Tko.TK_POINTER then
                inner = c.types->Inner( inner )
            end if
            if IsWideString_( c, inner ) then return cur
            if inner <> Tko.TYPE_NONE then
                if c.types->Kind( inner ) = Tko.TK_BUILTIN then
                    if c.types->BuiltinOf( inner ) = Tko.TY_WSTRING then return cur
                end if
            end if
        end if
        cur = cse->nextOverload
    wend
    return Tko.SYMBOL_NONE
end function

private function UserCastToWide_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.SymbolId want = WideCastOverload_( c, c.info->TypeOf_( id ) )
    if want = Tko.SYMBOL_NONE then return false

    dim as MirValue self_ = LowerAddr( c, id )
    if self_.kind = cast( ubyte, MV_NONE ) then return false
    outv = EmitMemberCall( c, want, self_, MT_PTR )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function


'' THE WIDE SUBSTRING AND TRIM FAMILY, as an RVALUE.
''
'' Each of these returns a bare uint16* -- there is no descriptor, which is what makes
'' them lowerable now while their narrow counterparts still are not. fbc releases the
'' result with fb_WstrDelete; tiko-lang does not model that lifetime yet, so EVERY CALL HERE
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
    ( byref c as Ctx, byval value as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( value ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, value )].data )]
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )
    if (cp->count < 1) orelse (cp->count > 3) then return false

    '' The FIRST argument decides: these names are all overloaded on narrow strings
    '' too, and only the wide overload is lowered here.
    dim as Tko.NodeId a0 = cast( Tko.NodeId, c.ast->children[cp->first] )
    dim as MirValue s0
    if WideOperand_( c, a0, s0 ) = false then return false

    '' The second argument, unwrapped from 'any' if it carries one.
    dim as Tko.NodeId a1 = Tko.NODE_NONE
    dim as boolean isAny = false
    if cp->count >= 2 then
        a1 = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
        if c.ast->Kind( a1 ) = Tko.N_UNARY then
            dim as Tko.UnaryPayload ptr up = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, a1 )].data )]
            if cast( Tko.TokenKind, up->op ) = Tko.KW_ANY then
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

    if a1 <> Tko.NODE_NONE then
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
            dim as Tko.NodeId a2 = cast( Tko.NodeId, c.ast->children[cp->first + 2] )
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
