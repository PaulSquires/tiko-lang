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

declare function WideConcatStep_ _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), byval r as RtlId, _
      byref acc as MirValue ) as boolean

'' Defined in lowerstr.bas; the narrow classifier the wide code needs for a mixed
'' operand.
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
    t = c.types->Unqualify( t )
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
    '' CONST IS NOT A DIFFERENT STRING -- see StrSwapKind_. 'dim cw as const wstring *
    '' 10' is the same uint16 array as a mutable one, and the qualified type is a
    '' distinct entry whose kind test said "not a wide string", so every chain spelled
    '' with one dropped its initialiser.
    t = c.types->Unqualify( t )
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
'' A USTRING IS NOT A NARROW STRING, and the wide path is tried on the way past every
'' assignment. IsStringType says yes to a ustring, so 'v = p + u' over a ustring
'' destination was claimed here and emitted fb_WstrConcatWA over the ustring operand
'' and then fb_WstrAssignToA into the ustring descriptor -- a wstring written where a
'' UTF-16 descriptor lives. It lowered and it verified.
''
'' A ustring anywhere in the chain belongs to the conversion fold in lowerterm.bas,
'' which transcodes through fb_WstrToUStr instead.
private function ChainTouchesU_( byref c as Ctx, byval value as Tko.NodeId ) as boolean
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, value, terms )
    for i as long = 0 to terms.Count - 1
        if IsUStringType( c, c.info->TypeOf_( cast( Tko.NodeId, terms[i] ) ) ) then
            return true
        end if
    next
    return false
end function

function LowerWideAssign _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean

    if IsUStringType( c, c.info->TypeOf_( target ) ) then return false
    '' ...BUT A USTRING SOURCE IS NOT A CHAIN THIS CANNOT DO. It is one runtime call,
    '' fb_UStrAssignToW, and refusing it here sent 'w = s' over a 'wstring * 8' to the
    '' generic scalar path, which found a non-void type and STORED THE 24-BYTE USTRING
    '' DESCRIPTOR into the 16-byte buffer -- wrong bytes and an eight-byte overrun,
    '' with 0 statements not lowered to say so.
    if IsUStringType( c, c.info->TypeOf_( value ) ) = false then
        if ChainTouchesU_( c, value ) then return false
    end if

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
    '' A USTRING SOURCE IS ONE CALL. Measured, and the LENGTH is the destination's
    '' element count plainly -- not the sign-tagged form the narrow fixed strings use:
    ''
    ''     w  = s   over a 'wstring * 8'   fb_UStrAssignToW( W$0, 8ll, &S$0, -1ll )
    ''     *wp = s  over a 'wstring ptr'   fb_UStrAssignToW( WP$0, 0ll, &S$0, -1ll )
    ''
    '' and run, both print 'hi'. RTL_USTR_TO_W has been declared since the table was
    '' written and had no emit site at all.
    if IsUStringType( c, c.info->TypeOf_( value ) ) then
        dim as MirValue usrc = LowerAddr( c, value )
        if usrc.kind <> cast( ubyte, MV_NONE ) then
            args.Push( cast( ulong, usrc.kind ) ) : args.Push( cast( ulong, usrc.id ) )
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, cast( ulongint, -1 ) ) )
            EmitRtl( c, RTL_USTR_TO_W, args )
            return true
        end if
        return false
    end if

    dim as MirValue rv
    if WideOperand_( c, value, rv ) then
        args.Push( cast( ulong, rv.kind ) ) : args.Push( cast( ulong, rv.id ) )
        EmitRtl( c, RTL_WSTR_ASSIGN, args )
        return true
    end if

    dim as Tko.TypeId st = c.info->TypeOf_( value )

    '' A LITERAL, or ADJACENT LITERALS, which are one literal -- see LowerZstrAssignTo.
    dim as string lit
    dim as boolean isLit = false
    if c.ast->Kind( value ) = Tko.N_STRING_LIT then
        lit = StringLitText_( c, value )
        isLit = true
    elseif c.ast->Kind( value ) = Tko.N_STRCAT then
        isLit = StrCatText_( c, value, lit )
    end if
    if isLit then
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

    '' A SOURCE THAT IS NOT A STRING AT ALL is rendered wide first. Measured:
    ''
    ''     w &= n     vr = fb_IntToWstr( N$0 );  TMP = vr;
    ''                fb_WstrConcatAssign( W, 80, TMP );  fb_WstrDelete( TMP );
    ''
    '' -- and the same for a BOOLEAN through fb_BoolToWstr and a DOUBLE through
    '' fb_DoubleToWstr. Without it every 'w &= n' and 'w = wstr( "a" ) & n' declined,
    '' which is most of what the boolean and wstring corpus files append.
    '' TermIsWide_ AND NOT THE TYPE ALONE. A wide RVALUE whose callee is unbound --
    '' 'wspace( 3 )', 'wstr( n )' -- has NO TYPE, so a type-only test called it
    '' 'not a wide string', fell into the narrow/number branch below, matched
    '' neither, and declined. The wide path underneath already reaches it through
    '' WideOperand_, which knows the shape.
    dim as boolean srcIsWide = IsWideString_( c, c.info->TypeOf_( value ) )
    if srcIsWide = false then srcIsWide = TermIsWide_( c, value )
    if srcIsWide = false then
        '' A NARROW STRING SOURCE goes through the MIXED entry point and back:
        ''
        ''     TMP = fb_WstrConcatWA( W, (void*)"lit", 4 );
        ''     fb_WstrAssign( W, 80, TMP );  fb_WstrDelete( TMP );
        ''
        '' -- measured, and it is not fb_WstrConcatAssign with the narrow bytes: the
        '' append happens into a temporary and the result is assigned back.
        dim as Tko.TypeId svt = c.info->TypeOf_( value )
        dim as longint zln
        dim as boolean narrowSrc = IsStringType( c, svt ) andalso _
                                   (IsUStringType( c, svt ) = false)
        if narrowSrc = false then
            narrowSrc = (StrSwapKind_( c, svt, zln ) = 1)
        end if
        if narrowSrc = false then
            narrowSrc = (c.ast->Kind( Unparen_( c, value ) ) = Tko.N_STRING_LIT)
        end if
        if narrowSrc then
            dim as FB.Array( of ulong ) wargs
            wargs.Push( cast( ulong, dst.kind ) ) : wargs.Push( cast( ulong, dst.id ) )
            if EmitStrTerm( c, wargs, value ) = false then return false
            dim as MirValue acc
            if WideConcatStep_( c, wargs, RTL_WSTR_CONCAT_WA, acc ) = false then
                return false
            end if
            dim as FB.Array( of ulong ) aargs
            aargs.Push( cast( ulong, dst.kind ) ) : aargs.Push( cast( ulong, dst.id ) )
            aargs.Push( cast( ulong, MV_CONST_INT ) ) : aargs.Push( cast( ulong, n ) )
            aargs.Push( cast( ulong, acc.kind ) ) : aargs.Push( cast( ulong, acc.id ) )
            EmitRtl( c, RTL_WSTR_ASSIGN, aargs )
            return true
        end if

        dim as MirValue nv
        if NumberToWideTemp_( c, value, nv ) = false then return false
        dim as FB.Array( of ulong ) nargs
        nargs.Push( cast( ulong, dst.kind ) ) : nargs.Push( cast( ulong, dst.id ) )
        nargs.Push( cast( ulong, MV_CONST_INT ) ) : nargs.Push( cast( ulong, n ) )
        nargs.Push( cast( ulong, nv.kind ) ) : nargs.Push( cast( ulong, nv.id ) )
        EmitRtl( c, RTL_WSTR_CONCAT_ASSIGN, nargs )
        return true
    end if
    '' THROUGH WideOperand_, not LowerAddr: a wide RVALUE -- 'w &= wstr( "2" )',
    '' 'w &= trim( w2 )' -- has no address, and asking for one declined every
    '' compound append whose source was a call rather than a variable. It is the same
    '' recogniser the assignment path already uses, and it knows every wide shape:
    '' a literal, a variable, a call and a concatenation.
    dim as MirValue src
    if WideOperand_( c, value, src ) = false then return false
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
declare function NarrowDestWideSource_ _
    ( byref c as Ctx, byval value as Tko.NodeId, byref src as MirValue ) as boolean
