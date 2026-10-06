'' castpick.bas -- WHICH 'operator cast' A STRING CONTEXT CALLS: one rule, for Check and lowering.
''
'' fbc picks a cast by SCORE against one target type -- symbFindCastOvlProc / hCheckCastOvl --
'' and a tie is an ambiguous call. The score of each cast's RESULT against the target is the
'' string table of hCalcTypesDiff (FULL = 500, HALF = 300, minus a distance). That rule, and
'' which target each statement asks with, were MEASURED: tka-probes/phase4/pc runs 81 overload
'' sets (each subset of { string, ustring, byref zstring, zstring ptr, byref wstring,
'' wstring ptr, long, double, any ptr } of size one and two, both orders) through 20 statements
'' under fbc-modern, and this table reproduces every one of the 648 string-context cells:
''
''     print u / s = u / dim as string s = u / "x" & u / u & wstr( "x" ) / f( byval string )
''                                                           target STRING
''     dim as ustring s = u                                  target USTRING
''     dim as wstring * N s = u                              target WSTRING
''
'' A WINNER THAT IS NOT TEXT -- a pointer or a number -- converts to nothing: fbc's 24 (print,
'' initialiser), 181 (assignment), 20 (concatenation). fbc's own initialiser path drops such a
'' statement silently, which tiko does not copy.
''
'' Its own unit (build/sources.txt), namespace Tko.Check, declared in check.bi.

#include once "symbols/check.bi"

namespace Tko.Check

