'' mangle.bas -- the Itanium encoder. See mangle.bi for the four FreeBASIC rules and
'' for why every one of them was measured against fbc rather than read off a document.

#include once "symbols/mangle.bi"
#include once "support/text.bi"

namespace Fbx.Mangle

'' -------------------------------------------------------------- substitutions

function Substitutions.Find( byref enc as string ) as long
    for i as long = 0 to items.Count - 1
        if items[i] = enc then return i
    next
    return -1
end function

function Substitutions.FindType( byval t as Fbx.TypeId ) as long
    if t = Fbx.TYPE_NONE then return -1
    for i as long = 0 to keys.Count - 1
        if keys[i] = cast( ulong, t ) then return i
    next
    return -1
end function

sub Substitutions.Add( byref enc as string, byval t as Fbx.TypeId = 0 )
    if (t = 0) andalso (Find( enc ) >= 0) then return
    if (t <> 0) andalso (FindType( t ) >= 0) then return
    items.Push( enc )
    keys.Push( cast( ulong, t ) )
end sub

'' S_ is candidate 0, S0_ is candidate 1, S1_ is candidate 2: the number in the
'' encoding is one LESS than the index, and the first candidate has none at all.
private function SubRef( byval idx as long ) as string
    if idx = 0 then return "S_"
    return "S" & trim( str( idx - 1 ) ) & "_"
end function

'' Itanium <source-name>: the length in decimal, then the characters.
private function SrcName( byref s as string ) as string
    return trim( str( len( s ) ) ) & s
end function

'' ------------------------------------------------------------------ type codes

'' 'types' is the TypeId each component names, or 0 for a namespace. It matters: a
'' TYPE component is the same substitution candidate as that type used as a
'' parameter, so 'operator let( byref rhs as W )' inside W is _ZN1WaSERS_ -- the R
'' refers BACK to the 1W already emitted, and keying it by name alone would miss.
private sub QualifierChain _
    ( byref syms as Fbx.SymbolTable, byval sc as Fbx.ScopeId, _
      byref names as Fbx.Interner, byref outp as FB.Array( of string ), _
      byref outTypes as FB.Array( of ulong ) )

    dim as FB.Array( of string ) rev
    dim as FB.Array( of ulong ) revT
    dim as Fbx.ScopeId cur = sc
    while cur <> Fbx.SCOPE_NONE
        dim as Fbx.SymScope ptr s = syms.ScopeAt( cur )
        if s = 0 then exit while
        if (s->kind = cast( ubyte, Fbx.SCOPEK_NAMESPACE )) orelse _
           (s->kind = cast( ubyte, Fbx.SCOPEK_TYPE )) then
            dim as Fbx.Symbol ptr owner = syms.SymbolAt( s->owner )
            if owner <> 0 then
                rev.Push( Fbx.Text.UpperAscii( names.Spelling( owner->name ) ) )
                if s->kind = cast( ubyte, Fbx.SCOPEK_TYPE ) then
                    revT.Push( cast( ulong, owner->type_ ) )
                else
                    revT.Push( 0 )
                end if
            end if
        end if
        cur = s->parent
    wend
    for i as long = rev.Count - 1 to 0 step -1
        outp.Push( rev[i] )
        outTypes.Push( revT[i] )
    next
end sub



'' __FUNCTION__'s value. Shares the qualifier walk with mangling and nothing else:
'' the result is 'NS.INNER', not '_ZN2NS5INNEREv', and two overloads of one name give
'' the SAME answer because fbc does not distinguish them here.
'' The implicit module-level procedure. fbc emits P( (char*)"__FB_MAINPROC__" ) for a
'' module-level __FUNCTION__, so this is a measured spelling and not a placeholder.
const MAIN_PROC_NAME as string = "__FB_MAINPROC__"

function SourceQualifiedName _
    ( byref syms as Fbx.SymbolTable, byval sid as Fbx.SymbolId, _
      byref names as Fbx.Interner ) as string

    dim as Fbx.Symbol ptr s = syms.SymbolAt( sid )
    if s = 0 then return ""
    dim as FB.Array( of string ) q
    dim as FB.Array( of ulong ) qt
    QualifierChain( syms, s->parent, names, q, qt )
    dim as string r = ""
    for i as long = 0 to q.Count - 1
        r += q[i] & "."
    next
    return r & Fbx.Text.UpperAscii( names.Spelling( s->name ) )
