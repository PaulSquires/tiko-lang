'' resolvertl.bas -- A DECLARATION NAMED LIKE A RUNTIME PROCEDURE: fbc's error 4.
''
'' Included from resolveintr.bas, inside Resolve's namespace, before WalkExpr.
''
'' fbc PREDECLARES its runtime procedures in the global namespace, and they are not
'' reserved words: 'sub Run( )', 'dim as long timer', 'const beep = 1' and a parameter
'' called 'kill' are each error 4, "Duplicated definition". tiko accepted all of them --
'' a user 'sub Run' simply became the program's Run -- except where its prelude happened
'' to declare the name and a different signature failed TKO0793 instead.
''
'' THE RULE, measured on fbc-modern 1.20, 2026-09-24, with 'run':
''
''     sub / function / declare at module level            error 4
''     dim, dim shared, redim, const, a 'for' counter       error 4, inside 'scope' too
''     a local in a module-level procedure                  error 4
''     a parameter of a module-level DEFINITION             error 4
''     anything inside a NAMESPACE or a METHOD              accepted
''     a parameter of a prototype or a procedure type       accepted
''     a field, a member procedure, an enum member, a type  accepted
''
'' ...and an OVERLOADABLE runtime procedure -- 'hex', 'sleep' -- takes a new overload:
'' 'sub Hex( )' compiles, 'dim as long hex' does not. '#define run' is error 4 as well,
'' and is the preprocessor's, not this.

'' THE NAMES, measured one by one: 'dim as long NAME' is fbc's error 4 for every one, and
'' tiko accepted every one. The candidates came from fbc's rtl-*.bas tables and the list is
'' the probe's. The first group also took a new overload.
private function RtlProcName_( byref nm as string, byref overloadable as boolean ) as boolean
    overloadable = false
    select case nm
    case _
        "bin", "bsave", "dir", "dylibsymbol", "getmouse", "hex", "imageinfo", "left", "oct", _
        "right", "screencontrol", "screenglproc", "screeninfo", "sleep", "val", "valint", _
        "vallng", "valuint", "valulng", "wbin", "whex", "woct"
        overloadable = true
        return true
    case _
        "allocate", "beep", "bload", "callocate", "chain", "chdir", "clear", "cls", "command", _
        "condbroadcast", "condcreate", "conddestroy", "condsignal", "condwait", "csrlin", _
        "curdir", "date", "deallocate", "dylibfree", "dylibload", "environ", "eof", "erfn", _
        "erl", "ermn", "exec", "exepath", "flip", "fre", "freefile", "getjoystick", "getkey", _
        "imageconvertrow", "imagedestroy", "inkey", "inp", "kill", "loc", "locate", "lof", _
        "lpos", "mkdir", "multikey", "mutexcreate", "mutexdestroy", "mutexlock", "mutexunlock", _
        "out", "pcopy", "pmap", "pointcoord", "pos", "randomize", "reallocate", "reset", _
        "rmdir", "rnd", "run", "screencopy", "screenevent", "screenlist", "screenlock", _
        "screenptr", "screenres", "screenset", "screensync", "screenunlock", "setdate", _
        "setenviron", "setmouse", "settime", "shell", "space", "stop", "system", _
        "threadcreate", "threadwait", "time", "timer", "wait", "windowtitle", "wspace"
        return true
    end select
    return false
end function

