'' ppmodule.bas -- '#module', '#import' and '#export': their form, where they may stand,
'' and the header scan the build graph reads files with (ADR 0017; RFC-0001). #included by
'' pp.bas after directive.bas, like the other parts of the one preprocessor unit.
''
'' ONLY THE FORM IS CHECKED HERE. Where an import leads needs the package search roots, and
'' those are the driver's: src/driver/modresolve.bas. What the preprocessor owns is what it
'' alone can see -- which directive came first, what an '#if' consulted, whether the
'' header has already ended.
''
'' THE HEADER is the part of a file an '#import' may stand in: before the first token, and
'' before any directive but '#module', '#import', '#lang', '#pragma once' and the
'' conditionals. It is what makes a file's imports readable by running the engine only
'' until it ends, which is the whole of the build graph's scan (PpConfig.scanHeader).

namespace Tko

'' Is the directive being read in the ROOT file itself -- not in a header it included, and
'' not in a macro expansion?
private function PpModInRoot_( byref e as PpEngine ) as boolean
    if e.frames.Count <> 1 then return false
    return (e.frames[0].file = e.rootFile)
end function

'' PREDEFINED, for the rule that a condition around an '#import' may test nothing else
'' (TKO0363). Either a macro PpDefineBuiltins made, or a name in the predefine namespace --
'' '__FB_WIN64__' is predefined on Windows and simply absent on Linux, and '#ifdef
'' __FB_WIN64__' must be allowed on both. 'defined' is the operator, not a name.
private function PpModIsPredefName_( byref e as PpEngine, byval id as InternId ) as boolean
    dim as long i = cast( long, id )
    if (i > 0) andalso (i < e.modst.predefMark.Count) then
        if e.modst.predefMark[i] <> 0 then return true
    end if
    dim as string s = Text.LowerAscii( e.names->Spelling( id ) )
    if s = "defined" then return true
    if left( s, 5 ) = "__fb_" then return true
    if left( s, 6 ) = "__tiko" then return true
    return (left( s, 6 ) = "__tko_")
end function

'' Runs between PpDefineBuiltins and PpDefineFromCommandLine, so every macro defined so far
'' is a builtin and every one defined later is the user's.
sub PpModAfterBuiltins( byref e as PpEngine )
    for i as long = 0 to e.macroSlot.Count - 1
        if e.macroSlot[i] = 0 then continue for
        while e.modst.predefMark.Count <= i
            e.modst.predefMark.Push( 0 )
        wend
        e.modst.predefMark[i] = 1
    next
end sub

'' THE FIRST NAME ON THIS DIRECTIVE'S LINE THAT IS NOT PREDEFINED, as written, read WITHOUT
'' consuming anything: the condition is evaluated afterwards from the same tokens. Only the
'' file frame is read -- a condition inside a '#macro' body is not a file's header.
function PpModFirstUserIdent( byref e as PpEngine ) as string
    if e.frames.Count = 0 then return ""
    dim as PpFrame ptr f = @e.frames[e.frames.Count - 1]
    if f->file = FILE_NONE then return ""
    for p as long = f->pos to f->toks->Count - 1
        dim as Token t = f->toks->At( p )
        dim as TokenKind k = Tk( t )
        if (k = TK_EOL) orelse (k = TK_EOF) then exit for
        if k <> TK_IDENT then continue for
        dim as InternId id = cast( InternId, t.literal )
        if PpModIsPredefName_( e, id ) = false then return SpellOf( e, t )
    next
    return ""
end function

'' An '#elseif' condition joins its '#if': an '#import' in the '#else' branch is guarded
'' by every condition of the chain, so the first user name of any of them is the one.
sub PpModNoteElse( byref e as PpEngine, byval c as PpCond ptr )
    if len( c->userName ) = 0 then c->userName = PpModFirstUserIdent( e )
end sub

'' TKO0363 for an '#import' inside a condition that consulted a name nobody predefined.
'' Checked whether or not the branch is taken: '#ifdef MYFLAG' around an import is wrong
'' whatever MYFLAG is today, because a file's header must be decidable from the target.
private sub PpModCheckConds_( byref e as PpEngine, byval at as SourceLoc )
    for i as long = 0 to e.conds.Count - 1
        if len( e.conds[i].userName ) = 0 then continue for
        Report( e, TKO0363, at, e.conds[i].userName )
        return
    next
