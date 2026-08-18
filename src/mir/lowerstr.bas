'' lowerstr.bas -- string lowering and the runtime call helper.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. The division
'' is by subject rather than by size: everything here is about the string runtime.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' Local to this file: the two halves of concatenation lowering call each other.
declare function EmitStrTerm _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), _
      byval term as Fbx.NodeId ) as boolean
declare sub PushStrArg _
    ( byref args as FB.Array( of ulong ), byref addr as MirValue )
declare sub PushStrLiteralArg _
    ( byref args as FB.Array( of ulong ), byval gidx as long, byval nbytes as long )
declare function PrintOne _
    ( byref c as Ctx, byval it as Fbx.NodeId, byval mask as long ) as boolean
declare function PrintRtlFor( byref c as Ctx, byval t as Fbx.TypeId ) as RtlId
declare sub PushConst( byref args as FB.Array( of ulong ), byval v as long )
declare function StringLitText_ _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as string
declare function LowerConcatViaTemp _
    ( byref c as Ctx, byref dst as MirValue, _
      byref terms as FB.Array( of ulong ) ) as boolean
declare sub FlattenConcat _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outp as FB.Array( of ulong ) )


'' 'a = b + a'. The chain is built in an anonymous FBSTRING slot and then assigned.
''
'' The temporary is NEVER deleted here, and that is measured rather than assumed: fbc
'' emits a plain 'FBSTRING TMP;' local and no fb_StrDelete for it. The runtime frees
'' the temp descriptor when it is handed to fb_StrAssign, so deleting it as well would
'' be a double free.
private function LowerConcatViaTemp _
    ( byref c as Ctx, byref dst as MirValue, _
      byref terms as FB.Array( of ulong ) ) as boolean

    if terms.Count < 2 then return false
    dim as long slot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot

    '' fb_StrConcat takes the destination descriptor first, then the two operands.
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, tmp.kind ) )
    args.Push( cast( ulong, tmp.id ) )
    if EmitStrTerm( c, args, cast( Fbx.NodeId, terms[0] ) ) = false then return false
    if EmitStrTerm( c, args, cast( Fbx.NodeId, terms[1] ) ) = false then return false
    dim as MirValue acc = EmitRtl( c, RTL_STR_CONCAT, args )

    '' Any further terms concatenate onto the temporary in place.
    for i as long = 2 to terms.Count - 1
        dim as FB.Array( of ulong ) more
        PushStrArg( more, tmp )
        if EmitStrTerm( c, more, cast( Fbx.NodeId, terms[i] ) ) = false then return false
        more.Push( cast( ulong, MV_CONST_INT ) )
        more.Push( 0 )
        EmitRtl( c, RTL_STR_CONCAT_ASSIGN, more )
    next

    dim as FB.Array( of ulong ) fin
    PushStrArg( fin, dst )
    PushStrArg( fin, tmp )
    fin.Push( cast( ulong, MV_CONST_INT ) )
    fin.Push( 0 )
    EmitRtl( c, RTL_STR_ASSIGN, fin )
    return true
end function

'' The text of a string literal. The parser records the span rather than the decoded
'' bytes, so it is read back out of the source buffer here.
function StringLitText_ _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as string

    if c.ast->Kind( id ) <> Fbx.N_STRING_LIT then return ""
    dim as Fbx.LiteralPayload ptr lp = _
        @c.ast->literals[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->strLength <= 0 then return ""
    '' The literal's OWN file, not the node's loc: a literal built by macro expansion is
    '' repointed at the use site for diagnostics, and its text does not live there.
    dim as Fbx.SourceFile ptr f = c.srcMgr->FileAt( cast( Fbx.FileId, lp->strFile ) )
    if f = 0 then return ""
    if (lp->strOffset + lp->strLength) > f->text.Count then return ""
    dim as string r = space( lp->strLength )
    for i as long = 0 to lp->strLength - 1
        r[i] = f->text[lp->strOffset + i]
    next
    return r
end function

'' ------------------------------------------------------------------ runtime

'' A call to a runtime function, by table id. Nothing here spells a runtime name: the
'' inventory is the only place that does (docs/plan/11 section 3).
function EmitRtl _
    ( byref c as Ctx, byval r as RtlId, byref args as FB.Array( of ulong ) ) as MirValue

    dim as MirValue v
    dim as Fbx.InternId nm = c.names->GetString( RtlSymbol( r ) )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( nm, RtlReturn( r ) )
        decl->isDefinition = false
        decl->paramCount = RtlArity( r )
        fidx = c.m->functions.Count - 1
    end if

    dim as long first = c.m->argPool.Count \ 2
    for i as long = 0 to args.Count - 1
        c.m->argPool.Push( args[i] )
    next

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL_RTL )
    ins.ty = cast( ubyte, RtlReturn( r ) )
    ins.first = first
    ins.count = args.Count \ 2
    ins.callee = fidx
    return Emit( c, ins )
