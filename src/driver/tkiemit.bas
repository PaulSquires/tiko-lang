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
#include once "symbols/modsym.bi"
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
    as Tko.StrVec ptr          aliases
    as Tko.StrVec ptr          spaces
    '' Per token: the qualifier a name a 'using' reached is written with (Qualify_).
    as Tko.StrVec              qual
    '' Token by source location, for the declarations' tokens: open addressing, key loc + 1.
    as FB.Array( of ulong )    hkey
    as FB.Array( of long )     hval
    as long                    hmask
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

'' 'esc.Url', where esc is an import's alias: '__tko_mod_acme_text_esc.Url'.
private function Rewritten_( byref w as TkiWriter_, byval i as long ) as string
    dim as string sp = Tko.PpSpell( w.ctx->sources, w.ctx->names, w.ctx->ppLits, (*w.toks)[i] )
    if len( w.qual[i] ) > 0 then
        if Kind_( w, i - 1 ) <> Tko.TK_DOT then return w.qual[i] & "." & sp
    end if
    if w.aliases->Count = 0 then return sp
    if Kind_( w, i ) <> Tko.TK_IDENT then return sp
    if Kind_( w, i + 1 ) <> Tko.TK_DOT then return sp
    if Kind_( w, i - 1 ) = Tko.TK_DOT then return sp
    dim as string low = Tko.Text.LowerAscii( sp )
    for k as long = 0 to w.aliases->Count - 1
        if (*w.aliases)[k] = low then return (*w.spaces)[k]
    next
    return sp
end function

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
        w.text &= Rewritten_( w, i )
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