end sub

'' EVERY DIRECTIVE PASSES HERE FIRST, conditionals included, before PpDirective acts on
'' it. It counts the root file's directives for '#module', checks an '#import''s
'' conditions, and ends the header at the first directive the header may not contain.
'' TRUE: the engine is scanning, the header has ended, and nothing more is to be read.
function PpModPreDirective _
    ( byref e as PpEngine, byref word as string, byval at as SourceLoc ) as boolean

    if PpModInRoot_( e ) andalso (word <> "lang") then e.modst.directives += 1
    if word = "import" then PpModCheckConds_( e, at )
    if e.modst.headerClosed then return false
    if Emitting( e ) = false then return false

    select case word
    case "module", "import", "lang", "if", "ifdef", "ifndef", "elseif", "elseifdef", _
         "elseifndef", "else", "endif"
        return false
    case "pragma"
        dim as Token t
        if PeekOnLine( e, t ) then
            if Tk( t ) = TK_IDENT then
                if e.names->Spelling( cast( InternId, t.literal ) ) = "once" then return false
            end if
        end if
    end select

    e.modst.headerClosed = true
    if e.cfg->scanHeader = false then return false
    e.stopped = true
    return true
end function

'' EVERY TOKEN ABOUT TO BE EMITTED PASSES HERE. The first one that is not an end of line
'' ends the header. TRUE: the engine is scanning, and stops before emitting it.
function PpModBeforeEmit( byref e as PpEngine, byref t as Token ) as boolean
    if Tk( t ) = TK_EOL then return false
    e.modst.sawToken = true
    if e.modst.headerClosed then return false
    e.modst.headerClosed = true
    if e.cfg->scanHeader = false then return false
    e.stopped = true
    return true
end function

'' ------------------------------------------------------------------- the form

'' A SEGMENT of an import path or a module name: a letter, then letters, digits and '_',
'' and not a keyword -- it must be usable as a namespace name. "" when it is one, else
'' what is wrong with it.
private function PpModSegmentProblem_( byref e as PpEngine, byref seg as string ) as string
    if len( seg ) = 0 then return "the path has an empty segment"
    if (seg = ".") orelse (seg = "..") then return "'.' and '..' may only begin a path"
    for i as long = 0 to len( seg ) - 1
        dim as ubyte c = seg[i]
        dim as boolean letter = ((c >= 65) andalso (c <= 90)) orelse ((c >= 97) andalso (c <= 122))
        dim as boolean digit = (c >= 48) andalso (c <= 57)
        dim as boolean under = (c = 95)
        dim as boolean later = (i > 0)
        dim as boolean ok = letter orelse (later andalso (digit orelse under))
        if ok = false then return "'" & seg & "' is not a valid name"
    next
    dim as InternId id = e.names->GetString( Text.LowerAscii( seg ) )
    if IsKeywordKind( e.kw->KindOf( id ) ) then return "'" & seg & "' is a keyword"
    return ""
end function