end function


function ProcNameOrMain _
    ( byref syms as Fbx.SymbolTable, byval sid as Fbx.SymbolId, _
      byref names as Fbx.Interner ) as string

    if sid = Fbx.SYMBOL_NONE then return MAIN_PROC_NAME
    dim as string r = SourceQualifiedName( syms, sid, names )
    if len( r ) = 0 then return MAIN_PROC_NAME
    return r
end function

function EnclosingProcName _
    ( byref syms as Fbx.SymbolTable, byval sc as Fbx.ScopeId, _
      byref names as Fbx.Interner ) as string

    dim as Fbx.ScopeId cur = sc
    while cur <> Fbx.SCOPE_NONE
        dim as Fbx.SymScope ptr s = syms.ScopeAt( cur )
        if s = 0 then exit while
        if s->kind = cast( ubyte, Fbx.SCOPEK_PROC ) then
            dim as string r = SourceQualifiedName( syms, s->owner, names )
            if len( r ) > 0 then return r
            exit while
        end if
        cur = s->parent
    wend
    return MAIN_PROC_NAME
end function


'' Measured against fbc, tests/mangle. 'integer' and 'uinteger' are VENDOR EXTENDED
'' types rather than 'x'/'y': they are pointer-sized, so they stay distinct from
'' longint even on a target where both happen to be 64 bits wide.
'' 'is32' is win32: Linux is 64-bit only by decision, so a 32-bit pointer means Windows.
'' INTEGER and UINTEGER are the only codes that move. They are VENDOR EXTENDED on win64
'' because they are pointer-sized and so distinct from every C type; on win32 they are
'' four bytes and coincide with C's long, and fbc spells them 'l' and 'm'.
''
'' That also silently changes the SUBSTITUTION table, which is the part worth watching:
'' a single-letter code is never a substitution candidate, so 'sub S6( a as integer,
'' b as integer )' ends 'Eu7INTEGERS0_' on win64 and plainly 'Ell' on win32. It falls
'' out of IsSubstitutable rather than needing a rule.
private function BuiltinCode _
    ( byval b as Fbx.BuiltinType, byval is32 as boolean ) as string

    if is32 then
        select case b
        case Fbx.TY_INTEGER  : return "l"
        case Fbx.TY_UINTEGER : return "m"
        end select
    end if
    select case b
    case Fbx.TY_BYTE     : return "a"
    case Fbx.TY_UBYTE    : return "h"
    case Fbx.TY_SHORT    : return "s"
    case Fbx.TY_USHORT   : return "t"
    case Fbx.TY_LONG     : return "i"
    case Fbx.TY_ULONG    : return "j"
    case Fbx.TY_INTEGER  : return "u7INTEGER"
    case Fbx.TY_UINTEGER : return "u8UINTEGER"
    case Fbx.TY_LONGINT  : return "x"
    case Fbx.TY_ULONGINT : return "y"
    case Fbx.TY_SINGLE   : return "f"
    case Fbx.TY_DOUBLE   : return "d"
    case Fbx.TY_BOOLEAN  : return "b"
    case Fbx.TY_STRING   : return "8FBSTRING"
    case Fbx.TY_USTRING  : return "9FBUSTRING"
    case Fbx.TY_ZSTRING  : return "c"
    case Fbx.TY_WSTRING  : return "w"
    end select
    return "v"
end function

'' The single-letter builtins are never substitution candidates; everything longer
'' is. Measured: 'sub S6( byval a as integer, byval b as integer )' ends Eu7INTEGERS0_,
'' so the vendor extended forms DO take part.
private function IsSubstitutable( byref enc as string ) as boolean
    return len( enc ) > 1
end function

