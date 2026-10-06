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

'' 1 a narrow string (string, zstring, ustring), 2 a wstring, 0 anything else.
private function StrKind_( byref types as Tko.TypeContext, byval t as Tko.TypeId ) as long
    if t = Tko.TYPE_NONE then return 0
    if types.Kind( t ) <> Tko.TK_BUILTIN then return 0
    select case types.BuiltinOf( t )
    case Tko.TY_STRING, Tko.TY_ZSTRING, Tko.TY_USTRING : return 1
    case Tko.TY_WSTRING : return 2
    end select
    return 0
end function

'' DOES A UDT DECLARE A CAST YIELDING TEXT -- a string of any width, or a character pointer?
'' Measured on fbc-modern: a type casting only to long and double is error 24 as a 'string'
'' initialiser, 181 assigned to one and 58 passed as one; tiko converted the number.
function UdtHasStrCast _
    ( byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byref names as Tko.Interner, byval udt as Tko.TypeId ) as boolean

    dim as Tko.TypeId u = types.Unqualify( udt )
    if types.Kind( u ) = Tko.TK_REFERENCE then u = types.Unqualify( types.Inner( u ) )
    if types.Kind( u ) <> Tko.TK_UDT then return false
    dim as Tko.SymbolId cur = StructorNamed( syms, types, names, u, "cast" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Tko.Symbol ptr cs = syms.SymbolAt( cur )
        if cs = 0 then exit while
        dim as Tko.TypeId rt = types.Unqualify( cs->type_ )
        if rt <> Tko.TYPE_NONE then
            if types.Kind( rt ) = Tko.TK_REFERENCE then rt = types.Unqualify( types.Inner( rt ) )
            if types.Kind( rt ) = Tko.TK_POINTER then rt = types.Unqualify( types.Inner( rt ) )
            if StrKind_( types, rt ) <> 0 then return true
        end if
        cur = cs->nextOverload
    wend
    return false
end function

'' A UDT ARGUMENT REACHING A CONSTRUCTOR'S (or 'let's) STRING OR NUMERIC PARAMETER THROUGH ITS OWN
'' 'operator cast', or CONV_NONE. Measured on fbc-modern: S casting to string (or 'byref as
'' wstring') and T constructible from 'byref/byval as string' or 'byref as wstring' -- 'T( s )',
'' 'dim as T q = s', a T argument and an operand all run [cast][ctor]; and over numbers every
'' CONVERTING pair does too (a 'double' cast into 'constructor( byval as long )', 'short' into
'' 'integer', ...). fbc refuses only the pairs whose types are IDENTICAL -- 'long' into 'long',
'' 'double' into 'double' -- with error 99, which is its defect, not a rule: tiko takes those too
'' (the F-76 precedent). A numeric cast is the one NumericCastPick takes for the parameter.
function StructorCastCost _
    ( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byref names as Tko.Interner, byval at as Tko.TypeId, byval pt as Tko.TypeId ) as long

    if (at = Tko.TYPE_NONE) orelse (pt = Tko.TYPE_NONE) then return CONV_NONE
    dim as Tko.TypeId a = types.Unqualify( at )
    if types.Kind( a ) = Tko.TK_REFERENCE then a = types.Unqualify( types.Inner( a ) )
    if types.Kind( a ) <> Tko.TK_UDT then return CONV_NONE
    dim as Tko.TypeId p = types.Unqualify( pt )
    if types.Kind( p ) = Tko.TK_REFERENCE then p = types.Unqualify( types.Inner( p ) )
    if StrKind_( types, p ) = 0 then
        if NumericCastRank( types, p ) = 0 then return CONV_NONE
        dim as Tko.SymbolId nc = NumericCastPick( syms, types, names, a, p )
        if nc = Tko.SYMBOL_NONE then return CONV_NONE
        dim as long sc = ConversionCost( types.Unqualify( syms.SymbolAt( nc )->type_ ), p, types )
        if sc >= CONV_NONE then return CONV_NONE
        if sc > 0 then sc = CONV_NUMERIC   '' a cast then ANY conversion: one flat score, as fbc ranks it
        return CONV_USERDEF + sc + 2   '' a string cast beats a numeric one, as UserConvCost_ prices them
    end if
    dim as long best = CONV_NONE
    dim as Tko.SymbolId cur = StructorNamed( syms, types, names, a, "cast" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Tko.Symbol ptr cs = syms.SymbolAt( cur )
        if cs = 0 then exit while
        dim as Tko.TypeId rt = types.Unqualify( cs->type_ )
        dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
        dim as boolean byrefRes = false
        if (pn <> Tko.NODE_NONE) andalso (ast.Kind( pn ) = Tko.N_PROC) then
            byrefRes = ((ast.nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0)
        end if
        if rt <> Tko.TYPE_NONE then
            if types.Kind( rt ) = Tko.TK_REFERENCE then rt = types.Unqualify( types.Inner( rt ) )
            if byrefRes andalso (types.Kind( rt ) = Tko.TK_POINTER) then rt = types.Unqualify( types.Inner( rt ) )
            dim as long rk = StrKind_( types, rt )
            if rk <> 0 then
                dim as long cost = CONV_USERDEF + iif( rk = StrKind_( types, p ), 0, 1 )
                if cost < best then best = cost
            end if
        end if
        cur = cs->nextOverload
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
                        if cost >= CONV_NONE then cost = StructorCastCost( ast, syms, types, names, at2, pt2 )
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
'' THE POINTER 'operator cast' -- by what the value meets. Measured on fbc-modern, with casts to
'' 'any ptr', 'long ptr' and 'double ptr' in any order:
''
''     dim as double ptr p = x / byval double ptr / p = x     the EXACT pointer       [double]
''     dim as byte ptr p = x  (long ptr + any ptr)             the 'any ptr' one       [any]
''     if x then              (long ptr + any ptr)             the 'any ptr' one       [any]
''     dim as any ptr p = x   (long ptr + double ptr)          error 98, ambiguous
''
'' tiko took the first pointer overload every time, and 'pd' read a long's bytes as a double.
'' WANT is the destination, TYPE_NONE where none is named; where fbc is ambiguous this keeps
'' the first, as before.
function PtrCastPick _
    ( byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, byref names as Tko.Interner, _
      byval udt as Tko.TypeId, byval want as Tko.TypeId ) as Tko.SymbolId

    if udt = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.TypeId u = types.Unqualify( udt )
    if types.Kind( u ) = Tko.TK_REFERENCE then u = types.Unqualify( types.Inner( u ) )
    if types.Kind( u ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.TypeId wi = Tko.TYPE_NONE
    if want <> Tko.TYPE_NONE then
        dim as Tko.TypeId w = types.Unqualify( want )
        if types.Kind( w ) = Tko.TK_REFERENCE then w = types.Unqualify( types.Inner( w ) )
        if types.Kind( w ) = Tko.TK_POINTER then wi = types.Unqualify( types.Inner( w ) )
    end if
    dim as Tko.SymbolId first = Tko.SYMBOL_NONE, anyp = Tko.SYMBOL_NONE
    dim as Tko.SymbolId cur = StructorNamed( syms, types, names, u, "cast" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Tko.Symbol ptr cs = syms.SymbolAt( cur )
        if cs = 0 then exit while
        dim as Tko.TypeId rt = types.Unqualify( cs->type_ )
        if rt <> Tko.TYPE_NONE then
            if types.Kind( rt ) = Tko.TK_POINTER then
                dim as Tko.TypeId ri = types.Unqualify( types.Inner( rt ) )
                if (wi <> Tko.TYPE_NONE) andalso (ri = wi) then return cur
                if first = Tko.SYMBOL_NONE then first = cur
                if anyp = Tko.SYMBOL_NONE then
                    if types.Kind( ri ) = Tko.TK_BUILTIN then
                        if types.BuiltinOf( ri ) = Tko.TY_ANY then anyp = cur
                    end if
                end if
            end if
        end if
        cur = cs->nextOverload
    wend
    if anyp <> Tko.SYMBOL_NONE then return anyp
    return first
end function

'' DOES A UDT'S POINTER 'operator cast' REACH THE POINTER WANT? -1 when it declares none (not
'' this question), 0 when one does, 1 when none does, 2 when several do and none is better.
'' Measured on fbc-modern: a cast reaches only its EXACT pointer type, or any pointer when it
'' yields 'any ptr', or 'any ptr' from any pointer. 'long ptr' into 'byte ptr' or 'zstring ptr'
'' is error 24 by initialiser, 181 by assignment, 58 as an argument; 'long ptr' and 'double ptr'
'' both into 'any ptr' is error 98. A 'byref as' result is the thing itself, not a pointer.
'' Does a cast yielding the pointer RES reach the pointer DST? Its own type, or either is 'any ptr'.
function PtrCastReaches( byref types as Tko.TypeContext, byval res as Tko.TypeId, byval dst as Tko.TypeId ) as boolean
    dim as Tko.TypeId ri = types.Unqualify( types.Inner( types.Unqualify( res ) ) )
    dim as Tko.TypeId di = types.Unqualify( types.Inner( types.Unqualify( dst ) ) )
    if ri = di then return true
    if (types.Kind( ri ) = Tko.TK_BUILTIN) andalso (types.BuiltinOf( ri ) = Tko.TY_ANY) then return true
    if (types.Kind( di ) = Tko.TK_BUILTIN) andalso (types.BuiltinOf( di ) = Tko.TY_ANY) then return true
    return false
end function

function PtrCastFit _
    ( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byref names as Tko.Interner, byval udt as Tko.TypeId, byval want as Tko.TypeId ) as long

    if (udt = Tko.TYPE_NONE) orelse (want = Tko.TYPE_NONE) then return -1
    dim as Tko.TypeId u = types.Unqualify( udt )
    if types.Kind( u ) = Tko.TK_REFERENCE then u = types.Unqualify( types.Inner( u ) )
    if types.Kind( u ) <> Tko.TK_UDT then return -1
    dim as Tko.TypeId w = types.Unqualify( want )
    if types.Kind( w ) = Tko.TK_REFERENCE then w = types.Unqualify( types.Inner( w ) )
    if types.Kind( w ) <> Tko.TK_POINTER then return -1
    dim as Tko.TypeId wi = types.Unqualify( types.Inner( w ) )
    dim as boolean wantAny = false
    if types.Kind( wi ) = Tko.TK_BUILTIN then wantAny = (types.BuiltinOf( wi ) = Tko.TY_ANY)
    dim as long nPtr = 0, nFit = 0
    dim as Tko.SymbolId cur = StructorNamed( syms, types, names, u, "cast" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Tko.Symbol ptr cs = syms.SymbolAt( cur )
        if cs = 0 then exit while
        dim as Tko.TypeId rt = types.Unqualify( cs->type_ )
        dim as boolean byrefRes = false
        dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
        if (pn <> Tko.NODE_NONE) andalso (ast.Kind( pn ) = Tko.N_PROC) then
            byrefRes = ((ast.nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0)
        end if
        if (rt <> Tko.TYPE_NONE) andalso (byrefRes = false) then
            if types.Kind( rt ) = Tko.TK_POINTER then
                nPtr += 1
                dim as Tko.TypeId ri = types.Unqualify( types.Inner( rt ) )
                if ri = wi then return 0
                dim as boolean resAny = false
                if types.Kind( ri ) = Tko.TK_BUILTIN then resAny = (types.BuiltinOf( ri ) = Tko.TY_ANY)
                if resAny then return 0
                if wantAny then nFit += 1
            end if
        end if
        cur = cs->nextOverload
    wend
    if nPtr = 0 then return -1
    if nFit = 1 then return 0
    if nFit > 1 then return 2
    return 1
end function

'' A UDT WITH NO NUMERIC CAST BUT A 'byref as zstring|wstring' ONE, MEETING A NUMBER, is its FIRST
'' CHARACTER: measured on fbc-modern, over "ab", 'z + 1' is 98, '1 + z' 98, 'z * 2' 194, 'z = 97'
'' -1, 'z + 1.5' 98.5 -- fbc's character class is integer, and a reference to one reads it.
'' tiko concatenated ("ab1") or failed to lower. Returns that cast, or NONE; CHARTYPE is ubyte
'' for zstring and the target's wchar (ushort on Windows, ulong on Linux) for wstring.
function CharRefCastPick _
    ( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byref names as Tko.Interner, byval udt as Tko.TypeId, byref charType as Tko.TypeId ) as Tko.SymbolId

    charType = Tko.TYPE_NONE
    if udt = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.TypeId u = types.Unqualify( udt )
    if types.Kind( u ) = Tko.TK_REFERENCE then u = types.Unqualify( types.Inner( u ) )
    if types.Kind( u ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    if NumericCastPick( syms, types, names, u, Tko.TYPE_NONE ) <> Tko.SYMBOL_NONE then return Tko.SYMBOL_NONE
    '' A WIDE REFERENCE BEATS A NARROW ONE, either order: fbc's numeric pick takes the more precise
    '' type, and WCHAR ranks above CHAR -- measured, 'if u' and 'u + 1' over [byref as zstring,
    '' byref as wstring] call the wstring one. NARROW holds the first zstring one, for no wstring.
    dim as Tko.SymbolId narrow = Tko.SYMBOL_NONE
    dim as Tko.SymbolId cur = StructorNamed( syms, types, names, u, "cast" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 4096)
        guard += 1
        dim as Tko.Symbol ptr cs = syms.SymbolAt( cur )
        if cs = 0 then exit while
        dim as Tko.TypeId rt = types.Unqualify( cs->type_ )
        dim as boolean byRes = false
        dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
        if (pn <> Tko.NODE_NONE) andalso (ast.Kind( pn ) = Tko.N_PROC) then
            byRes = ((ast.nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0) orelse _
                    ((ast.stmts[cast( long, ast.nodes[cast( long, pn )].data )].extra and Tko.PF_BYREF_RESULT) <> 0)
        end if
        if rt <> Tko.TYPE_NONE then
            if types.Kind( rt ) = Tko.TK_REFERENCE then rt = types.Unqualify( types.Inner( rt ) ) : byRes = true
            if byRes andalso (types.Kind( rt ) = Tko.TK_POINTER) then rt = types.Unqualify( types.Inner( rt ) )
            if byRes andalso (types.Kind( rt ) = Tko.TK_BUILTIN) then
                select case types.BuiltinOf( rt )
                case Tko.TY_ZSTRING
                    if narrow = Tko.SYMBOL_NONE then narrow = cur
                case Tko.TY_WSTRING
                    charType = types.Builtin( iif( types.target.wcharBytes = 4, Tko.TY_ULONG, Tko.TY_USHORT ) )
                    return cur
                end select
            end if
        end if
        cur = cs->nextOverload
    wend
    if narrow <> Tko.SYMBOL_NONE then charType = types.Builtin( Tko.TY_UBYTE )
    return narrow
end function

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
        '' A BOOLEAN meets the cast nearest a BYTE: measured, fbc takes byte over double and ubyte,
        '' short over ulong, longint over single, single over double for 'dim as boolean b = m'.
        if types.Kind( w ) = Tko.TK_BUILTIN then
            if types.BuiltinOf( w ) = Tko.TY_BOOLEAN then w = types.Builtin( Tko.TY_BYTE )
        end if
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

'' THE COPY CONSTRUCTOR of a UDT, or NONE: a constructor whose FIRST parameter is the type itself
'' (by reference, const or not) and, with DEFAULTED, whose every other parameter has a default.
'' TWO QUESTIONS, and fbc answers them differently. Measured on fbc-modern, with
'' 'constructor( byref r as T, byval extra as long = 0 )' beside 'constructor( byval n as long )':
''
''     dim as T b = a              the defaulted one copies      101   (DEFAULTED = true)
''     dim as T g = gives( )       it copies on return AND here  205
''     takes( a ) / byval          no copy at all                  1   (DEFAULTED = false)
''
'' fbc's own copy-constructor FACT (symb-comp.bas, symbCheckCompCtor) counts a constructor of
'' exactly one parameter, so the type stays trivial -- passed by value, returned in registers --
'' while an initialiser still resolves the overload and finds the defaulted copy.
function CopyStructorOf _
    ( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, byref types as Tko.TypeContext, _
      byref names as Tko.Interner, byref info as Tko.SemanticInfo, byval t as Tko.TypeId, _
      byval defaulted as boolean ) as Tko.SymbolId

    if t = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.TypeId u = types.Unqualify( t )
    if types.Kind( u ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.SymbolId cur = StructorNamed( syms, types, names, u, "__ctor" )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 10000)
        guard += 1
        dim as Tko.Symbol ptr s = syms.SymbolAt( cur )
        if s = 0 then exit while
        dim as Tko.NodeId pn = SpProcNode_( ast, syms, cur )
        if pn <> Tko.NODE_NONE then
            dim as Tko.StmtPayload ptr pp = SpStmt_( ast, pn )
            dim as long seen = 0
            dim as boolean ok = false
            for i as long = 0 to pp->count - 1
                dim as Tko.NodeId prm = cast( Tko.NodeId, ast.children[pp->first + i] )
                if ast.Kind( prm ) <> Tko.N_PARAM then continue for
                if seen = 0 then
                    dim as Tko.TypeId pt = info.TypeOf_( SpStmt_( ast, prm )->a )
                    if pt = Tko.TYPE_NONE then exit for
                    pt = types.Unqualify( pt )
                    if types.Kind( pt ) = Tko.TK_REFERENCE then pt = types.Unqualify( types.Inner( pt ) )
                    ok = (pt = u)
                    if ok = false then exit for
                elseif (defaulted = false) orelse (SpStmt_( ast, prm )->b = Tko.NODE_NONE) then
                    ok = false
                    exit for
                end if
                seen += 1
            next
            if ok then return cur
        end if
        cur = s->nextOverload
    wend
    return Tko.SYMBOL_NONE
end function

'' A STRING CAST REACHING A STRING OF ITS OWN WIDTH -- narrow to narrow, wide to wide -- is
'' closer than one changing width. Measured, offered 'p( byref as const wstring )' and
'' 'p( byref as const string )', a UDT with 'operator cast( ) byref as zstring' picks STRING
'' and one with 'byref as wstring' WSTRING. Both scored the flat cast-and-convert tier, and
'' the call was ambiguous (structs/implicit-cast.bas). USTRING counts as wide.
function StringSameWidth _
    ( byref types as Tko.TypeContext, byval a as Tko.TypeId, byval b as Tko.TypeId ) as boolean

    if (types.Kind( a ) <> Tko.TK_BUILTIN) orelse (types.Kind( b ) <> Tko.TK_BUILTIN) then return false
    dim as Tko.BuiltinType ab = types.BuiltinOf( a ), bb = types.BuiltinOf( b )
    select case ab
    case Tko.TY_STRING, Tko.TY_ZSTRING
        return (bb = Tko.TY_STRING) orelse (bb = Tko.TY_ZSTRING)
    case Tko.TY_WSTRING, Tko.TY_USTRING
        return (bb = Tko.TY_WSTRING) orelse (bb = Tko.TY_USTRING)
    end select
    return false
end function

end namespace
