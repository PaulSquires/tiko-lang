'' instframe.bas -- WHICH INSTANTIATION a re-parsed generic body belongs to (T16).
''
'' Included from generic.bas, inside namespace Tko.Resolve, before the code that queues
'' and drains instantiations.
''
'' A generic's body is checked once per instantiation, against the real type -- so a demand
'' the type cannot meet ('a > b' on a type with no '>') is an error IN THE BODY, and that is
'' the right place to point. What was missing was everything else: TKO0903, "in
'' instantiation of '%0'", was declared and reported from nowhere, so the error named the
'' generic's line and not the line that had asked for the instantiation. In a program with
'' one instantiation that is an annoyance; with thirty it is a search.
''
'' THE SHAPE, clang's: a FRAME per instantiation -- its text, the line that asked for it,
'' and the frame that was active when it was asked for, which is what makes the chain
'' through an instantiation that instantiates another. The frame is made when the
'' instantiation is QUEUED, because that is the one moment the asking line is in hand:
'' InstantiateGeneric_ has the type reference, InstantiateProcAt_ the call. The body is
'' re-parsed later, when the queue drains, and is MARKED with the frame -- the N_PROC and
'' every lambda hoisted out of it -- in SemanticInfo, where every later pass can read it.
'' A pass entering a marked body enters its frame (DiagnosticEngine.EnterInst), and
'' whatever it reports meanwhile is rendered with the chain as notes. The resolve walk of
'' the body happens inside the drain; visibility.bas walks the bodies again (visinst.bas).
''
'' THE TEXT is the generic's own spelling and the argument types as the type table names
'' them: 'Ranked( of opaque_ )'. The type names are the ones every other diagnostic uses,
'' folded spelling included -- that is T34's to change, everywhere at once, not here.

'' The frame for one instantiation asked for at 'at_', or 'fallback' when there is no
'' asking node -- the global operators instantiated alongside a generic TYPE, which belong
'' to that type's frame.
function InstFrameFor_ _
    ( byref c as Ctx, byval at_ as Tko.NodeId, byval gname as Tko.InternId, _
      byref argTypes as containers.Array( of ulong ), byval fallback as long ) as long

    if at_ = Tko.NODE_NONE then return fallback
    dim as string t = c.names->Spelling( gname ) & "( of "
    for i as long = 0 to argTypes.Count - 1
        if i > 0 then t &= ", "
        t &= c.types->Name( cast( Tko.TypeId, argTypes[i] ) )
    next
    t &= " )"
    return c.diags->AddInstFrame( t, Tko.PointRange( c.ast->Loc( at_ ) ), _
                                  c.diags->ActiveInst( ) )
end function

'' Marks a re-parsed body and the lambdas hoisted out of it. A lambda written inside a
'' generic is hoisted into a procedure of its own, so it is walked on its own -- and an
'' error in it belongs to the same instantiation as the body it was written in.
sub MarkInstBody_ _
    ( byref c as Ctx, byval fresh as Tko.NodeId, byref q as Tko.ParserState, _
      byval frame as long )

    if frame <= 0 then return
    c.info->Resize( c.ast->Count( ) )
    c.info->SetInstFrame( fresh, frame )
    for li as long = 0 to q.lambdas.Count - 1
        c.info->SetInstFrame( cast( Tko.NodeId, q.lambdas[li] ), frame )
    next
end sub

'' The frame queued with entry 'k' of a pending list, or 0 for one queued before frames
'' existed -- the lists are parallel, and a short one means none.
function PendingFrame_( byref frames as containers.Array( of ulong ), byval k as long ) as long
    if (k < 0) orelse (k >= frames.Count) then return 0
    return cast( long, frames[k] )
end function