'' Emit a nested-name prefix, substituting the LONGEST cumulative prefix already
'' seen. The lookup key is always the full literal encoding: once a component has
'' been replaced by S_, appending the next component to that abbreviation produces a
'' key that matches nothing, and every later component gets spelled out in full.
private function EmitPrefix _
    ( byref quals as FB.Array( of string ), byref qualTypes as FB.Array( of ulong ), _
      byref subs as Substitutions ) as string

    dim as string full = ""      '' the literal cumulative prefix -- the KEY
    dim as string body = ""      '' what actually gets emitted
    for i as long = 0 to quals.Count - 1
        dim as string comp = SrcName( quals[i] )
        full += comp
        dim as Fbx.TypeId qt = cast( Fbx.TypeId, qualTypes[i] )
        dim as long hit = -1
        if qt <> 0 then
            hit = subs.FindType( qt )
        else
            hit = subs.Find( full )
        end if
        if hit >= 0 then
            body = SubRef( hit )
        else
            body += comp
            subs.Add( full, qt )
        end if
    next
    return body
end function

function TypeCode _
    ( byval t as Fbx.TypeId, byref types as Fbx.TypeContext, _
      byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
      byref subs as Substitutions ) as string

    if t = Fbx.TYPE_NONE then return "v"

    '' Look the TYPE up before encoding it. Doing it afterwards compares an encoding
    '' whose inner components have already been substituted, which never matches.
    dim as long hit = subs.FindType( t )
    if hit >= 0 then return SubRef( hit )

    dim as string enc = ""

    '' A const qualifier is its own component: K<T>. 'const long ptr' is PKi and
    '' 'byref as const long' is RKi -- in both the K binds to the base type, so it is
    '' stripped here and re-applied around whatever is left.
    if types.IsConst( t ) then
        dim as Fbx.TypeId bare = types.Unqualify( t )
        if bare <> t then
            enc = "K" & TypeCode( bare, types, syms, names, subs )
            subs.Add( enc, t )
            return enc
        end if
    end if

    dim as Fbx.TypeInfo ptr ti = 0
    if cast( long, t ) < types.types.Count then ti = @types.types[cast( long, t )]

    select case types.Kind( t )
    case Fbx.TK_POINTER
        enc = "P" & TypeCode( types.Inner( t ), types, syms, names, subs )

    case Fbx.TK_REFERENCE
        enc = "R" & TypeCode( types.Inner( t ), types, syms, names, subs )

    case Fbx.TK_UDT, Fbx.TK_ENUM, Fbx.TK_FORWARD, Fbx.TK_TYPEDEF
        dim as string nm = ""
        if ti <> 0 then nm = Fbx.Text.UpperAscii( names.Spelling( ti->name ) )
        if len( nm ) = 0 then return "v"
        '' A UDT inside a namespace is a NESTED NAME: N <prefix> <name> E, and the
        '' prefix is usually a substitution because the procedure's own qualifiers
        '' already emitted it -- 'byref as Vec' in namespace BYVAL_OK is NS2_3VECE.
        dim as FB.Array( of string ) q
        dim as FB.Array( of ulong ) qt
        if ti <> 0 then QualifierChain( syms, cast( Fbx.ScopeId, ti->declScope ), names, q, qt )
        if q.Count = 0 then
            enc = SrcName( nm )
        else
            enc = "N" & EmitPrefix( q, qt, subs ) & SrcName( nm ) & "E"
        end if

    case Fbx.TK_PROC
        '' F <return> <params...> E. A function TYPE encodes its return type, unlike
        '' a procedure NAME, which never does.
        dim as string body = "F" & TypeCode( types.Inner( t ), types, syms, names, subs )
        dim as long n = 0
        if ti <> 0 then n = ti->count
        if n <= 0 then
            body += "v"
        else
            for i as long = 0 to n - 1
                dim as Fbx.TypeId pt = cast( Fbx.TypeId, types.pool[ti->first + i] )
                body += TypeCode( pt, types, syms, names, subs )
            next
        end if
        enc = body & "E"

    case Fbx.TK_BUILTIN
        enc = BuiltinCode( types.BuiltinOf( t ), (types.target.pointerBits = 32) )

    case else
        enc = "v"
    end select

    if IsSubstitutable( enc ) = false then return enc
    subs.Add( enc, t )
    return enc
