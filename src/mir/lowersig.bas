'' lowersig.bas -- SignatureFromProc: the signature of a procedure this module does
'' not define. Split out of lowerproc.bas on 2026-09-10 for the 1500-line cap; nothing
'' about the code changed in the move.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

'' THE SIGNATURE OF A PROCEDURE THIS MODULE DOES NOT DEFINE.
''
'' The definition path records a signature from the parameter SLOTS, which is the
'' authority -- a slot's type is what the body actually reads. A declaration has no
'' slots, so the types come from the DECLARED types instead, through ParamMirType,
'' which is the rule the slots were built with. One rule, two entry points.
''
'' The two hidden parameters are the caller's business and are passed in rather than
'' re-derived here: given only a proc node this cannot see whether the call site
'' decided to pass a hidden result pointer, and guessing would put the arity of the
'' declaration and the arity of the call out of step.
'' HOW A NARROW INTEGER PARAMETER IS WIDENED, from the FB type. fbc passes anything
'' narrower than 32 bits as i32 -- signext for a signed type, zeroext for an unsigned
'' one, and zeroext for BOOLEAN whatever its signedness, which is what clang emits for
'' C's _Bool. Measured against 'fbc -gen llvm' on byte, ubyte, short, ushort, boolean
'' and long: '( i32 signext, i32 zeroext, i32 signext, i32 zeroext, i32 zeroext, i32 )'.
''
'' ONLY MT_I8 AND MT_I16 WIDEN. A byref parameter is a pointer and has nothing to
'' widen, an i32 is already the width, and an aggregate is the ABI pass's business.
'' MirFunction.paramExt says why this matters and what it cost.
function ParamExtClass_ _
    ( byref c as Ctx, byval t as Tko.TypeId ) as ubyte

    select case ParamMirType( c, t )
    case MT_I8, MT_I16
    case else
        return TKO_PX_NONE
    end select
    if c.types->BuiltinOf( c.types->Unqualify( t ) ) = Tko.TY_BOOLEAN then
        return TKO_PX_ZERO
    end if
    if IsUnsignedType( c, t ) then return TKO_PX_ZERO
    return TKO_PX_SIGN
end function

