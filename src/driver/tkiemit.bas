'' tkiemit.bas -- a module's interface, written as tiko source (ADR 0017; RFC-0004 §2-3).
''
'' NOTHING IS PRINTED FROM SYMBOLS. The parser recorded where every declaration of the unit
'' lies in the token vector (ast.declRanges), and the interface is those tokens, spelled
'' back after preprocessing -- so it names nothing a macro wrote, which is what makes it
'' hermetic, and it says exactly what the module declared, because it is what the module
'' wrote. The walk is over the unit's MODULE LEVEL: declarations in a module file, outside
'' any procedure, through any number of namespaces. What each becomes:
''
''     sub / function / operator      'declare' and its header; the body stays behind
''     a type's member, out of line   nothing: the type's own 'declare' is the interface
''     a generic, and its members     verbatim, bodies and all: an importer instantiates it
''     declare, type, union, enum,
''     const, type alias, extern      verbatim
''     dim shared                     'extern', linking by the module's own name for it
''     namespace                      the block, holding what was chosen from inside it
''
'' 'private' leaves anything out. 'public' is written as it was, and in an importer it is
'' what separates the names it may use from the ones that are only there for a generic's
'' body to find (RFC-0002 §3).

#include once "driver/tkiemit.bi"
#include once "pp/pp.bi"
#include once "symbols/mangle.bi"
#include once "support/text.bi"

namespace Tko.Modules

type TkiWriter_
    as Tko.CompilerContext ptr ctx
    as Tko.TokenVec ptr        toks
    as Tko.AstArena ptr        ast
    as Tko.SymbolTable ptr     syms
    as Tko.SemanticInfo ptr    info
    '' Where the declaration starting at each token ends (exclusive), 0 where none starts.
    as FB.Array( of long )     endAt
    as FB.Array( of long )     nodeAt
    '' A procedure's FIRST DECLARATION, by node: the symbol keeps it as its payload. Only
    '' that one is written -- fbc refuses a second 'declare' of one signature, and a
    '' definition that follows its 'declare' adds nothing an importer can see.
    as FB.Array( of ubyte )    firstSight
    as string                  text
    '' The source line the next output line stands for, so '#line' is written only when
    '' the two part.
    as ulong                   lineFile
    as long                    lineNo
    as boolean                 atLineStart
    as long                    prevTok
end type

function InterfaceNamespace( byref chain as string ) as string
    dim as string s = "__tko_mod_" & chain
    for i as long = 0 to len( s ) - 1
        if s[i] = asc( "." ) then s[i] = asc( "_" )
    next
    return s
end function

private function Kind_( byref w as TkiWriter_, byval i as long ) as Tko.TokenKind
    if (i < 0) orelse (i >= w.toks->Count) then return Tko.TK_EOF
    return cast( Tko.TokenKind, (*w.toks)[i].kind )
end function

private function FileOf_( byref w as TkiWriter_, byval i as long ) as ulong
    return cast( ulong, w.ctx->sources.Decode( (*w.toks)[i].loc ).file )
end function

private function InModule_( byref w as TkiWriter_, byval i as long ) as boolean
    dim as ulong f = FileOf_( w, i )
    for each m as ulong in w.ctx->modFiles
        if m = f then return true
    next
    return false
end function

'' The end of line that ends the statement starting at i -- a ':' counts.
private function StmtEnd_( byref w as TkiWriter_, byval i as long ) as long
    dim as long j = i
    while (Kind_( w, j ) <> Tko.TK_EOL) andalso (Kind_( w, j ) <> Tko.TK_EOF)
        j += 1
    wend
    return j
end function

private sub NewLine_( byref w as TkiWriter_ )
    w.text &= !"\n"
    w.atLineStart = true
    w.lineNo += 1
    w.prevTok = -1
end sub