end function

'' ------------------------------------------------------------------ proc names

'' ------------------------------------------------------------------ proc names

private function StmtOf _
    ( byref ast as Fbx.AstArena, byval id as Fbx.NodeId ) as Fbx.StmtPayload ptr
    return @ast.stmts[cast( long, ast.nodes[cast( long, id )].data )]
end function

'' The enclosing NAMESPACE and TYPE names, outermost first. A procedure's own scope
'' and any block scope inside it are not part of its name.

'' A property's emitted name carries its accessor: SIZE__get__ / SIZE__set__. Which
'' one it is comes from the signature -- a getter takes no parameters.
private function PropertySuffix _
    ( byref ast as Fbx.AstArena, byval proc_ as Fbx.NodeId ) as string
    dim as Fbx.StmtPayload ptr sp = StmtOf( ast, proc_ )
    if sp->count > 0 then return "__set__"
    return "__get__"
end function

'' fbc rejects most operators as members ("Operator cannot be a member function"),
'' so only the two that compile are encoded: LET is Itanium's assignment operator,
'' and CAST is a conversion operator whose TARGET TYPE is part of the name -- which
'' is what distinguishes 'operator cast as long' from 'operator cast as string'.
private function OperatorCode _
    ( byref ast as Fbx.AstArena, byval proc_ as Fbx.NodeId, _
      byref types as Fbx.TypeContext, byref syms as Fbx.SymbolTable, _
      byref names as Fbx.Interner, _
      byref info as Fbx.SemanticInfo, byref subs as Substitutions, _
      byref ident as string ) as string

    dim as Fbx.StmtPayload ptr sp = StmtOf( ast, proc_ )
    dim as string nm = Fbx.Text.LowerAscii( names.Spelling( sp->name ) )
    if nm = "let" then return "aS"
    if nm = "cast" then
        return "cv" & TypeCode( info.TypeOf_( sp->a ), types, syms, names, subs )
    end if

    '' FreeBASIC's own operators -- FOR, STEP, NEXT, the custom loop protocol -- have
    '' no C++ counterpart, so fbc uses Itanium's VENDOR EXTENDED operator: 'v',
    '' the arity, then the name. The name keeps its lowercase keyword spelling.
    dim as long arity = 0
    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId prm = cast( Fbx.NodeId, ast.children[sp->first + i] )
        if ast.Kind( prm ) = Fbx.N_PARAM then arity += 1
    next
    return "v" & trim( str( arity ) ) & SrcName( nm )
end function


'' ------------------------------------------------------- win32 decoration

'' The stack a stdcall callee pops, which is the '@N' suffix. Every argument is rounded
'' up to four bytes INDIVIDUALLY and then summed -- two BYTE parameters are @8, not @4 --
'' and a by-value aggregate contributes its OWN size rather than a hidden pointer: a
'' 12-byte UDT is @12, a 5-byte one @8, and a byval STRING @12, the descriptor on the
'' stack. All measured.
private function StdcallBytes _
    ( byref ast as Fbx.AstArena, byval proc_ as Fbx.NodeId, _
      byref types as Fbx.TypeContext, byref info as Fbx.SemanticInfo, _
      byval hasThis as boolean ) as long

    dim as long total = 0
    if hasThis then total += 4
    dim as Fbx.StmtPayload ptr sp = StmtOf( ast, proc_ )
    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId prm = cast( Fbx.NodeId, ast.children[sp->first + i] )
        if ast.Kind( prm ) <> Fbx.N_PARAM then continue for
        '' BYREF is a pointer whatever it refers to.
        if (ast.nodes[cast( long, prm )].flags and Fbx.NF_BYREF) <> 0 then
            total += 4
            continue for
        end if
        dim as Fbx.StmtPayload ptr pp = StmtOf( ast, prm )
        dim as long sz = types.Layout( info.TypeOf_( pp->a ) ).size
        if sz < 4 then sz = 4
        total += ((sz + 3) \ 4) * 4
    next
    return total
end function

