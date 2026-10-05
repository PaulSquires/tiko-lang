'' structpick.bas -- WHICH CONSTRUCTOR, OR WHICH 'operator let', FOR A SET OF ARGUMENT TYPES.
''
'' One resolver for the whole compiler (overload re-pick refactor, Phase 2). It was
'' lowering's PickCtor (mir/lowerstore.bas) with its CtorUserConvCost_ (mir/lowerctor.bas),
'' while Check's late access check chose a constructor by a narrower rule of its own
'' (latechecks.bas CtorChosenBy_). Both now ask this; the cost model is the one overload
'' resolution uses -- fitted to 1,274 measured fbc choices.

#include once "symbols/check.bi"

namespace Tko.Check

private function SpStmt_( byref ast as Tko.AstArena, byval n as Tko.NodeId ) as Tko.StmtPayload ptr
    return @ast.stmts[cast( long, ast.nodes[cast( long, n )].data )]
end function

private function SpProcNode_( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, byval sid as Tko.SymbolId ) as Tko.NodeId
    dim as Tko.Symbol ptr s = syms.SymbolAt( sid )
    if s = 0 then return Tko.NODE_NONE
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return Tko.NODE_NONE
    if ast.Kind( pn ) <> Tko.N_PROC then return Tko.NODE_NONE
    return pn
end function

private function SpParamCount_( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, byval sid as Tko.SymbolId ) as long
    dim as Tko.NodeId pn = SpProcNode_( ast, syms, sid )
    if pn = Tko.NODE_NONE then return 0
    dim as Tko.StmtPayload ptr pp = SpStmt_( ast, pn )
    dim as long n = 0
    for i as long = 0 to pp->count - 1
        if ast.Kind( cast( Tko.NodeId, ast.children[pp->first + i] ) ) = Tko.N_PARAM then n += 1
    next
    return n
end function

private function SpParamType_( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, _
    byref info as Tko.SemanticInfo, byval sid as Tko.SymbolId, byval idx as long ) as Tko.TypeId
    dim as Tko.NodeId pn = SpProcNode_( ast, syms, sid )
    if pn = Tko.NODE_NONE then return Tko.TYPE_NONE
    dim as Tko.StmtPayload ptr pp = SpStmt_( ast, pn )
    dim as long seen = 0
    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, ast.children[pp->first + i] )
        if ast.Kind( prm ) <> Tko.N_PARAM then continue for
        if seen = idx then return info.TypeOf_( SpStmt_( ast, prm )->a )
        seen += 1
    next
    return Tko.TYPE_NONE
end function

'' The constructor ('__ctor'), destructor ('__dtor') or 'let' chain of a UDT, or NONE: they
'' live in the type's scope under synthetic names, having no names of their own.
function StructorNamed _
    ( byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, byref names as Tko.Interner, _
      byval t as Tko.TypeId, byref which as string ) as Tko.SymbolId

    if t = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    if types.Kind( t ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.InternId tn = types.NameOf( t )
    if tn = 0 then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, types.DeclScopeOf( t ) )
    dim as Tko.Symbol ptr s = syms.SymbolAt( syms.LookupTyped( ds, tn, true ) )
    if s = 0 then return Tko.SYMBOL_NONE
    if s->inner = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
    return syms.LookupLocal( s->inner, names.Fold( names.GetString( which ) ) )
end function