end function

'' The (pointer, length) pair the string runtime takes. A var-length string is its
'' DESCRIPTOR's address with a length of -1; the runtime reads the length from the
'' descriptor itself.
'' A LITERAL is passed as its own bytes with a real length -- strlen PLUS ONE, for
'' the terminator: fbc emits 2 for "x" and 6 for "hello". Getting that off by one
'' truncates or overruns, and neither shows up near the cause.
sub PushStrLiteralArg _
    ( byref args as FB.Array( of ulong ), byval gidx as long, byval nbytes as long )
    args.Push( cast( ulong, MV_GLOBAL ) )
    args.Push( cast( ulong, gidx ) )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, nbytes + 1 ) )
end sub

sub PushStrArg _
    ( byref args as FB.Array( of ulong ), byref addr as MirValue )
    args.Push( cast( ulong, addr.kind ) )
    args.Push( cast( ulong, addr.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, cast( ulongint, -1 ) ) )
end sub


function IsStringType _
    ( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_BUILTIN then return false
    dim as Fbx.BuiltinType b = c.types->BuiltinOf( t )
    return (b = Fbx.TY_STRING) orelse (b = Fbx.TY_USTRING)
end function

'' 'a = b' and 'a = a + b' between var-length strings. Returns false when this is not
'' a string assignment, so the caller falls back to an ordinary store.

'' Zeroes a 24-byte string descriptor.
''
'' fbc emits '__builtin_memset( &A, 0, 24 )' for a string local with no initialiser.
'' MIR has no memset, so this is three i64 stores -- which mem2reg folds away for a
'' local that is written before it is read anyway.
''
'' This is NOT cosmetic. A string local always registers an fb_StrDelete for its scope
'' exit, so a descriptor that was never written would hand the runtime a wild pointer
'' to free.
sub ZeroStrDescriptor( byref c as Ctx, byref dst as MirValue )
    for off as long = 0 to 16 step 8
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = dst
        fa.imm = off
        dim as MirValue p = Emit( c, fa )
        dim as MirValue z
        z.kind = cast( ubyte, MV_CONST_INT )
        z.ty = cast( ubyte, MT_I64 )
        z.id = 0
        dim as MirInst st_
        st_.op = cast( ushort, M_STORE )
        st_.ty = cast( ubyte, MT_VOID )
        st_.a = p
        st_.b = z
        Emit( c, st_ )
    next
end sub

'' A string local at its DECLARATION, which is not the same as an assignment to it.
''
'' Measured from fbc:
''   dim as string a           ->  memset( &A, 0, 24 )
''   dim as string b = "hi"    ->  fb_StrInit( &B, -1, "hi", 3, 0 )
''   a = "x"                   ->  fb_StrAssign( &A, -1, "x", 2, 0 )
''
'' Init and Assign differ because Assign releases whatever the destination already
'' held; at a declaration there is nothing to release and the descriptor is garbage,
'' so calling Assign on it would free that garbage.
function LowerStringInit _
    ( byref c as Ctx, byval slot as long, byval target as Fbx.NodeId, _
      byval value as Fbx.NodeId ) as boolean

    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot

    if value = Fbx.NODE_NONE then
        ZeroStrDescriptor( c, dst )
        return true
    end if

    '' A concatenation cannot go through fb_StrInit, which takes one source. Zero the
    '' descriptor so it is a valid empty string, then build into it the ordinary way.
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, value, terms )
    if terms.Count <> 1 then
        ZeroStrDescriptor( c, dst )
        if target = Fbx.NODE_NONE then return true
        return LowerStringAssign( c, target, value )
    end if

    dim as FB.Array( of ulong ) args
    PushStrArg( args, dst )
    if EmitStrTerm( c, args, cast( Fbx.NodeId, terms[0] ) ) = false then
        '' The source did not lower, so the descriptor must still be made valid --
        '' its fb_StrDelete is registered either way.
        ZeroStrDescriptor( c, dst )
        return false
    end if
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( 0 )
    EmitRtl( c, RTL_STR_INIT, args )
    return true