'' The linker-visible name on win32: a leading underscore on EVERYTHING, and '@N' on
'' stdcall only.
''
'' CONSTRUCTORS AND DESTRUCTORS CARRY NO SUFFIX -- measured, '__ZN1WC1Ei' where the
'' rule would predict @8 -- so they are cdecl whatever the surrounding declaration says.
'' An ALIAS does not remove the suffix either: 'my_alias' with no parameters is
'' '_my_alias@0'.
private function DecorateWin32 _
    ( byref ast as Fbx.AstArena, byval proc_ as Fbx.NodeId, _
      byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
      byref types as Fbx.TypeContext, byref info as Fbx.SemanticInfo, _
      byref nm as string ) as string

    dim as Fbx.StmtPayload ptr sp = StmtOf( ast, proc_ )

    '' An instance method's implicit THIS is four more bytes. It is one only when the
    '' INNERMOST qualifier is a TYPE and the procedure is not STATIC: 'W.G( )' is @4 with
    '' no parameters at all, while the static 'W.ST( )' is @0 and a namespace's
    '' 'TB.B30( )' is @0 too.
    dim as FB.Array( of string ) q
    dim as FB.Array( of ulong ) qt
    QualifierChain( syms, info.ScopeOf( proc_ ), names, q, qt )
    dim as boolean hasThis = false
    if qt.Count > 0 then
        hasThis = (qt[qt.Count - 1] <> 0) andalso _
                  ((sp->extra and Fbx.PF_STATIC) = 0)
    end if
    dim as ushort kw = sp->op
    if (kw = cast( ushort, Fbx.KW_CONSTRUCTOR )) orelse _
       (kw = cast( ushort, Fbx.KW_DESTRUCTOR )) then
        return "_" & nm
    end if

    '' The convention lives on the SYMBOL, not the node: a definition inherits its
    '' DECLARE's, and reading the node alone would decorate the two halves differently.
    dim as Fbx.CallConv cc = Fbx.CallConvOf( sp->extra )
    dim as Fbx.Symbol ptr s = syms.SymbolAt( info.RefOf( proc_ ) )
    if s <> 0 then
        if s->callConv <> cast( ubyte, Fbx.CC_NONE ) then
            cc = cast( Fbx.CallConv, s->callConv )
        end if
    end if
    if cc = Fbx.CC_NONE then cc = Fbx.CC_STDCALL
    if cc <> Fbx.CC_STDCALL then return "_" & nm

    return "_" & nm & "@" & StdcallBytes( ast, proc_, types, info, hasThis )
end function

