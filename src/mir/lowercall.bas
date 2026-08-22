'' lowercall.bas -- lowering a CALL.
''
'' Split out of lower.bas, which is at its size limit. Everything about getting from a
'' call node to a 'call' instruction lives here: the receiver, the hidden result
'' pointer, argument passing, and the choice between a direct and an indirect call.

#include once "lowerctx.bi"

namespace Fbx.Mir

using Fbx


function LowerCallParts _
    ( byref c as Ctx, byval calleeNode as Fbx.NodeId, byval callee as Fbx.SymbolId, _
      byval argFirst as long, byval argCount as long, _
      byval mt as MirType ) as MirValue

    dim as MirValue v

    '' A BUILT-IN PROCEDURE binds to nothing because nothing declares it -- fbc
    '' predeclares 'allocate', 'deallocate', the mutex four and 'fb_Assert' and lowers
    '' each straight to a runtime call. Checked BEFORE the symbol, which is exactly
    '' what these do not have.
    dim as MirValue bv
    if LowerBuiltinProc( c, calleeNode, argFirst, argCount, bv ) then return bv

    dim as Fbx.Symbol ptr cs = c.syms->SymbolAt( callee )
    if callee = Fbx.SYMBOL_NONE then return v
    if cs = 0 then return v

    '' A CALL THROUGH A PROCEDURE POINTER. 'dim as sub( ) p = procptr( f ) : p( )'
    '' names a VARIABLE, not a procedure, so there is no function to look up and
    '' mangling its name would invent one. docs/plan/09 lists 'call_indirect' for
    '' exactly this; the callee is the pointer's VALUE.
    dim as boolean viaPointer = false
    if cs->kind <> cast( ubyte, Fbx.SYM_PROC ) then
        dim as Fbx.TypeId ct = cs->type_
        if ct <> Fbx.TYPE_NONE then
            if c.types->Kind( ct ) = Fbx.TK_REFERENCE then ct = c.types->Inner( ct )
            if c.types->Kind( ct ) = Fbx.TK_POINTER then ct = c.types->Inner( ct )
            viaPointer = (c.types->Kind( ct ) = Fbx.TK_PROC)
        end if
        '' Anything else that is not a procedure is not callable, and was already
        '' declining here.
        if viaPointer = false then return v
    end if

    '' Arguments are collected LOCALLY and pushed to the shared pool in one run at the
    '' end. Lowering them straight into the pool interleaved a nested call's arguments
    '' with this one's, because the callee's extent was opened before its arguments were
    '' lowered: 'F( G( 7 ), 9 )' emitted 'call void F(%4, %5)' -- F( 7, G(7) ) -- and
    '' dropped the 9 entirely. No decline, no diagnostic, wrong arguments.
    dim as FB.Array( of ulong ) argv

    '' THE RECEIVER IS THE FIRST ARGUMENT of an instance method, and it was missing.
    '' fbc declares 'void _ZN1T1MEi( struct $1T*, int32 )'; fbx emitted
    '' 'call void _ZN1T1MEi(%5)' -- the right name, the wrong arguments, and no decline,
    '' so it counted as fully lowered. A mangled name that says member and a call that
    '' does not pass one is the worst shape a bug can have here.
    '' A UDT RESULT THAT TRAVELS THROUGH A HIDDEN POINTER needs somewhere to land,
    '' and the caller provides it: a temporary, passed as ARGUMENT 0 -- before the
    '' receiver, which is where fbc puts it. Measured in fbc's assembly: RCX is the
    '' pointer and RDX is 'this'.
    ''
    '' The call's VALUE is that temporary's address, so 'v = F( )' and 'F( ).field'
    '' both read from it. fbc destroys the temp at the end of the statement; fbx does
    '' not model that yet, so a result whose type has a destructor LEAKS one object per
    '' call. Stated rather than hidden -- and the alternative was not lowering the
    '' statement at all.
    dim as MirValue sretTmp
    if cs->kind = cast( ubyte, Fbx.SYM_PROC ) then
        if UsesSretReturn( c, cs->type_ ) then
            dim as long tslot = _
                NewTempLocal( c, MT_AGG, SizeOfType( c, cs->type_ ) )
            if tslot < 0 then return v
            sretTmp.kind = cast( ubyte, MV_LOCAL )
            sretTmp.ty = cast( ubyte, MT_PTR )
            sretTmp.id = tslot
            argv.Push( cast( ulong, sretTmp.kind ) )
            argv.Push( cast( ulong, sretTmp.id ) )
        end if
    end if

    dim as MirValue self_ = ReceiverOf( c, calleeNode, callee )
    if self_.kind <> cast( ubyte, MV_NONE ) then
        argv.Push( cast( ulong, self_.kind ) )
        argv.Push( cast( ulong, self_.id ) )
    end if

    for i as long = 0 to argCount - 1
        dim as Fbx.NodeId argNode = cast( Fbx.NodeId, c.ast->children[argFirst + i] )
        dim as boolean wantsRef = ParamIsByref( c, callee, i )

        dim as MirValue a
        if wantsRef then
            a = LowerAddr( c, argNode )
            '' An argument with no address -- a literal or a computed value -- cannot
            '' be passed by reference as it stands. fbc materialises a temporary for
            '' one; fbx declines rather than passing something that is not the
            '' variable the callee will write through.
            if a.kind = cast( ubyte, MV_NONE ) then a = LowerExpr( c, argNode )
        else
            a = LowerExpr( c, argNode )
        end if
        argv.Push( cast( ulong, a.kind ) )
        argv.Push( cast( ulong, a.id ) )
    next

    dim as long first = c.m->argPool.Count \ 2
    dim as long n = argv.Count \ 2
    for i as long = 0 to argv.Count - 1
        c.m->argPool.Push( argv[i] )
    next

    '' The callee is named by its MANGLED name, which is what MIR carries.
    ''
    '' It must be mangled the SAME WAY the definition was. Symbol.name is the FOLDED
    '' spelling -- lowercased, because FreeBASIC lookup is case-insensitive -- so using
    '' it here produced 'call void a()' against a definition named 'A', which matched
    '' nothing and silently added an extern declaration instead. The result was a
    '' module that referenced a symbol it also defined, under two spellings.
    dim as Fbx.InternId cnm = cs->name
    if cs->payload <> 0 then
        cnm = c.names->GetString( Fbx.Mangle.ProcName( _
            *c.ast, cast( Fbx.NodeId, cs->payload ), *c.syms, *c.names, _
            *c.types, *c.info ) )
    end if

    '' THE INDIRECT CALL. The callee is the pointer's VALUE, loaded from wherever the
    '' variable lives; there is no function table entry and no name.
    '' The call's own MIR type follows the callee: an sret function returns the
    '' POINTER it was handed, not an aggregate.
    dim as MirType callTy = mt
    if sretTmp.kind <> cast( ubyte, MV_NONE ) then callTy = MT_PTR

    if viaPointer then
        '' THE RESULT TYPE COMES OFF THE PROCEDURE TYPE when the caller asked for none.
        '' 'dim as double a = f( x, ctx )' through a function-pointer parameter reached
        '' here with mt VOID -- a DIM initialiser names no type for its right-hand side
        '' -- so the call went out as 'call.ind void' and the initialiser declined with
        '' the call sitting right there. A DIRECT call gets its type from the callee's
        '' symbol; an indirect one has no symbol, and the pointee is where it lives.
        if callTy = MT_VOID then
            dim as Fbx.TypeId ft = c.info->TypeOf_( calleeNode )
            if ft <> Fbx.TYPE_NONE then
                if c.types->Kind( ft ) = Fbx.TK_POINTER then ft = c.types->Inner( ft )
                if ft <> Fbx.TYPE_NONE then
                    if c.types->Kind( ft ) = Fbx.TK_PROC then
                        callTy = LowerType( c.types->Inner( ft ), *c.types )
                    end if
                end if
            end if
        end if

        dim as MirValue fp = LowerExpr( c, calleeNode )
        if fp.kind = cast( ubyte, MV_NONE ) then return v
        dim as MirInst ic
        ic.op = cast( ushort, M_CALL_IND )
        ic.ty = cast( ubyte, callTy )
        ic.a = Coerce( c, fp, MT_PTR )
        ic.first = first
        ic.count = n
        return Emit( c, ic )
    end if

    '' Finding the function object is a linear scan for now; it is a map when it
    '' matters.
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = cnm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( cnm, callTy )
        decl->isDefinition = false
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, callTy )
    ins.first = first
    ins.count = n
    ins.callee = fidx
    dim as MirValue cv = Emit( c, ins )

    '' The RESULT is the VALUE in the temporary the callee filled in, not the pointer
    '' the call returned. An aggregate variable's value is a whole-aggregate load in
    '' this IR -- 'y = x' over a UDT is load-then-store -- so a call result has to be
    '' the same shape or every consumer would need a special case for it.
    ''
    '' NOT COVERED, and it declines rather than being approximated: 'F( ).field'.
    '' LowerAddr has no N_CALL case, so there is no address to take an offset from,
    '' and inventing one would mean lowering the call twice.
    if sretTmp.kind <> cast( ubyte, MV_NONE ) then
        return LowerExprLoad( c, sretTmp, MT_AGG )
    end if
    return cv