end function


'' PRINT.
''
'' MEASURED from fbc (docs/internals/phase-6-print.md). There is NO generic print entry
'' point: every scalar type has its own, and the third argument is a SEPARATOR MASK
'' saying what follows THAT item --
''
''     0   nothing        ';' between items, or a trailing ';'
''     1   newline        end of the statement
''     2   tab            ',' between items
''
''     print            -> fb_PrintVoid( 0, 1 )
''     print s          -> fb_PrintString( 0, &S, 1 )
''     print s; n       -> fb_PrintString( 0, &S, 0 )  fb_PrintInt( 0, N, 1 )
''     print s, n       -> fb_PrintString( 0, &S, 2 )  fb_PrintInt( 0, N, 1 )
''     print s;         -> fb_PrintString( 0, &S, 0 )
''
'' so the mask belongs to the item BEFORE the separator, and a trailing ';' suppresses
'' the newline entirely rather than printing one.
function LowerPrint( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )

    '' 'print #1, ...' and 'print using' are not lowered; both change the call shape.
    if sp->a <> Fbx.NODE_NONE then return false
    if sp->extra <> 0 then return false

    '' No items at all is the bare 'print', a newline on its own.
    if sp->count = 0 then
        dim as FB.Array( of ulong ) va
        PushConst( va, 0 )
        PushConst( va, 1 )
        EmitRtl( c, RTL_PRINT_VOID, va )
        return true
    end if

    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId it = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( it ) = Fbx.N_PRINT_SEP then continue for

        '' What follows decides the mask: a ';' suppresses, a ',' tabs, and anything
        '' else -- including running out of children -- ends the line.
        dim as long mask = 1
        if i + 1 < sp->count then
            dim as Fbx.NodeId nx = cast( Fbx.NodeId, c.ast->children[sp->first + i + 1] )
            if c.ast->Kind( nx ) = Fbx.N_PRINT_SEP then
                dim as Fbx.StmtPayload ptr np = StmtOf( c, nx )
                if np->op = cast( ushort, Fbx.TK_COMMA ) then
                    mask = 2
                else
                    mask = 0
                end if
                '' A separator with nothing after it is a TRAILING one, and trailing
                '' means no newline -- which is the 0 already chosen for ';'. A
                '' trailing ',' still tabs, so the mask stands either way.
            end if
        end if

        if PrintOne( c, it, mask ) = false then return false
    next
    return true
end function

'' One PRINT item.
private function PrintOne _
    ( byref c as Ctx, byval it as Fbx.NodeId, byval mask as long ) as boolean

    dim as Fbx.TypeId t = c.info->TypeOf_( it )
    dim as FB.Array( of ulong ) args
    PushConst( args, 0 )                  '' file number; only #0 is lowered

    if IsStringType( c, t ) then
        '' fb_PrintString takes an FBSTRING DESCRIPTOR, not a (pointer, length) pair
        '' like fb_StrAssign does. A literal has no descriptor, so fbc borrows a
        '' temporary one from the runtime and prints that:
        ''
        ''     FBSTRING* vr$4 = fb_StrAllocTempDescZEx( "lit", 3 );
        ''     fb_PrintString( 0, vr$4, 1 );
        ''
        '' Passing the literal's BYTES here instead would have the runtime read a
        '' descriptor out of string data.
        dim as MirValue desc
        if c.ast->Kind( it ) = Fbx.N_STRING_LIT then
            dim as string litText = StringLitText_( c, it )
            '' The length here is the literal's EXACT length, not the len+1 that
            '' fb_StrAssign and fb_StrConcat take. Measured: fbc passes 2 for "x" to
            '' fb_StrAssign but 3 for "lit" to fb_StrAllocTempDescZEx. The Z in the
            '' name is the difference -- it already knows the bytes are terminated,
            '' so it is not being told to include the terminator in the count.
            dim as FB.Array( of ulong ) ta
            ta.Push( cast( ulong, MV_GLOBAL ) )
            ta.Push( cast( ulong, c.m->AddStringLiteral( litText, *c.names ) ) )
            ta.Push( cast( ulong, MV_CONST_INT ) )
            ta.Push( cast( ulong, len( litText ) ) )
            desc = EmitRtl( c, RTL_STR_TEMPZ, ta )
        else
            desc = LowerAddr( c, it )
        end if
        if desc.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, desc.kind ) ) : args.Push( cast( ulong, desc.id ) )
        PushConst( args, mask )
        EmitRtl( c, RTL_PRINT_STRING, args )
        return true
    end if

    dim as RtlId which = PrintRtlFor( c, t )
    if which = RTL_NONE then return false
    dim as MirValue v = LowerExpr( c, it )
    if v.kind = cast( ubyte, MV_NONE ) then return false
    v = Coerce( c, v, LowerType( t, *c.types ) )
    args.Push( cast( ulong, v.kind ) ) : args.Push( cast( ulong, v.id ) )
    PushConst( args, mask )
    EmitRtl( c, which, args )
    return true