'' WHAT IS WRONG WITH AN IMPORT PATH, or "". A leading './' or a run of '../' makes it
'' relative; what follows is one or more segments separated by '/'.
private function PpModPathProblem_( byref e as PpEngine, byref p as string ) as string
    if len( p ) = 0 then return "the path is empty"
    if instr( p, "\" ) > 0 then return "use '/' to separate the segments of a path"
    dim as long i = 1
    if left( p, 2 ) = "./" then
        i = 3
    else
        while mid( p, i, 3 ) = "../"
            i += 3
        wend
    end if
    dim as string rest = mid( p, i )
    if len( rest ) = 0 then return "the path names no module"
    dim as long st = 1
    do
        dim as long sl = instr( st, rest, "/" )
        dim as string seg = iif( sl = 0, mid( rest, st ), mid( rest, st, sl - st ) )
        dim as string why = PpModSegmentProblem_( e, seg )
        if len( why ) > 0 then return why
        if sl = 0 then exit do
        st = sl + 1
    loop
    return ""
end function

private function PpModLastSegment_( byref p as string ) as string
    dim as long sl = instrrev( p, "/" )
    return mid( p, sl + 1 )
end function

'' THE QUOTED STRING a directive needs next, without its quotes. An escaped or
'' interpolated literal ('!"..."', '$"..."') is not a path.
private function PpModString_ _
    ( byref e as PpEngine, byref what as string, byval at as SourceLoc, _
      byref outs as string ) as boolean

    dim as Token t
    dim as boolean have = PeekOnLine( e, t )
    if have then have = (Tk( t ) = TK_STRING_LIT)
    if have = false then
        Report( e, TKO0364, at, what, "expected a quoted string" )
        SkipToEol( e )
        return false
    end if
    dim as string spelled = SpellOf( e, t )
    dim as long a = instr( spelled, """" )
    dim as long b = instrrev( spelled, """" )
    if (a <> 1) orelse (b <= a) then
        Report( e, TKO0364, at, what, "a path is a plain quoted string" )
        SkipToEol( e )
        return false
    end if
    outs = mid( spelled, 2, b - 2 )
    Advance( e )
    return true
end function

'' The directory the root file is in, by name: what '#module' must be called.
private function PpModDirName_( byref e as PpEngine ) as string
    dim as string p = e.src->AbsPathOf( e.rootFile )
    dim as long n = len( p )
    dim as long lastSep = 0
    dim as long prevSep = 0
    for i as long = 1 to n
        dim as ubyte c = p[i - 1]
        if (c = 47) orelse (c = 92) then
            prevSep = lastSep
            lastSep = i
        end if
    next
    if lastSep = 0 then return ""
    return mid( p, prevSep + 1, lastSep - prevSep - 1 )
end function

'' TKO0992 ONCE PER UNIT, and never from a scan. Until the module build exists (phases P2
'' and P3), a compile that meets '#module' or '#import' cannot do what the file asks.
private sub PpModNotImpl_( byref e as PpEngine, byval at as SourceLoc )
    if e.cfg->scanHeader orelse e.modst.reportedNotImpl then return
    e.modst.reportedNotImpl = true
    Report( e, TKO0992, at, "modules ('#module', '#import'; ADR 0017)" )
end sub

private sub PpModModule_( byref e as PpEngine, byval at as SourceLoc )
    '' A MODULE FILE REACHED BY '#include' (TKO0367): a module is reachable by '#import'
    '' only, and pasting one of its files into another unit would compile it twice.
    dim as long top = e.frames.Count - 1
    dim as boolean included = (top > 0)
    if included then included = (e.frames[top].file <> FILE_NONE)
    if included then included = (e.frames[top].file <> e.rootFile)
    if included then
        dim as string inm
        if PpModString_( e, "#module", at, inm ) = false then return
        Report( e, TKO0367, at, e.src->PathOf( e.frames[top].file ), inm )
        SkipToEol( e )
        return
    end if

    dim as boolean first_ = PpModInRoot_( e ) andalso (e.modst.directives = 1)
    if first_ then first_ = (e.modst.sawToken = false)
    if first_ = false then
        Report( e, TKO0360, at )
        SkipToEol( e )
        return
    end if

    dim as string nm
    if PpModString_( e, "#module", at, nm ) = false then return
    dim as string why = PpModSegmentProblem_( e, nm )
    if len( why ) > 0 then
        Report( e, TKO0364, at, "#module", why )
        SkipToEol( e )
        return
    end if
    dim as Token t
    if PeekOnLine( e, t ) then
        Report( e, TKO0364, at, "#module", "unexpected '" & SpellOf( e, t ) & "' after the name" )
        SkipToEol( e )
        return
    end if

    dim as string dirName = PpModDirName_( e )
    if Text.LowerAscii( nm ) <> Text.LowerAscii( dirName ) then
        Report( e, TKO0361, at, nm, dirName )
    end if
    e.modst.isModuleFile = true
    e.outp->isModuleFile = true
    e.outp->moduleName = nm
    e.outp->moduleLoc = at
    '' Compiled as a module unit, '#module' is what the unit expects (P2). Compiled any other
    '' way, the file is a module file outside its module: not built yet.
    if e.cfg->moduleFiles = 0 then PpModNotImpl_( e, at )
end sub

private sub PpModImport_( byref e as PpEngine, byval at as SourceLoc )
    '' Only the compiled file's own header: a header cannot bring a dependency along.
    dim as boolean placed = PpModInRoot_( e ) andalso (e.modst.headerClosed = false)
    if placed = false then
        Report( e, TKO0362, at )
        SkipToEol( e )
        return
    end if

    dim as string path_
    if PpModString_( e, "#import", at, path_ ) = false then return
    dim as string why = PpModPathProblem_( e, path_ )
    if len( why ) > 0 then
        Report( e, TKO0364, at, "#import", why )
        SkipToEol( e )
        return
    end if

    dim as PpImport rec
    rec.path = path_
    rec.alias_ = PpModLastSegment_( path_ )
    rec.isPublic = false
    rec.loc = at

    dim as Token t
    dim as boolean more = PeekOnLine( e, t )
    if more andalso (Tk( t ) = KW_AS) then
        Advance( e )
        dim as Token a
        dim as boolean named = PeekOnLine( e, a )
        if named then named = (Tk( a ) = TK_IDENT)
        if named = false then
            Report( e, TKO0364, at, "#import", "'as' must be followed by a name" )
            SkipToEol( e )
            return
        end if
        rec.alias_ = SpellOf( e, a )
        Advance( e )
        more = PeekOnLine( e, t )
    end if
    if more andalso (Tk( t ) = KW_PUBLIC) then
        Advance( e )
        if e.modst.isModuleFile = false then
            Report( e, TKO0369, at, "'#import ... public'" )
            SkipToEol( e )
            return
        end if
        rec.isPublic = true
        more = PeekOnLine( e, t )
    end if
    if more then
        Report( e, TKO0364, at, "#import", "unexpected '" & SpellOf( e, t ) & "' after the path" )
        SkipToEol( e )
        return
    end if

    e.outp->imports.Push( rec )
    if e.cfg->importsBuilt = false then PpModNotImpl_( e, at )
end sub

private sub PpModExport_( byref e as PpEngine, byval at as SourceLoc )
    if e.modst.isModuleFile = false then
        Report( e, TKO0369, at, "'#export'" )
        SkipToEol( e )
        return
    end if
    dim as Token t
    dim as boolean named = false
    while PeekOnLine( e, t )
        dim as TokenKind k = Tk( t )
        if k = TK_COMMA then
            Advance( e )
            continue while
        end if
        if k <> TK_IDENT then
            Report( e, TKO0364, t.loc, "#export", "expected a macro name" )
            SkipToEol( e )
            return
        end if
        if MacroFor( e, cast( InternId, t.literal ) ) = 0 then
            Report( e, TKO0365, t.loc, SpellOf( e, t ) )
        end if
        named = true
        Advance( e )
    wend
    if named = false then Report( e, TKO0364, at, "#export", "expected a macro name" )
end sub

'' ------------------------------------------------------------ the module unit
''
'' A MODULE UNIT IS ITS FILES, ONE AFTER ANOTHER, IN ONE ENGINE (PpConfig.moduleFiles). The
'' parser sees one token stream and builds one N_MODULE, which is what generic
'' instantiation needs: it re-parses token ranges of the unit's single token vector. Each
'' file is still read as a file of its own -- its own header, its own '#module' -- and at
'' its end three things happen (RFC-0003 §3):
''
''   - an '#if' still open is TKO0303, as it would be at the end of any file
''   - a file that never said '#module' is TKO0145
''   - every macro the file defined or undefined ITSELF is put back as it was. A macro
''     from a header the file included stays: the next file's '#include once' of the same
''     header reads nothing, so dropping it would leave the declarations without it.

'' The directory part of a path, as written.
private function PpModDirOf_( byref p as string ) as string
    for i as long = len( p ) to 1 step -1
        dim as ubyte c = p[i - 1]
        if (c = 47) orelse (c = 92) then return left( p, i - 1 )
    next
    return "."
end function

'' A DEFINITION OR UNDEFINITION IS ABOUT TO CHANGE m. Recorded, with m as it is now, when
'' the directive stands in the module file itself -- the innermost file frame is the root
'' -- and not in a header it included.
sub PpModJournal( byref e as PpEngine, byval m as PpMacro ptr )
    if e.cfg->moduleFiles = 0 then return
    for k as long = e.frames.Count - 1 to 0 step -1
        if e.frames[k].file = FILE_NONE then continue for
        if e.frames[k].file <> e.rootFile then return
        exit for
    next
    e.modst.journalSlot.Push( cast( ulong, SlotOf( e, m->name ) ) )
    e.modst.journalMac.Push( *m )
end sub

'' The end of one file of a module unit, whether or not another follows.
sub PpModEndFile( byref e as PpEngine )
    if e.cfg->moduleFiles = 0 then return
    if e.modst.isModuleFile = false then
        dim as string p = e.src->PathOf( e.rootFile )
        Report( e, TKO0145, e.src->LocFor( e.rootFile, 0 ), p, PpModDirOf_( p ) )
    end if
    for k as long = e.modst.journalSlot.Count - 1 to 0 step -1
        e.macros[e.modst.journalSlot[k] - 1] = e.modst.journalMac[k]
    next
    e.modst.journalSlot.Clear( )
    e.modst.journalMac.Clear( )
end sub

'' THE ROOT FILE HAS REACHED ITS EOF, which PeekTok is about to hand out. The file's end is
'' dealt with HERE, once, and not in PpFinish: a compile's parser stops at the EOF and never
'' asks for more, so PpFinish never ran and an '#if' left open at the end of a file was
'' accepted -- fbc refuses it, error 290 (measured 2026-09-27). If the unit has another
'' file, start it in place of the EOF, which is then never emitted, and say TRUE. One end
'' of line goes between the two, so a last line with no newline cannot run into the next
'' file's first.
function PpModNextFile( byref e as PpEngine ) as boolean
    if e.modst.rootEnded then return false
    dim as IdVec ptr files = e.cfg->moduleFiles
    dim as boolean more = false
    if files <> 0 then more = (e.modst.fileIndex + 1 < files->Count)

    if e.cfg->scanHeader = false then
        while e.conds.IsEmpty( ) = false
            Report( e, TKO0303, e.conds[e.conds.Count - 1].loc )
            e.conds.Pop( )
        wend
        PpModEndFile( e )
    end if
    if more = false then
        e.modst.rootEnded = true
        return false
    end if
    PopFrame( e )

    e.modst.fileIndex += 1
    dim as FileId nx = cast( FileId, (*files)[e.modst.fileIndex] )
    e.rootFile = nx
    e.modst.directives = 0
    e.modst.sawToken = false
    e.modst.headerClosed = false
    e.modst.isModuleFile = false
    PushFrame( e, PpLexFile( e, nx ), INTERN_NONE, nx, false )

    dim as TokenVec ptr sep = new TokenVec
    dim as Token t
    t.kind = cast( ushort, TK_EOL )
    t.flags = 0
    t.loc = e.src->LocFor( nx, 0 )
    t.length = 0
    t.literal = 0
    sep->Push( t )
    PushFrame( e, sep, INTERN_NONE, FILE_NONE, true )
    return true
end function

'' '#cmdline' IN A MODULE FILE (TKO0366): a restart re-reads the whole command line,
'' which belongs to whoever compiles the program, not to one of its modules. TRUE when
'' refused, with the line consumed.
function PpModRefuse( byref e as PpEngine, byref what as string, byval at as SourceLoc ) as boolean
    if e.modst.isModuleFile = false then return false
    Report( e, TKO0366, at, what )
    SkipToEol( e )
    return true
end function

sub PpModDirective( byref e as PpEngine, byref word as string, byval at as SourceLoc )
    select case word
    case "module" : PpModModule_( e, at )
    case "import" : PpModImport_( e, at )
    case else     : PpModExport_( e, at )
    end select
end sub

end namespace
