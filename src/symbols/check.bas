'' check.bas -- expression typing. See check.bi for the measured promotion rules and
'' for why each of them is not what a C programmer would guess.

#include once "symbols/check.bi"

namespace Fbx.Check

type Ctx
    as Fbx.AstArena ptr         ast
    as Fbx.SymbolTable ptr      syms
    as Fbx.TypeContext ptr      types
    as Fbx.Interner ptr         names
    as Fbx.DiagnosticEngine ptr diags
    as Fbx.SemanticInfo ptr     info
    as Stats ptr                st
end type

'' ------------------------------------------------------------------- classes

private function IsFloat_( byval b as Fbx.BuiltinType ) as boolean
    return (b = Fbx.TY_SINGLE) orelse (b = Fbx.TY_DOUBLE)
end function

private function IsInt_( byval b as Fbx.BuiltinType ) as boolean
    select case b
    case Fbx.TY_BYTE, Fbx.TY_UBYTE, Fbx.TY_SHORT, Fbx.TY_USHORT, _
         Fbx.TY_LONG, Fbx.TY_ULONG, Fbx.TY_INTEGER, Fbx.TY_UINTEGER, _
         Fbx.TY_LONGINT, Fbx.TY_ULONGINT
        return true
    end select
    return false
end function

'' The 64-bit UNSIGNED types, and only those, make an integer result UINTEGER.
'' 'ulong + ulong' is INTEGER: signed 64 holds every unsigned 32 value, so nothing
'' forces the result unsigned.
private function IsUnsigned64_( byval b as Fbx.BuiltinType ) as boolean
    return (b = Fbx.TY_UINTEGER) orelse (b = Fbx.TY_ULONGINT)
end function

private function IsStringy_( byval b as Fbx.BuiltinType ) as boolean
    select case b
    case Fbx.TY_STRING, Fbx.TY_ZSTRING, Fbx.TY_WSTRING, Fbx.TY_USTRING
        return true
    end select
    return false
end function

'' ------------------------------------------------------------ operator classes

private function IsComparison_( byval op as Fbx.TokenKind ) as boolean
    select case op
    case Fbx.TK_EQ, Fbx.TK_NE, Fbx.TK_LT, Fbx.TK_GT, Fbx.TK_LE, Fbx.TK_GE
        return true
    end select
    return false
end function

'' AND, OR, XOR, EQV, IMP: bitwise on integers, logical on booleans.
private function IsBitwise_( byval op as Fbx.TokenKind ) as boolean
    select case op
    case Fbx.KW_AND, Fbx.KW_OR, Fbx.KW_XOR, Fbx.KW_EQV, Fbx.KW_IMP
        return true
    end select
    return false
end function

'' ANDALSO and ORELSE are NOT the bitwise operators with short-circuiting bolted on.
'' They are BOOLEAN when both sides are and INTEGER in every other case -- never
'' UINTEGER, even for 'uinteger andalso uinteger', where AND would give UINTEGER.
'' They also reject nothing except a string operand.
private function IsShortCircuit_( byval op as Fbx.TokenKind ) as boolean
    return (op = Fbx.KW_ANDALSO) orelse (op = Fbx.KW_ORELSE)
end function

'' The operators whose result is an INTEGER even when handed floats: '\', MOD, SHL,
'' SHR. They convert first and are not the same operator as '/'.
private function IsIntegerOp_( byval op as Fbx.TokenKind ) as boolean
    select case op
    case Fbx.TK_BACKSLASH, Fbx.KW_MOD, Fbx.KW_SHL, Fbx.KW_SHR
        return true
    end select
    return false
end function

private function IsArith_( byval op as Fbx.TokenKind ) as boolean
    select case op
    case Fbx.TK_PLUS, Fbx.TK_MINUS, Fbx.TK_STAR
        return true
    end select
    return false
end function

'' ------------------------------------------------------------------ promotion

'' The integer result of a numeric pair: UINTEGER when either side is 64-bit
'' unsigned, INTEGER otherwise. Nothing narrower is ever produced.
private function IntResult_ _
    ( byval lb as Fbx.BuiltinType, byval rb as Fbx.BuiltinType, _
      byref types as Fbx.TypeContext ) as Fbx.TypeId

    if IsUnsigned64_( lb ) orelse IsUnsigned64_( rb ) then
        return types.Builtin( Fbx.TY_UINTEGER )
    end if
    return types.Builtin( Fbx.TY_INTEGER )