sub SignatureFromProc _
    ( byref c as Ctx, byval f as MirFunction ptr, byval pn as Tko.NodeId, _
      byval withSret as boolean, byval withThis as boolean )

    if f = 0 then return
    if withSret then
        f->AddParam( MT_PTR )
        f->hasSretParam = true
    end if
    if withThis then f->AddParam( MT_PTR )
    if pn = Tko.NODE_NONE then return
    if c.ast->Kind( pn ) <> Tko.N_PROC then return
    '' AN AGGREGATE RETURN NEEDS ITS SIZE HERE TOO. The DEFINITION path records it;
    '' this one -- every DECLARATION, so every callee this module only calls -- did
    '' not, and a retSize of zero is exactly what both halves of the ABI pass read as
    '' "decline". 'declare agg _ZplRK11UDT_DEFAULTS1_(ptr, ptr)' then reached the
    '' emitter untouched: two of the corpus's codegen failures, an operator+ and
    '' fb/vector.bi's Conjugate.
    if cast( MirType, f->retTy ) = MT_AGG then
        if f->retSize <= 0 then
            dim as Tko.SymbolId rsid = c.info->RefOf( pn )
            dim as Tko.Symbol ptr rs = c.syms->SymbolAt( rsid )
            if rs <> 0 then
                if rs->type_ <> Tko.TYPE_NONE then
                    f->retSize = SizeOfType( c, rs->type_ )
                    f->retClass = ClassifyEightbytes( c, rs->type_ )
                end if
            end if
        end if
    end if
    dim as Tko.StmtPayload ptr sp = StmtOf( c, pn )
    if sp = 0 then return

    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        '' THE ELLIPSIS IS AN N_PARAM and is not a parameter: it carries no type and
        '' contributes no argument. LLVM spells it in the signature's tail instead.
        if StmtOf( c, prm )->op = cast( ushort, Tko.TK_ELLIPSIS ) then
            f->isVariadic = true
            continue for
        end if
        '' THE TYPE IS ON THE TYPEREF CHILD, not on the N_PARAM -- which carries none,
        '' so reading it there gives TYPE_NONE and every parameter comes out 'void'.
        '' ParamTypeAt has always read it this way; this is the same fact.
        dim as Tko.TypeId pt = c.info->TypeOf_( StmtOf( c, prm )->a )
        '' BYREF IS ON THE PARAMETER, NOT IN THE TYPEREF. The typeref carries the bare
        '' type either way; Resolve settles byref -- including the DEFAULT, which is
        '' byref for a UDT or a string and byval for everything else -- by writing
        '' NF_BYREF onto this node and making the SYMBOL's type a reference. The slot
        '' path reads the symbol and so sees a pointer; reading the typeref alone does
        '' not, and 'byref q as Pt' came out an aggregate passed by value.
        '' AN ARRAY PARAMETER TAKES A DESCRIPTOR POINTER, and says so nowhere else.
        '' 'b( ) as T' carries the ELEMENT's type on its typeref and no NF_BYREF, so
        '' this read it as a byval T: 'declare void TAKE<23>(i32, i32)' against a
        '' definition '(i32, ptr)', and the ABI pass then copied the caller's 72-byte
        '' descriptor into a 4-byte aggregate. The callee read lbound 0, ubound -1 and
        '' the program segfaulted.
        ''
        '' ORDER IS WHAT HID IT. The DEFINITION path records the signature from the
        '' parameter SLOTS, where an array slot is already a pointer, so this only
        '' shows when the CALL is lowered before the callee's body -- which is what a
        '' generic calling a generic does. The same call from module scope was right.
        dim as boolean isArr = ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_ARRAY) <> 0)
        if isArr orelse ((c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0) then
            f->AddParam( MT_PTR )
        else
            '' The SIZE only where it is genuinely an aggregate -- see the definition
            '' path above for what recording it otherwise did.
            dim as MirType smt = ParamMirType( c, pt )
            dim as ulong ssz = 0
            dim as ulong scl = 0
            if smt = MT_AGG then
                ssz = cast( ulong, SizeOfType( c, pt ) )
                scl = ClassifyEightbytes( c, pt )
            end if
            f->AddParam( smt, ssz, scl, TKO_PA_NONE, ParamExtClass_( c, pt ) )
        end if
    next
    f->callConv = ProcCallConv_( c, pn )
end sub

'' IT IS ATTACHED TO EVERY INDIRECT CALL, whatever the call returns. It used to go only on one that
'' returned an aggregate, and without it the ABI pass skipped the call's ARGUMENTS as well: a
'' struct passed by value went out as a raw '[8 x i8]' or '[16 x i8]' value where the procedure it
'' reached takes an i64, or a pointer to a copy. Measured on win64-msvc, 'p8( a8 )' through
'' 'function cdecl( byval s as S8 ) as long' returned -732239352 and 'p16( a16 )' segfaulted,
'' where the same calls made directly print 8 and 16 -- and fbc prints 8 and 16 both ways. Every
'' libclang entry point tiko's C importer calls is this shape: a CXCursor or CXType by value, a
'' scalar back. tests/codegen/procptr-byval-agg.test.
''
'' A SIGNATURE FOR A CALL THROUGH A PROCEDURE POINTER, off the pointer's TYPE. With no function
'' to name, the ABI pass declined the call's aggregate result: 'p.parse_( body, id )' returned a
'' 24-byte struct in registers while the procedure it reached wrote through a hidden pointer, so
'' ApexWealth's quote provider came back failed and test_net crashed. The call names this
'' declaration by index (plus one, as a virtual call does); nothing links against it. One per
'' procedure type, found again by TYPE. -1 when the type is not a procedure's.
function PtrCallSigIndex_( byref c as Ctx, byval sigT as Tko.TypeId ) as long
    if sigT = Tko.TYPE_NONE then return -1
    if c.types->Kind( sigT ) <> Tko.TK_PROC then return -1
    '' KEYED ON THE TYPE, not on a name built from it. The name is still what the
    '' function is called -- nothing links against it, but the dump and the emitter
    '' read it -- and it is built ONCE, when the signature is first made. Finding it
    '' again used to build that string and intern it at every procedure-pointer call
    '' site, and then scan every function in the module.
    dim as long tkey = cast( long, sigT )
    while c.m->procSigByType.Count <= tkey
        c.m->procSigByType.Push( 0 )
    wend
    if c.m->procSigByType[tkey] > 0 then return c.m->procSigByType[tkey] - 1

    dim as Tko.InternId nm = c.names->GetString( "$tko.procsig." & str( tkey ) )
    dim as Tko.TypeId rt = c.types->Inner( sigT )
    dim as MirType rmt = MT_VOID
    if rt <> Tko.TYPE_NONE then rmt = LowerType( rt, *c.types )
    dim as MirFunction ptr f = c.m->AddFunction( nm, rmt )
    if f = 0 then return -1
    c.m->procSigByType[tkey] = c.m->functions.Count
    f->isDefinition = false
    '' ...AND WHETHER IT IS VARIADIC, which the emitter needs to say where the fixed parameters stop
    '' -- on win64 that decides whether a float in the tail is duplicated into a GPR.
    f->isVariadic = c.types->IsVariadic( sigT )
    '' A STRING RESULT IS A POINTER at every call site -- see LowerCallParts -- so only a real
    '' aggregate carries the size and class RewriteCallReturn reads.
    if (rmt = MT_AGG) andalso (IsStringType( c, rt ) = false) then
        f->retSize = SizeOfType( c, rt )
        f->retClass = ClassifyEightbytes( c, rt )
    end if
    for i as long = 0 to c.types->ProcParamCount( sigT ) - 1
        dim as Tko.TypeId pt = c.types->ProcParam( sigT, i )
        if c.types->Kind( pt ) = Tko.TK_REFERENCE then
            f->AddParam( MT_PTR )
        elseif ParamMirType( c, pt ) = MT_AGG then
            f->AddParam( MT_AGG, cast( ulong, SizeOfType( c, pt ) ), ClassifyEightbytes( c, pt ) )
        else
            '' A PROCEDURE POINTER'S SIGNATURE WIDENS TOO. The call goes through this
            '' declaration, so a narrow parameter here must say so or the call site and
            '' the callee disagree about the register's upper bits.
            f->AddParam( ParamMirType( c, pt ), 0, 0, TKO_PA_NONE, _
                         ParamExtClass_( c, pt ) )
        end if
    next
    return c.m->functions.Count - 1
end function

end namespace