declare sub EmitWideToNarrow_ _
    ( byref c as Ctx, byref dst as MirValue, byval dn as longint, byref src as MirValue, _
      byval isInit as boolean = false, byval pad as longint = 0 )

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
    if IsUStringType( c, dt ) then return false
    if ChainTouchesU_( c, value ) then return false
    dim as longint dn = -1
    dim as longint pad = 0
    if IsStringType( c, dt ) = false then
        '' KIND 3 -- 'string * N' -- BELONGS HERE TOO, and refusing it sent 'f = *pw'
        '' down the narrow path, which found no narrow source and declined. Its dn is
        '' already the sign-bit-tagged length fbc wants, and it is the kind that pads,
        '' so it is also the one that passes -1 last. Measured:
        ''
        ''     fb_WstrAssignToA( (void*)F$0, -9223372036854775777ll, (uint16*)PW$0, -1 )
        ''
        '' and run, f holds "123" space-padded to its full 31 columns.
        dim as long dk0 = StrSwapKind_( c, dt, dn )
        if (dk0 <> 1) andalso (dk0 <> 3) then return false
        if dk0 = 3 then pad = -1
    end if

    '' A CONCATENATION IS WIDE-TYPED TOO now that 'w + s' answers WSTRING, and it has no
    '' address. The address is TRIED and anything without one falls through to the
    '' temporary; treating a wide TYPE as "addressable" declined every mixed chain.
    dim as boolean wideSrc = (IsWideString_( c, c.info->TypeOf_( value ) ))
    dim as MirValue src
    if wideSrc = false then
        if NarrowDestWideSource_( c, value, src ) = false then return false
    end if

    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false
    if wideSrc then src = LowerAddr( c, value )
    if src.kind = cast( ubyte, MV_NONE ) then
        if NarrowDestWideSource_( c, value, src ) = false then return false
    end if
    if src.kind = cast( ubyte, MV_NONE ) then return false

    EmitWideToNarrow_( c, dst, dn, src, false, pad )
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

    '' A WIDE RVALUE WITH NO ADDRESS -- 'wstr( x )', 'trim( w )' -- is a bare uint16*
    '' like any other wide operand, and WideOperand_ already knows all three spellings.
    '' Without it 'print using wstr( "###" )' had a wide source that was neither a
    '' concatenation nor an operator cast and declined.
    ''
    '' ASKED ONLY OF A GENUINELY WIDE TERM. WideOperand_ answers for shapes that are
    '' not wide at all -- it is a spelling test, not a type test -- and letting it claim
    '' a NARROW source here turned four goldens into wide runtime calls over narrow
    '' data.
    if TermIsWide_( c, value ) then
        if WideOperand_( c, value, src ) then
            if src.kind <> cast( ubyte, MV_NONE ) then return true
        end if
    end if
    return UserCastToWide_( c, value, src )