end function

function BinOpFor _
    ( byval tk as Fbx.TokenKind, byval t as MirType, _
      byval isUnsigned as boolean ) as MirOp

    dim as boolean f = IsFloatTy( t )
    select case tk
    case Fbx.TK_PLUS      : return M_ADD
    case Fbx.TK_MINUS     : return M_SUB
    case Fbx.TK_STAR      : return M_MUL
    case Fbx.TK_SLASH     : return M_FDIV
    case Fbx.TK_BACKSLASH : return iif( isUnsigned, M_UDIV, M_SDIV )
    case Fbx.KW_MOD       : return iif( isUnsigned, M_UREM, M_SREM )
    case Fbx.KW_AND       : return M_AND
    case Fbx.KW_OR        : return M_OR
    case Fbx.KW_XOR       : return M_XOR
    case Fbx.KW_SHL       : return M_SHL
    '' SHR is ARITHMETIC on a signed value -- '-1 shr 1' is -1, measured in
    '' docs/internals/phase-5-const.md -- so it is ashr unless the type is unsigned.
    case Fbx.KW_SHR       : return iif( isUnsigned, M_LSHR, M_ASHR )
    case Fbx.TK_EQ        : return iif( f, M_FCMP_EQ, M_ICMP_EQ )
    case Fbx.TK_NE        : return iif( f, M_FCMP_NE, M_ICMP_NE )
    case Fbx.TK_LT        : return iif( f, M_FCMP_LT, iif( isUnsigned, M_ICMP_ULT, M_ICMP_SLT ) )
    case Fbx.TK_GT        : return iif( f, M_FCMP_GT, iif( isUnsigned, M_ICMP_UGT, M_ICMP_SGT ) )
    case Fbx.TK_LE        : return iif( f, M_FCMP_LE, M_ICMP_SLE )
    case Fbx.TK_GE        : return iif( f, M_FCMP_GE, M_ICMP_SGE )
    end select
    return M_NONE
end function

function IsUnsignedType _
    ( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_BUILTIN then return false
    select case c.types->BuiltinOf( t )
    case Fbx.TY_UBYTE, Fbx.TY_USHORT, Fbx.TY_ULONG, Fbx.TY_UINTEGER, Fbx.TY_ULONGINT
        return true
    end select
    return false
end function

end namespace
