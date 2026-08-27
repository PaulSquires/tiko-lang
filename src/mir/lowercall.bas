'' lowercall.bas -- lowering a CALL.
''
'' Split out of lower.bas, which is at its size limit. Everything about getting from a
'' call node to a 'call' instruction lives here: the receiver, the hidden result
'' pointer, argument passing, and the choice between a direct and an indirect call.

#include once "lowerctx.bi"

namespace Tko.Mir
declare function CallFailed_( byref c as Ctx, byref v as MirValue ) as MirValue

declare function ByvalStrTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long ) as boolean
declare sub DeleteStrArgTemps_ _
    ( byref c as Ctx, byref slots as FB.Array( of ulong ), _
      byref types as FB.Array( of ulong ) )


declare function UdtConvTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long, byref outType as Tko.TypeId ) as boolean
declare function ArgNeedsUdtConv_ _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long, _
      byval argNode as Tko.NodeId ) as boolean
declare function ByvalUdtCopyArg_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long, byref outType as Tko.TypeId ) as boolean
declare sub DestroyArgTemps_ _
    ( byref c as Ctx, byref slots as FB.Array( of ulong ), _
      byref types as FB.Array( of ulong ) )


using Tko


declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long


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
function ArrayDescArg_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval isArrayParam as boolean, _
      byref outv as MirValue ) as boolean

    if (argNode = Tko.NODE_NONE) orelse (isArrayParam = false) then return false

    dim as Tko.NodeId nameNode = argNode
    if c.ast->Kind( argNode ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, argNode )].data )]
        if lp->count <> 0 then return false
        if lp->target = Tko.NODE_NONE then return false
        nameNode = lp->target
    end if

    dim as Tko.TypeId at = c.info->TypeOf_( nameNode )
    if at = Tko.TYPE_NONE then return false
    if c.types->Kind( at ) <> Tko.TK_ARRAY then return false

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
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId ) as MirValue

    dim as MirValue none_
    if (argNode = Tko.NODE_NONE) orelse (pt = Tko.TYPE_NONE) then return none_

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
        dim as Tko.Check.ConstVal acv = Tko.Check.ConstOf( _
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
    ( byref c as Ctx, byval calleeNode as Tko.NodeId, byval callee as Tko.SymbolId, _
      byval argFirst as long, byval argCount as long, _
      byval mt as MirType ) as MirValue

    dim as MirValue v

    '' A BUILT-IN PROCEDURE binds to nothing because nothing declares it -- fbc
    '' predeclares 'allocate', 'deallocate', the mutex four and 'fb_Assert' and lowers
    '' each straight to a runtime call. Checked BEFORE the symbol, which is exactly
    '' what these do not have.
    dim as MirValue bv
    if LowerBuiltinProc( c, calleeNode, argFirst, argCount, bv ) then return bv

    '' A CALLEE THAT IS AN EXPRESSION, not a name. '(iif( c, p1, p2 ))( )' and
    '' 'cptr( typeof( d.proc ), tbl[ i ] )( args )' are how the corpus calls through a
    '' procedure pointer it just computed, and there is no symbol to look up -- so the
    '' call was abandoned even though the value is exactly what the indirect path at the
    '' bottom of this function already knows how to call. Its TYPE is what says it is
    '' callable, and that is all the indirect path needs.
    dim as boolean exprCallee = false
    if callee = Tko.SYMBOL_NONE then
        dim as Tko.TypeId et = c.types->Unqualify( c.info->TypeOf_( calleeNode ) )
        if c.types->Kind( et ) = Tko.TK_REFERENCE then et = c.types->Inner( et )
        if c.types->Kind( et ) = Tko.TK_POINTER then et = c.types->Inner( et )
        exprCallee = (c.types->Kind( et ) = Tko.TK_PROC)
    end if

    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if (callee = Tko.SYMBOL_NONE) andalso (exprCallee = false) then
        return CallFailed_( c, v )
    end if
    if (cs = 0) andalso (exprCallee = false) then return CallFailed_( c, v )

    '' A CALL THROUGH A PROCEDURE POINTER. 'dim as sub( ) p = procptr( f ) : p( )'
    '' names a VARIABLE, not a procedure, so there is no function to look up and
    '' mangling its name would invent one. docs/plan/09 lists 'call_indirect' for
    '' exactly this; the callee is the pointer's VALUE.
    dim as boolean viaPointer = exprCallee
    if (exprCallee = false) andalso (cs->kind <> cast( ubyte, Tko.SYM_PROC )) then
        dim as Tko.TypeId ct = cs->type_
        if ct <> Tko.TYPE_NONE then
            if c.types->Kind( ct ) = Tko.TK_REFERENCE then ct = c.types->Inner( ct )
            if c.types->Kind( ct ) = Tko.TK_POINTER then ct = c.types->Inner( ct )
            viaPointer = (c.types->Kind( ct ) = Tko.TK_PROC)
        end if
        '' Anything else that is not a procedure is not callable, and was already
        '' declining here.
        if viaPointer = false then return CallFailed_( c, v )
    end if

    '' Arguments are collected LOCALLY and pushed to the shared pool in one run at the
    '' end. Lowering them straight into the pool interleaved a nested call's arguments
    '' with this one's, because the callee's extent was opened before its arguments were
    '' lowered: 'F( G( 7 ), 9 )' emitted 'call void F(%4, %5)' -- F( 7, G(7) ) -- and
    '' dropped the 9 entirely. No decline, no diagnostic, wrong arguments.
    dim as FB.Array( of ulong ) argv
    '' THE CALLER-BUILT COPIES of byval non-trivial UDT arguments, which are destroyed
    '' AFTER the call returns and so cannot be dealt with where they are made.
    dim as FB.Array( of ulong ) tempSlots
    dim as FB.Array( of ulong ) tempTypes
    '' ...and the STRING descriptors, which are released with the runtime rather than
    '' with a destructor.
    dim as FB.Array( of ulong ) strTemps
    dim as FB.Array( of ulong ) strTempTypes
    dim as long tempSlot = -1
    dim as Tko.TypeId tempType = Tko.TYPE_NONE

    '' THE RECEIVER IS THE FIRST ARGUMENT of an instance method, and it was missing.
    '' fbc declares 'void _ZN1T1MEi( struct $1T*, int32 )'; tiko-lang emitted
    '' 'call void _ZN1T1MEi(%5)' -- the right name, the wrong arguments, and no decline,
    '' so it counted as fully lowered. A mangled name that says member and a call that
    '' does not pass one is the worst shape a bug can have here.
    '' A UDT RESULT THAT TRAVELS THROUGH A HIDDEN POINTER needs somewhere to land,
    '' and the caller provides it: a temporary, passed as ARGUMENT 0 -- before the
    '' receiver, which is where fbc puts it. Measured in fbc's assembly: RCX is the
    '' pointer and RDX is 'this'.
    ''
    '' The call's VALUE is that temporary's address, so 'v = F( )' and 'F( ).field'
    '' both read from it, and it is destroyed at the END OF THE STATEMENT -- measured,
    '' and registered below beside the string temporaries, which have the same life.
    dim as MirValue sretTmp
    if (cs <> 0) andalso (cs->kind = cast( ubyte, Tko.SYM_PROC )) then
        if UsesSretReturn( c, cs->type_ ) then
            dim as long tslot = _
                NewTempLocal( c, MT_AGG, SizeOfType( c, cs->type_ ) )
            if tslot < 0 then return CallFailed_( c, v )
            if TypeNeedsDtor_( c, cs->type_ ) then
                c.udtTemps.Push( cast( ulong, tslot ) )
                c.udtTempTypes.Push( cast( ulong, cs->type_ ) )
            end if
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
        dim as Tko.NodeId argNode = Tko.NODE_NONE
        if i < argCount then
            argNode = cast( Tko.NodeId, c.ast->children[argFirst + i] )
            if c.ast->Kind( argNode ) = Tko.N_ELIDED then argNode = Tko.NODE_NONE
        end if
        if argNode = Tko.NODE_NONE then argNode = ParamDefaultAt( c, callee, i )
        '' 'f( byval x )' AGAINST A BYREF PARAMETER: the value itself is the reference.
        '' The marker is unwrapped here and remembered, so everything below sees the
        '' expression it wraps.
        dim as boolean forcedByval = false
        if argNode <> Tko.NODE_NONE then
            if c.ast->Kind( argNode ) = Tko.N_UNARY then
                dim as Tko.UnaryPayload ptr bup = _
                    @c.ast->unaries[cast( long, c.ast->nodes[cast( long, argNode )].data )]
                if cast( Tko.TokenKind, bup->op ) = Tko.KW_BYVAL then
                    forcedByval = true
                    argNode = bup->operand
                end if
            end if
        end if
        if argNode = Tko.NODE_NONE then
            '' Nothing written and no default: the call is short and the callee would
            '' read the stack. Declining says so.
            if i >= argCount then return CallFailed_( c, v )
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
            dim as Tko.TypeId prt = ParamTypeAt( c, callee, i )
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
            '' A WIDE ARGUMENT TO A BYREF STRING IS A CONVERSION, not an address.
            '' Measured: 'g( w )' against 'byref s as string' is
            '' 'fb_WstrAssignToA( &TMP$3$0, -1, (uint16*)W$0, 0 ); G1( &TMP$3$0, 0 )'.
            '' tiko handed the callee the WIDE BUFFER'S address where an FBSTRING
            '' belongs, and for a wide RVALUE it pushed NOTHING AT ALL -- a call with
            '' a hole in it, counted as fully lowered.
            if IsWideString_( c, c.info->TypeOf_( argNode ) ) then
                dim as Tko.TypeId wsp = c.types->Builtin( Tko.TY_STRING )
                if ByvalStrTemp_( c, argNode, wsp, a, tempSlot ) then
                    strTemps.Push( cast( ulong, tempSlot ) )
                    strTempTypes.Push( cast( ulong, wsp ) )
                end if
            end if
            if a.kind = cast( ubyte, MV_NONE ) then
                if StrDescriptorOf_( c, argNode, a ) = false then
                    a = LowerAddr( c, argNode )
                end if
            end if
            '' NOTHING TO PASS IS NOT AN ARGUMENT.
            if a.kind = cast( ubyte, MV_NONE ) then return CallFailed_( c, v )
        elseif wantsWide then
            if WideOperand_( c, argNode, a ) = false then a = LowerAddr( c, argNode )
            '' A NARROW ARGUMENT IS CONVERTED, and an RVALUE has no address to fall
            '' back on. Measured -- 'f( hex( 1 ) )' against 'byref w as wstring' is a
            '' narrow temporary, fb_StrToWstr over its data pointer, and the call:
            ''
            ''     fb_StrAssign( &TMP$6$0, -1, vr$20, -1, 0 );
            ''     vr$22 = fb_StrToWstr( (char*)*(char**)&TMP$6$0 );
            ''     vr$23 = F1( TMP$7$0, 0 );
            ''
            '' functions/temp-strings.bas writes the shape twelve times and every one
            '' of them declined.
            if a.kind = cast( ubyte, MV_NONE ) then
                NarrowToWideTemp_( c, argNode, a )
            end if
            if a.kind = cast( ubyte, MV_NONE ) then return CallFailed_( c, v )
        elseif wantsZ then
            if ZstrDataOf_( c, argNode, a ) = false then a = LowerAddr( c, argNode )
            '' A WIDE ARGUMENT IS CONVERTED. Measured, for 'byref z as zstring':
            ''
            ''     fb_WstrAssignToA( &TMP$7$0, -1, TMP$5$0, 0 );
            ''     vr$28 = G2( *(char**)&TMP$7$0, 0 );
            ''
            '' -- the same narrow temporary a byval string parameter gets, read one
            '' level further. A wide RVALUE has no address either way, so both the
            '' descriptor and the address answered nothing and the call declined.
            if a.kind = cast( ubyte, MV_NONE ) then
                dim as MirValue wzt
                '' THE TEMPORARY IS A NARROW STRING, whatever the argument was:
                '' 'fb_WstrAssignToA' writes an FBSTRING, and it is the temporary's
                '' own type that says which deleter releases it.
                dim as Tko.TypeId wzp = c.types->Builtin( Tko.TY_STRING )
                if ByvalStrTemp_( c, argNode, wzp, wzt, tempSlot ) then
                    strTemps.Push( cast( ulong, tempSlot ) )
                    strTempTypes.Push( cast( ulong, wzp ) )
                    dim as MirInst wzf
                    wzf.op = cast( ushort, M_FIELD_ADDR )
                    wzf.ty = cast( ubyte, MT_PTR )
                    wzf.a = wzt
                    wzf.imm = 0
                    dim as MirValue wzpa = Emit( c, wzf )
                    if wzpa.kind <> cast( ubyte, MV_NONE ) then
                        a = LowerExprLoad( c, wzpa, MT_PTR )
                    end if
                end if
            end if
            if a.kind = cast( ubyte, MV_NONE ) then return CallFailed_( c, v )
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
            if a.kind = cast( ubyte, MV_NONE ) then return CallFailed_( c, v )
        else
            '' A STRING PASSED TO A 'zstring ptr' PARAMETER IS ITS DATA POINTER.
            '' Measured: fbc writes 'F( (char*)*(char**)&S )', and for an rvalue it
            '' copies into a temporary descriptor first. Without it the argument
            '' lowered to NOTHING and went out as a malformed operand -- a call with a
            '' hole in it that the verifier does not look at.
            dim as Tko.TypeId ppt = ParamTypeAt( c, callee, i )
            dim as boolean wantsZPtr = false
            dim as boolean wantsWPtr = false
            if ppt <> Tko.TYPE_NONE then
                if c.types->Kind( c.types->Unqualify( ppt ) ) = Tko.TK_POINTER then
                    dim as Tko.TypeId pin = _
                        c.types->Unqualify( c.types->Inner( c.types->Unqualify( ppt ) ) )
                    if c.types->Kind( pin ) = Tko.TK_BUILTIN then
                        if c.types->BuiltinOf( pin ) = Tko.TY_ZSTRING then
                            '' A WIDE ARGUMENT COUNTS TOO, and is converted through
                            '' the same narrow temporary: measured,
                            '' 'G3( (char*)*(char**)&TMP$10$0, 0 )' after an
                            '' fb_WstrAssignToA into it.
                            dim as Tko.TypeId zat = c.info->TypeOf_( argNode )
                            wantsZPtr = IsStringType( c, zat )
                            wantsZPtr = wantsZPtr orelse IsWideString_( c, zat )
                        elseif c.types->BuiltinOf( pin ) = Tko.TY_WSTRING then
                            '' A 'wstring ptr' PARAMETER TAKES THE WIDE DATA POINTER,
                            '' which is what a wide value already IS: measured, fbc
                            '' writes 'TMP = fb_WstrHex_l( 255 ); TAKEWSTRINGPTR( TMP )'
                            '' and passes it straight through.
                            '' A NARROW ARGUMENT COUNTS TOO, and is CONVERTED.
                            '' Measured: 'f( s )' and 'f( z )' against a 'wstring ptr'
                            '' parameter are 'fb_StrToWstr( (char*)*(char**)&S$0 )'
                            '' and 'fb_StrToWstr( (char*)Z$0 )'. tiko loaded the
                            '' DESCRIPTOR'S FIRST EIGHT BYTES and bitcast them to the
                            '' wide pointer -- so the callee read narrow bytes as
                            '' UTF-16, and nothing declined.
                            dim as Tko.TypeId wat = c.info->TypeOf_( argNode )
                            wantsWPtr = IsWideString_( c, wat )
                            wantsWPtr = wantsWPtr orelse IsStringType( c, wat )
                            if wantsWPtr = false then
                                dim as longint wzn
                                wantsWPtr = (StrSwapKind_( c, wat, wzn ) = 1)
                            end if
                        end if
                    end if
                end if
            end if
            if wantsWPtr then
                if WideOperand_( c, argNode, a ) = false then
                    '' A NARROW ARGUMENT IS CONVERTED HERE TOO. 'wstring ptr' takes
                    '' the same wide pointer 'byref as wstring' does, and fbc builds
                    '' the same narrow temporary for an rvalue source.
                    NarrowToWideTemp_( c, argNode, a )
                end if
                if a.kind = cast( ubyte, MV_NONE ) then
                    c.blameNode = cast( ulong, argNode )
                    return CallFailed_( c, v )
                end if
                argv.Push( cast( ulong, a.kind ) )
                argv.Push( cast( ulong, a.id ) )
                continue for
            end if

            if wantsZPtr then
                if ZstrDataOf_( c, argNode, a ) = false then
                    '' AN RVALUE HAS NO DESCRIPTOR TO TAKE THE DATA POINTER OUT OF.
                    '' Measured: fbc builds one, passes its data pointer, and deletes
                    '' it after the call --
                    ''
                    ''     fb_StrAssign( &TMP$5$0, -1, vr$8, -1, 0 );
                    ''     TAKEZSTRINGPTR( (char*)*(char**)&TMP$5$0, 0 );
                    ''     fb_StrDelete( &TMP$5$0 );
                    ''
                    '' -- which is the same temporary a byval string parameter gets,
                    '' read one level further.
                    dim as MirValue zt
                    '' A NARROW TEMPORARY, whatever the source was: a WIDE argument
                    '' is converted into it by fb_WstrAssignToA, and it is the
                    '' temporary's type -- not the argument's -- that says which
                    '' deleter releases it.
                    dim as Tko.TypeId zpt = c.info->TypeOf_( argNode )
                    if IsStringType( c, zpt ) = false then
                        zpt = c.types->Builtin( Tko.TY_STRING )
                    end if
                    if ByvalStrTemp_( c, argNode, zpt, zt, tempSlot ) = false then
                        c.blameNode = cast( ulong, argNode )
                        return CallFailed_( c, v )
                    end if
                    strTemps.Push( cast( ulong, tempSlot ) )
                    strTempTypes.Push( cast( ulong, zpt ) )
                    a = LowerExprLoad( c, zt, MT_PTR )
                    if a.kind = cast( ubyte, MV_NONE ) then return CallFailed_( c, v )
                end if
                argv.Push( cast( ulong, a.kind ) )
                argv.Push( cast( ulong, a.id ) )
                continue for
            end if

            '' A BYVAL NON-TRIVIAL UDT ARGUMENT IS A COPY THE CALLER BUILDS.
            ''
            '' Measured: the parameter is a POINTER, and around the call fbc writes
            ''
            ''     _ZN2S1C1ERKS_( &TMP$5$0, &S$0 );      the copy constructor...
            ''     T3( &TMP$5$0 );                       ...the call takes its address
            ''     _ZN2S1D1Ev( &TMP$5$0 );               ...and the temporary dies here
            ''
            '' -- a plain memcpy into the temporary when the type has a destructor but
            '' no copy constructor, and no destruction at all when it has a copy
            '' constructor but no destructor. Each of the three was measured on its own
            '' type.
            ''
            '' Passing the AGGREGATE, which is what this did, gave the callee a bitwise
            '' copy: over a type holding a string, two objects owning one buffer and
            '' both released. It lowered and it verified.
            '' A BYVAL VAR-LENGTH STRING ARGUMENT IS A COPY THE CALLER BUILDS, in a
            '' descriptor of its own that it deletes after the call. Measured:
            ''
            ''     memset( &TMP$4$0, 0, 24 );
            ''     fb_StrAssign( &TMP$4$0, -1, &V$0, -1, 0 );
            ''     TAKEBYVALSTRING( &TMP$4$0 );
            ''     fb_StrDelete( &TMP$4$0 );
            if ParamIsIndirectStr_( c, callee, i ) then
                dim as Tko.TypeId spt = ParamTypeAt( c, callee, i )
                if ByvalStrTemp_( c, argNode, spt, a, tempSlot ) = false then
                    c.blameNode = cast( ulong, argNode )
                    return CallFailed_( c, v )
                end if
                strTemps.Push( cast( ulong, tempSlot ) )
                strTempTypes.Push( cast( ulong, spt ) )
                argv.Push( cast( ulong, a.kind ) )
                argv.Push( cast( ulong, a.id ) )
                continue for
            end if

            '' AN ARGUMENT THAT IS NOT THE PARAMETER'S TYPE IS A CONVERSION, and it is
            '' tried before either copy path: neither of those has anything to copy
            '' FROM. See UdtConvTemp_ -- without it the raw operand went to the callee.
            if ArgNeedsUdtConv_( c, callee, i, argNode ) then
                dim as Tko.TypeId upt = ParamTypeAt( c, callee, i )
                dim as MirValue ca
                if UdtConvTemp_( c, argNode, upt, ca, tempSlot, tempType ) = false then
                    c.blameNode = cast( ulong, argNode )
                    return CallFailed_( c, v )
                end if
                if tempSlot >= 0 then
                    tempSlots.Push( cast( ulong, tempSlot ) )
                    tempTypes.Push( cast( ulong, tempType ) )
                end if
                '' THE CALLEE TAKES WHAT IT WOULD HAVE TAKEN ANYWAY: the temporary's
                '' ADDRESS when the type is passed indirectly, and the aggregate itself
                '' when it is not. Measured -- fbc writes 'F( TMP$2$0 )' for a type with
                '' no destructor and 'F( &TMP$3$0 )' for one with.
                if ParamIsIndirectUdt_( c, callee, i ) then
                    a = ca
                else
                    a = LowerExprLoad( c, ca, MT_AGG )
                    if a.kind = cast( ubyte, MV_NONE ) then
                        c.blameNode = cast( ulong, argNode )
                        return CallFailed_( c, v )
                    end if
                end if
                argv.Push( cast( ulong, a.kind ) )
                argv.Push( cast( ulong, a.id ) )
                continue for
            end if

            if ParamIsIndirectUdt_( c, callee, i ) then
                if ByvalUdtCopyArg_( c, argNode, ParamTypeAt( c, callee, i ), _
                                     a, tempSlot, tempType ) = false then
                    c.blameNode = cast( ulong, argNode )
                    return CallFailed_( c, v )
                end if
                if tempSlot >= 0 then
                    tempSlots.Push( cast( ulong, tempSlot ) )
                    tempTypes.Push( cast( ulong, tempType ) )
                end if
                argv.Push( cast( ulong, a.kind ) )
                argv.Push( cast( ulong, a.id ) )
                continue for
            end if

            '' A UDT ARGUMENT FOR A SCALAR PARAMETER IS ITS 'operator cast', not its
            '' bytes -- the same rule an assignment follows, and the other half of the
            '' user-defined conversion the overload ranking now scores. Without it the
            '' candidate became viable and the argument was then passed as a loaded,
            '' sign-extended aggregate.
            dim as boolean argCast = false
            if callee <> Tko.SYMBOL_NONE then
                argCast = UserConvToScalar_( c, argNode, ParamTypeAt( c, callee, i ), a )
            end if
            if argCast = false then a = LowerExpr( c, argNode )
            '' AN ARGUMENT THAT WOULD NOT LOWER IS A DECLINE, not a hole. It used to be
            '' pushed anyway, so the call went out with a malformed operand in it.
            ''
            '' The ARGUMENT is what gets the blame: inside a macro the statement's own
            '' location is the macro BODY, while the argument's tokens come from the
            '' invocation and point at the work.
            if a.kind = cast( ubyte, MV_NONE ) then
                c.blameNode = cast( ulong, argNode )
                return CallFailed_( c, v )
            end if
            '' TO THE PARAMETER'S TYPE, not the argument's. 'randomize 42' passes an
            '' INTEGER literal to a 'byval as double', and handing the callee the
            '' narrow value puts half a quantity in a wide slot -- the same rule the
            '' type-constructor path already applies to its own arguments.
            ''
            '' An AGGREGATE is passed whole and has nothing to convert.
            dim as Tko.TypeId pt = ParamTypeAt( c, callee, i )
            if forcedByval andalso ParamIsByref( c, callee, i ) then
                '' The parameter is a REFERENCE and the value is standing in for one,
                '' so the width is the pointer's, not the parameter's declared type.
                if a.kind <> cast( ubyte, MV_NONE ) then a = Coerce( c, a, MT_PTR, false )
            elseif (pt <> Tko.TYPE_NONE) andalso (a.kind <> cast( ubyte, MV_NONE )) then
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
    '' A CALLEE WITH NO SYMBOL has no name and no declaration to read defaults from;
    '' it is called indirectly and nothing below this point applies to it.
    dim as Tko.InternId cnm = 0
    if cs <> 0 then cnm = cs->name
    if (cs <> 0) andalso (cs->payload <> 0) then
        cnm = c.names->GetString( Tko.Mangle.ProcName( _
            *c.ast, cast( Tko.NodeId, cs->payload ), *c.syms, *c.names, _
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
                DestroyArgTemps_( c, tempSlots, tempTypes )
                DeleteStrArgTemps_( c, strTemps, strTempTypes )
                c.lastCallOk = true
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
            dim as Tko.TypeId ft = c.info->TypeOf_( calleeNode )
            if ft <> Tko.TYPE_NONE then
                if c.types->Kind( ft ) = Tko.TK_POINTER then ft = c.types->Inner( ft )
                if ft <> Tko.TYPE_NONE then
                    if c.types->Kind( ft ) = Tko.TK_PROC then
                        callTy = LowerType( c.types->Inner( ft ), *c.types )
                    end if
                end if
            end if
        end if

        dim as MirValue fp = LowerExpr( c, calleeNode )
        if fp.kind = cast( ubyte, MV_NONE ) then return CallFailed_( c, v )
        dim as MirInst ic
        ic.op = cast( ushort, M_CALL_IND )
        ic.ty = cast( ubyte, callTy )
        ic.a = Coerce( c, fp, MT_PTR )
        ic.first = first
        ic.count = n
        dim as MirValue iv = Emit( c, ic )
        DestroyArgTemps_( c, tempSlots, tempTypes )
        DeleteStrArgTemps_( c, strTemps, strTempTypes )
        c.lastCallOk = true
        return iv
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
    DestroyArgTemps_( c, tempSlots, tempTypes )
    DeleteStrArgTemps_( c, strTemps, strTempTypes )
    c.lastCallOk = true

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
    ( byref c as Ctx, byval id as Tko.NodeId, byval mt as MirType, _
      byref outv as MirValue ) as boolean

    '' 'T.StaticFn' IS THE SAME RULE QUALIFIED. 'DateTime.MaxValue' is a call, and
    '' with only the bare spelling here it was a member access whose base named a
    '' procedure -- so it declined, or worse, read the function's code bytes.
    '' chrono/core.bas writes it eleven times. A PROPERTY is handled before this by
    '' LowerPropertyGet_, so the only member form that arrives is a real procedure.
    dim as Tko.NodeKind bk = c.ast->Kind( id )
    if (bk <> Tko.N_IDENT) andalso (bk <> Tko.N_MEMBER) then return false
    dim as Tko.SymbolId sid = c.info->RefOf( id )
    if sid = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return false
    if s->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    if s->type_ = Tko.TYPE_NONE then return false          '' a SUB has no value

    '' EVERY PARAMETER MUST HAVE A DEFAULT. ParamDefaultAt answers for each, and a
    '' variadic tail is not something a bare name can fill.
    if IsVariadicProc( c, sid ) then return false
    dim as long np = ParamCountOf( c, sid )
    for i as long = 0 to np - 1
        if ParamDefaultAt( c, sid, i ) = Tko.NODE_NONE then return false
    next

    outv = LowerCallParts( c, id, sid, 0, 0, mt )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' IMP AND EQV ARE TWO INSTRUCTIONS EACH, which is why they are not in the table
'' below: measured from fbc, 'a imp b' is '~A | B' and 'a eqv b' is '~(A ^ B)'. Both
'' are bitwise on integers, so this is the same shape the other bitwise operators take
'' with a NOT in front of one of them.
function EmitImpEqv_ _
    ( byref c as Ctx, byval tk as Tko.TokenKind, byval ty as MirType, _
      byref l as MirValue, byref r as MirValue ) as MirValue

    dim as MirValue none_
    if tk = Tko.KW_IMP then
        dim as MirInst n1
        n1.op = cast( ushort, M_NOT )
        n1.ty = cast( ubyte, ty )
        n1.a = l
        dim as MirValue nl = Emit( c, n1 )
        if nl.kind = cast( ubyte, MV_NONE ) then return none_
        dim as MirInst o1
        o1.op = cast( ushort, M_OR )
        o1.ty = cast( ubyte, ty )
        o1.a = nl
        o1.b = r
        return Emit( c, o1 )
    end if
    if tk = Tko.KW_EQV then
        dim as MirInst x1
        x1.op = cast( ushort, M_XOR )
        x1.ty = cast( ubyte, ty )
        x1.a = l
        x1.b = r
        dim as MirValue xv = Emit( c, x1 )
        if xv.kind = cast( ubyte, MV_NONE ) then return none_
        dim as MirInst n2
        n2.op = cast( ushort, M_NOT )
        n2.ty = cast( ubyte, ty )
        n2.a = xv
        return Emit( c, n2 )
    end if
    return none_
end function

function BinOpFor _
    ( byval tk as Tko.TokenKind, byval t as MirType, _
      byval isUnsigned as boolean ) as MirOp

    dim as boolean f = IsFloatTy( t )
    select case tk
    case Tko.TK_PLUS      : return M_ADD
    case Tko.TK_MINUS     : return M_SUB
    case Tko.TK_STAR      : return M_MUL
    case Tko.TK_SLASH     : return M_FDIV
    case Tko.TK_BACKSLASH : return iif( isUnsigned, M_UDIV, M_SDIV )
    case Tko.KW_MOD       : return iif( isUnsigned, M_UREM, M_SREM )
    case Tko.KW_AND       : return M_AND
    case Tko.KW_OR        : return M_OR
    case Tko.KW_XOR       : return M_XOR
    case Tko.KW_SHL       : return M_SHL
    '' SHR is ARITHMETIC on a signed value -- '-1 shr 1' is -1, measured in
    '' docs/internals/phase-5-const.md -- so it is ashr unless the type is unsigned.
    case Tko.KW_SHR       : return iif( isUnsigned, M_LSHR, M_ASHR )
    case Tko.TK_EQ        : return iif( f, M_FCMP_EQ, M_ICMP_EQ )
    case Tko.TK_NE        : return iif( f, M_FCMP_NE, M_ICMP_NE )
    case Tko.TK_LT        : return iif( f, M_FCMP_LT, iif( isUnsigned, M_ICMP_ULT, M_ICMP_SLT ) )
    case Tko.TK_GT        : return iif( f, M_FCMP_GT, iif( isUnsigned, M_ICMP_UGT, M_ICMP_SGT ) )
    case Tko.TK_LE        : return iif( f, M_FCMP_LE, M_ICMP_SLE )
    case Tko.TK_GE        : return iif( f, M_FCMP_GE, M_ICMP_SGE )
    end select
    return M_NONE
end function

function IsUnsignedType _
    ( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    if t = Tko.TYPE_NONE then return false
    if c.types->Kind( t ) <> Tko.TK_BUILTIN then return false
    select case c.types->BuiltinOf( t )
    case Tko.TY_UBYTE, Tko.TY_USHORT, Tko.TY_ULONG, Tko.TY_UINTEGER, Tko.TY_ULONGINT
        return true
    '' A STRING IN AN ARITHMETIC CONTEXT IS ONE CHARACTER, and characters are
    '' UNSIGNED. The only way a string TYPE reaches a numeric coercion is '*pz' or
    '' 's[ i ]' being widened, and fbc writes '(double)(uint8)*PZ$0' for it -- a byte
    '' above 127 would come out NEGATIVE through a sign extension. Every string PATH
    '' goes through the descriptor helpers instead and never asks this.
    case Tko.TY_ZSTRING, Tko.TY_WSTRING, Tko.TY_STRING, Tko.TY_USTRING, _
         Tko.TY_FIXSTR, Tko.TY_FIXUSTR
        return true
    end select
    return false
end function



'' THE CONVERSION CONSTRUCTOR for one argument that is not already the parameter's type.
''
'' 'sub f( byval x as UDT )' called as 'f( 1122 )' over a type declaring
'' 'declare constructor( byval n as integer )'. Measured:
''
''     struct UDT TMP$2$0;
''     _ZN3UDTC1Eu7INTEGER( &TMP$2$0, 1122ll );
''     F( TMP$2$0 );
''
'' -- a temporary, the constructor into it, and the temporary passed. It is destroyed at
'' the END OF THE STATEMENT, after the call's result has been consumed, which is what
'' the argument-temporary list this returns into already does.
''
'' Without it the raw operand went straight to the callee: 'call void F( 1122 )', an
'' integer where an object belongs, with "0 statements not lowered" beside it. It lowered
'' and it verified.
''
'' A CONVERSION CONSTRUCTOR IS ANY ARITY-1 CONSTRUCTOR WHOSE PARAMETER IS NOT THE TYPE
'' ITSELF -- one whose parameter IS the type is the copy constructor, and that is a
'' different path with a different meaning.
private function ConvCtorFor_ _
    ( byref c as Ctx, byval pt as Tko.TypeId ) as Tko.SymbolId

    dim as Tko.SymbolId cur = StructorOf( c, pt, "__ctor" )
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
            dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
            dim as long np = 0
            for i as long = 0 to pp->count - 1
                dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                if c.ast->Kind( prm ) = Tko.N_PARAM then np += 1
            next
            if np = 1 then
                dim as Tko.TypeId cpt = ParamTypeAt( c, cur, 0 )
                if cpt <> Tko.TYPE_NONE then
                    dim as Tko.TypeId u = cpt
                    if c.types->Kind( u ) = Tko.TK_REFERENCE then u = c.types->Inner( u )
                    if c.types->Unqualify( u ) <> c.types->Unqualify( pt ) then
                        return cur
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    return Tko.SYMBOL_NONE
end function

'' A TEMPORARY OF THE PARAMETER'S TYPE, constructed from the argument. Returns its
'' ADDRESS; the caller decides whether the callee wants that or the aggregate loaded out
'' of it, which is the same choice an ordinary byval UDT argument already makes.
private function UdtConvTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long, byref outType as Tko.TypeId ) as boolean

    outSlot = -1
    outType = Tko.TYPE_NONE
    if argNode = Tko.NODE_NONE then return false
    dim as long sz = SizeOfType( c, pt )
    if sz <= 0 then return false

    dim as Tko.SymbolId cv = ConvCtorFor_( c, pt )
    if cv = Tko.SYMBOL_NONE then return false
    dim as Tko.TypeId cpt = ParamTypeAt( c, cv, 0 )
    if cpt = Tko.TYPE_NONE then return false

    '' EVERYTHING THAT CAN FAIL, BEFORE ANYTHING IS EMITTED. A decline that has already
    '' made a temporary does not LOOK like one -- the alloca counts as an instruction and
    '' the statement reads as lowered with the call missing from it.
    dim as boolean byrefP = ParamIsByref( c, cv, 0 )
    dim as MirValue av
    if byrefP then
        av = LowerAddr( c, argNode )
    else
        av = LowerExpr( c, argNode )
    end if
    if av.kind = cast( ubyte, MV_NONE ) then return false
    if byrefP = false then
        dim as MirType cmt = LowerType( cpt, *c.types )
        if (cmt = MT_VOID) orelse (cmt = MT_AGG) then return false
        av = Coerce( c, av, cmt, IsUnsignedType( c, c.info->TypeOf_( argNode ) ) )
        if av.kind = cast( ubyte, MV_NONE ) then return false
    end if

    dim as long slot = NewTempLocal( c, MT_AGG, sz )
    if slot < 0 then return false
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot

    dim as FB.Array( of ulong ) cargs
    cargs.Push( cast( ulong, av.kind ) )
    cargs.Push( cast( ulong, av.id ) )
    EmitStructorCall( c, cv, -1, @dst, @cargs )

    if TypeNeedsDtor_( c, pt ) then
        outSlot = slot
        outType = pt
    end if
    outa = dst
    return true
end function

'' Whether argument 'i' of 'callee' has to be CONVERTED rather than passed. True only
'' when the parameter is a UDT and the argument is not already one of that type -- an
'' argument of the same type is a copy, and both other cases are somebody else's path.
private function ArgNeedsUdtConv_ _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long, _
      byval argNode as Tko.NodeId ) as boolean

    if argNode = Tko.NODE_NONE then return false
    if ParamIsArray( c, callee, idx ) then return false
    dim as Tko.TypeId pt = ParamTypeAt( c, callee, idx )
    if pt = Tko.TYPE_NONE then return false
    if c.types->Kind( pt ) = Tko.TK_REFERENCE then pt = c.types->Inner( pt )
    pt = c.types->Unqualify( pt )
    if c.types->Kind( pt ) <> Tko.TK_UDT then return false

    dim as Tko.TypeId at = c.info->TypeOf_( argNode )
    if at = Tko.TYPE_NONE then return false
    if c.types->Kind( at ) = Tko.TK_REFERENCE then at = c.types->Inner( at )
    at = c.types->Unqualify( at )
    if at = pt then return false
    '' A DERIVED OBJECT IS NOT A CONVERSION -- it is the base subobject at offset zero,
    '' which the ordinary path already passes.
    if c.types->Kind( at ) = Tko.TK_UDT then return false
    return true
end function

'' THE CALLER-BUILT COPY of one byval non-trivial UDT argument.
''
'' Returns the address to pass, and the temporary's slot when one was made so the call
'' site can destroy it afterwards. A slot of -1 means nothing needs destroying, which
'' is the type with a copy constructor and no destructor.
private function ByvalUdtCopyArg_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long, byref outType as Tko.TypeId ) as boolean

    outSlot = -1
    outType = Tko.TYPE_NONE
    if argNode = Tko.NODE_NONE then return false
    dim as long sz = SizeOfType( c, pt )
    if sz <= 0 then return false

    '' WHICH COPY, DECIDED BEFORE ANYTHING IS EMITTED. A decline that has already made
    '' a temporary is a decline that does not LOOK like one: the alloca counts as an
    '' instruction, and the statement then reads as lowered with the call missing from
    '' it. That is the shape this whole sweep exists to find.
    ''   2  the written copy constructor      1  the synthesised one      0  memcpy
    dim as Tko.SymbolId cc = StructorWithArity( c, StructorOf( c, pt, "__ctor" ), 1 )
    dim as long how = 0
    if cc <> Tko.SYMBOL_NONE then
        dim as Tko.TypeId cpt = ParamTypeAt( c, cc, 0 )
        if cpt <> Tko.TYPE_NONE then
            if c.types->Kind( cpt ) = Tko.TK_REFERENCE then cpt = c.types->Inner( cpt )
            if c.types->Unqualify( cpt ) = c.types->Unqualify( pt ) then how = 2
        end if
    end if
    if (how = 0) andalso NeedsLetBody_( c, pt ) then how = 1
    '' A DYNAMIC ARRAY MEMBER AND NO WRITTEN COPY CONSTRUCTOR IS A DECLINE.
    ''
    '' fbc synthesises one for such a type and copies the array with fb_ArrayRedimTo
    '' and an element loop; tiko-lang deliberately synthesises none, because an
    '' assignment that skipped the array would look like the field had been handled.
    '' The bitwise fallback is fine for a type whose destructor owns nothing -- fbc
    '' itself memcpys one -- but here the temporary would hold a SECOND descriptor
    '' over the caller's data, and destroying it after the call would erase it.
    if (how = 0) andalso HasDynArrayMember_( c, pt ) then return false

    '' THE SOURCE HAS TO HAVE AN ADDRESS. A copy constructor takes one, and a bitwise
    '' copy of an rvalue that something else already owns would be a second owner of
    '' its buffer -- so an argument with no address DECLINES rather than being copied
    '' some other way.
    dim as MirValue src = LowerAddr( c, argNode )
    if src.kind = cast( ubyte, MV_NONE ) then return false

    dim as long slot = NewTempLocal( c, MT_AGG, sz )
    if slot < 0 then return false
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot

    select case how
    case 2
        dim as FB.Array( of ulong ) cargs
        cargs.Push( cast( ulong, src.kind ) )
        cargs.Push( cast( ulong, src.id ) )
        EmitStructorCall( c, cc, -1, @dst, @cargs )
    case 1
        CallImplicitCopy_( c, pt, dst, src )
    case else
        '' fbc emits '__builtin_memcpy( &TMP$4$0, &D$0, 4 )' and nothing else for a
        '' type whose only claim on this path is a destructor.
        dim as MirValue whole = LowerExprLoad( c, src, MT_AGG )
        if whole.kind = cast( ubyte, MV_NONE ) then return false
        StoreThrough( c, dst, whole )
    end select

    if TypeNeedsDtor_( c, pt ) then
        outSlot = slot
        outType = pt
    end if
    outa = dst
    return true
end function

'' The temporaries a call built for its byval UDT arguments, destroyed after it returns
'' and in reverse -- which is the order fbc destroys them in when there is more than one.
private sub DestroyArgTemps_ _
    ( byref c as Ctx, byref slots as FB.Array( of ulong ), _
      byref types as FB.Array( of ulong ) )

    for k as long = slots.Count - 1 to 0 step -1
        dim as Tko.TypeId t = cast( Tko.TypeId, types[k] )
        dim as MirValue a
        a.kind = cast( ubyte, MV_LOCAL )
        a.ty = cast( ubyte, MT_PTR )
        a.id = cast( long, slots[k] )
        dim as Tko.SymbolId dt = StructorWithArity( c, StructorOf( c, t, "__dtor" ), 0 )
        if dt <> Tko.SYMBOL_NONE then
            dim as FB.Array( of ulong ) none_
            EmitStructorCall( c, dt, -1, @a, @none_ )
        else
            CallImplicitDtor_( c, t, a )
        end if
    next
end sub


'' THE CALLER-BUILT DESCRIPTOR for one byval var-length string argument: zeroed,
'' assigned from the source, and passed by ADDRESS. The slot comes back so the call
'' site can delete it afterwards.
private function ByvalStrTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long ) as boolean

    outSlot = -1
    if argNode = Tko.NODE_NONE then return false
    dim as long slot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
    if slot < 0 then return false
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot
    ZeroStrDescriptor( c, dst )
    '' The same assignment a 'dim as string s = expr' makes, so every source shape --
    '' a literal, a fixed-length string, a concatenation -- reaches the entry point it
    '' already had. A WIDE source is its own conversion: measured,
    '' 'takeByvalString( whex( n ) )' is 'fb_WstrAssignToA( &TMP, -1, TMP_wide, 0 )'
    '' and not fb_StrAssign.
    if LowerWideToNarrowSlot( c, slot, pt, argNode ) then
    elseif LowerStringAssignToSlot( c, slot, argNode ) = false then
        return false
    end if
    outSlot = slot
    outa = dst
    return true