end function

'' The print entry point for a type. There is no generic one, and a POINTER has none of
'' its own -- fbc sends it through fb_PrintULongint.
private function PrintRtlFor( byref c as Ctx, byval t as Fbx.TypeId ) as RtlId
    if t = Fbx.TYPE_NONE then return RTL_NONE
    select case c.types->Kind( t )
    case Fbx.TK_POINTER, Fbx.TK_PROC : return RTL_PRINT_ULONGINT
    case Fbx.TK_ENUM                 : return RTL_PRINT_INT
    case Fbx.TK_BUILTIN
        select case c.types->BuiltinOf( t )
        case Fbx.TY_BYTE      : return RTL_PRINT_BYTE
        case Fbx.TY_UBYTE     : return RTL_PRINT_UBYTE
        case Fbx.TY_SHORT     : return RTL_PRINT_SHORT
        case Fbx.TY_USHORT    : return RTL_PRINT_USHORT
        case Fbx.TY_LONG      : return RTL_PRINT_INT
        case Fbx.TY_ULONG     : return RTL_PRINT_UINT
        case Fbx.TY_LONGINT   : return RTL_PRINT_LONGINT
        case Fbx.TY_ULONGINT  : return RTL_PRINT_ULONGINT
        case Fbx.TY_SINGLE    : return RTL_PRINT_SINGLE
        case Fbx.TY_DOUBLE    : return RTL_PRINT_DOUBLE
        case Fbx.TY_BOOLEAN   : return RTL_PRINT_BOOL
        case Fbx.TY_INTEGER
            if c.types->target.pointerBits = 32 then return RTL_PRINT_INT
            return RTL_PRINT_LONGINT
        case Fbx.TY_UINTEGER
            if c.types->target.pointerBits = 32 then return RTL_PRINT_UINT
            return RTL_PRINT_ULONGINT
        end select
    end select
    return RTL_NONE
end function

'' An i32 constant argument, which every print call needs twice.
private sub PushConst( byref args as FB.Array( of ulong ), byval v as long )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, v ) )
end sub


'' A string relational operator.
''
'' MEASURED from fbc: one fb_StrCompare, then the operator applied against ZERO.
''
''     int32 vr$5 = fb_StrCompare( &A$1, -1ll, &B$1, -1ll );
''     if( (int64)vr$5 != 0ll ) goto ...          ' for 'a = b'
''
'' so '=' becomes 'cmp == 0', '<' becomes 'cmp < 0', and so on -- the same operator,
'' with the second operand replaced by 0. The (pointer, length) pairs follow the
'' fb_StrAssign convention, where a literal's length INCLUDES the terminator: fbc passes
'' 4 for "lit" here, not the 3 fb_StrAllocTempDescZEx takes.
function LowerStrCompare _
    ( byref c as Ctx, byval bp as Fbx.BinaryPayload ptr, _
      byval tk as Fbx.TokenKind ) as MirValue

    dim as MirValue none_
    select case tk
    case Fbx.TK_EQ, Fbx.TK_NE, Fbx.TK_LT, Fbx.TK_GT, Fbx.TK_LE, Fbx.TK_GE
    case else
        '' Concatenation and the rest are not comparisons and do not belong here.
        return none_
    end select

    dim as FB.Array( of ulong ) args
    if EmitStrTerm( c, args, bp->lhs ) = false then return none_
    if EmitStrTerm( c, args, bp->rhs ) = false then return none_
    dim as MirValue cmp = EmitRtl( c, RTL_STR_COMPARE, args )
    if cmp.kind = cast( ubyte, MV_NONE ) then return none_

    dim as MirValue zero_
    zero_.kind = cast( ubyte, MV_CONST_INT )
    zero_.ty = cast( ubyte, MT_I32 )
    zero_.id = 0
    dim as MirInst ins
    ins.op = cast( ushort, BinOpFor( tk, MT_I32, false ) )
    ins.ty = cast( ubyte, MT_I8 )
    ins.a = cmp
    ins.b = zero_
    if ins.op = cast( ushort, M_NONE ) then return none_
    return Emit( c, ins )