'' AT THE START OF AN OUTPUT LINE, the '#line' that puts token i where the module wrote
'' it -- when the line in hand no longer does. A token a header's macro wrote has no line
'' in the module to be put on.
private sub Settle_( byref w as TkiWriter_, byval i as long )
    if w.atLineStart = false then return
    if InModule_( w, i ) = false then return
    dim as Tko.DecodedLoc d = w.ctx->sources.Decode( (*w.toks)[i].loc )
    if (cast( ulong, d.file ) = w.lineFile) andalso (d.lineNo = w.lineNo) then return
    '' fbc's '#line N' numbers ITS OWN line N, so the line after it is N + 1.
    w.text &= "#line " & (d.lineNo - 1) & " """ & w.ctx->sources.AbsPathOf( d.file ) & """" & !"\n"
    w.lineFile = cast( ulong, d.file )
    w.lineNo = d.lineNo
end sub

'' ONE TOKEN, spaced so it re-lexes as itself: tokens the source wrote side by side stay
'' side by side -- the lexer split them once and will again -- and everything else gets a
'' space, which never joins two tokens into one.
private sub Tok_( byref w as TkiWriter_, byval i as long )
    dim as Tko.Token ptr t = @(*w.toks)[i]
    if w.atLineStart then
        Settle_( w, i )
        w.atLineStart = false
    else
        dim as boolean tight = false
        if w.prevTok >= 0 then
            dim as Tko.Token ptr pt = @(*w.toks)[w.prevTok]
            dim as ushort madeUp = Tko.TF_FROM_MACRO or Tko.TF_SYNTHESISED
            if ((t->flags or pt->flags) and madeUp) = 0 then
                if (t->flags and Tko.TF_SPACE_BEFORE) = 0 then
                    dim as Tko.DecodedLoc a = w.ctx->sources.Decode( pt->loc )
                    dim as Tko.DecodedLoc b = w.ctx->sources.Decode( t->loc )
                    tight = (a.file = b.file) andalso (a.offset + cast( long, pt->length ) = b.offset)
                end if
            end if
        end if
        if tight = false then w.text &= " "
    end if
    if Kind_( w, i ) = Tko.TK_EOL then
        w.text &= ":"
    else
        w.text &= Tko.PpSpell( w.ctx->sources, w.ctx->names, w.ctx->ppLits, *t )
    end if
    w.prevTok = i
end sub

'' Tokens a..b-1, a real end of line breaking the output line and a ':' kept as one. A
'' trailing end of line is written as the chunk's own.
private sub Chunk_( byref w as TkiWriter_, byval a as long, byval b as long )
    dim as long e = b
    while (e > a) andalso (Kind_( w, e - 1 ) = Tko.TK_EOL)
        e -= 1
    wend
    for i as long = a to e - 1
        dim as boolean realEol = (Kind_( w, i ) = Tko.TK_EOL) andalso _
                                 (((*w.toks)[i].flags and Tko.TF_COLON) = 0)
        if realEol then
            NewLine_( w )
        else
            Tok_( w, i )
        end if
    next
    if w.atLineStart = false then NewLine_( w )
end sub

private sub Word_( byref w as TkiWriter_, byref s as string )
    if w.atLineStart = false then w.text &= " "
    w.text &= s
    w.atLineStart = false
    w.prevTok = -1
end sub

'' THE SCOPE A DECLARATION'S NAME LANDS IN. A node that opens a scope of its own -- a
'' type, a namespace -- records that one, and its name is declared in the one around it.
private function DeclScope_( byref w as TkiWriter_, byval n as Tko.NodeId ) as Tko.ScopeId
    dim as Tko.ScopeId sc = w.info->ScopeOf( n )
    dim as Tko.SymScope ptr os = w.syms->ScopeAt( sc )
    if os = 0 then return sc
    dim as Tko.Symbol ptr ow = w.syms->SymbolAt( os->owner )
    if ow = 0 then return sc
    dim as Tko.StmtPayload ptr sp = @w.ast->stmts[cast( long, w.ast->nodes[cast( long, n )].data )]
    if ow->name = sp->name then return os->parent
    return sc
end function

'' AT THIS LEVEL, and not in a block of the module's top-level code: a 'scope' or an 'if'
'' there declares into a scope of its own, which no importer can reach.
private function AtLevel_( byref w as TkiWriter_, byval n as Tko.NodeId, byval sc as Tko.ScopeId ) as boolean
    dim as Tko.ScopeId ds = DeclScope_( w, n )
    if ds = Tko.SCOPE_NONE then return true
    return ds = sc
end function

private function HasTypeParams_( byref w as TkiWriter_, byval a as long, byval b as long ) as boolean
    for i as long = a to b - 1
        if Kind_( w, i ) <> Tko.TK_LPAREN then continue for
        if Kind_( w, i + 1 ) <> Tko.TK_IDENT then continue for
        '' 'of' is no keyword: the word after the parenthesis is.
        if w.ctx->names.Spelling( cast( Tko.InternId, (*w.toks)[i + 1].literal ) ) = "of" then return true
    next
    return false
end function

'' 'sub f( ) constructor' is the module's initialiser, not something to call.
private function IsStructor_( byref w as TkiWriter_, byval a as long, byval b as long ) as boolean
    dim as long depth = 0
    for i as long = a + 1 to b - 1
        select case Kind_( w, i )
        case Tko.TK_LPAREN : depth += 1
        case Tko.TK_RPAREN : depth -= 1
        case Tko.KW_CONSTRUCTOR, Tko.KW_DESTRUCTOR
            if depth = 0 then return true
        end select
    next
    return false
end function

'' A PROCEDURE DEFINITION'S HEADER, as a declaration: tokens kw..hEnd-1 after 'declare',
'' less the words a declaration does not take -- 'static' and 'export'.
private sub DeclareHeader_( byref w as TkiWriter_, byval s as long, byval kw as long, byval hEnd as long )
    Settle_( w, s )
    if kw > s then Tok_( w, s )
    Word_( w, "declare" )
    Tok_( w, kw )
    dim as long depth = 0
    for i as long = kw + 1 to hEnd - 1
        dim as Tko.TokenKind k = Kind_( w, i )
        if k = Tko.TK_LPAREN then depth += 1
        if k = Tko.TK_RPAREN then depth -= 1
        if (depth = 0) andalso ((k = Tko.KW_STATIC) orelse (k = Tko.KW_EXPORT)) then continue for
        Tok_( w, i )
    next
    NewLine_( w )
end sub

private function VarLinkName_( byref w as TkiWriter_, byval sc as Tko.ScopeId, byval i as long ) as string
    dim as Tko.InternId nm = cast( Tko.InternId, (*w.toks)[i].literal )
    dim as Tko.SymbolId sid = w.syms->LookupLocal( sc, nm )
    while sid <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = w.syms->SymbolAt( sid )
        if s = 0 then exit while
        if s->kind = cast( ubyte, Tko.SYM_VARIABLE ) then
            return Tko.Mangle.ModuleVarName( *w.syms, sid, w.ctx->names )
        end if
        sid = s->altClass
    wend
    return ""
end function

'' 'dim shared' AS AN EXTERN: each name followed by the alias it links by, and each
'' initialiser dropped -- the storage, and what it starts as, are the module's.
private sub SharedVar_( byref w as TkiWriter_, byval s as long, byval kw as long, _
                        byval e as long, byval n as Tko.NodeId, byval sc as Tko.ScopeId )
    '' The names are the N_VAR_ITEMs', found by location.
    dim as FB.Array( of ulong ) itemLocs
    dim as Tko.StmtPayload ptr sp = @w.ast->stmts[cast( long, w.ast->nodes[cast( long, n )].data )]
    for c as long = 0 to sp->count - 1
        dim as Tko.NodeId item = cast( Tko.NodeId, w.ast->children[sp->first + c] )
        if w.ast->Kind( item ) = Tko.N_VAR_ITEM then itemLocs.Push( cast( ulong, w.ast->nodes[cast( long, item )].loc ) )
    next

    dim as long stop_ = e
    while (stop_ > kw) andalso (Kind_( w, stop_ - 1 ) = Tko.TK_EOL)
        stop_ -= 1
    wend
    Settle_( w, s )
    if kw > s then Tok_( w, s )
    '' 'extern' takes the place of 'dim shared'.
    Word_( w, "extern" )
    dim as long depth = 0
    dim as boolean dropping = false
    dim as long i = kw + 2
    while i < stop_
        dim as Tko.TokenKind k = Kind_( w, i )
        if (k = Tko.TK_LPAREN) orelse (k = Tko.TK_LBRACE) then depth += 1
        if (k = Tko.TK_RPAREN) orelse (k = Tko.TK_RBRACE) then depth -= 1
        if depth = 0 then
            if (k = Tko.TK_EQ) orelse (k = Tko.TK_FATARROW) then dropping = true
            if k = Tko.TK_COMMA then dropping = false
        end if
        if dropping then
            i += 1
            continue while
        end if
        Tok_( w, i )
        dim as boolean isItem = false
        if k = Tko.TK_IDENT then
            for each l as ulong in itemLocs
                if l = cast( ulong, (*w.toks)[i].loc ) then isItem = true
            next
        end if
        if isItem then
            dim as long nameTok = i
            '' ...after its dimensions, if it has them: 'x( 0 to 3 ) alias "..."'.
            if Kind_( w, i + 1 ) = Tko.TK_LPAREN then
                dim as long pd = 0
                do
                    i += 1
                    if Kind_( w, i ) = Tko.TK_LPAREN then pd += 1
                    if Kind_( w, i ) = Tko.TK_RPAREN then pd -= 1
                    Tok_( w, i )
                loop until (pd = 0) orelse (i >= stop_ - 1)
            end if
            dim as string ln = VarLinkName_( w, sc, nameTok )
            if len( ln ) > 0 then Word_( w, "alias """ & ln & """" )
        end if
        i += 1
    wend
    NewLine_( w )
end sub

declare sub Level_( byref w as TkiWriter_, byref i as long, byval sc as Tko.ScopeId, _
                    byval closer as Tko.TokenKind )

'' A BLOCK OF DECLARATIONS -- a namespace, or an 'extern "C"' -- written as its header, what
'' is chosen from inside it, and its end.
private sub Block_( byref w as TkiWriter_, byval s as long, byval sc as Tko.ScopeId, _
                    byval closer as Tko.TokenKind )
    dim as long hEnd = StmtEnd_( w, s )
    '' The scope a namespace opens, down a dotted name: 'namespace a.b'. An extern block
    '' opens none.
    dim as Tko.ScopeId inner = sc
    for j as long = s + 1 to hEnd - 1
        if closer <> Tko.KW_NAMESPACE then exit for
        if Kind_( w, j ) <> Tko.TK_IDENT then continue for
        dim as Tko.SymbolId sid = w.syms->LookupLocal( inner, cast( Tko.InternId, (*w.toks)[j].literal ) )
        dim as Tko.Symbol ptr ns = w.syms->SymbolAt( sid )
        while (ns <> 0) andalso (ns->kind <> cast( ubyte, Tko.SYM_NAMESPACE ))
            ns = w.syms->SymbolAt( ns->altClass )
        wend
        if ns = 0 then return
        inner = ns->inner
    next
    Chunk_( w, s, hEnd )
    dim as long i = hEnd + 1
    Level_( w, i, inner, closer )
    Word_( w, "end " & Tko.Text.LowerAscii( Tko.TokenKindText( closer ) ) )
    NewLine_( w )
end sub

private sub Declaration_( byref w as TkiWriter_, byval s as long, byval e as long, byval sc as Tko.ScopeId )
    dim as Tko.NodeId n = cast( Tko.NodeId, w.nodeAt[s] )
    dim as long kw = s
    dim as Tko.TokenKind vis = Kind_( w, s )
    if (vis = Tko.KW_PUBLIC) orelse (vis = Tko.KW_PRIVATE) then kw += 1
    if vis = Tko.KW_PRIVATE then return
    dim as long hEnd = StmtEnd_( w, s )

    select case Kind_( w, kw )
    case Tko.KW_SUB, Tko.KW_FUNCTION, Tko.KW_PROPERTY, Tko.KW_OPERATOR, _
         Tko.KW_CONSTRUCTOR, Tko.KW_DESTRUCTOR
        if HasTypeParams_( w, kw, hEnd ) then
            Chunk_( w, s, e )
            return
        end if
        '' A MEMBER DEFINED OUT OF LINE: the type's declaration already carries it. A
        '' property, a constructor and a destructor are never anything else here.
        select case Kind_( w, kw )
        case Tko.KW_PROPERTY, Tko.KW_CONSTRUCTOR, Tko.KW_DESTRUCTOR
            return
        end select
        if Kind_( w, kw + 2 ) = Tko.TK_DOT then return
        if IsStructor_( w, kw, hEnd ) then return
        if w.firstSight[cast( long, n )] = 0 then return
        DeclareHeader_( w, s, kw, hEnd )

    case Tko.KW_EXTERN
        if Kind_( w, kw + 1 ) = Tko.TK_STRING_LIT then
            Block_( w, s, sc, Tko.KW_EXTERN )
        else
            Chunk_( w, s, e )
        end if

    case Tko.KW_DECLARE
        Chunk_( w, s, e )

    case Tko.KW_TYPE, Tko.KW_UNION, Tko.KW_ENUM, Tko.KW_CONST
        if AtLevel_( w, n, sc ) then Chunk_( w, s, e )

    case Tko.KW_DIM, Tko.KW_STATIC
        if Kind_( w, kw + 1 ) <> Tko.KW_SHARED then return
        if w.ast->Kind( n ) <> Tko.N_VAR then return
        if AtLevel_( w, n, sc ) = false then return
        SharedVar_( w, s, kw, e, n, sc )

    case Tko.KW_NAMESPACE
        Block_( w, s, sc, Tko.KW_NAMESPACE )
    end select
end sub

'' One level's statements, from i to the end of the unit or, in a block, to its 'end' --
'' where i is left pointing past it.
sub Level_( byref w as TkiWriter_, byref i as long, byval sc as Tko.ScopeId, _
            byval closer as Tko.TokenKind )
    while i < w.toks->Count
        dim as Tko.TokenKind k = Kind_( w, i )
        if k = Tko.TK_EOF then exit while
        if k = Tko.TK_EOL then
            i += 1
            continue while
        end if
        if (closer <> 0) andalso (k = Tko.KW_END) andalso (Kind_( w, i + 1 ) = closer) then
            i = StmtEnd_( w, i ) + 1
            exit while
        end if
        dim as long e = w.endAt[i]
        if e <= i then
            i = StmtEnd_( w, i ) + 1
            continue while
        end if
        if InModule_( w, i ) then Declaration_( w, i, e, sc )
        i = e
    wend
end sub

function WriteInterface _
    ( byref ctx as Tko.CompilerContext, byref toks as Tko.TokenVec, _
      byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, _
      byref info as Tko.SemanticInfo ) as string

    dim as TkiWriter_ w
    w.ctx = @ctx : w.toks = @toks : w.ast = @ast : w.syms = @syms : w.info = @info
    w.atLineStart = true
    w.prevTok = -1
    for j as long = 0 to toks.Count - 1
        w.endAt.Push( 0 )
        w.nodeAt.Push( 0 )
    next
    for j as long = 0 to ast.Count( )
        w.firstSight.Push( 0 )
    next
    for si as long = 1 to syms.Count( )
        dim as Tko.Symbol ptr ps = syms.SymbolAt( cast( Tko.SymbolId, si ) )
        if ps = 0 then continue for
        if ps->kind <> cast( ubyte, Tko.SYM_PROC ) then continue for
        dim as long pn = cast( long, ps->payload )
        if (pn > 0) andalso (pn <= ast.Count( )) then w.firstSight[pn] = 1
    next
    '' The OUTERMOST declaration at a token wins -- the longest range starting there.
    for r as long = 0 to ast.declRanges.Count - 3 step 3
        dim as long a = cast( long, ast.declRanges[r + 1] )
        dim as long b = cast( long, ast.declRanges[r + 2] )
        if (a < 0) orelse (a >= toks.Count) then continue for
        if b > w.endAt[a] then
            w.endAt[a] = b
            w.nodeAt[a] = cast( long, ast.declRanges[r] )
        end if
    next

    w.text = "'' tiko-interface 1" & !"\n" & "'' module " & ctx.modChain & !"\n"
    w.text &= "namespace " & InterfaceNamespace( ctx.modChain ) & !"\n"
    w.lineFile = 0
    '' The unit's MODULE scope, which Collect opens inside the global one.
    dim as Tko.ScopeId modScope = Tko.SCOPE_GLOBAL
    for sc as long = 1 to syms.ScopeCount( )
        dim as Tko.SymScope ptr ss = syms.ScopeAt( cast( Tko.ScopeId, sc ) )
        if ss = 0 then continue for
        if ss->kind = cast( ubyte, Tko.SCOPEK_MODULE ) then
            modScope = cast( Tko.ScopeId, sc )
            exit for
        end if
    next
    dim as long i = 0
    Level_( w, i, modScope, 0 )
    w.text &= "end namespace" & !"\n"
    return w.text
end function

end namespace