end function

private sub EmitWideToNarrow_ _
    ( byref c as Ctx, byref dst as MirValue, byval dn as longint, byref src as MirValue, _
      byval isInit as boolean, byval pad as longint )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    '' PushStrLen_, NOT an inline MV_CONST_INT: that payload is 32 BITS and a
    '' 'string * N' length is '&h8000000000000000 or N', which truncates to plain N
    '' and silently turns the fixed-length tag into an ordinary zstring count. The
    '' destination was a zstring here until kind 3 could reach this sub, so nothing
    '' had ever passed a tagged length through it.
    PushStrLen_( c, args, dn )
    args.Push( cast( ulong, src.kind ) ) : args.Push( cast( ulong, src.id ) )
    '' THE LAST ARGUMENT IS NOT ALWAYS ZERO. It is -1 for a 'string * N'
    '' destination, which is the one narrow kind that PADS, and 0 for the other two.
    '' Measured, and in both entry points:
    ''
    ''     dim as string  * 9 f = *pw   fb_WstrAssignToA_Init( F, <encoded>, PW, -1ll )
    ''     dim as zstring * 9 z = *pw   fb_WstrAssignToA_Init( Z, 9ll,       PW,  0ll )
    ''     f = *pw                      fb_WstrAssignToA     ( F, <encoded>, PW, -1 )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, pad ) )
    '' THE DECLARATION FORM IS A DIFFERENT FUNCTION, not a flag: fb_WstrAssignToA_Init
    '' where a later store takes fb_WstrAssignToA. Measured.
    dim as long which = RTL_WSTR_ASSIGN_TOA
    if isInit then which = RTL_WSTR_TOA_INIT
    EmitRtl( c, which, args )
end sub

'' THE SAME, INTO A RESULT SLOT. 'function = w' inside a STRING function has no target
'' node to take an address from -- the destination is fb$result -- so the ordinary
'' entry point could not be reached and every one of those declined.
'' The destination is a SLOT or, for storage with no slot, an ADDRESS -- selfv. A
'' UDT FIELD has no frame slot, so 'k as string = wstr( "fOoBaR" )' had nowhere to
'' write and declined.
function LowerWideToNarrowSlot _
    ( byref c as Ctx, byval slot as long, byval dt as Tko.TypeId, _
      byval value as Tko.NodeId, byval isInit as boolean = false, _
      byval selfv as MirValue ptr = 0 ) as boolean

    if (slot < 0) andalso (selfv = 0) then return false
    if IsUStringType( c, dt ) then return false
    if ChainTouchesU_( c, value ) then return false
    dim as longint dn = -1
    dim as longint pad = 0
    if IsStringType( c, dt ) = false then
        '' A FIXED-LENGTH NARROW DESTINATION TAKES ITS OWN ELEMENT COUNT where a
        '' var-length one takes -1. Measured:
        ''
        ''   dim s1 as zstring * 10 = wchr( 65 )
        ''     fb_WstrAssignToA_Init( (void*)S1$0, 10ll, (uint16*)L"A", 0ll )
        ''
        '' Refusing anything but kind 1 left 'zstring * N' out, so the narrow
        '' fixed-string path took it, found no narrow source, and declined.
        dim as long dk = StrSwapKind_( c, dt, dn )
        if (dk <> 1) andalso (dk <> 3) then return false
        if dk = 3 then pad = -1
    end if

    '' A CONCATENATION IS WIDE-TYPED TOO now that 's + w' answers WSTRING, and it has no
    '' address: asking LowerAddr for one gave nothing and the whole shape declined.
    '' The address is TRIED, and anything without one falls through to the temporary.
    dim as MirValue src
    if IsWideString_( c, c.info->TypeOf_( value ) ) then src = LowerAddr( c, value )
    if src.kind = cast( ubyte, MV_NONE ) then
        if NarrowDestWideSource_( c, value, src ) = false then return false
    end if
    if src.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirValue dst
    if selfv <> 0 then
        dst = *selfv
    else
        dst.kind = cast( ubyte, MV_LOCAL )
        dst.ty = cast( ubyte, MT_PTR )
        dst.id = slot
    end if
    EmitWideToNarrow_( c, dst, dn, src, isInit, pad )
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

    dim as MirValue cond = LowerCondition( c, condE )
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

'' DOES THIS LITERAL CONTAIN A UNICODE ESCAPE? Only an ESCAPED literal can: '"'+BS+'u41"'
'' is four ordinary characters and '$"'+BS+'u41"' is too.
function LitHasUnicodeEscape_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    if e = Tko.NODE_NONE then return false
    if c.ast->Kind( e ) <> Tko.N_STRING_LIT then return false
    dim as Tko.LiteralPayload ptr lp = _
        @c.ast->literals[cast( long, c.ast->nodes[cast( long, e )].data )]
    if lp->strKind <> cast( ubyte, Tko.STRK_ESCAPED ) then return false
    if lp->strLength < 2 then return false
    dim as Tko.SourceFile ptr f = c.srcMgr->FileAt( cast( Tko.FileId, lp->strFile ) )
    if f = 0 then return false
    if (lp->strOffset + lp->strLength) > f->text.Count then return false
    for k as long = 0 to lp->strLength - 2
        if f->text[lp->strOffset + k] = 92 then
            dim as ubyte nx = f->text[lp->strOffset + k + 1]
            if (nx = asc( "u" )) orelse (nx = asc( "U" )) then return true
        end if
    next
    return false
