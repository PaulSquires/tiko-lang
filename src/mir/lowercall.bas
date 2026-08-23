'' lowercall.bas -- lowering a CALL.
''
'' Split out of lower.bas, which is at its size limit. Everything about getting from a
'' call node to a 'call' instruction lives here: the receiver, the hidden result
'' pointer, argument passing, and the choice between a direct and an indirect call.

#include once "lowerctx.bi"

namespace Fbx.Mir

using Fbx


declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long


'' AN ARRAY PASSED TO A BYDESC PARAMETER -- 'Q( v( ) )' against 'sub Q( a( ) as long )'.
'' What crosses is a DESCRIPTOR POINTER, and which one depends on the argument:
''
''   a DYNAMIC array   its own descriptor's address
''   a FIXED array     a descriptor MATERIALISED on the stack over it, which is what
''                     fbc emits -- nine stores and then '&tmp'
''
'' The argument is spelled 'v( )', an empty call over the array's name, so the name is
'' one level in. Without this the argument lowered to NOTHING and was pushed anyway:
'' 'Q( v( ) )' went out as a call with a hole where its only operand belongs.
private function ArrayDescArg_ _
    ( byref c as Ctx, byval argNode as Fbx.NodeId, byval isArrayParam as boolean, _
      byref outv as MirValue ) as boolean

    if (argNode = Fbx.NODE_NONE) orelse (isArrayParam = false) then return false

    dim as Fbx.NodeId nameNode = argNode
    if c.ast->Kind( argNode ) = Fbx.N_CALL then
        dim as Fbx.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, argNode )].data )]
        if lp->count <> 0 then return false
        if lp->target = Fbx.NODE_NONE then return false
        nameNode = lp->target
    end if

    dim as Fbx.TypeId at = c.info->TypeOf_( nameNode )
    if at = Fbx.TYPE_NONE then return false
    if c.types->Kind( at ) <> Fbx.TK_ARRAY then return false

    dim as MirValue base_ = LowerAddr( c, nameNode )
    if base_.kind = cast( ubyte, MV_NONE ) then return false
    if c.types->IsDynArray( at ) then
        outv = base_
        return true
    end if
    return SynthFixedArrayDesc( c, base_, at, outv )
end function


'' A temporary holding an argument that must be passed BYREF and has no address of its
'' own. Returns the temporary's ADDRESS, or nothing when the value would not lower or
'' the parameter's type is one a scalar slot cannot hold.
''
'' AN AGGREGATE GOES THE SAME WAY, and it has to: 'sub tester( byref x as UDT =
'' type<UDT>( 123 ) )' called as 'tester( )' is 329 statements in one corpus file
'' alone. A UDT rvalue lowers to a LOADED aggregate -- a value, not an address -- so
'' passing it where a pointer belongs was the same bug in a wider slot. The store is
'' the plain M_STORE of an aggregate that a UDT return already uses.
private function ByrefTemp_ _
    ( byref c as Ctx, byval argNode as Fbx.NodeId, byval pt as Fbx.TypeId ) as MirValue

    dim as MirValue none_
    if (argNode = Fbx.NODE_NONE) orelse (pt = Fbx.TYPE_NONE) then return none_

    '' UNQUALIFIED, because 'byref r as const any' is the same parameter as 'byref r
    '' as any' for this purpose and a const ANY would otherwise miss the test below.
    dim as MirType pmt = LowerType( c.types->Unqualify( pt ), *c.types )

    dim as MirValue rv = LowerExpr( c, argNode )
    if rv.kind = cast( ubyte, MV_NONE ) then
        '' A value that would not lower may still have an address -- and if it has
        '' one, LowerAddr would have found it before this was ever called.
        return none_
    end if

    dim as long sz = 0
    if pmt = MT_VOID then
        '' 'byref r as any' HAS NO TYPE TO MAKE A TEMPORARY OF, so the ARGUMENT's own
        '' type is what fbc uses -- and a CONSTANT is not given a temporary at all, it
        '' goes by VALUE cast to a pointer. Measured, and the comment in the corpus
        '' file that exercises it says the same thing:
        ''
        ''     u( 0 )       U( (void*)0ll )        no temp
        ''     u( i )       U( (void*)&I )         the variable's own address
        ''     u( i + 1 )   U( (void*)&TMP )       a temp of the ARGUMENT's type
        '' CONSTNESS IS THE SOURCE EXPRESSION'S QUESTION, not the lowered value's:
        '' a literal 0 comes out of LowerExpr as an instruction result, so testing the
        '' MirValue's kind answered "not constant" for the one case fbc singles out.
        dim as Fbx.Check.ConstVal acv = Fbx.Check.ConstOf( _
            *c.ast, argNode, *c.srcMgr, *c.names, c.types->target.pointerBits )
        if acv.known then return Coerce( c, rv, MT_PTR, false )
        pmt = cast( MirType, rv.ty )
        if (pmt = MT_VOID) orelse (pmt = MT_AGG) then return none_
        select case pmt
        case MT_I8            : sz = 1
        case MT_I16           : sz = 2
        case MT_I32, MT_F32   : sz = 4
        case else             : sz = 8
        end select
    else
        if pmt <> MT_AGG then rv = Coerce( c, rv, pmt, IsUnsignedType( c, pt ) )
        sz = c.types->Layout( pt ).size
        if pmt = MT_AGG then sz = SizeOfType( c, pt )
    end if

    dim as long slot = NewTempLocal( c, pmt, sz )
    if slot < 0 then return none_
    dim as MirValue tmp
    tmp.kind = cast( ubyte, MV_LOCAL )
    tmp.ty = cast( ubyte, MT_PTR )
    tmp.id = slot
    StoreThrough( c, tmp, rv )
    return tmp