'' The name before any target decoration. Split out so the win32 underscore and '@N'
'' apply to EVERY path -- the foreign one, the unmangled one and the Itanium one alike --
'' rather than to whichever return the change happened to be written next to.
private function ProcNameCore _
    ( byref ast as Fbx.AstArena, byval proc_ as Fbx.NodeId, _
      byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
      byref types as Fbx.TypeContext, byref info as Fbx.SemanticInfo ) as string

    if ast.Kind( proc_ ) <> Fbx.N_PROC then return ""
    dim as Fbx.StmtPayload ptr sp = StmtOf( ast, proc_ )

    dim as boolean aliased = (sp->aliasName <> 0)
    dim as string written = ""
    if sp->rawName <> 0 then written = names.Spelling( sp->rawName )
    if len( written ) = 0 then written = names.Spelling( sp->name )

    '' Rule 3: foreign linkage takes the spelling verbatim and ignores OVERLOAD.
    if (sp->extra and Fbx.PF_FOREIGN) <> 0 then
        if aliased then return names.Spelling( sp->aliasName )
        return written
    end if

    '' Rule 2: an ALIAS replaces the identifier and KEEPS ITS CASE.
    dim as string ident = ""
    if aliased then
        ident = names.Spelling( sp->aliasName )
    else
        ident = Fbx.Text.UpperAscii( written )
    end if

    dim as ushort kw = sp->op
    dim as boolean isCtor = (kw = cast( ushort, Fbx.KW_CONSTRUCTOR ))
    dim as boolean isDtor = (kw = cast( ushort, Fbx.KW_DESTRUCTOR ))
    if kw = cast( ushort, Fbx.KW_PROPERTY ) then
        ident += PropertySuffix( ast, proc_ )
    end if

    dim as FB.Array( of string ) quals
    dim as FB.Array( of ulong ) qualTypes
    QualifierChain( syms, info.ScopeOf( proc_ ), names, quals, qualTypes )

    dim as boolean nested = (quals.Count > 0)
    dim as boolean overloaded = ((sp->extra and Fbx.PF_OVERLOAD) <> 0)

    '' Rule 1: not nested and no OVERLOAD -- the uppercased spelling, nothing more.
    if (nested = false) andalso (overloaded = false) then return ident

    dim as Substitutions subs
    dim as string outp = "_Z"

    if nested then
        outp += "N"
        '' A const method is _ZNK..., not _ZN...: the qualifier sits before the
        '' nested name rather than with the parameters.
        if (sp->extra and Fbx.PF_CONST) <> 0 then outp += "K"
        '' A prefix candidate is the CUMULATIVE prefix, not the single component.
        '' 'namespace tests.fbc_tests.boolean_.boolean_' has two components spelled
        '' the same, and fbc emits 8BOOLEAN_8BOOLEAN_ rather than substituting the
        '' second: they are different PREFIXES. Matching per component produced
        '' 8BOOLEAN_S1_ and a name no linker would ever resolve.
        outp += EmitPrefix( quals, qualTypes, subs )
        if isCtor then
            outp += "C1"
        elseif isDtor then
            outp += "D1"
        elseif kw = cast( ushort, Fbx.KW_OPERATOR ) then
            outp += OperatorCode( ast, proc_, types, syms, names, info, subs, ident )
        else
            outp += SrcName( ident )
        end if
        outp += "E"
    else
        outp += SrcName( ident )
    end if

    '' Parameters. A procedure's RETURN type is never encoded; only a function
    '' POINTER's is, and TypeCode handles that.
    dim as long emitted = 0
    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId prm = cast( Fbx.NodeId, ast.children[sp->first + i] )
        if ast.Kind( prm ) <> Fbx.N_PARAM then continue for
        dim as Fbx.StmtPayload ptr pp = StmtOf( ast, prm )
        dim as Fbx.TypeId pt = info.TypeOf_( pp->a )
        if (ast.nodes[cast( long, prm )].flags and Fbx.NF_BYREF) <> 0 then
            pt = types.Reference( pt )
        end if
        outp += TypeCode( pt, types, syms, names, subs )
        emitted += 1
    next
    if emitted = 0 then outp += "v"
    return outp
end function

function ProcName _
    ( byref ast as Fbx.AstArena, byval proc_ as Fbx.NodeId, _
      byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
      byref types as Fbx.TypeContext, byref info as Fbx.SemanticInfo ) as string

    dim as string nm = ProcNameCore( ast, proc_, syms, names, types, info )
    '' A 32-bit pointer means win32: Linux is 64-bit only by decision.
    if types.target.pointerBits <> 32 then return nm
    return DecorateWin32( ast, proc_, syms, names, types, info, nm )
end function


'' ------------------------------------------------------------------------ dump

function Dump _
    ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
      byref syms as Fbx.SymbolTable, byref names as Fbx.Interner, _
      byref types as Fbx.TypeContext, byref info as Fbx.SemanticInfo ) as string

    dim as string outp = ""
    for i as long = 1 to ast.Count( )
        dim as Fbx.NodeId n = cast( Fbx.NodeId, i )
        if ast.Kind( n ) <> Fbx.N_PROC then continue for
        '' A DECLARE with no body names the same symbol its definition does; emitting
        '' both would double every entry in the dump.
        if StmtOf( ast, n )->b = Fbx.NODE_NONE then continue for
        '' A PRIVATE procedure is module-static: it has an internal name but no
        '' symbol the linker can see, so fbc's object file has no entry to compare.
        if (StmtOf( ast, n )->extra and Fbx.PF_PRIVATE) <> 0 then continue for
        dim as string m = ProcName( ast, n, syms, names, types, info )
        if len( m ) > 0 then outp += m & chr( 10 )
    next
    return outp
end function

end namespace
