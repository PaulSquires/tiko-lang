'' binresult.bas -- THE RESULT TYPE OF A BINARY OPERATOR.
''
'' One table, measured against fbc operator by operator: concatenation, the string and
'' pointer rules, the comparison tiers and the numeric promotions.
''
'' Split out of check.bas at the 1500-line cap and included from it in the same place.
'' Nothing in it changed in the move.

function BinaryResult _
    ( byval op as Tko.TokenKind, byval lhs as Tko.TypeId, byval rhs as Tko.TypeId, _
      byref types as Tko.TypeContext ) as Tko.TypeId

    if (lhs = Tko.TYPE_NONE) orelse (rhs = Tko.TYPE_NONE) then return Tko.TYPE_NONE

    '' '&' is FreeBASIC's concatenation operator and is ALWAYS a string, whatever it
    '' is handed -- 'long & long' is STRING. It converts rather than rejecting, so it
    '' is decided before any of the numeric rules and before the builtin-only guard:
    '' concatenating a UDT with a CAST operator is still a string.
    '' '&' STAYS NARROW HERE whatever it is handed, and that is not the same answer
    '' fbc's own 'typeof( w & w )' gives -- WSTRING. Its LOWERING decides the width
    '' per term instead, measured shape by shape in tests/mir/concat-mixed: only a
    '' genuinely wide term is wide, a literal and a number are not, and a narrow prefix
    '' folds before the chain goes wide. Handing it a wide RESULT type instead made
    '' 'r = s & w' assign narrowly and drop the wide term altogether.
    if op = Tko.TK_AMP then return types.Builtin( Tko.TY_STRING )
    '' AN ENUM DECAYS TO ITS UNDERLYING INTEGER for arithmetic. Measured:
    '' 'typeof( e + 69 )' is INTEGER. Without this an enum operand fell out at the
    '' builtin-only guard below, so 'var res = a_thing + 69' inferred nothing and got
    '' a VOID slot -- and the enum itself typed fine, which is what made it puzzling.
    dim as Tko.TypeId lhs2 = StrFlavourOf_( types, lhs )
    dim as Tko.TypeId rhs2 = StrFlavourOf_( types, rhs )
    if types.Kind( lhs2 ) = Tko.TK_ENUM then lhs2 = types.Builtin( Tko.TY_INTEGER )
    if types.Kind( rhs2 ) = Tko.TK_ENUM then rhs2 = types.Builtin( Tko.TY_INTEGER )

    '' A POINTER COMPARES AS AN INTEGER and answers one: measured, 'typeof( p <> 0 )',
    '' 'typeof( p = q )' and 'typeof( p < q )' are all INTEGER. A pointer is not a
    '' builtin, so every one of them fell out at the guard below with no type at all --
    '' and an untyped comparison is a value that cannot be printed, assigned or passed.
    '' 'if p <> 0' worked all along, because a CONDITION needs no type.
    if IsComparison_( op ) then
        if (types.Kind( lhs2 ) = Tko.TK_POINTER) orelse _
           (types.Kind( rhs2 ) = Tko.TK_POINTER) then
            return types.Builtin( Tko.TY_INTEGER )
        end if
    end if

    '' POINTER ARITHMETIC, and only '+' and '-' have any. Measured:
    ''
    ''     p + n    LONG PTR      the pointer, scaled by the pointee
    ''     n + p    LONG PTR
    ''     p - n    LONG PTR
    ''     p - p    INTEGER       the DIFFERENCE is a count, not an address
    ''     q - q    INTEGER       an ANY PTR too
    ''     p * n    error 20      every other operator rejects
    ''
    '' A pointer is not a builtin, so all of them fell out at the guard below with no
    '' type at all -- and an untyped expression cannot be printed, assigned, passed or
    '' measured with sizeof.
    dim as boolean lPtr = (types.Kind( lhs2 ) = Tko.TK_POINTER)
    dim as boolean rPtr = (types.Kind( rhs2 ) = Tko.TK_POINTER)
    if lPtr orelse rPtr then
        if op = Tko.TK_MINUS then
            if lPtr andalso rPtr then return types.Builtin( Tko.TY_INTEGER )
            if lPtr then return lhs2
            return Tko.TYPE_NONE
        end if
        if op = Tko.TK_PLUS then
            if lPtr andalso rPtr then return Tko.TYPE_NONE
            if lPtr then return lhs2
            return rhs2
        end if
        return Tko.TYPE_NONE
    end if

    '' Only builtin operands are decided here. A UDT operand means an overloaded
    '' operator, which is overload resolution's business, not this table's.
    if types.Kind( lhs2 ) <> Tko.TK_BUILTIN then return Tko.TYPE_NONE
    if types.Kind( rhs2 ) <> Tko.TK_BUILTIN then return Tko.TYPE_NONE

    dim as Tko.BuiltinType lb = types.BuiltinOf( lhs2 )
    dim as Tko.BuiltinType rb = types.BuiltinOf( rhs2 )
    dim as boolean lStr = IsStringy_( lb )
    dim as boolean rStr = IsStringy_( rb )
    dim as boolean lNum = IsInt_( lb ) orelse IsFloat_( lb )
    dim as boolean rNum = IsInt_( rb ) orelse IsFloat_( rb )
    dim as boolean lBool = (lb = Tko.TY_BOOLEAN)
    dim as boolean rBool = (rb = Tko.TY_BOOLEAN)

    '' Strings concatenate with '+' and compare with anything; every other operator
    '' rejects them, and mixing a string with a number rejects too.
    if lStr orelse rStr then
        if (lStr = false) orelse (rStr = false) then return Tko.TYPE_NONE
        if IsComparison_( op ) then return types.Builtin( Tko.TY_INTEGER )
        if op = Tko.TK_PLUS then return ConcatResult_( types, lb, rb )
        return Tko.TYPE_NONE
    end if

    '' Equality and ordering differ on BOOLEAN, which is the sort of distinction only
    '' a measurement finds: '=' and '<>' accept a boolean against anything -- BOOLEAN
    '' when both sides are, INTEGER otherwise -- while '<', '>', '<=' and '>=' reject
    '' BOOLEAN outright, including 'boolean < boolean'.
    if IsComparison_( op ) then
        if (op = Tko.TK_EQ) orelse (op = Tko.TK_NE) then
            if lBool andalso rBool then return types.Builtin( Tko.TY_BOOLEAN )
            return types.Builtin( Tko.TY_INTEGER )
        end if
        if lBool orelse rBool then return Tko.TYPE_NONE
        return types.Builtin( Tko.TY_INTEGER )
    end if

    if IsShortCircuit_( op ) then
        if lBool andalso rBool then return types.Builtin( Tko.TY_BOOLEAN )
        if (lBool orelse lNum) andalso (rBool orelse rNum) then
            return types.Builtin( Tko.TY_INTEGER )
        end if
        return Tko.TYPE_NONE
    end if

    if IsBitwise_( op ) then
        if lBool andalso rBool then return types.Builtin( Tko.TY_BOOLEAN )
        if (lBool orelse lNum) andalso (rBool orelse rNum) then
            return IntResult_( lb, rb, types )
        end if
        return Tko.TYPE_NONE
    end if

    '' Arithmetic rejects BOOLEAN outright: 'boolean + boolean' is an error, unlike
    '' 'boolean and long', which is not.
    if lBool orelse rBool then return Tko.TYPE_NONE
    if (lNum = false) orelse (rNum = false) then return Tko.TYPE_NONE

    if IsIntegerOp_( op ) then return IntResult_( lb, rb, types )
    if op = Tko.TK_CARET then return types.Builtin( Tko.TY_DOUBLE )

    '' '/' is always floating point, and SINGLE only when BOTH sides are single --
    '' unlike '+', where a single against an integer stays single. 'long / single'
    '' is DOUBLE.
    if op = Tko.TK_SLASH then
        if (lb = Tko.TY_SINGLE) andalso (rb = Tko.TY_SINGLE) then
            return types.Builtin( Tko.TY_SINGLE )
        end if
        return types.Builtin( Tko.TY_DOUBLE )
    end if

    if IsArith_( op ) = false then return Tko.TYPE_NONE

    if (lb = Tko.TY_DOUBLE) orelse (rb = Tko.TY_DOUBLE) then
        return types.Builtin( Tko.TY_DOUBLE )
    end if
    if (lb = Tko.TY_SINGLE) orelse (rb = Tko.TY_SINGLE) then
        return types.Builtin( Tko.TY_SINGLE )
    end if
    return IntResult_( lb, rb, types )
end function