end function

function BinaryResult _
    ( byval op as Fbx.TokenKind, byval lhs as Fbx.TypeId, byval rhs as Fbx.TypeId, _
      byref types as Fbx.TypeContext ) as Fbx.TypeId

    if (lhs = Fbx.TYPE_NONE) orelse (rhs = Fbx.TYPE_NONE) then return Fbx.TYPE_NONE

    '' '&' is FreeBASIC's concatenation operator and is ALWAYS a string, whatever it
    '' is handed -- 'long & long' is STRING. It converts rather than rejecting, so it
    '' is decided before any of the numeric rules and before the builtin-only guard:
    '' concatenating a UDT with a CAST operator is still a string.
    if op = Fbx.TK_AMP then return types.Builtin( Fbx.TY_STRING )
    '' Only builtin operands are decided here. A UDT operand means an overloaded
    '' operator, which is overload resolution's business, not this table's.
    if types.Kind( lhs ) <> Fbx.TK_BUILTIN then return Fbx.TYPE_NONE
    if types.Kind( rhs ) <> Fbx.TK_BUILTIN then return Fbx.TYPE_NONE

    dim as Fbx.BuiltinType lb = types.BuiltinOf( lhs )
    dim as Fbx.BuiltinType rb = types.BuiltinOf( rhs )
    dim as boolean lStr = IsStringy_( lb )
    dim as boolean rStr = IsStringy_( rb )
    dim as boolean lNum = IsInt_( lb ) orelse IsFloat_( lb )
    dim as boolean rNum = IsInt_( rb ) orelse IsFloat_( rb )
    dim as boolean lBool = (lb = Fbx.TY_BOOLEAN)
    dim as boolean rBool = (rb = Fbx.TY_BOOLEAN)

    '' Strings concatenate with '+' and compare with anything; every other operator
    '' rejects them, and mixing a string with a number rejects too.
    if lStr orelse rStr then
        if (lStr = false) orelse (rStr = false) then return Fbx.TYPE_NONE
        if IsComparison_( op ) then return types.Builtin( Fbx.TY_INTEGER )
        if op = Fbx.TK_PLUS then return types.Builtin( Fbx.TY_STRING )
        return Fbx.TYPE_NONE
    end if

    '' Equality and ordering differ on BOOLEAN, which is the sort of distinction only
    '' a measurement finds: '=' and '<>' accept a boolean against anything -- BOOLEAN
    '' when both sides are, INTEGER otherwise -- while '<', '>', '<=' and '>=' reject
    '' BOOLEAN outright, including 'boolean < boolean'.
    if IsComparison_( op ) then
        if (op = Fbx.TK_EQ) orelse (op = Fbx.TK_NE) then
            if lBool andalso rBool then return types.Builtin( Fbx.TY_BOOLEAN )
            return types.Builtin( Fbx.TY_INTEGER )
        end if
        if lBool orelse rBool then return Fbx.TYPE_NONE
        return types.Builtin( Fbx.TY_INTEGER )
    end if

    if IsShortCircuit_( op ) then
        if lBool andalso rBool then return types.Builtin( Fbx.TY_BOOLEAN )
        if (lBool orelse lNum) andalso (rBool orelse rNum) then
            return types.Builtin( Fbx.TY_INTEGER )
        end if
        return Fbx.TYPE_NONE
    end if

    if IsBitwise_( op ) then
        if lBool andalso rBool then return types.Builtin( Fbx.TY_BOOLEAN )
        if (lBool orelse lNum) andalso (rBool orelse rNum) then
            return IntResult_( lb, rb, types )
        end if
        return Fbx.TYPE_NONE
    end if

    '' Arithmetic rejects BOOLEAN outright: 'boolean + boolean' is an error, unlike
    '' 'boolean and long', which is not.
    if lBool orelse rBool then return Fbx.TYPE_NONE
    if (lNum = false) orelse (rNum = false) then return Fbx.TYPE_NONE

    if IsIntegerOp_( op ) then return IntResult_( lb, rb, types )
    if op = Fbx.TK_CARET then return types.Builtin( Fbx.TY_DOUBLE )

    '' '/' is always floating point, and SINGLE only when BOTH sides are single --
    '' unlike '+', where a single against an integer stays single. 'long / single'
    '' is DOUBLE.
    if op = Fbx.TK_SLASH then
        if (lb = Fbx.TY_SINGLE) andalso (rb = Fbx.TY_SINGLE) then
            return types.Builtin( Fbx.TY_SINGLE )
        end if
        return types.Builtin( Fbx.TY_DOUBLE )
    end if

    if IsArith_( op ) = false then return Fbx.TYPE_NONE

    if (lb = Fbx.TY_DOUBLE) orelse (rb = Fbx.TY_DOUBLE) then
        return types.Builtin( Fbx.TY_DOUBLE )
    end if
    if (lb = Fbx.TY_SINGLE) orelse (rb = Fbx.TY_SINGLE) then
        return types.Builtin( Fbx.TY_SINGLE )
    end if
    return IntResult_( lb, rb, types )