end function

'' wstr( cmp )' declined outright -- 52 statements in one corpus file, all of them the
'' same macro.
function TermIsWide_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
    e = Unparen_( c, e )
    if e = Tko.NODE_NONE then return false
    '' 'str( x )' IS NARROW WHATEVER IT WAS HANDED, and it is asked first because
    '' every test below reads the OPERAND's type -- see IsStrCall_.
    if IsStrCall_( c, e ) then return false
    if IsWideString_( c, c.info->TypeOf_( e ) ) then return true
    '' A LITERAL CONTAINING A UNICODE ESCAPE IS WIDE, and does NOT follow its
    '' context the way every other literal does. Measured: '#print typeof(
    '' !"\u0041" )' is 'WSTRING * 3' while '!"\n"' and '"A"' are both ZSTRING.
    ''
    '' So a NARROW destination CONVERTS one -- fbc emits
    '' 'fb_WstrAssignToA_Init( &S, -1, L"AB", 0 )' for 'dim as string s =
    '' !"\u0041\u0042"' -- where tiko-lang put the twelve characters of the
    '' SPELLING into a narrow global and called it done.
    if LitHasUnicodeEscape_( c, e ) then return true
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
    '' A CHARACTER PLUS A NUMBER IS ARITHMETIC, not a concatenation, and the wide
    '' half did not know it. Measured, fbc prints 97 for both
    ''
    ''     print *p + 0        '' p is a zstring ptr
    ''     print *pw + 0       '' pw is a wstring ptr
    ''
    '' and tiko printed 97 for the narrow one and 'abc0' for the wide one --
    '' fb_WstrConcatWA over the whole string. The comparison path in lowerexpr.bas
    '' has carried exactly this rule since quirk/zwstr-deref.bas was written; this
    '' is the same rule on the ADDITIVE side, and the file that measures it
    '' (tests/mir/src/zstring-deref-arith.bas) already says the narrow case was
    '' fixed and its wide twin was not.
    dim as Tko.BinaryPayload ptr cbp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, e )].data )]
    if cast( Tko.TokenKind, cbp->op ) = Tko.TK_PLUS then
        dim as boolean lIsChar = (CharLvalueTy_( c, cbp->lhs ) <> MT_VOID)
        dim as boolean rIsChar = (CharLvalueTy_( c, cbp->rhs ) <> MT_VOID)
        dim as boolean lNum = NumericTerm_( c, cbp->lhs )
        dim as boolean rNum = NumericTerm_( c, cbp->rhs )
        dim as boolean arith = false
        if lIsChar andalso rNum then arith = true
        if rIsChar andalso lNum then arith = true
        if arith then return false
    end if
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
function WideConcatStep_ _
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
'' A NUMBER OR A BOOLEAN RENDERED WIDE, into a temporary the statement releases.
''
'' Measured: 'w &= n' is 'vr = fb_IntToWstr( N$0 ); TMP = vr; fb_WstrConcatAssign( W,
'' 80, TMP ); fb_WstrDelete( TMP )'. Which renderer comes off the operand's own type,
'' and BOOLEAN has its own -- fb_BoolToWstr, which writes "true" where fb_IntToWstr
'' would write -1.
function NumberToWideTemp_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.TypeId at = c.types->Unqualify( c.info->TypeOf_( e ) )
    if at = Tko.TYPE_NONE then return false
    if c.types->Kind( at ) = Tko.TK_ENUM then at = c.types->Builtin( Tko.TY_INTEGER )
    '' A POINTER RENDERS AS ITS ADDRESS, unsigned -- measured, 'wstr( p )' is
    '' 'fb_ULongintToWstr( (uint64)P$0 )' for every pointer type. It is not a
    '' BUILTIN, so the test below refused it and the call came out untyped.
    dim as boolean atPtr = (c.types->Kind( at ) = Tko.TK_POINTER)
    if (c.types->Kind( at ) <> Tko.TK_BUILTIN) andalso (atPtr = false) then return false

    dim as RtlId r = RTL_NONE
    dim as MirType want = MT_I32
    if atPtr then r = RTL_ULONGINT_TO_WSTR : want = MT_I64
    if atPtr = false then
        select case c.types->BuiltinOf( at )
    case Tko.TY_BOOLEAN
        r = RTL_BOOL_TO_WSTR : want = MT_I8
    case Tko.TY_BYTE, Tko.TY_SHORT, Tko.TY_LONG
        r = RTL_INT_TO_WSTR
    case Tko.TY_UBYTE, Tko.TY_USHORT, Tko.TY_ULONG
        r = RTL_UINT_TO_WSTR
    case Tko.TY_INTEGER, Tko.TY_LONGINT
        r = RTL_LONGINT_TO_WSTR : want = MT_I64
    case Tko.TY_UINTEGER, Tko.TY_ULONGINT
        r = RTL_ULONGINT_TO_WSTR : want = MT_I64
    case Tko.TY_SINGLE
        r = RTL_FLOAT_TO_WSTR : want = MT_F32
    case Tko.TY_DOUBLE
        r = RTL_DOUBLE_TO_WSTR : want = MT_F64
    case else
        return false
    end select
    end if

    dim as MirValue av = LowerExpr( c, e )
    if av.kind = cast( ubyte, MV_NONE ) then return false
    av = CoerceTy( c, av, want, at)
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, av.kind ) ) : args.Push( cast( ulong, av.id ) )
    return WideConcatStep_( c, args, r, outv )
