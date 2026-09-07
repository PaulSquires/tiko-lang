'' lowerboundchk.bas -- the '-exx' array bounds check.
''
'' SPLIT OUT OF lowerarr.bas, which this pushed to 1548 lines against a limit of
'' 1500. The subscript lowering keeps one line of it; everything the check has to
'' say for itself is here.

#include once "mir/lowerctx.bi"
#include once "mir/rtl.bi"

namespace Tko.Mir

'' EmitRtl takes each argument as its KIND and then its ID, two ulongs. Spelled out
'' at every other call site; once here, because this call pushes six.
private sub PushArg_( byref a as FB.Array( of ulong ), byref v as MirValue )
    a.Push( cast( ulong, v.kind ) )
    a.Push( cast( ulong, v.id ) )
end sub

'' The array's own name, which is what turns the runtime message from 'array
'' accessed with invalid index' into "'A' accessed with invalid index".
''
'' UPPERCASED, which is fbc's spelling here and not a stylistic choice: FreeBASIC
'' identifiers are case-insensitive, so 'A' is the canonical form of a name written
'' 'a'. Measured -- fbc prints 'A' for 'dim a(0 to 9)'.
''
'' EMPTY WHEN THE TARGET IS NOT A PLAIN IDENTIFIER. A subscript on a field or on a
'' returned array has no single name to give, and the runtime prints the generic
'' word for an empty string. That is fbc's own fallback rather than a gap here: its
'' legacy fb_ArraySngBoundChk forwards a NULL name for exactly this case.
private function ArrayNameOf_( byref c as Ctx, byval target as Tko.NodeId ) as string
    if target = Tko.NODE_NONE then return ""
    if c.ast->Kind( target ) <> Tko.N_IDENT then return ""
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, target )].data )]
    return ucase( c.names->Spelling( ip->name ) )
end function

'' ONE DIMENSION OF ONE SUBSCRIPT, checked before it becomes an address.
''
'' fbc emits one call per DIMENSION rather than one per access, and the shape was
'' measured from its own '-gen llvm -r' output:
''
''     fb_ArraySngBoundChkEx( idx, ubound, line, filename, varname )
''
'' THE SINGLE-BOUND FORM IS FOR AN LBOUND OF 0. The runtime declares those first two
'' parameters unsigned on purpose: a negative index reinterpreted as unsigned becomes
'' enormous and fails the one 'idx > ubound' test, which is one comparison instead of
'' two. An lbound of anything else takes fb_ArrayBoundChkEx and its signed triple.
''
'' THE RESULT IS IGNORED, and that is correct HERE and nowhere else. The runtime
'' returns null when the index is in range and a resume address when it is not -- but
'' tiko-lang does not implement ON ERROR (lowerintr.bas), so no handler can be
'' installed and the out-of-range path never returns: it reaches fb_Die. fbc branches
'' on the result because '-ex' gives it somewhere to branch TO. When RESUME arrives,
'' this is the site that changes with it.
''
'' NO fb_ErrorSetFuncName, DELIBERATELY. fbc calls it at entry and again on the way
'' out, so its abort reads 'oob.bas::()' where this one reads 'oob.bas()' -- the file
'' is named and the function slot is empty. Setting it at module level only, which is
'' the cheap half, would leave every check inside a SUB reporting {MODLEVEL}: a name
'' that is wrong rather than missing. The save/restore pair that makes it right
'' belongs with the procedure lowering.
''
'' NOTHING IS EMITTED WHEN THE BOUNDS ARE NOT CONSTANT. A dynamic array carries its
'' bounds in a descriptor and takes a different path entirely; a fixed one whose
'' bounds did not fold has nothing to compare against, and inventing a limit would
'' turn a missing check into a wrong one.
sub EmitBoundsCheck_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval target as Tko.NodeId, _
      byval at as Tko.TypeId, byval k as long, byref iv as MirValue, _
      byval offTy as MirType )

    dim as boolean loKnown = false, hiKnown = false
    dim as longint lo = c.types->ArrayBound( at, k, false, loKnown )
    dim as longint hi = c.types->ArrayBound( at, k, true, hiKnown )
    if (loKnown = false) orelse (hiKnown = false) then return

    '' THE SOURCE FILE, not the module stem. Measured against fbc: its abort says
    '' 'at line 4 of oob.bas::()', and the string it hands the check is the path as
    '' written on the command line. Passing the stem produced 'of oob()' -- the same
    '' failure, naming the wrong thing.
    dim as Tko.DecodedLoc fd = c.srcMgr->Decode( c.ast->Loc( id ) )
    dim as MirValue fileV = LowerTextAddr( c, c.srcMgr->PathOf( fd.file ) )
    dim as MirValue nameV = LowerTextAddr( c, ArrayNameOf_( c, target ) )
    dim as MirValue lineV = ConstInt( c, fd.lineNo, MT_I32 )

    dim as FB.Array( of ulong ) ba
    PushArg_( ba, iv )
    if lo <> 0 then PushArg_( ba, ConstInt( c, lo, offTy ) )
    PushArg_( ba, ConstInt( c, hi, offTy ) )
    PushArg_( ba, lineV )
    PushArg_( ba, fileV )
    PushArg_( ba, nameV )

    if lo = 0 then
        EmitRtl( c, RTL_ARRAY_SNG_BOUND_CHK_EX, ba )
    else
        EmitRtl( c, RTL_ARRAY_BOUND_CHK_EX, ba )
    end if
end sub

'' -exx: A POINTER DEREFERENCE, CHECKED FOR NULL.
''
'' fb_NullPtrChk( p, line, filename ), measured from fbc's own IR, and the abort
'' it produces is runtime error 7 with exit code 7.
''
'' THE RESULT IS IGNORED for the reason the bounds check gives: without ON ERROR
'' there is no handler to resume into, so the failing path never returns.
''
'' ONLY A DEREFERENCE, not every pointer that is read. '*p' is the shape fbc checks;
'' passing a null pointer to a procedure, or storing one, is legal and is not.
sub EmitNullCheck_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref pv as MirValue )

    if pv.kind = cast( ubyte, MV_NONE ) then return
    dim as Tko.DecodedLoc fd = c.srcMgr->Decode( c.ast->Loc( id ) )
    dim as MirValue fileV = LowerTextAddr( c, c.srcMgr->PathOf( fd.file ) )

    dim as FB.Array( of ulong ) na
    PushArg_( na, pv )
    PushArg_( na, ConstInt( c, fd.lineNo, MT_I32 ) )
    PushArg_( na, fileV )
    EmitRtl( c, RTL_NULL_PTR_CHK, na )
end sub

end namespace