end function

'' --------------------------------------------------------------------- typing

private function StmtOf _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.StmtPayload ptr
    return @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
end function

declare function TypeOf_ _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.TypeId

'' An integer literal is the narrowest of INTEGER / LONGINT that holds it, matching
'' fbc: small literals are INTEGER, which is pointer-sized, not LONG.
private function LiteralType_ _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.TypeId

    select case c.ast->Kind( id )
    case Fbx.N_INT_LIT
        return c.types->Builtin( Fbx.TY_INTEGER )
    case Fbx.N_FLOAT_LIT
        return c.types->Builtin( Fbx.TY_DOUBLE )
    case Fbx.N_STRING_LIT, Fbx.N_STRCAT
        return c.types->Builtin( Fbx.TY_STRING )
    end select
    return Fbx.TYPE_NONE
end function

function TypeOf_ _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.TypeId

    if id = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    dim as Fbx.TypeId known = c.info->TypeOf_( id )
    if known <> Fbx.TYPE_NONE then return known

    dim as Fbx.NodeKind k = c.ast->Kind( id )
    dim as Fbx.TypeId t = Fbx.TYPE_NONE

    select case k
    case Fbx.N_INT_LIT, Fbx.N_FLOAT_LIT, Fbx.N_STRING_LIT, Fbx.N_STRCAT
        t = LiteralType_( c, id )

    case Fbx.N_IDENT
        dim as Fbx.SymbolId sid = c.info->RefOf( id )
        dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
        if s <> 0 then t = s->type_

    case Fbx.N_PAREN
        '' A parenthesised expression is a LIST node, not a statement node: its
        '' single child is in the shared child pool. Reading it through the stmt
        '' pool indexes a different array entirely, which is a segfault, not a
        '' wrong answer.
        dim as Fbx.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if lp->count > 0 then
            t = TypeOf_( c, cast( Fbx.NodeId, c.ast->children[lp->first] ) )
        end if

    case Fbx.N_UNARY
        dim as Fbx.UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Fbx.TypeId inner = TypeOf_( c, up->operand )
        dim as Fbx.TokenKind op = cast( Fbx.TokenKind, up->op )
        if inner <> Fbx.TYPE_NONE then
            if op = Fbx.KW_NOT then
                '' NOT keeps BOOLEAN boolean and widens everything else, exactly as
                '' the binary bitwise operators do.
                if c.types->BuiltinOf( inner ) = Fbx.TY_BOOLEAN then
                    t = inner
                else
                    t = BinaryResult( Fbx.KW_AND, inner, inner, *c.types )
                end if
            elseif (op = Fbx.TK_MINUS) orelse (op = Fbx.TK_PLUS) then
                t = BinaryResult( Fbx.TK_PLUS, inner, inner, *c.types )
            else
                t = inner
            end if
        end if

    case Fbx.N_BINARY
        dim as Fbx.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Fbx.TypeId lt = TypeOf_( c, bp->lhs )
        dim as Fbx.TypeId rt = TypeOf_( c, bp->rhs )
        dim as Fbx.TokenKind op = cast( Fbx.TokenKind, bp->op )
        t = BinaryResult( op, lt, rt, *c.types )
        if (t = Fbx.TYPE_NONE) andalso (lt <> Fbx.TYPE_NONE) andalso _
           (rt <> Fbx.TYPE_NONE) then
            '' Both operands are known and the combination is still not allowed --
            '' that is a real operand-type error rather than a gap in this pass.
            if (c.types->Kind( lt ) = Fbx.TK_BUILTIN) andalso _
               (c.types->Kind( rt ) = Fbx.TK_BUILTIN) then
                c.st->badOperands += 1
            end if
        end if

    case Fbx.N_DEREF
        '' Built by MakeUnary, so the payload is a UNARY, not a statement.
        dim as Fbx.UnaryPayload ptr dp = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Fbx.TypeId inner = TypeOf_( c, dp->operand )
        if inner <> Fbx.TYPE_NONE then
            if c.types->Kind( inner ) = Fbx.TK_POINTER then t = c.types->Inner( inner )
        end if

    case Fbx.N_ADDROF
        dim as Fbx.UnaryPayload ptr ap = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Fbx.TypeId inner = TypeOf_( c, ap->operand )
        if inner <> Fbx.TYPE_NONE then t = c.types->Pointer_( inner )
    end select

    if t <> Fbx.TYPE_NONE then
        c.info->SetType( id, t )
        c.st->typed += 1
    else
        c.st->untyped += 1
    end if
    return t