end function

function NarrowToWideTemp_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byref outv as MirValue ) as boolean

    if UStrDataArg_( c, e, outv ) then return true   '' already UTF-16 -- see UStrDataArg_
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


'' A WIDE LITERAL'S CODE UNITS, with its escapes decoded.
''
'' '\uXXXX' IS A CODE UNIT, NOT A BYTE, which is why this exists beside the narrow
'' reader rather than inside it: StringLitText_ answers in bytes and DELIBERATELY
'' leaves an escaped literal containing a unicode escape alone, because decoding the
'' byte escapes around one and dropping the wide ones would produce a literal that is
'' neither compiler's answer.
''
'' So the raw text flowed through to the wide global, and a 'wstring' initialised
'' from '!"\u0041\u0042"' held the twelve characters of the SPELLING where fbc has
'' the two characters AB. It lowered, it verified, and 34 corpus files are made of
'' it -- wstring/trim.bas writes 186 of them and declines nothing.
''
'' Every other escape is the byte the narrow reader gives, widened: measured, fbc's
'' own wide literal for '!"A\n"' is L"A\\x000A".
declare function WideLitUnits_ _
    ( byref c as Ctx, byval id as Tko.NodeId, _
      byref outText as string, byref outUnits as FB.Array( of ulong ) ) as boolean

'' A SOURCE LITERAL AS A WIDE GLOBAL, with its escapes decoded, and the CHARACTER
'' COUNT that goes with it. Every site that turns an N_STRING_LIT into a wide
'' literal goes through here: the count is the units', not the spelling's, and
'' '!"\u0041"' is one character written with six.
''
'' Returns -1 when the node is not a literal this can read.
function WideLitGlobal_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outChars as long ) as long

    outChars = 0
    dim as string wtext
    dim as FB.Array( of ulong ) wunits
    if WideLitUnits_( c, id, wtext, wunits ) = false then return -1
    outChars = cast( long, wunits.Count )
    return c.m->AddWideStringUnits( wtext, wunits, *c.names )
end function