'' A UDT PARAMETER THE ARGUMENT REACHES THROUGH ONE OF THAT UDT'S OWN CONSTRUCTORS. The
'' standard conversions alone found nothing for 'dim as X x2 = 13' over 'constructor X(
'' byref w as W )' and 'constructor W( byval v as long )', where fbc writes '_ZN1WC1Ei(
'' &TMP$38$0, 13 ); _ZN1XC1ER1W( &X2$0, &TMP$38$0 )'. CONV_USERDEF plus the standard
'' conversion into that constructor's parameter, one level only: a copy constructor never
'' counts.
function StructorUserConvCost _
    ( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byref names as Tko.Interner, byref info as Tko.SemanticInfo, _
      byval at as Tko.TypeId, byval pt as Tko.TypeId ) as long

    if (at = Tko.TYPE_NONE) orelse (pt = Tko.TYPE_NONE) then return CONV_NONE
    dim as Tko.TypeId t = types.Unqualify( pt )
    if types.Kind( t ) = Tko.TK_REFERENCE then t = types.Unqualify( types.Inner( t ) )
    if types.Kind( t ) <> Tko.TK_UDT then return CONV_NONE
    dim as long best = CONV_NONE
    dim as Tko.SymbolId cur = StructorNamed( syms, types, names, t, "__ctor" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 1000)
        guard += 1
        dim as Tko.Symbol ptr s = syms.SymbolAt( cur )
        if s = 0 then exit while
        if SpParamCount_( ast, syms, cur ) = 1 then
            dim as Tko.TypeId cpt = SpParamType_( ast, syms, info, cur, 0 )
            if cpt <> Tko.TYPE_NONE then
                dim as Tko.TypeId cu = types.Unqualify( cpt )
                if types.Kind( cu ) = Tko.TK_REFERENCE then cu = types.Unqualify( types.Inner( cu ) )
                if cu <> t then
                    dim as long sc = ConversionCost( at, cpt, types )
                    if sc < CONV_NONE then
                        if (CONV_USERDEF + sc) < best then best = CONV_USERDEF + sc
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    return best
end function

'' THE CONSTRUCTOR (or 'let') OVERLOAD FOR A SET OF ARGUMENT TYPES, from the chain at
'' 'first_'; NONE for no viable one, and NONE for a tie -- an ambiguous construction, not
'' a silent pick.
function PickStructor _
    ( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byref names as Tko.Interner, byref info as Tko.SemanticInfo, _
      byval first_ as Tko.SymbolId, byref argT as FB.Array( of ulong ) ) as Tko.SymbolId

    dim as Tko.SymbolId best = Tko.SYMBOL_NONE
    dim as long bestCost = CONV_NONE
    dim as long ties = 0
    dim as Tko.SymbolId cur = first_
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = syms.SymbolAt( cur )
        if s = 0 then exit while
        dim as Tko.NodeId pn = SpProcNode_( ast, syms, cur )
        if pn <> Tko.NODE_NONE then
            dim as Tko.StmtPayload ptr pp = SpStmt_( ast, pn )
            dim as long np = 0
            for i as long = 0 to pp->count - 1
                if ast.Kind( cast( Tko.NodeId, ast.children[pp->first + i] ) ) = Tko.N_PARAM then np += 1
            next
            '' A CONSTRUCTOR WITH DEFAULTED TRAILING PARAMETERS IS VIABLE FOR THE SHORTER
            '' CALL. 'constructor( byval c as long, byval os as long = 0 )' answers 'A( 5 )'
            '' -- measured, fbc emits '_ZN1AC1Eii( &A1, 5, 0 )' -- and exact arity alone
            '' found none, so 'dim as A a1 = A( 5 )' default-constructed and then copied.
            dim as boolean arityOk = (np = argT.Count)
            if (arityOk = false) andalso (np > argT.Count) then
                arityOk = true
                dim as long sd = 0
                for i as long = 0 to pp->count - 1
                    dim as Tko.NodeId prm = cast( Tko.NodeId, ast.children[pp->first + i] )
                    if ast.Kind( prm ) <> Tko.N_PARAM then continue for
                    if sd >= argT.Count then
                        if SpStmt_( ast, prm )->b = Tko.NODE_NONE then
                            arityOk = false
                            exit for
                        end if
                    end if
                    sd += 1
                next
            end if
            if arityOk then
                dim as long total = 0
                dim as long ai = 0
                dim as boolean viable = true
                for i as long = 0 to pp->count - 1
                    dim as Tko.NodeId prm = cast( Tko.NodeId, ast.children[pp->first + i] )
                    if ast.Kind( prm ) <> Tko.N_PARAM then continue for
                    '' The defaulted tail costs nothing: there is no argument to convert.
                    if ai >= argT.Count then exit for
                    dim as Tko.TypeId at2 = cast( Tko.TypeId, argT[ai] )
                    dim as Tko.TypeId pt2 = info.TypeOf_( SpStmt_( ast, prm )->a )
                    dim as long cost = 0
                    '' AN ARRAY PARAMETER IS MATCHED BY ITS ELEMENT TYPE: its declared type IS
                    '' the element, the array-ness is the node's flag (structs/udt-array-ops-1).
                    if (ast.nodes[cast( long, prm )].flags and Tko.NF_ARRAY) <> 0 then
                        dim as Tko.TypeId ae = at2
                        if ae <> Tko.TYPE_NONE then
                            if types.Kind( ae ) = Tko.TK_ARRAY then ae = types.Inner( ae )
                        end if
                        cost = ConversionCost( ae, pt2, types )
                    else
                        cost = ConversionCost( at2, pt2, types )
                        if cost >= CONV_NONE then cost = StructorUserConvCost( ast, syms, types, names, info, at2, pt2 )
                    end if
                    ai += 1
                    if cost >= CONV_NONE then
                        viable = false
                        exit for
                    end if
                    total += cost
                next
                if viable then
                    if total < bestCost then
                        bestCost = total
                        best = cur
                        ties = 0
                    elseif total = bestCost then
                        ties += 1
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    if ties > 0 then return Tko.SYMBOL_NONE
    return best