end function

'' ...and their release, after the call returns.
private sub DeleteStrArgTemps_ _
    ( byref c as Ctx, byref slots as FB.Array( of ulong ), _
      byref types as FB.Array( of ulong ) )

    for k as long = slots.Count - 1 to 0 step -1
        dim as MirValue a
        a.kind = cast( ubyte, MV_LOCAL )
        a.ty = cast( ubyte, MT_PTR )
        a.id = cast( long, slots[k] )
        dim as FB.Array( of ulong ) args
        args.Push( cast( ulong, a.kind ) ) : args.Push( cast( ulong, a.id ) )
        EmitRtl( c, StrRtlFor_( c, cast( Tko.TypeId, types[k] ), RTL_STR_DELETE ), args )
    next
end sub


'' A CALL THAT GAVE UP, counted.
''
'' The statement dispatcher used to ask whether the block had gained INSTRUCTIONS, and
'' a call's ARGUMENTS are lowered before the call itself can fail -- so a statement
'' whose call was never emitted read as fully lowered with the call missing out of the
'' middle of it. That hid 2,632 dropped calls in ONE corpus file and 956,887
'' instructions across the corpus, with nothing anywhere to say so.
''
'' A FLAG AND NOT A COUNTER, because calls NEST and an inner one may fail and then be
'' retried by another path: 'takeByvalString( hex( 255 ) )' lowers the argument through
'' here first, fails, and succeeds as an intrinsic. The OUTERMOST call is the last to
'' write the flag, so what the statement reads is its own outcome.
private function CallFailed_( byref c as Ctx, byref v as MirValue ) as MirValue
    c.lastCallOk = false
    return v
end function

'' 'threadcall' -- included HERE rather than made a module of its own, because the
'' byval-string temporary and its delete are this file's private helpers and a thread
'' call marshals a string exactly the way an ordinary call's argument does.
#include once "mir/lowerthread.bas"

end namespace