'' Does scope sc reach module level without passing a NAMESPACE or a TYPE? A method's
'' parameters and locals are accepted: 'sub T.m( byval kill as long )' compiles. (A
'' parameter named like a MEMBER of T is fbc's error 4 too, but that is another rule.)
private function RtlGlobalChain_ ( byref c as Ctx, byval sc as Tko.ScopeId ) as boolean
    for guard as long = 0 to 255
        if sc = Tko.SCOPE_NONE then return false
        dim as Tko.SymScope ptr ss = c.syms->ScopeAt( sc )
        if ss = 0 then return false
        select case ss->kind
        case Tko.SCOPEK_GLOBAL, Tko.SCOPEK_MODULE
            return true
        case Tko.SCOPEK_NAMESPACE, Tko.SCOPEK_TYPE
            return false
        end select
        sc = ss->parent
    next
    return false
end function

'' One report per node: Resolve revisits a declaration whose type was not ready.
private sub RtlReport_ ( byref c as Ctx, byval n as Tko.NodeId, byval nm as Tko.InternId )
    for i as long = 0 to c.rtlSeen.Count - 1
        if c.rtlSeen[i] = cast( ulong, n ) then return
    next
    c.rtlSeen.Push( cast( ulong, n ) )
    c.diags->Report( Tko.TKO0813, Tko.PointRange( c.ast->Loc( n ) ), c.names->Spelling( nm ) )
end sub

private function RtlNameAt_ _
    ( byref c as Ctx, byval nm as Tko.InternId, byval isProc as boolean ) as boolean
    if nm = 0 then return false
    dim as boolean over
    if RtlProcName_( Tko.Text.LowerAscii( c.names->Spelling( nm ) ), over ) = false then return false
    return (isProc = false) orelse (over = false)
end function

sub RtlNameClash_ ( byref c as Ctx, byval id as Tko.NodeId, byval here as Tko.ScopeId )
    dim as Tko.NodeKind k = c.ast->Kind( id )
    select case k
    case Tko.N_VAR, Tko.N_CONST, Tko.N_FOR, Tko.N_PROC
    case else
        return
    end select
    '' The prelude declares these very names, and a #cinclude binding is unmeasured.
    dim as Tko.SourceFile ptr sf = c.srcMgr->FileAt( c.srcMgr->Decode( c.ast->Loc( id ) ).file )
    if sf = 0 then return
    if sf->isVirtual then return
    dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
    select case k
    case Tko.N_VAR, Tko.N_CONST
        if RtlGlobalChain_( c, here ) = false then return
        for i as long = 0 to sp->count - 1
            dim as Tko.NodeId it = cast( Tko.NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( it ) <> Tko.N_VAR_ITEM then continue for
            '' 'dim shared as integer NS.U.val' DEFINES a static member: qualified, not new.
            if StmtOf( c, it )->ownerName <> 0 then continue for
            dim as Tko.InternId inm = StmtOf( c, it )->name
            if RtlNameAt_( c, inm, false ) then RtlReport_( c, it, inm )
        next
    case Tko.N_FOR
        if sp->c = Tko.NODE_NONE then return             '' no 'as': declares nothing
        if RtlGlobalChain_( c, here ) = false then return
        dim as Tko.InternId fnm = IdentNameOf( c, sp->a )
        if RtlNameAt_( c, fnm, false ) then RtlReport_( c, sp->a, fnm )
    case Tko.N_PROC
        if (sp->extra and Tko.PF_GENERIC_PROC) <> 0 then return
        dim as boolean isDef = (sp->b <> Tko.NODE_NONE)     '' a DEFINITION has a body
        '' The procedure's OWN scope, when Collect gave it one, is not where it is declared.
        dim as Tko.ScopeId outer = here
        dim as Tko.SymScope ptr hs = c.syms->ScopeAt( here )
        if hs <> 0 then
            if hs->kind = cast( ubyte, Tko.SCOPEK_PROC ) then outer = hs->parent
        end if
        '' A METHOD DEFINITION 'sub T.Run' is a member and so not this, nor its parameters.
        if (c.ast->nodes[cast( long, id )].flags and Tko.NF_QUALIFIED) = 0 then
            select case cast( Tko.TokenKind, sp->op )
            case Tko.KW_SUB, Tko.KW_FUNCTION
                if RtlGlobalChain_( c, outer ) andalso RtlNameAt_( c, sp->name, true ) then
                    RtlReport_( c, id, sp->name )
                end if
            end select
        end if
        if isDef = false then return
        if RtlGlobalChain_( c, here ) = false then return
        for i as long = 0 to sp->count - 1
            dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
            dim as Tko.InternId pnm = StmtOf( c, prm )->name
            if RtlNameAt_( c, pnm, false ) then RtlReport_( c, prm, pnm )
        next
    end select
end sub