end function



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

    '' DEFAULTED ARGUMENTS. A parameter's default was parsed onto its N_PARAM and then
    '' never used, so 'sleep' called fb_Sleep with NO arguments and 'locate 5, 10'
    '' called a five-parameter entry point with two. The callee read the rest off the
    '' stack.
    ''
    '' The count comes from the CALLEE, not from the call: a call with three arguments
    '' to a five-parameter procedure emits five. A variadic tail has no parameter list
    '' to run past, so the written count stands.
    dim as long nparams = ParamCountOf( c, callee )
    dim as long slots = argCount
    if (nparams > slots) andalso (IsVariadicProc( c, callee ) = false) then slots = nparams

    for i as long = 0 to slots - 1
        '' AN ELIDED ARGUMENT TAKES THE DEFAULT TOO. 'locate , 10' is the shape that
        '' says the two are one rule and not two.
        dim as Fbx.NodeId argNode = Fbx.NODE_NONE
        if i < argCount then
            argNode = cast( Fbx.NodeId, c.ast->children[argFirst + i] )
            if c.ast->Kind( argNode ) = Fbx.N_ELIDED then argNode = Fbx.NODE_NONE
        end if
        if argNode = Fbx.NODE_NONE then argNode = ParamDefaultAt( c, callee, i )
        '' 'f( byval x )' AGAINST A BYREF PARAMETER: the value itself is the reference.
        '' The marker is unwrapped here and remembered, so everything below sees the
        '' expression it wraps.
        dim as boolean forcedByval = false
        if argNode <> Fbx.NODE_NONE then
            if c.ast->Kind( argNode ) = Fbx.N_UNARY then
                dim as Fbx.UnaryPayload ptr bup = _
                    @c.ast->unaries[cast( long, c.ast->nodes[cast( long, argNode )].data )]
                if cast( Fbx.TokenKind, bup->op ) = Fbx.KW_BYVAL then
                    forcedByval = true
                    argNode = bup->operand
                end if
            end if
        end if
        if argNode = Fbx.NODE_NONE then
            '' Nothing written and no default: the call is short and the callee would
            '' read the stack. Declining says so.
            if i >= argCount then return v
        end if
        dim as boolean wantsRef = ParamIsByref( c, callee, i ) andalso (forcedByval = false)

        '' A BYDESC ARRAY PARAMETER takes a descriptor pointer, whichever way the
        '' parameter was spelled: the array-ness is the type's, not the passing mode's.
        dim as MirValue adv
        if ArrayDescArg_( c, argNode, ParamIsArray( c, callee, i ), adv ) then
            argv.Push( cast( ulong, adv.kind ) )
            argv.Push( cast( ulong, adv.id ) )
            continue for
        end if

        dim as MirValue a
        '' A BYREF STRING PARAMETER TAKES A DESCRIPTOR, and a literal has none.
        '' Measured: fbc builds one -- 'fb_StrAllocTempDescZEx( "x.txt", 5 )' -- and
        '' passes THAT. Taking the address of the literal handed the callee the BYTES
        '' where it expected an FBSTRING, so it read the first eight of them as a
        '' pointer. It linked, it verified, and it was a wild read on every call.
        ''
        '' StrDescriptorOf_ already knows all four shapes: a descriptor variable, a
        '' literal, a fixed-length string and a concatenation.
        dim as boolean wantsDesc = false
        dim as boolean wantsWide = false
        dim as boolean wantsZ = false
        if wantsRef then
            dim as Fbx.TypeId prt = ParamTypeAt( c, callee, i )
            wantsDesc = IsStringType( c, prt )
            '' A BYREF WSTRING IS A uint16*, A BYREF ZSTRING A char*, and neither is a
            '' descriptor or the address of one. Asked for either as an ordinary byref
            '' argument, 'p( wstr( "a" ) )' and 'p( "lit" )' had no address at all.
            '' IsWideString_ rather than StrSwapKind_ for the wide half: an UNSIZED
            '' 'wstring' -- which is what a byref parameter declares -- is a plain
            '' builtin, and StrSwapKind_ recognises only the SIZED form, so every
            '' 'byref w as wstring' fell through to the ordinary byref path.
            if wantsDesc = false then
                dim as longint pn
                if IsWideString_( c, prt ) then
                    wantsWide = true
                elseif StrSwapKind_( c, prt, pn ) = 1 then
                    wantsZ = true
                end if
            end if
        end if
        if wantsDesc then
            if StrDescriptorOf_( c, argNode, a ) = false then a = LowerAddr( c, argNode )
        elseif wantsWide then
            if WideOperand_( c, argNode, a ) = false then a = LowerAddr( c, argNode )
            if a.kind = cast( ubyte, MV_NONE ) then return v
        elseif wantsZ then
            if ZstrDataOf_( c, argNode, a ) = false then a = LowerAddr( c, argNode )
            if a.kind = cast( ubyte, MV_NONE ) then return v
        elseif wantsRef then
            a = LowerAddr( c, argNode )
            '' AN ARGUMENT WITH NO ADDRESS -- a literal, a computed value, or the
            '' DEFAULT of an omitted one -- still has to be passed by reference, and a
            '' value is not a pointer. fbc materialises a temporary, stores the value
            '' into it and passes ITS address. Measured, for a written rvalue and for
            '' a defaulted parameter alike:
            ''
            ''   screencontrol 100, 5   TMP = 5;  fb_GfxControl_i64( 100, &TMP, ... )
            ''   screeninfo a           TMP = 0;  fb_GfxScreenInfo32( &A, &TMP, ... )
            ''
            '' That one rule is the whole of SCREENINFO, IMAGEINFO, GETMOUSE and
            '' GETJOYSTICK: their omitted outputs are byref parameters with defaults,
            '' and each family's sentinel is nothing but the default it declares.
            ''
            '' Passing the VALUE -- which is what this did -- handed the callee a
            '' number where it expected a pointer, and it then wrote through it.
            if a.kind = cast( ubyte, MV_NONE ) then
                a = ByrefTemp_( c, argNode, ParamTypeAt( c, callee, i ) )
            end if
            '' Still nothing: decline, rather than pass something that is not the
            '' variable the callee will write through.
            if a.kind = cast( ubyte, MV_NONE ) then return v
        else
            '' A STRING PASSED TO A 'zstring ptr' PARAMETER IS ITS DATA POINTER.
            '' Measured: fbc writes 'F( (char*)*(char**)&S )', and for an rvalue it
            '' copies into a temporary descriptor first. Without it the argument
            '' lowered to NOTHING and went out as a malformed operand -- a call with a
            '' hole in it that the verifier does not look at.
            dim as Fbx.TypeId ppt = ParamTypeAt( c, callee, i )
            dim as boolean wantsZPtr = false
            if ppt <> Fbx.TYPE_NONE then
                if c.types->Kind( c.types->Unqualify( ppt ) ) = Fbx.TK_POINTER then
                    dim as Fbx.TypeId pin = _
                        c.types->Unqualify( c.types->Inner( c.types->Unqualify( ppt ) ) )
                    if c.types->Kind( pin ) = Fbx.TK_BUILTIN then
                        if c.types->BuiltinOf( pin ) = Fbx.TY_ZSTRING then
                            wantsZPtr = IsStringType( c, c.info->TypeOf_( argNode ) )
                        end if
                    end if
                end if
            end if
            if wantsZPtr then
                if ZstrDataOf_( c, argNode, a ) = false then return v
                argv.Push( cast( ulong, a.kind ) )
                argv.Push( cast( ulong, a.id ) )
                continue for
            end if

            a = LowerExpr( c, argNode )
            '' AN ARGUMENT THAT WOULD NOT LOWER IS A DECLINE, not a hole. It used to be
            '' pushed anyway, so the call went out with a malformed operand in it.
            ''
            '' The ARGUMENT is what gets the blame: inside a macro the statement's own
            '' location is the macro BODY, while the argument's tokens come from the
            '' invocation and point at the work.
            if a.kind = cast( ubyte, MV_NONE ) then
                c.blameNode = cast( ulong, argNode )
                return v
            end if
            '' TO THE PARAMETER'S TYPE, not the argument's. 'randomize 42' passes an
            '' INTEGER literal to a 'byval as double', and handing the callee the
            '' narrow value puts half a quantity in a wide slot -- the same rule the
            '' type-constructor path already applies to its own arguments.
            ''
            '' An AGGREGATE is passed whole and has nothing to convert.
            dim as Fbx.TypeId pt = ParamTypeAt( c, callee, i )
            if forcedByval andalso ParamIsByref( c, callee, i ) then
                '' The parameter is a REFERENCE and the value is standing in for one,
                '' so the width is the pointer's, not the parameter's declared type.
                if a.kind <> cast( ubyte, MV_NONE ) then a = Coerce( c, a, MT_PTR, false )
            elseif (pt <> Fbx.TYPE_NONE) andalso (a.kind <> cast( ubyte, MV_NONE )) then
                dim as MirType pmt = LowerType( pt, *c.types )
                if (pmt <> MT_VOID) andalso (pmt <> MT_AGG) then
                    a = Coerce( c, a, pmt, IsUnsignedType( c, pt ) )
                end if
            end if
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

    '' A VIRTUAL CALL GOES THROUGH THE RECEIVER'S OWN VPTR, not to the name the
    '' overload resolver bound. 'p->f( )' through an 'A ptr' binds to A's f, and if p
    '' holds a B the call must reach B's -- so the name is right and the CALL is not.
    '' Without this it emitted 'call _ZN1A1FEv', which links, verifies, and returns the
    '' wrong answer.
    ''
    '' fbc does not devirtualise at the C level even on a known-concrete local, and
    '' neither is done here.
    dim as long vslot = VirtualSlotOf_( c, calleeNode, callee )
    if (viaPointer = false) andalso (vslot >= 0) then
        if self_.kind <> cast( ubyte, MV_NONE ) then
            dim as MirValue vfp = VirtualCalleeOf_( c, self_, vslot )
            if vfp.kind <> cast( ubyte, MV_NONE ) then
                dim as MirInst vc
                vc.op = cast( ushort, M_CALL_IND )
                vc.ty = cast( ubyte, callTy )
                vc.a = vfp
                vc.first = first
                vc.count = n
                dim as MirValue vr = Emit( c, vc )
                if sretTmp.kind <> cast( ubyte, MV_NONE ) then
                    return LowerExprLoad( c, sretTmp, MT_AGG )
                end if
                return vr
            end if
        end if
    end if


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

'' A bare procedure NAME used as a value: 'd = timer', 's = curdir'.
''
'' Only a FUNCTION, and only one whose every parameter has a default -- otherwise the
'' call would be short and the callee would read the stack. A SUB has no value, and a
'' name written where an address is meant reaches LowerAddr instead.
function LowerBareProcCall_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval mt as MirType, _
      byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_IDENT then return false
    dim as Fbx.SymbolId sid = c.info->RefOf( id )
    if sid = Fbx.SYMBOL_NONE then return false
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    if s->kind <> cast( ubyte, Fbx.SYM_PROC ) then return false
    if s->type_ = Fbx.TYPE_NONE then return false          '' a SUB has no value

    '' EVERY PARAMETER MUST HAVE A DEFAULT. ParamDefaultAt answers for each, and a
    '' variadic tail is not something a bare name can fill.
    if IsVariadicProc( c, sid ) then return false
    dim as long np = ParamCountOf( c, sid )
    for i as long = 0 to np - 1
        if ParamDefaultAt( c, sid, i ) = Fbx.NODE_NONE then return false
    next

    outv = LowerCallParts( c, id, sid, 0, 0, mt )
    return (outv.kind <> cast( ubyte, MV_NONE ))
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