end function

'' WHICH NUMERIC 'operator cast' A UDT VALUE TAKES (overload re-pick refactor, Phase 4). Measured on
'' fbc-modern, over a type casting to BYTE (100) and DOUBLE (2.75), in either declaration order:
''
''     x + 1, x + n (long), x * 2, x \ 2, x = 100       the BYTE cast     101 200 50 -1
''     x + d (double), x + s (single)                    the DOUBLE cast   4.25
''     dim as long k = x / dim as byte b = x             BYTE              100
''     dim as double d = x / dim as single g = x         DOUBLE            2.75
''     -x, abs( x ), sqr( x ), int( x ), x + y (two UDTs) DOUBLE           -2.75 ...
''
'' -- the cast CHEAPEST to convert to what the value meets ('want': the other operand or
'' the destination), the higher-ranked on a tie; with nothing to meet, the highest-ranked
'' (NumericCastRank). Lowering ranked always, so 'x + 1' added 2.75 and 'dim as long k =
'' x' stored 3 where fbc has 101 and 100; Check typed 'x + 1' DOUBLE where fbc says
'' INTEGER. A number is an ENUM or any builtin that is not a string flavour or VOID.
function NumericCastPick _
    ( byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, byref names as Tko.Interner, _
      byval udt as Tko.TypeId, byval want as Tko.TypeId ) as Tko.SymbolId

    if udt = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.TypeId u = types.Unqualify( udt )
    if types.Kind( u ) = Tko.TK_REFERENCE then u = types.Unqualify( types.Inner( u ) )
    if types.Kind( u ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    '' Only a NUMBER is something to meet: a UDT, a string or a pointer leaves the rank.
    dim as Tko.TypeId w = Tko.TYPE_NONE
    if want <> Tko.TYPE_NONE then
        w = types.Unqualify( want )
        if types.Kind( w ) = Tko.TK_REFERENCE then w = types.Unqualify( types.Inner( w ) )
        if NumericCastRank( types, w ) = 0 then w = Tko.TYPE_NONE
    end if
    dim as Tko.SymbolId best = Tko.SYMBOL_NONE
    dim as long bestCost = CONV_NONE, bestRank = 0
    dim as Tko.SymbolId cur = StructorNamed( syms, types, names, u, "cast" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Tko.Symbol ptr cs = syms.SymbolAt( cur )
        if cs = 0 then exit while
        dim as Tko.TypeId rt = types.Unqualify( cs->type_ )
        dim as long rk = 0
        if rt <> Tko.TYPE_NONE then
            if types.Kind( rt ) = Tko.TK_ENUM then rk = NumericCastRank( types, rt )
            if types.Kind( rt ) = Tko.TK_BUILTIN then
                select case types.BuiltinOf( rt )
                case Tko.TY_STRING, Tko.TY_ZSTRING, Tko.TY_WSTRING, Tko.TY_USTRING, Tko.TY_VOID
                case else
                    rk = NumericCastRank( types, rt )
                    if rk = 0 then rk = 1   '' a number the rank table does not list still counts
                end select
            end if
        end if
        if rk > 0 then
            dim as long cost = 0
            if w <> Tko.TYPE_NONE then cost = ConversionCost( rt, w, types )
            if (cost < bestCost) orelse ((cost = bestCost) andalso (rk > bestRank)) then
                best = cur : bestCost = cost : bestRank = rk
            end if
        end if
        cur = cs->nextOverload
    wend
    return best
end function

end namespace
