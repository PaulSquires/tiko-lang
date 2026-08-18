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



'' Measured against fbc, tests/mangle. 'integer' and 'uinteger' are VENDOR EXTENDED
'' types rather than 'x'/'y': they are pointer-sized, so they stay distinct from
'' longint even on a target where both happen to be 64 bits wide.
private function BuiltinCode( byval b as Fbx.BuiltinType ) as string
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
        enc = BuiltinCode( types.BuiltinOf( t ) )

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

function ProcName _
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