'' WHAT A CAST YIELDS, in the terms the table scores. A 'byref as zstring' result is the string
'' itself (CR_CHAR), held as a reference -- or, past Check, as a pointer the proc's NF_BYREF
'' flag marks -- where 'as zstring ptr' is a pointer (CR_CHARPTR).
function CastResultClass _
    ( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byval sym as Tko.SymbolId ) as long

    dim as Tko.Symbol ptr s = syms.SymbolAt( sym )
    if (s = 0) orelse (s->type_ = Tko.TYPE_NONE) then return CR_NONE
    dim as boolean byrefRes = false
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if (pn <> Tko.NODE_NONE) andalso (ast.Kind( pn ) = Tko.N_PROC) then
        byrefRes = ((ast.nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0)
    end if
    dim as Tko.TypeId rt = types.Unqualify( s->type_ )
    if types.Kind( rt ) = Tko.TK_REFERENCE then
        rt = types.Unqualify( types.Inner( rt ) )
        byrefRes = true
    end if
    if types.Kind( rt ) = Tko.TK_POINTER then
        dim as Tko.TypeId inner = types.Unqualify( types.Inner( rt ) )
        if types.Kind( inner ) = Tko.TK_BUILTIN then
            select case types.BuiltinOf( inner )
            case Tko.TY_ZSTRING : return iif( byrefRes, CR_CHAR, CR_CHARPTR )
            case Tko.TY_WSTRING : return iif( byrefRes, CR_WCHAR, CR_WCHARPTR )
            end select
        end if
        return CR_OTHERPTR
    end if
    '' A FIXED-LENGTH result is the string flavour it holds.
    if types.Kind( rt ) = Tko.TK_ARRAY then
        dim as Tko.TypeId el = types.Unqualify( types.Inner( rt ) )
        if types.Kind( el ) = Tko.TK_BUILTIN then
            select case types.BuiltinOf( el )
            case Tko.TY_ZSTRING : return CR_CHAR
            case Tko.TY_WSTRING : return CR_WCHAR
            case Tko.TY_FIXSTR  : return CR_STRING
            case Tko.TY_FIXUSTR : return CR_USTRING
            end select
        end if
        return CR_NONE
    end if
    if types.Kind( rt ) = Tko.TK_ENUM then return CR_INT
    if types.Kind( rt ) <> Tko.TK_BUILTIN then return CR_NONE
    select case types.BuiltinOf( rt )
    case Tko.TY_STRING  : return CR_STRING
    case Tko.TY_USTRING : return CR_USTRING
    case Tko.TY_ZSTRING : return CR_CHAR
    case Tko.TY_WSTRING : return CR_WCHAR
    case Tko.TY_SINGLE, Tko.TY_DOUBLE : return CR_FLOAT
    case Tko.TY_VOID, Tko.TY_ANY : return CR_NONE
    end select
    return CR_INT
end function

'' THE SCORE of a cast yielding CLS against TARGET (CT_*): higher is better, 0 no match.
function StrCastScore( byval target as long, byval cls as long ) as long
    select case target
    case CT_STRING
        select case cls
        case CR_STRING   : return 500
        case CR_CHAR     : return 499
        case CR_CHARPTR  : return 498
        case CR_USTRING  : return 298
        case CR_WCHAR    : return 297
        case CR_WCHARPTR : return 296
        end select
    case CT_USTRING
        '' A 'zstring ptr' does NOT reach a ustring (fbc: "NOT from a ustring").
        select case cls
        case CR_USTRING  : return 500
        case CR_CHAR     : return 499
        case CR_STRING   : return 298
        case CR_WCHAR, CR_WCHARPTR : return 297
        end select
    case CT_WSTRING
        select case cls
        case CR_WCHAR    : return 500
        case CR_WCHARPTR : return 499
        case CR_USTRING  : return 299
        case CR_STRING   : return 298
        case CR_CHAR     : return 297
        case CR_CHARPTR  : return 296
        case CR_FLOAT    : return 1        '' a float scores, below every string: then converts to nothing
        end select
    end select
    return 0
end function

'' THE CAST A STRING CONTEXT CALLS, or NONE. OUTCOME says which: CP_OK, CP_NONE (no cast scored),
'' CP_AMBIGUOUS (fbc's error 98 -- two casts share the best score) or CP_NOCONV (a pointer or a
'' number won, which converts to no string). WINCLS is the winner's CR_* class.
function StrCastPick _
    ( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byref names as Tko.Interner, byval udt as Tko.TypeId, byval target as long, _
      byref outcome as long, byref winCls as long ) as Tko.SymbolId

    outcome = CP_NONE
    winCls = CR_NONE
    if udt = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.TypeId u = types.Unqualify( udt )
    if types.Kind( u ) = Tko.TK_REFERENCE then u = types.Unqualify( types.Inner( u ) )
    if types.Kind( u ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.SymbolId best = Tko.SYMBOL_NONE
    dim as long bestScore = 0, nBest = 0, bestCls = CR_NONE
    dim as Tko.SymbolId cur = StructorNamed( syms, types, names, u, "cast" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Tko.Symbol ptr cs = syms.SymbolAt( cur )
        if cs = 0 then exit while
        dim as long cls = CastResultClass( ast, syms, types, cur )
        dim as long sc = StrCastScore( target, cls )
        if sc > bestScore then
            best = cur : bestScore = sc : nBest = 1 : bestCls = cls
        elseif (sc = bestScore) andalso (sc > 0) then
            nBest += 1
        end if
        cur = cs->nextOverload
    wend
    if best = Tko.SYMBOL_NONE then return Tko.SYMBOL_NONE
    winCls = bestCls
    if nBest > 1 then
        outcome = CP_AMBIGUOUS
        return Tko.SYMBOL_NONE
    end if
    select case bestCls
    case CR_STRING, CR_USTRING, CR_CHAR, CR_WCHAR
        outcome = CP_OK
        return best
    end select
    outcome = CP_NOCONV
    return best
end function

'' DOES A UDT REACH A STRING CONTEXT asking TARGET? -1 not this question (not a UDT, or no cast
'' at all -- other diagnostics own those), 0 it does, 1 its best cast converts to no string (a
'' pointer or a number won, or nothing scored), 2 two casts tie (fbc's error 98). Measured on
'' fbc-modern, the 1 is error 24 for print and an initialiser, 181 for an assignment, 20 for '&',
'' 58 for an argument.
function UdtStrCastFit _
    ( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byref names as Tko.Interner, byval udt as Tko.TypeId, byval target as long ) as long

    if udt = Tko.TYPE_NONE then return -1
    dim as Tko.TypeId u = types.Unqualify( udt )
    if types.Kind( u ) = Tko.TK_REFERENCE then u = types.Unqualify( types.Inner( u ) )
    if types.Kind( u ) <> Tko.TK_UDT then return -1
    if StructorNamed( syms, types, names, u, "cast" ) = Tko.SYMBOL_NONE then return -1
    dim as long oc, cls
    StrCastPick( ast, syms, types, names, u, target, oc, cls )
    select case oc
    case CP_OK        : return 0
    case CP_AMBIGUOUS : return 2
    end select
    return 1
end function

end namespace
