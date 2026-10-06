'' pplocal.bas -- '#if' over a procedure's own declarations: PpProcEnter / PpProcLeave and the
'' local notes they undo. #included by pp.bas at the 1500-line cap; PpNoteConst's local branch
'' writes the same log.

sub PpProcEnter( byref st as PpStream )
    if st.engine = 0 then return
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )
    e->procMarks.Push( e->localUndo.Count )
end sub

sub PpProcLeave( byref st as PpStream )
    if st.engine = 0 then return
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )
    if e->procMarks.Count = 0 then return
    dim as long mark = e->procMarks.Pop( )
    while e->localUndo.Count > mark
        dim as longint ov = e->localUndo.Pop( ), om = e->localUndo.Pop( )
        dim as long ix = cast( long, e->localUndo.Pop( ) ), tbl = cast( long, e->localUndo.Pop( ) )
        if tbl = 1 then
            if ix < e->declaredMark.Count then e->declaredMark[ix] = cast( ulong, om )
        elseif tbl = 3 then
            dim as string os_ = e->localUndoStr.Pop( )
            if ix < e->constStr.Count then e->constStr[ix] = os_
        else
            if ix < e->constMark.Count then e->constMark[ix] = cast( ulong, om ) : e->constVal[ix] = ov
        end if
    wend
end sub

sub PpNoteLocalDeclared( byref st as PpStream, byval nm as InternId, byval kind as long )
    if (st.engine = 0) orelse (nm = INTERN_NONE) then return
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )
    if e->procMarks.Count = 0 then return
    dim as long ix = cast( long, nm )
    dim as longint om = 0
    if ix < e->declaredMark.Count then om = e->declaredMark[ix]
    e->localUndo.Push( cast( longint, 1 ) ) : e->localUndo.Push( cast( longint, ix ) ) : e->localUndo.Push( om ) : e->localUndo.Push( cast( longint, 0 ) )
    MarkDeclared_( *e, nm, kind )
end sub

'' A LOCAL CONST'S PREVIOUS VALUE, logged before PpNoteConst overwrites it.
private sub UndoLogConst_( byref e as PpEngine, byval nm as InternId )
    if (e.procMarks.Count = 0) orelse (nm = INTERN_NONE) then return
    dim as long ix = cast( long, nm )
    dim as longint om = 0, ov = 0
    if ix < e.constMark.Count then om = e.constMark[ix] : ov = e.constVal[ix]
    e.localUndo.Push( cast( longint, 2 ) ) : e.localUndo.Push( cast( longint, ix ) ) : e.localUndo.Push( om ) : e.localUndo.Push( ov )
end sub

'' A STRING CONST: its text, by raw InternId, as "=text" ("" is none). A local one logs the old.
sub PpNoteConstStr( byref st as PpStream, byval nm as InternId, byref txt as string, byval isLocal as boolean )
    if (st.engine = 0) orelse (nm = INTERN_NONE) then return
    dim as PpEngine ptr e = cast( PpEngine ptr, st.engine )
    dim as long ix = cast( long, nm )
    while e->constStr.Count <= ix
        e->constStr.Push( "" )
    wend
    if isLocal andalso (e->procMarks.Count > 0) then
        e->localUndo.Push( cast( longint, 3 ) ) : e->localUndo.Push( cast( longint, ix ) ) : e->localUndo.Push( cast( longint, 0 ) ) : e->localUndo.Push( cast( longint, 0 ) )
        e->localUndoStr.Push( e->constStr[ix] )
    end if
    e->constStr[ix] = "=" & txt
end sub

function PpConstStrValue( byref e as PpEngine, byval nm as InternId, byref outs as string ) as boolean
    dim as long ix = cast( long, nm )
    if (nm = INTERN_NONE) orelse (ix >= e.constStr.Count) then return false
    if len( e.constStr[ix] ) = 0 then return false
    outs = mid( e.constStr[ix], 2 )
    return true
end function