end function

'' ---------------------------------------------------------------- the walk

private sub WalkAll( byref c as Ctx )
    '' Every expression node in the arena, in id order. Expressions are created
    '' bottom-up by the parser, so a child always has a LOWER id than its parent and
    '' one linear pass types the whole tree without recursion into statements.
    for i as long = 1 to c.ast->Count( )
        dim as Fbx.NodeId n = cast( Fbx.NodeId, i )
        select case c.ast->Kind( n )
        case Fbx.N_INT_LIT, Fbx.N_FLOAT_LIT, Fbx.N_STRING_LIT, Fbx.N_STRCAT, _
             Fbx.N_IDENT, Fbx.N_PAREN, Fbx.N_UNARY, Fbx.N_BINARY, _
             Fbx.N_DEREF, Fbx.N_ADDROF
            TypeOf_( c, n )
        end select
    next
end sub

function Run _
    ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
      byref syms as Fbx.SymbolTable, byref types as Fbx.TypeContext, _
      byref names as Fbx.Interner, byref diags as Fbx.DiagnosticEngine, _
      byref info as Fbx.SemanticInfo, byref st as Stats ) as long

    dim as Ctx c
    c.ast = @ast
    c.syms = @syms
    c.types = @types
    c.names = @names
    c.diags = @diags
    c.info = @info
    c.st = @st
    WalkAll( c )
    return st.badOperands
end function

'' ------------------------------------------------------------------------ dump

function Dump _
    ( byref ast as Fbx.AstArena, byref src as Fbx.SourceManager, _
      byref types as Fbx.TypeContext, byref info as Fbx.SemanticInfo, _
      byref st as Stats ) as string

    dim as string outp = ""
    for i as long = 1 to ast.Count( )
        dim as Fbx.NodeId n = cast( Fbx.NodeId, i )
        if ast.Kind( n ) <> Fbx.N_INTRINSIC then continue for
        dim as Fbx.StmtPayload ptr sp = _
            @ast.stmts[cast( long, ast.nodes[cast( long, n )].data )]
        if sp->count <= 0 then continue for
        dim as Fbx.NodeId arg = cast( Fbx.NodeId, ast.children[sp->first] )
        if arg = Fbx.NODE_NONE then continue for
        dim as Fbx.TypeId t = info.TypeOf_( arg )
        dim as string nm = "?"
        if t <> Fbx.TYPE_NONE then nm = types.Name( t )
        outp += str( src.Decode( ast.Loc( n ) ).lineNo ) & " " & nm & chr( 10 )
    next
    outp += "checked: " & st.typed & " typed, " & st.untyped & " untyped, " & _
            st.badOperands & " bad operand pairs" & chr( 10 )
    return outp
end function

end namespace