private function WideLitUnits_ _
    ( byref c as Ctx, byval id as Tko.NodeId, _
      byref outText as string, byref outUnits as FB.Array( of ulong ) ) as boolean

    '' A NAMED CONSTANT IS ITS INITIALISER. 'const TV = wchr( 256, 257 )' then
    '' 'dim as wstring * 32 s = TV' -- only an N_STRING_LIT was read here, so the
    '' constant fell through to the NARROW folder, whose carrier is a byte string
    '' and which declines a code above 255. Reading it here gives the units
    '' directly, which is what the wide global holds anyway.
    if (c.ast->Kind( id ) = Tko.N_IDENT) orelse (c.ast->Kind( id ) = Tko.N_MEMBER) then
        dim as Tko.Symbol ptr wcs = c.syms->SymbolAt( c.info->RefOf( id ) )
        if wcs = 0 then return false
        if wcs->kind <> cast( ubyte, Tko.SYM_CONSTANT ) then return false
        if (wcs->flags and Tko.SYMF_BUILTIN) <> 0 then return false
        if wcs->payload = 0 then return false
        dim as Tko.NodeId witem = cast( Tko.NodeId, wcs->payload )
        if c.ast->Kind( witem ) <> Tko.N_VAR_ITEM then return false
        return WideLitUnits_( c, StmtOf( c, witem )->b, outText, outUnits )
    end if

    '' 'wchr( a, b, c )' IS A WIDE LITERAL, one unit per code, and a code ABOVE 255
    '' is the whole point of writing it: 'wchr( 256, 257, 258 )' is three units the
    '' narrow carrier cannot hold, so it declined there and the statement went with
    '' it. wstring/wchr.bas is two of those.
    if c.ast->Kind( id ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr wcp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if wcp->target = Tko.NODE_NONE then return false
        if c.ast->Kind( wcp->target ) <> Tko.N_IDENT then return false
        dim as Tko.IdentPayload ptr wip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, wcp->target )].data )]
        if Tko.Text.LowerAscii( c.names->Spelling( wip->name ) ) <> "wchr" then
            return false
        end if
        if wcp->count < 1 then return false
        dim as string wkey = ""
        for i as long = 0 to wcp->count - 1
            dim as Tko.NodeId wa = cast( Tko.NodeId, c.ast->children[wcp->first + i] )
            dim as Tko.Check.ConstVal wv = Tko.Check.ConstOf( _
                *c.ast, wa, *c.srcMgr, *c.names, 64, c.syms, Tko.SCOPE_GLOBAL )
            if wv.known = false then return false
            if (wv.value < 0) orelse (wv.value > 65535) then return false
            outUnits.Push( cast( ulong, wv.value ) )
            '' The MERGE KEY, and it has to separate two literals with different
            '' units -- AddWideStringUnits dedups on this text, not on the units.
            wkey += "\u" & hex( cast( long, wv.value ), 4 )
        next
        outText = wkey
        return true
    end if

    if c.ast->Kind( id ) <> Tko.N_STRING_LIT then return false
    dim as Tko.LiteralPayload ptr lp = _
        @c.ast->literals[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->strLength < 0 then return false
    dim as Tko.SourceFile ptr f = c.srcMgr->FileAt( cast( Tko.FileId, lp->strFile ) )
    if f = 0 then return false
    if (lp->strOffset + lp->strLength) > f->text.Count then return false
    '' A UTF-8 SOURCE DECODES ITS CHARACTERS -- see PushSourceUnit_.
    dim as boolean u8 = (f->encoding <> Tko.Text.ENC_BYTES)

    '' The RAW body, with '""' collapsed to one quote -- the same first step the
    '' narrow reader takes, and for the same reason: the span is source.
    dim as string body = ""
    dim as long k = 0
    while k < lp->strLength
        dim as ubyte ch = f->text[lp->strOffset + k]
        body += chr( ch )
        if (ch = 34) andalso (k + 1 < lp->strLength) then
            if f->text[lp->strOffset + k + 1] = 34 then k += 1
        end if
        k += 1
    wend
    outText = body

    if lp->strKind <> cast( ubyte, Tko.STRK_ESCAPED ) then
        '' Not an escaped literal: every source CHARACTER is its own unit (or pair).
        dim as long bi = 0
        while bi < len( body )
            PushSourceUnit_( c, u8, body, bi, outUnits )
        wend
        return true
    end if

    dim as long p2 = 1
    while p2 <= len( body )
        if asc( mid( body, p2, 1 ) ) <> 92 then
            dim as long ci = p2 - 1
            PushSourceUnit_( c, u8, body, ci, outUnits )
            p2 = ci + 1
            continue while
        end if
        dim as long nx = 0
        if p2 + 1 <= len( body ) then nx = asc( mid( body, p2 + 1, 1 ) )
        if (nx = asc( "u" )) orelse (nx = asc( "U" )) then
            '' EXACTLY FOUR HEX DIGITS. Fewer is not this escape, and reading a
            '' greedy run would swallow the text after it.
            if p2 + 5 > len( body ) then return false
            dim as long uv = 0
            for d as long = 0 to 3
                dim as long hc = asc( mid( body, p2 + 2 + d, 1 ) )
                dim as long dv = -1
                if (hc >= 48) andalso (hc <= 57) then dv = hc - 48
                if (hc >= 97) andalso (hc <= 102) then dv = hc - 87
                if (hc >= 65) andalso (hc <= 70) then dv = hc - 55
                if dv < 0 then return false
                uv = uv * 16 + dv
            next
            outUnits.Push( cast( ulong, uv ) )
            p2 += 6
            continue while
        end if
        dim as long bi = p2
        dim as long bv = Tko.Text.EscapeByteAt( body, bi )
        p2 = bi
        '' A NUL FROM A NUMERIC ESCAPE ENDS THE LITERAL, exactly as it does in the
        '' narrow reader -- measured there by running fbc's own output.
        if bv = 0 then exit while
        if bv > 0 then outUnits.Push( cast( ulong, bv ) )
    wend
    return true
end function

function WideOperand_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    id = Unparen_( c, id )

    '' 'winput( n [, [#]f] )' HANDS BACK A WIDE POINTER, which is exactly what a wide
    '' operand is. Its node is an N_INTRINSIC and nothing here claimed it, so
    '' 'winput( 2, #1 ) = wstr( "bb" )' declined while the ASSIGNMENT form beside it
    '' lowered. fbc: 'uint16* vr$10 = fb_FileWstrInput( 2ll, 1 );'.
    if c.ast->Kind( id ) = Tko.N_INTRINSIC then
        dim as Tko.StmtPayload ptr wip = StmtOf( c, id )
        if (wip->extra and 8) <> 0 then
            if cast( Tko.TokenKind, wip->op ) = Tko.KW_WINPUT then
                dim as MirValue wiv = LowerExpr( c, id )
                if wiv.kind <> cast( ubyte, MV_NONE ) then
                    outv = wiv
                    return true
                end if
                return false
            end if
        end if
    end if

    '' A LITERAL IS A WIDE ONE HERE. fbc writes '(uint16*)L"x"' for a literal compared
    '' against a wstring -- a genuinely wide global, not a narrow one widened at
    '' runtime -- so it takes the wide literal pool the DATA statement already uses.
    if c.ast->Kind( id ) = Tko.N_STRING_LIT then
        dim as string wtext
        dim as FB.Array( of ulong ) wunits
        if WideLitUnits_( c, id, wtext, wunits ) = false then return false
        outv.kind = cast( ubyte, MV_GLOBAL )
        outv.ty = cast( ubyte, MT_PTR )
        outv.id = c.m->AddWideStringUnits( wtext, wunits, *c.names )
        return true
    end if

    '' A WIDE STRING CONSTANT IS ITS TEXT, as a wide literal. 'const S = wstr( "ab" )'
    '' has a type -- 'WSTRING * 3' -- but no storage and no address, so the branch
    '' below claimed it and then asked for one. Every use of a wide constant declined.
    if (c.ast->Kind( id ) = Tko.N_IDENT) orelse (c.ast->Kind( id ) = Tko.N_MEMBER) then
        if IsWideString_( c, c.info->TypeOf_( id ) ) then
            '' THE UNITS FIRST, because ConstStringTextOf_'s carrier is a BYTE
            '' string: 'const TV = wchr( 256, 257, 258 )' has no byte spelling and
            '' declined there, taking the assignment with it. WideLitUnits_ reads
            '' the constant's initialiser and hands back real code units.
            dim as string wut
            dim as FB.Array( of ulong ) wuu
            if WideLitUnits_( c, id, wut, wuu ) then
                outv.kind = cast( ubyte, MV_GLOBAL )
                outv.ty = cast( ubyte, MT_PTR )
                outv.id = c.m->AddWideStringUnits( wut, wuu, *c.names )
                return true
            end if
            dim as string wct
            if ConstStringTextOf_( c, id, wct ) then
                outv.kind = cast( ubyte, MV_GLOBAL )
                outv.ty = cast( ubyte, MT_PTR )
                dim as long wcc = 0
                outv.id = WideFoldedText_( c, id, wct, wcc )
                return true
            end if
        end if
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
            '' BYREF makes it a POINTER to the wstring, so both spellings count -- and a
            '' REFERENCE is the third, which 'byref as const wstring' resolves to. CONST
            '' is stripped with it: 'const wstring' is the same wstring.
            dim as Tko.TypeId inner = c.types->Unqualify( rt )
            if c.types->Kind( inner ) = Tko.TK_REFERENCE then
                inner = c.types->Unqualify( c.types->Inner( inner ) )
            end if
            if c.types->Kind( inner ) = Tko.TK_POINTER then
                inner = c.types->Unqualify( c.types->Inner( inner ) )
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

function UserCastToWide_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    dim as Tko.SymbolId want = WideCastOverload_( c, c.info->TypeOf_( id ) )
    if want = Tko.SYMBOL_NONE then return false

    '' A PAREN-LESS CALL IS A CALL: LowerAddr on a bare procedure name is its CODE address,
    '' which 'AfxGetExePathName & "\x"' handed the cast as 'this' -- tracks died in wcslen.
    '' Called as MT_AGG, what the definition returns (MT_PTR made the ABI pass decline the
    '' function), then copied to a temporary for an address, as UdtSelfAddr_ does; the
    '' call's own result slot is the one registered for destruction.
    dim as MirValue self_, brv
    dim as Tko.Symbol ptr bs = 0
    dim as Tko.NodeKind ik = c.ast->Kind( id )
    if (ik = Tko.N_IDENT) orelse (ik = Tko.N_MEMBER) then bs = c.syms->SymbolAt( c.info->RefOf( id ) )
    if (bs <> 0) andalso (bs->kind = cast( ubyte, Tko.SYM_PROC )) then
        dim as long bsz = SizeOfType( c, c.types->Unqualify( c.info->TypeOf_( id ) ) )
        if bsz <= 0 then return false
        if LowerBareProcCall_( c, id, MT_AGG, brv ) = false then return false
        self_.kind = cast( ubyte, MV_LOCAL ) : self_.ty = cast( ubyte, MT_PTR )
        self_.id = NewTempLocal( c, MT_AGG, bsz )
        if cast( long, self_.id ) < 0 then return false
        StoreThrough( c, self_, brv )
    else
        self_ = LowerAddr( c, id )
    end if
    if self_.kind = cast( ubyte, MV_NONE ) then return false
    outv = EmitMemberCall( c, want, self_, MT_PTR )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function


'' THE WIDE SUBSTRING AND TRIM FAMILY, as an RVALUE.
''
'' Each of these returns a bare uint16* -- there is no descriptor, which is what makes
'' them lowerable now while their narrow counterparts still are not. fbc releases the
'' result with fb_WstrDelete, and so does the tail of this function: the result goes
'' out through WideConcatStep_, which parks it in a temporary and puts that on the
'' statement's wide-temporary list. It used to leave through EmitRtl, and every call
'' here leaked one temporary.
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
    if cp->count < 1 then return false

    '' 'wchr( a, b, ... )' -- THE WIDE TWIN OF CHR, and variadic like it: a COUNT and
    '' then that many codes. It had no lowering at all, so 'w = wchr( n )' declined and
    '' so did every term built out of one -- 'u &= wchr( QUOTE )' is the line
    '' fb/string.bi's own comment insists must be WCHR and never CHR.
    if nm = "wchr" then
        if cp->count < 1 then return false
        '' AN ALL-CONSTANT 'wchr' IS A LITERAL, and fbc folds it to one: measured,
        '' 'dim s as zstring * 10 = wchr( 65 )' passes '(uint16*)L"A"' and calls
        '' nothing. Emitting fb_WstrChr instead is a wide temporary the caller owns
        '' and nothing here deletes -- a leak per execution where fbc has a static
        '' global.
        dim as boolean allConst = true
        dim as string wtx
        dim as FB.Array( of ulong ) wus
        for i as long = 0 to cp->count - 1
            dim as Tko.NodeId kn = cast( Tko.NodeId, c.ast->children[cp->first + i] )
            dim as Tko.Check.ConstVal kv = Tko.Check.ConstOf( _
                *c.ast, kn, *c.srcMgr, *c.names, c.types->target.pointerBits, _
                c.syms, c.info->ScopeOf( value ) )
            if kv.known = false then
                allConst = false
                exit for
            end if
            if (kv.value < 0) orelse (kv.value > 65535) then
                allConst = false
                exit for
            end if
            wus.Push( cast( ulong, kv.value ) )
            '' The TEXT is the pool's key and only that: two literals with the same
            '' units must share one global, and the units decide what is emitted.
            wtx += chr( cast( long, kv.value ) and &hFF )
            wtx += chr( (cast( long, kv.value ) shr 8) and &hFF )
        next
        if allConst then
            outv.kind = cast( ubyte, MV_GLOBAL )
            outv.ty = cast( ubyte, MT_PTR )
            outv.id = c.m->AddWideStringUnits( wtx, wus, *c.names )
            return true
        end if
        dim as FB.Array( of ulong ) wca
        wca.Push( cast( ulong, MV_CONST_INT ) ) : wca.Push( cast( ulong, cp->count ) )
        for i as long = 0 to cp->count - 1
            dim as Tko.NodeId ai = cast( Tko.NodeId, c.ast->children[cp->first + i] )
            dim as MirValue av = LowerExpr( c, ai )
            if av.kind = cast( ubyte, MV_NONE ) then return false
            av = CoerceTy( c, av, MT_I64, c.info->TypeOf_( ai ))
            wca.Push( cast( ulong, av.kind ) ) : wca.Push( cast( ulong, av.id ) )
        next
        outv = EmitRtl( c, RTL_WSTR_CHR, wca )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' 'wspace( n )' -- THE WIDE TWIN OF SPACE. fb_WstrSpace was in the runtime table
    '' and had no caller at all, so every 'e = wspace( 5 )' declined -- and the corpus
    '' builds most of its EXPECTED VALUES that way, which is why lset and rset looked
    '' broken when they were not.
    ''
    '' Measured: 'uint16* vr$4 = fb_WstrSpace( 5ll )', and the result is an allocation
    '' the CALLER owns -- fbc deletes it -- so it goes through WideConcatStep_, which is
    '' what registers a wide temporary for its fb_WstrDelete.
    if nm = "wspace" then
        if cp->count <> 1 then return false
        dim as Tko.NodeId sn = cast( Tko.NodeId, c.ast->children[cp->first] )
        dim as MirValue nv = LowerExpr( c, sn )
        if nv.kind = cast( ubyte, MV_NONE ) then return false
        nv = CoerceTy( c, nv, MT_I64, c.info->TypeOf_( sn ))
        if nv.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) sa
        sa.Push( cast( ulong, nv.kind ) ) : sa.Push( cast( ulong, nv.id ) )
        return WideConcatStep_( c, sa, RTL_WSTR_SPACE, outv )
    end if

    '' AT MOST THREE, for everything below -- the trim, mid and radix families. WCHR is
    '' VARIADIC and is taken above this: fbc accepts up to 32 codes, and the guard used
    '' to sit at the top of the function and refuse a fourth.
    if cp->count > 3 then return false

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
    dim as boolean secondIsMode = false      '' ...or a 32-bit case mode
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
    '' THE SECOND ARGUMENT IS THE CASE MODE, and it is written: fbc emits
    '' 'fb_WstrUcase2( (uint16*)V$0, 1 )' for 'ucase( v, 1 )' and passes 0 only when
    '' the call omits it. Accepting the one-argument form alone made every
    '' 'ucase( w, 1 )' decline -- which is how string/case.bas writes all of them.
    case "ucase"
        if (cp->count < 1) orelse (cp->count > 2) then return false
        secondIsMode = true
        r = RTL_WSTR_UCASE
    case "lcase"
        if (cp->count < 1) orelse (cp->count > 2) then return false
        secondIsMode = true
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
            '' integer width the program used, so it is widened here. The case mode
            '' is an int32 instead, which is the width fbc declares.
            dim as MirValue n1 = LowerExpr( c, a1 )
            if n1.kind = cast( ubyte, MV_NONE ) then return false
            dim as MirType nw = MT_I64
            if secondIsMode then nw = MT_I32
            n1 = CoerceTy( c, n1, nw, c.info->TypeOf_( a1 ))
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
            n2 = CoerceTy( c, n2, MT_I64, c.info->TypeOf_( a2 ))
            args.Push( cast( ulong, n2.kind ) ) : args.Push( cast( ulong, n2.id ) )
        else
            args.Push( cast( ulong, MV_CONST_INT ) )
            args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        end if
    elseif secondIsMode andalso (a1 = Tko.NODE_NONE) then
        '' The trailing int32 is the case mode, 0 when the call omits it.
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    end if

    '' THROUGH WideConcatStep_, WHICH REGISTERS THE RESULT FOR ITS fb_WstrDelete.
    '' Every one of these returns an allocation the CALLER owns -- measured:
    '' 'w1 = left( d, 3 )' is 'vr = fb_WstrLeft( D, 3 ); fb_WstrAssign( W1, 50,
    '' vr ); fb_WstrDelete( vr )' -- and EmitRtl alone dropped the pointer, so
    '' every call here leaked one temporary. 12 of the 20 wstring corpus files
    '' that lower fully call fb_WstrDelete in fbc and never did here.
    return WideConcatStep_( c, args, r, outv )
end function


end namespace
