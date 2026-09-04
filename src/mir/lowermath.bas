'' lowermath.bas -- the MATH intrinsic family.
''
'' Split out of lowersub.bas at the 1500-line lint cap. INCLUDED into the same
'' compilation unit -- it is INCLUDED from inside lowersub.bas's own
'' 'namespace Tko.Mir', so it opens neither the namespace nor the header again.
'' Nothing in it changed in the move.


'' THE MATH INTRINSICS -- int, fix, frac, abs, sgn, sqr and the transcendentals.
''
'' None of them were lowered, so every one declined. 'ctr1 = 1 + int( (b - a) / s )' is
'' the shape the corpus writes and it was 280 declines in one file.
''
'' THREE DIFFERENT MECHANISMS, and which is which is not guessable -- each was read off
'' fbc's own C:
''
''   sqr sin cos tan asin acos atn log exp   gcc BUILTINS: '__builtin_sqrt( X )'
''   abs                                     a builtin, and a DIFFERENT one per width:
''                                           __builtin_fabs / fabsf / llabs
''   fix frac sgn                            RUNTIME CALLS: fb_FIXDouble, fb_FRACd,
''                                           fb_SGNl -- and SGN returns int32 from all
''                                           three, including the longint form
''   atan2                                   a plain libc call, no builtin prefix
''   int                                     a FLOOR, then the ordinary float-to-integer
''                                           coercion: 'fb_D2L( __builtin_floor( X ) )'
''                                           looks like a fourth case, but fb_D2L is a
''                                           MACRO over nearbyint and that coercion is
''                                           already what Coerce emits
''
'' The builtins are OPCODES rather than runtime entries, because a builtin is declared
'' nowhere -- putting them in the inventory would fail check-rtl, which reads what fbc
'' declares.
function LowerMathCall_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_CALL then return false
    dim as Tko.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Tko.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return false
    if (cp->count < 1) orelse (cp->count > 2) then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )

    dim as Tko.NodeId a0 = cast( Tko.NodeId, c.ast->children[cp->first] )
    dim as Tko.TypeId at = c.info->TypeOf_( a0 )
    if at = Tko.TYPE_NONE then return false
    dim as MirType amt = LowerType( at, *c.types )
    dim as boolean isFlt = (amt = MT_F32) orelse (amt = MT_F64)
    dim as boolean uns = IsUnsignedType( c, at )

    '' ATAN2 takes two and is the only one that does.
    if nm = "atan2" then
        if cp->count <> 2 then return false
        dim as Tko.NodeId a1 = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
        dim as MirValue v0 = LowerExpr( c, a0 )
        if v0.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirValue v1 = LowerExpr( c, a1 )
        if v1.kind = cast( ubyte, MV_NONE ) then return false
        v0 = Coerce( c, v0, MT_F64, uns )
        v1 = CoerceTy( c, v1, MT_F64, c.info->TypeOf_( a1 ))
        dim as FB.Array( of ulong ) aa
        aa.Push( cast( ulong, v0.kind ) ) : aa.Push( cast( ulong, v0.id ) )
        aa.Push( cast( ulong, v1.kind ) ) : aa.Push( cast( ulong, v1.id ) )
        outv = EmitRtl( c, RTL_ATAN2, aa )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if
    if cp->count <> 1 then return false

    '' AN INTEGER ARGUMENT NEVER REACHES THE RUNTIME. Measured, and each prints what
    '' fbc prints for 'dim as integer i = 3':
    ''
    ''     fix( i )   3      int( i )   3      frac( i )   0
    ''
    '' -- fbc emits no fb_FIX*/fb_FRAC* call at all for these; there is no fractional
    '' part to take. Refusing them instead declined the whole statement, so
    '' 'print fix( i )' was unlowered while 'print abs( i )' beside it was fine.
    '' The ARGUMENT is still lowered: it may have side effects that fbc performs.
    dim as boolean truncFamily = _
        ((nm = "fix") orelse (nm = "int") orelse (nm = "frac"))
    if (isFlt = false) andalso truncFamily then
        dim as MirValue iv = LowerExpr( c, a0 )
        if iv.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirType iwant = LowerType( c.info->TypeOf_( id ), *c.types )
        if iwant = MT_VOID then iwant = amt
        if nm = "frac" then
            outv = ConstInt( c, 0, iwant )
        else
            outv = Coerce( c, iv, iwant, uns )
        end if
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' FIX / FRAC / SGN -- the runtime three. SGN is the odd one out twice over: it
    '' accepts integers as well as floats, and its result is int32 whatever went in.
    dim as RtlId r = RTL_NONE
    dim as MirType want = amt
    select case nm
    case "fix"
        if isFlt = false then return false
        r = iif( amt = MT_F32, RTL_FIX_SINGLE, RTL_FIX_DOUBLE )
    case "frac"
        if isFlt = false then return false
        r = iif( amt = MT_F32, RTL_FRAC_SINGLE, RTL_FRAC_DOUBLE )
    case "sgn"
        if amt = MT_F32 then
            r = RTL_SGN_SINGLE
        elseif amt = MT_F64 then
            r = RTL_SGN_DOUBLE
        else
            r = RTL_SGN_LONGINT
            want = MT_I64
        end if
    end select
    if r <> RTL_NONE then
        dim as MirValue v0 = LowerExpr( c, a0 )
        if v0.kind = cast( ubyte, MV_NONE ) then return false
        v0 = Coerce( c, v0, want, uns )
        dim as FB.Array( of ulong ) aa
        aa.Push( cast( ulong, v0.kind ) ) : aa.Push( cast( ulong, v0.id ) )
        outv = EmitRtl( c, r, aa )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    '' The BUILTINS. Every one but abs and int takes a DOUBLE and gives one back --
    '' fbc widens a single argument rather than reaching for the 'f' variant, except
    '' for abs and floor, which have per-width builtins of their own.
    dim as MirOp op = M_NONE
    dim as MirType rty = MT_F64
    select case nm
    case "sqr"  : op = M_SQRT
    case "sin"  : op = M_SIN
    case "cos"  : op = M_COS
    case "tan"  : op = M_TAN
    case "asin" : op = M_ASIN
    case "acos" : op = M_ACOS
    case "atn"  : op = M_ATAN
    case "log"  : op = M_LOG
    case "exp"  : op = M_EXP
    case "abs"
        '' PER WIDTH, and the integer form widens to int64: '__builtin_llabs(
        '' (int64)N )'.
        ''
        '' AN UNSIGNED ARGUMENT GOES THE SAME WAY. This used to refuse one, on the
        '' reasoning that an unsigned value has nothing to take the absolute of --
        '' but fbc does it anyway, and measurably:
        ''
        ''   dim as ulong    a = abs( ul )    A$0 = (uint32)__builtin_llabs( (int64)UL$0 )
        ''   dim as ulongint b = abs( ull )   B$0 = __builtin_llabs( ULL$0 )
        ''
        '' -- widened, llabs, narrowed back. Refusing left it to a path that has no
        '' answer for ABS at all, so every one of them declined:
        '' optimizations/consteval.bas runs the whole unary family over every width.
        if amt = MT_F32 then
            op = M_FABS : rty = MT_F32
        elseif amt = MT_F64 then
            op = M_FABS : rty = MT_F64
        else
            op = M_IABS : rty = MT_I64
        end if
    case "int"
        '' A FLOOR, and then whatever the surrounding expression wants. 'int' over an
        '' INTEGER is the identity and fbc emits nothing for it.
        if isFlt = false then return false
        op = M_FLOOR : rty = amt
    case else
        return false
    end select

    dim as MirValue v0 = LowerExpr( c, a0 )
    if v0.kind = cast( ubyte, MV_NONE ) then return false
    v0 = Coerce( c, v0, rty, uns )
    dim as MirInst ins
    ins.op = cast( ushort, op )
    ins.ty = cast( ubyte, rty )
    ins.a = v0
    outv = Emit( c, ins )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function