'' IS THE PROCEDURE WHOSE HEADER IS a..b-1 GENERIC -- its OWN type parameters, 'f( of T )( ... )'
'' or 'Box( of T ).Get( )'? Only the FIRST parenthesis can say so: a name's '( of' comes
'' before the parameter list, and anything later -- 'byref m as FB.Map( of string, long )',
'' 'as Array( of long )' -- is a generic INSTANCE in a non-generic signature. Taking one of
'' those for the procedure's own made it "generic": its body went into the interface, the
'' importer defined it again, and the link failed on a duplicate symbol.
private function HasTypeParams_( byref w as TkiWriter_, byval a as long, byval b as long ) as boolean
    for i as long = a to b - 1
        select case Kind_( w, i )
        case Tko.KW_AS
            return false
        case Tko.TK_LPAREN
            if Kind_( w, i + 1 ) <> Tko.TK_IDENT then return false
            '' 'of' is no keyword: the word after the parenthesis is.
            return Tko.Text.LowerAscii( w.ctx->names.Spelling( _
                cast( Tko.InternId, (*w.toks)[i + 1].literal ) ) ) = "of"
        end select
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

'' A GENERIC PROCEDURE OR MEMBER BODY, written whole. It goes at the END of its level: the
'' module may have written 'sub Box( of T ).Get( )' above 'type Box', which its unit takes
'' (RFC-0003 §5), and an importer collects the interface in order, so the type must come
'' first there.
private function GenericBody_( byref w as TkiWriter_, byval s as long ) as boolean
    dim as long kw = s
    dim as Tko.TokenKind vis = Kind_( w, s )
    if vis = Tko.KW_PRIVATE then return false
    if vis = Tko.KW_PUBLIC then kw += 1
    select case Kind_( w, kw )
    case Tko.KW_SUB, Tko.KW_FUNCTION, Tko.KW_PROPERTY, Tko.KW_OPERATOR, _
         Tko.KW_CONSTRUCTOR, Tko.KW_DESTRUCTOR
    case else
        return false
    end select
    return HasTypeParams_( w, kw, StmtEnd_( w, s ) )
end function

'' One level's statements, from i to the end of the unit or, in a block, to its 'end' --
'' where i is left pointing past it.
sub Level_( byref w as TkiWriter_, byref i as long, byval sc as Tko.ScopeId, _
            byval closer as Tko.TokenKind )
    dim as FB.Array( of long ) later
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
        if InModule_( w, i ) then
            if GenericBody_( w, i ) then
                later.Push( i )
                later.Push( e )
            else
                Declaration_( w, i, e, sc )
            end if
        end if
        i = e
    wend
    for k as long = 0 to later.Count - 2 step 2
        Chunk_( w, later[k], later[k + 1] )
    next
end sub

'' ONE EXPORTED MACRO'S BODY TOKENS, first..first+count-1, spelled for an importer
'' (RFC-0004 §6). HYGIENE: a name the module declares at module level, not written after a
'' '.', is qualified with the module's own namespace -- '__tko_mod_acme_x.Fail_' -- so it
'' means the module's name wherever the macro expands, and no local of the importer's
'' captures it; the importer reaches it through that namespace, which no lookup filters.
'' A parameter, and any other name, is left as written: a macro meant to name its caller's
'' variable still does. An import alias followed by '.' becomes that module's namespace, as
'' in declarations.
private function MacroBody_ _
    ( byref w as TkiWriter_, byref pr as Tko.PpResult, byval k as long ) as string
    dim as string outp = ""
    dim as long first_ = cast( long, pr.expBodyFirst[k] )
    dim as long count_ = cast( long, pr.expBodyCount[k] )
    dim as Tko.ScopeId modScope = Tko.ModSym.ModuleScope( *w.syms )
    dim as string ns = InterfaceNamespace( w.ctx->modChain )
    dim as long prev = -1
    for i as long = first_ to first_ + count_ - 1
        dim as Tko.Token ptr t = @pr.expBody[i]
        dim as Tko.TokenKind tk = cast( Tko.TokenKind, t->kind )
        dim as boolean realEol = (tk = Tko.TK_EOL) andalso ((t->flags and Tko.TF_COLON) = 0)
        if realEol then
            outp &= !"\n"
            prev = -1
            continue for
        end if
        '' Spaced as the source had it: tokens written side by side stay so -- '#x', '##'.
        if prev >= 0 then
            dim as boolean tight = false
            if (t->flags and Tko.TF_SPACE_BEFORE) = 0 then
                dim as Tko.DecodedLoc a = w.ctx->sources.Decode( pr.expBody[prev].loc )
                dim as Tko.DecodedLoc b = w.ctx->sources.Decode( t->loc )
                tight = (a.file = b.file) andalso (a.offset + cast( long, pr.expBody[prev].length ) = b.offset)
            end if
            if tight = false then outp &= " "
        end if
        dim as string sp = Tko.PpSpell( w.ctx->sources, w.ctx->names, w.ctx->ppLits, *t )
        if tk = Tko.TK_IDENT then
            dim as boolean isParam = false
            for q as long = 0 to cast( long, pr.expParamCount[k] ) - 1
                if pr.expParams[pr.expParamFirst[k] + q] = t->literal then isParam = true
            next
            dim as boolean afterDot = false
            if i > first_ then afterDot = (cast( Tko.TokenKind, pr.expBody[i - 1].kind ) = Tko.TK_DOT)
            dim as boolean beforeDot = false
            if i < first_ + count_ - 1 then beforeDot = (cast( Tko.TokenKind, pr.expBody[i + 1].kind ) = Tko.TK_DOT)
            if (isParam = false) andalso (afterDot = false) then
                dim as string low = Tko.Text.LowerAscii( sp )
                dim as boolean done_ = false
                if beforeDot then
                    for a as long = 0 to w.aliases->Count - 1
                        if (*w.aliases)[a] = low then
                            sp = (*w.spaces)[a]
                            done_ = true
                        end if
                    next
                end if
                if done_ = false then
                    dim as Tko.Symbol ptr s = w.syms->SymbolAt( w.syms->LookupLocal( modScope, cast( Tko.InternId, t->literal ) ) )
                    if s <> 0 then
                        if (s->flags and Tko.SYMF_MODSRC) <> 0 then sp = ns & "." & sp
                    end if
                end if
            end if
        end if
        outp &= sp
        prev = i
    next
    return outp
end function

'' THE MACROS THE MODULE '#export's, each under its interface name (PpModMacroName), which
'' only 'alias.NAME' in an importer expands.
private function ExportedMacros_( byref w as TkiWriter_, byref pr as Tko.PpResult ) as string
    dim as string r = ""
    for k as long = 0 to pr.expName.Count - 1
        dim as ulong fl = pr.expFlags[k]
        dim as string head = Tko.PpModMacroName( w.ctx->modChain, pr.expName[k] )
        if (fl and 1) <> 0 then
            head &= "("
            dim as long pc = cast( long, pr.expParamCount[k] )
            for q as long = 0 to pc - 1
                if q > 0 then head &= ", "
                head &= w.ctx->names.Spelling( cast( Tko.InternId, pr.expParams[pr.expParamFirst[k] + q] ) )
                if ((fl and 4) <> 0) andalso (q = pc - 1) then head &= "..."
            next
            head &= ")"
        end if
        dim as string body = MacroBody_( w, pr, k )
        if (fl and 2) <> 0 then
            r &= "#macro " & head & !"\n" & body & !"\n" & "#endmacro" & !"\n"
        else
            r &= "#define " & head & " " & body & !"\n"
        end if
    next
    return r
end function

'' ------------------------------------------------ a name a 'using' reached, qualified
''
'' A MODULE FILE'S 'using' STAYS IN THE MODULE. 'using core' followed by 'declare function
'' F( byref v as DVARIANT )' resolves DVARIANT through the using, but the interface does not
'' repeat the using -- inside the interface's namespace it would let 'com.DVARIANT' find
'' core's name through com, which M16 forbids -- so the importer read a bare DVARIANT and
'' reported it undeclared (fbx/com, 2026-09-29). Such a name is written with the path it
'' needs instead: '__tko_mod_fbx_core.DVARIANT', or 'ns.Inner' after 'using ns'.

private function Encloses_ _
    ( byref w as TkiWriter_, byval outer as Tko.ScopeId, byval inner as Tko.ScopeId ) as boolean
    dim as long guard = 0
    while (inner <> Tko.SCOPE_NONE) andalso (guard < 256)
        guard += 1
        if inner = outer then return true
        dim as Tko.SymScope ptr s = w.syms->ScopeAt( inner )
        if s = 0 then exit while
        inner = s->parent
    wend
    return false
end function

'' The namespace an importer names an imported module's scope by, or "".
private function ImportSpace_( byref w as TkiWriter_, byval owner as Tko.SymbolId ) as string
    for k as long = 0 to w.syms->importNs.Count - 1
        if w.syms->importNs[k] = cast( ulong, owner ) then
            return InterfaceNamespace( w.syms->importChains[k] )
        end if
    next
    dim as Tko.Symbol ptr o = w.syms->SymbolAt( owner )
    if o = 0 then return ""
    dim as string low = Tko.Text.LowerAscii( w.ctx->names.Spelling( o->name ) )
    for k as long = 0 to w.aliases->Count - 1
        if (*w.aliases)[k] = low then return (*w.spaces)[k]
    next
    return ""
end function

'' The path symbol 'sid' needs, named from scope 'from_': "" when it is visible there as it is.
private function Qualifier_ _
    ( byref w as TkiWriter_, byval sid as Tko.SymbolId, byval from_ as Tko.ScopeId ) as string
    dim as Tko.Symbol ptr s = w.syms->SymbolAt( sid )
    if s = 0 then return ""
    select case cast( Tko.SymbolKind, s->kind )
    case Tko.SYM_UDT, Tko.SYM_ENUM, Tko.SYM_TYPEDEF, Tko.SYM_CONSTANT, Tko.SYM_ENUMCONST, _
         Tko.SYM_PROC, Tko.SYM_VARIABLE, Tko.SYM_NAMESPACE
    case else
        return ""
    end select
    dim as string path = ""
    dim as Tko.ScopeId sc = s->parent
    dim as long guard = 0
    while (sc <> Tko.SCOPE_NONE) andalso (guard < 64)
        guard += 1
        dim as Tko.SymScope ptr ss = w.syms->ScopeAt( sc )
        if ss = 0 then return ""
        dim as Tko.Symbol ptr ow = w.syms->SymbolAt( ss->owner )
        select case cast( Tko.ScopeKind, ss->kind )
        case Tko.SCOPEK_GLOBAL, Tko.SCOPEK_MODULE
            exit while
        case Tko.SCOPEK_NAMESPACE
            if Encloses_( w, sc, from_ ) then exit while
            if ow = 0 then return ""
            dim as string isp = ImportSpace_( w, ss->owner )
            if len( isp ) > 0 then return isp & iif( len( path ) > 0, ".", "" ) & path
            dim as string nm = w.ctx->names.Spelling( ow->name )
            path = nm & iif( len( path ) > 0, ".", "" ) & path
        case Tko.SCOPEK_TYPE
            '' An enum's constant is also its enclosing scope's name; a type's member is not
            '' written qualified at all.
            if ow = 0 then return ""
            if ow->kind <> cast( ubyte, Tko.SYM_ENUM ) then return ""
        case else
            return ""
        end select
        sc = ss->parent
    wend
    return path
end function

private function TokAt_( byref w as TkiWriter_, byval loc as ulong ) as long
    if w.hmask = 0 then return -1
    dim as ulong h = (loc * 2654435761UL) and cast( ulong, w.hmask )
    while w.hkey[h] <> 0
        if w.hkey[h] = loc + 1 then return w.hval[h]
        h = (h + 1) and cast( ulong, w.hmask )
    wend
    return -1
end function

private sub Qualify_( byref w as TkiWriter_ )
    dim as long n = 0
    for i as long = 0 to w.toks->Count - 1
        w.qual.Push( "" )
        if w.endAt[i] > i then n += w.endAt[i] - i
    next
    dim as long sz = 16
    while sz < n * 2
        sz *= 2
    wend
    w.hmask = sz - 1
    for i as long = 0 to sz - 1
        w.hkey.Push( 0 )
        w.hval.Push( 0 )
    next
    for a as long = 0 to w.toks->Count - 1
        for i as long = a to w.endAt[a] - 1
            dim as ulong loc = cast( ulong, (*w.toks)[i].loc )
            dim as ulong h = (loc * 2654435761UL) and cast( ulong, w.hmask )
            while (w.hkey[h] <> 0) andalso (w.hkey[h] <> loc + 1)
                h = (h + 1) and cast( ulong, w.hmask )
            wend
            if w.hkey[h] = 0 then
                w.hkey[h] = loc + 1
                w.hval[h] = i
            end if
        next
    next
    for id as long = 1 to w.ast->Count( )
        dim as Tko.NodeId nd = cast( Tko.NodeId, id )
        dim as Tko.InternId nm = Tko.INTERN_NONE
        select case w.ast->Kind( nd )
        case Tko.N_TYPEREF
            dim as Tko.StmtPayload ptr tp = @w.ast->stmts[cast( long, w.ast->nodes[id].data )]
            if tp->ownerName <> Tko.INTERN_NONE then continue for
            nm = tp->name
        case Tko.N_IDENT
            nm = w.ast->idents[cast( long, w.ast->nodes[id].data )].name
        case else
            continue for
        end select
        if nm = Tko.INTERN_NONE then continue for
        dim as Tko.SymbolId sid = w.info->RefOf( nd )
        dim as Tko.ScopeId from_ = w.info->ScopeOf( nd )
        '' A PARAMETER'S DEFAULT is bound at each call, not where it is written, so its names
        '' carry no binding here: looked up from the declaration's scope, usings and all.
        if sid = Tko.SYMBOL_NONE then
            dim as Tko.ScopeId look = from_
            if look = Tko.SCOPE_NONE then look = Tko.ModSym.ModuleScope( *w.syms )
            if w.ast->Kind( nd ) = Tko.N_IDENT then sid = w.syms->Lookup( look, w.ctx->names.Fold( nm ) )
        end if
        if sid = Tko.SYMBOL_NONE then continue for
        dim as string q = Qualifier_( w, sid, from_ )
        if len( q ) = 0 then continue for
        dim as long t = TokAt_( w, cast( ulong, w.ast->Loc( nd ) ) )
        if t < 0 then continue for
        '' The node starts at its first token -- 'const', '..' -- and the name is a few on.
        dim as string want = Tko.Text.LowerAscii( w.ctx->names.Spelling( nm ) )
        for j as long = t to t + 6
            if Kind_( w, j ) <> Tko.TK_IDENT then continue for
            dim as string sp = Tko.PpSpell( w.ctx->sources, w.ctx->names, w.ctx->ppLits, (*w.toks)[j] )
            if Tko.Text.LowerAscii( sp ) = want then
                w.qual[j] = q
                exit for
            end if
        next
    next
end sub

function WriteInterface _
    ( byref ctx as Tko.CompilerContext, byref toks as Tko.TokenVec, _
      byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, _
      byref info as Tko.SemanticInfo, byref aliases as Tko.StrVec, _
      byref spaces as Tko.StrVec, byref headers as Tko.StrVec, _
      byval pr as Tko.PpResult ptr ) as string

    dim as TkiWriter_ w
    w.ctx = @ctx : w.toks = @toks : w.ast = @ast : w.syms = @syms : w.info = @info
    w.aliases = @aliases : w.spaces = @spaces
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
    '' ...AND AN OVERLOAD'S DEFINITION IS NOT ITS DECLARATION'S SECOND SIGHTING. OVERLOAD
    '' belongs to the name, so 'declare function F overload( ... )' and the 'function F
    '' overload( ... )' below it are two symbols of one signature in the chain, each the
    '' first sight of its own node -- and both were written, which an importer refused as
    '' TKO0677 (fbx/gui's fbxCWindowPtr). The definition is left out when a declaration of
    '' the same procedure type stands beside it.
    for si as long = 1 to syms.Count( )
        dim as Tko.Symbol ptr ps = syms.SymbolAt( cast( Tko.SymbolId, si ) )
        if ps = 0 then continue for
        if ps->kind <> cast( ubyte, Tko.SYM_PROC ) then continue for
        dim as long pn = cast( long, ps->payload )
        if (pn <= 0) orelse (pn > ast.Count( )) then continue for
        if w.firstSight[pn] = 0 then continue for
        if ast.Kind( cast( Tko.NodeId, pn ) ) <> Tko.N_PROC then continue for
        if ast.stmts[cast( long, ast.nodes[pn].data )].b = Tko.NODE_NONE then continue for
        dim as Tko.SymbolId oid = syms.LookupLocal( ps->parent, ps->name )
        dim as long guard = 0
        while (oid <> Tko.SYMBOL_NONE) andalso (guard < 1000)
            guard += 1
            dim as Tko.Symbol ptr os = syms.SymbolAt( oid )
            if os = 0 then exit while
            if (oid <> cast( Tko.SymbolId, si )) andalso (os->kind = cast( ubyte, Tko.SYM_PROC )) _
               andalso (os->parent = ps->parent) andalso (os->type_ = ps->type_) then
                dim as long on_ = cast( long, os->payload )
                if (on_ > 0) andalso (on_ <= ast.Count( )) then
                    if ast.Kind( cast( Tko.NodeId, on_ ) ) = Tko.N_PROC then
                        if ast.stmts[cast( long, ast.nodes[on_].data )].b = Tko.NODE_NONE then
                            w.firstSight[pn] = 0
                            exit while
                        end if
                    end if
                end if
            end if
            oid = os->nextOverload
        wend
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

    Qualify_( w )

    w.text = "'' tiko-interface 1" & !"\n" & "'' module " & ctx.modChain & !"\n"
    for each h as string in headers
        w.text &= "#include once """ & h & """" & !"\n"
    next
    if pr <> 0 then w.text &= ExportedMacros_( w, *pr )
    w.text &= "namespace " & InterfaceNamespace( ctx.modChain ) & !"\n"
    w.lineFile = 0
    dim as long i = 0
    Level_( w, i, Tko.ModSym.ModuleScope( syms ), 0 )
    w.text &= "end namespace" & !"\n"
    return w.text
end function

end namespace