end function

function LowerStringAssign _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean

    if IsStringType( c, c.info->TypeOf_( target ) ) = false then return false
    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false

    '' A '+' chain is flattened and emitted as ONE assign followed by concat-assigns,
    '' which is exactly what fbc does: 'a = b + c' is fb_StrAssign(a,b) then
    '' fb_StrConcatAssign(a,c), with no temporary at all.
    dim as FB.Array( of ulong ) terms
    FlattenConcat( c, value, terms )

    '' If the destination is read AFTER it would be written, the chain cannot be built
    '' in place: 'a = b + a' would overwrite a before reading it. fbc builds such a
    '' chain in a temporary and assigns from that.
    dim as boolean needsTemp = false
    for i as long = 1 to terms.Count - 1
        if SameLValue( c, target, cast( Fbx.NodeId, terms[i] ) ) then needsTemp = true
    next
    if needsTemp then return LowerConcatViaTemp( c, dst, terms )

    '' The first term is assigned, every later one concatenated onto it. When the
    '' destination IS the first term, the assign is a self-assignment and is skipped.
    for i as long = 0 to terms.Count - 1
        dim as Fbx.NodeId term = cast( Fbx.NodeId, terms[i] )
        if (i = 0) andalso SameLValue( c, target, term ) then continue for
        dim as FB.Array( of ulong ) args
        PushStrArg( args, dst )
        if EmitStrTerm( c, args, term ) = false then return false
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( 0 )
        if i = 0 then
            EmitRtl( c, RTL_STR_ASSIGN, args )
        else
            EmitRtl( c, RTL_STR_CONCAT_ASSIGN, args )
        end if
    next
    return true
end function

'' The (pointer, length) pair for one term of a concatenation.
function EmitStrTerm _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), _
      byval term as Fbx.NodeId ) as boolean

    if c.ast->Kind( term ) = Fbx.N_STRING_LIT then
        '' Named litText, not text: 'Text' is a namespace and FreeBASIC is
        '' case-insensitive, so a local called text shadows it.
        dim as string litText = StringLitText_( c, term )
        PushStrLiteralArg( args, c.m->AddStringLiteral( litText, *c.names ), _
                           len( litText ) )
        return true
    end if
    if IsStringType( c, c.info->TypeOf_( term ) ) = false then return false
    dim as MirValue src = LowerAddr( c, term )
    if src.kind = cast( ubyte, MV_NONE ) then return false
    PushStrArg( args, src )
    return true
end function

'' Flatten a left-leaning '+' chain into its terms, in source order.
sub FlattenConcat _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outp as FB.Array( of ulong ) )

    if id = Fbx.NODE_NONE then return
    if c.ast->Kind( id ) = Fbx.N_BINARY then
        dim as Fbx.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        if cast( Fbx.TokenKind, bp->op ) = Fbx.TK_PLUS then
            FlattenConcat( c, bp->lhs, outp )
            FlattenConcat( c, bp->rhs, outp )
            return
        end if
    end if
    outp.Push( cast( ulong, id ) )
end sub

'' Whether two expressions name the same storage. Only the simple cases are needed:
'' anything else falls back to the general path rather than guessing.
function SameLValue _
    ( byref c as Ctx, byval a as Fbx.NodeId, byval b as Fbx.NodeId ) as boolean
    if (a = Fbx.NODE_NONE) orelse (b = Fbx.NODE_NONE) then return false
    if c.ast->Kind( a ) <> c.ast->Kind( b ) then return false
    if c.ast->Kind( a ) <> Fbx.N_IDENT then return false
    return c.info->RefOf( a ) = c.info->RefOf( b )
end function


end namespace
