'' lowerintr.bas -- statement INTRINSICS whose lowering is a runtime call.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. What belongs
'' here is the quirk statements that are calls and nothing else -- no control flow of
'' their own, no state -- with the runtime shape MEASURED from fbc's own C output
'' rather than assumed. PRINT and SWAP live in lowerstr.bas instead, because both are
'' really about the string runtime.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' CLOSE. Every corpus form is the same shape: a list of file numbers, each closed in
'' turn, and an EMPTY list closing all of them.
''
'' Measured from fbc's own C output: 'close #1' is 'fb_FileClose( 1 )', 'close 1' the
'' same call -- the '#' is decoration and the parser has already dropped it -- 'close
'' #1, #2' is two calls in source order, and a bare 'close' is 'fb_FileCloseAll( )'.
'' No new shape, no state, nothing conditional.
''
'' 137 corpus statements across 39 files, none of which lowered before.
function LowerClose( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )

    if sp->count = 0 then
        dim as FB.Array( of ulong ) none_
        EmitRtl( c, RTL_FILE_CLOSEALL, none_ )
        return true
    end if

    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId it = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        '' An ELIDED slot is 'close ,' -- the corpus reaches it through a variadic
        '' macro invoked with an empty argument. fbc closes nothing for it.
        if c.ast->Kind( it ) = Fbx.N_ELIDED then continue for
        dim as MirValue fn = LowerExpr( c, it )
        if fn.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) args
        fn = Coerce( c, fn, MT_I32, IsUnsignedType( c, c.info->TypeOf_( it ) ) )
        args.Push( cast( ulong, fn.kind ) ) : args.Push( cast( ulong, fn.id ) )
        EmitRtl( c, RTL_FILE_CLOSE, args )
    next
    return true
end function

'' ERROR n -- raise a runtime error.
''
'' Measured from fbc's own C:
''
''     void* vr$0 = fb_ErrorThrowEx( 5, 2, (char*)"er.bas", (void*)0, (void*)0 );
''     goto *vr$0;
''
'' Five arguments: the error number, THE SOURCE LINE, THE SOURCE FILE NAME, and two
'' resume labels that are null in -lang fb. The return value is the address of the
'' installed handler, and fbc jumps to it.
''
'' fbx does not implement ON ERROR -- there is no indirect-branch terminator in MIR and
'' no address-of-label value -- so no handler is ever installed, the runtime aborts, and
'' the call does not return. The block therefore ends UNREACHABLE. That is exactly right
'' for all 191 corpus sites, every one of which is an abort path in a runtime header
'' (comptr.bi, result.bi, channel.bi, optional.bi), and it would be WRONG for a program
'' that installed a handler -- which fbx already cannot compile, and still declines.
function LowerError( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->count <> 1 then return false
    dim as Fbx.NodeId numE = cast( Fbx.NodeId, c.ast->children[sp->first] )
    dim as MirValue num = LowerExpr( c, numE )
    if num.kind = cast( ubyte, MV_NONE ) then return false
    num = Coerce( c, num, MT_I32, IsUnsignedType( c, c.info->TypeOf_( numE ) ) )

    dim as Fbx.DecodedLoc d = c.srcMgr->Decode( c.ast->Loc( id ) )
    dim as string fname = ""
    dim as Fbx.SourceFile ptr sf = c.srcMgr->FileAt( d.file )
    if sf <> 0 then fname = c.names->Spelling( sf->displayPath )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, num.kind ) ) : args.Push( cast( ulong, num.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, d.lineNo ) )
    args.Push( cast( ulong, MV_GLOBAL ) )
    args.Push( cast( ulong, c.m->AddStringLiteral( fname, *c.names ) ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_ERROR_THROW, args )

    Terminate( c, MTERM_UNREACHABLE, -1, -1, NoVal( ) )
    c.curBlock = NewBlock( c, "error.after" )
    return true
end function

end namespace
