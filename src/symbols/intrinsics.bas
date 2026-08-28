'' intrinsics.bas -- the keywords that are EXPRESSIONS, and what they return.
''
'' CBYTE through CPTR, PROCPTR, and the 48 IFORM_EXPR keywords -- LEN, ASC, LBOUND,
'' STR and the rest. None of them binds a symbol, so overload resolution has nothing to
'' say and the whole answer is a table measured from fbc:
''
''   tests/types/expected/fbc-conv.txt     the conversion family, exact
''   tests/types/expected/fbc-intrin.txt   the expression family, NOT exact -- see
''                                         tools/gen/check-intrin.sh for the shortfall
''
'' Included by check.bas, which owns the Ctx these read.

'' ------------------------------------------------- the conversion intrinsics

'' CSIGN / CUNSG. Measured in tests/types/expected/fbc-conv.txt, and not guessable: the
'' result is the argument's signed or unsigned COUNTERPART, and the argument itself
'' where there is none -- with a fixed-length string an asymmetric case, since 'cunsg'
'' of a ZSTRING * n is that same type while 'csign' of it is BYTE.
'' THE RESULT TYPE OF A UDT'S 'operator cast' THAT YIELDS A STRING, or TYPE_NONE.
''
'' 'operator cast' may be declared several times over different targets -- as long, as
'' string, as zstring -- and they hang off one symbol as a chain, so the first is not
'' necessarily the one being asked about.
private function UdtStringCastType_ _
    ( byref c as Ctx, byval t as Tko.TypeId ) as Tko.TypeId

    if t = Tko.TYPE_NONE then return Tko.TYPE_NONE
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> Tko.TK_UDT then return Tko.TYPE_NONE
    dim as Tko.SymbolId cs = UdtMemberSym_( c, u, "cast" )
    while cs <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr cse = c.syms->SymbolAt( cs )
        if cse = 0 then exit while
        dim as Tko.TypeId rt = cse->type_
        if rt <> Tko.TYPE_NONE then
            dim as Tko.TypeId ru = c.types->Unqualify( rt )
            if c.types->Kind( ru ) = Tko.TK_REFERENCE then
                ru = c.types->Unqualify( c.types->Inner( ru ) )
            end if
            if c.types->Kind( ru ) = Tko.TK_BUILTIN then
                select case c.types->BuiltinOf( ru )
                case Tko.TY_STRING, Tko.TY_ZSTRING, Tko.TY_WSTRING, Tko.TY_USTRING
                    return ru
                end select
            end if
        end if
        cs = cse->nextOverload
    wend
    return Tko.TYPE_NONE
end function

'' The result type of a UDT's 'operator cast' that returns a POINTER, or a NUMBER.
''
'' Same walk as UdtStringCastType_ and for the same reason: the cast operators share one
'' symbol chain, so the one that matters is found by what it RETURNS and not by taking
'' the head. Measured -- 'cast( integer ptr, bar )' emits a call to the pointer-returning
'' operator and then derefs its result, and '-v' calls the numeric one and negates ITS
'' result, with the operator's return type as the type of the whole expression.
private function UdtCastResultOf_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval wantPtr as boolean ) as Tko.TypeId

    if t = Tko.TYPE_NONE then return Tko.TYPE_NONE
    dim as Tko.TypeId u = c.types->Unqualify( t )
    if c.types->Kind( u ) <> Tko.TK_UDT then return Tko.TYPE_NONE
    dim as Tko.SymbolId cs = UdtMemberSym_( c, u, "cast" )
    while cs <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr cse = c.syms->SymbolAt( cs )
        if cse = 0 then exit while
        dim as Tko.TypeId rt = cse->type_
        if rt <> Tko.TYPE_NONE then
            dim as Tko.TypeId ru = c.types->Unqualify( rt )
            if c.types->Kind( ru ) = Tko.TK_REFERENCE then
                ru = c.types->Unqualify( c.types->Inner( ru ) )
            end if
            if wantPtr then
                if c.types->Kind( ru ) = Tko.TK_POINTER then return ru
            else
                '' A NUMBER, which is every builtin that is not one of the four string
                '' flavours -- those are UdtStringCastType_'s and mean something else at
                '' every site that asks this.
                if c.types->Kind( ru ) = Tko.TK_BUILTIN then
                    if IsStringy_( c.types->BuiltinOf( ru ) ) = false then return ru
                end if
            end if
        end if
        cs = cse->nextOverload
    wend
    return Tko.TYPE_NONE
end function

private function SignedFlip_ _
    ( byval t as Tko.TypeId, byval wantUnsigned as boolean, _
      byref types as Tko.TypeContext ) as Tko.TypeId

    if t = Tko.TYPE_NONE then return Tko.TYPE_NONE

    '' A POINTER becomes the FIXED-WIDTH integer of the pointer's size, with the
    '' requested signedness -- LONGINT on win64 and LONG on win32, not INTEGER either
    '' time, although INTEGER is the same width as both.
    if types.Kind( t ) = Tko.TK_POINTER then
        if types.target.pointerBits = 32 then
            return types.Builtin( iif( wantUnsigned, Tko.TY_ULONG, Tko.TY_LONG ) )
        end if
        return types.Builtin( iif( wantUnsigned, Tko.TY_ULONGINT, Tko.TY_LONGINT ) )
    end if

    dim as Tko.TypeId fs = FixedStringElem( t, types )
    if fs <> Tko.TYPE_NONE then
        if wantUnsigned then return t
        select case types.BuiltinOf( fs )
        case Tko.TY_ZSTRING : return types.Builtin( Tko.TY_BYTE )
        case Tko.TY_WSTRING : return types.Builtin( Tko.TY_SHORT )
        end select
        return t
    end if

    if types.Kind( t ) <> Tko.TK_BUILTIN then return t
    dim as Tko.BuiltinType b = types.BuiltinOf( t )
    if wantUnsigned then
        select case b
        case Tko.TY_BYTE,    Tko.TY_UBYTE    : return types.Builtin( Tko.TY_UBYTE )
        case Tko.TY_SHORT,   Tko.TY_USHORT   : return types.Builtin( Tko.TY_USHORT )
        case Tko.TY_LONG,    Tko.TY_ULONG    : return types.Builtin( Tko.TY_ULONG )
        case Tko.TY_INTEGER, Tko.TY_UINTEGER : return types.Builtin( Tko.TY_UINTEGER )
        case Tko.TY_LONGINT, Tko.TY_ULONGINT : return types.Builtin( Tko.TY_ULONGINT )
        end select
        return t
    end if
    select case b
    case Tko.TY_BYTE,    Tko.TY_UBYTE    : return types.Builtin( Tko.TY_BYTE )
    case Tko.TY_SHORT,   Tko.TY_USHORT   : return types.Builtin( Tko.TY_SHORT )
    case Tko.TY_LONG,    Tko.TY_ULONG    : return types.Builtin( Tko.TY_LONG )
    case Tko.TY_INTEGER, Tko.TY_UINTEGER : return types.Builtin( Tko.TY_INTEGER )
    case Tko.TY_LONGINT, Tko.TY_ULONGINT : return types.Builtin( Tko.TY_LONGINT )
    end select
    return t
end function

'' The result of an EXPRESSION intrinsic, or TYPE_NONE when this is not one.
''
'' Measured, and the surprises are the reason: ASC is ULONG rather than any character
'' type, PEEK is UBYTE, SGN is LONG whatever it is handed, and the math functions are
'' SINGLE for a single argument and DOUBLE for everything else. ABS keeps its argument's
'' PROMOTED type -- INTEGER for any integer, the float type for a float -- which is the
'' one rule here that could not have been read off a name.
''
'' Not covered, and named rather than faked: fbc CONSTANT-FOLDS several of these, so
'' 'chr( 1 )' is a ZSTRING * 2 and 'str( 1 )' a ZSTRING * n where the same call on a
'' variable is STRING. Those rows are the gate's shortfall.
'' Is this argument the bare keyword VIRTUAL? It is the second argument of
'' 'procptr( T.m, virtual )', and the parser leaves it as an identifier because
'' VIRTUAL is a keyword the expression grammar has nowhere else to put.
private function IsVirtualKeyword_( byref c as Ctx, byval a as Tko.NodeId ) as boolean
    if a = Tko.NODE_NONE then return false
    if c.ast->Kind( a ) <> Tko.N_IDENT then return false
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, a )].data )]
    return (Tko.Text.LowerAscii( c.names->Spelling( ip->name ) ) = "virtual")
end function

private function ExprIntrinsicType_ _
    ( byref c as Ctx, byref nm as string, byval cp as Tko.ListPayload ptr ) as Tko.TypeId

    dim as Tko.TypeId a0 = Tko.TYPE_NONE
    if cp->count > 0 then
        a0 = TypeOf_( c, cast( Tko.NodeId, c.ast->children[cp->first] ) )
    end if
    dim as Tko.BuiltinType ab = Tko.TY_NONE
    if a0 <> Tko.TYPE_NONE then
        dim as Tko.TypeId fs = FixedStringElem( a0, *c.types )
        if fs <> Tko.TYPE_NONE then
            ab = c.types->BuiltinOf( fs )
        elseif c.types->Kind( a0 ) = Tko.TK_BUILTIN then
            ab = c.types->BuiltinOf( a0 )
        else
            '' A UDT THAT CASTS TO A STRING IS THAT STRING, for the WHOLE family and
            '' not only for STR. Measured, over a type declaring
            '' 'operator cast( ) byref as const wstring' and one declaring
            '' 'operator cast( ) byref as string':
            ''
            ''     asc( wide_udt )      ULONG        asc( narrow_udt )    ULONG
            ''     val( narrow_udt )    DOUBLE       instr( narrow_udt, "a" )  INTEGER
            ''     trim( narrow_udt )   STRING       left( narrow_udt, 1 )     STRING
            ''
            '' The acceptance test below reads the argument's BUILTIN type, and a UDT
            '' has none -- so every one of those came out UNTYPED. That is not a
            '' diagnostic: 'print asc( u )' declined for want of anything to print,
            '' while 'dim k as integer = asc( u )' one line down lowered, because a
            '' DECLARATION takes its type from the variable.
            dim as Tko.TypeId sc = UdtStringCastType_( c, a0 )
            if sc <> Tko.TYPE_NONE then ab = c.types->BuiltinOf( sc )
        end if
    end if

    '' ACCEPTANCE is measured too, and is most of the table: fbc REFUSES 'asc( v_byte )'
    '' and 'chr( v_string )', where a rule built only from result types would happily
    '' answer both. Each family names the argument class it takes.
    '' A 'string * N' IS A STRING ARGUMENT. FixedStringElem answers TY_FIXSTR for one
    '' -- that is what it is for -- and IsStringy_ does not list TY_FIXSTR, so every
    '' intrinsic in this table refused a fixed narrow string and left the call UNTYPED.
    ''
    '' Measured, and fbc takes all of them over one, with the same result types the
    '' var-length forms give:
    ''
    ''   wstr( fs )      WSTRING * 1        val( fs )     DOUBLE
    ''   asc( fs )       ULONG              left( fs, 2 ) STRING
    ''   trim( fs )      STRING             ucase( fs )   STRING
    ''
    '' The cost of the omission was not a diagnostic: an untyped argument makes the
    '' ENCLOSING call untypable too, so 'proc( wstr( fs ) )' declined with the failure
    '' three layers from its cause -- the argument path asks IsWideString_ of the
    '' argument's type and there was none.
    ''
    '' NARROWED TO THIS TABLE deliberately. IsStringy_ also feeds assignment legality,
    '' binary-result typing and conversion cost, all of which are gated at 100% against
    '' fbc and reach a fixed string by another route; widening it there is a separate
    '' question with its own measurements to make.
    dim as boolean isStr = IsStringy_( ab ) orelse (ab = Tko.TY_FIXSTR)
    dim as boolean isNum = IsInt_( ab ) orelse IsFloat_( ab ) orelse (ab = Tko.TY_BOOLEAN)
    '' An ARRAY or a POINTER counts as numeric for these: measured, fbc takes
    '' 'chr( v_ptr )' and 'abs( v_arr )' and answers as if given a number.
    if a0 <> Tko.TYPE_NONE then
        select case c.types->Kind( a0 )
        case Tko.TK_POINTER : isNum = true
        case Tko.TK_ARRAY
            if FixedStringElem( a0, *c.types ) = Tko.TYPE_NONE then isNum = true
        end select
    end if
    dim as boolean isPtr = false
    if a0 <> Tko.TYPE_NONE then isPtr = (c.types->Kind( a0 ) = Tko.TK_POINTER)
    dim as boolean isArr = false
    if a0 <> Tko.TYPE_NONE then
        isArr = (c.types->Kind( a0 ) = Tko.TK_ARRAY) andalso _
                (FixedStringElem( a0, *c.types ) = Tko.TYPE_NONE)
    end if

    select case nm
    '' LEN and SIZEOF measure ANYTHING, which is the exception rather than the rule.
    '' OFFSETOF( T, field ) IS A COMPILE-TIME INTEGER, measured -- 'offsetof( E, i )'
    '' over a type whose first two fields are INTEGERs is 16, and 'typeof' of it is
    '' INTEGER. It takes a TYPE and a FIELD NAME rather than two expressions, so
    '' neither argument has a type of its own and the count is the only guard here.
    case "offsetof"
        if cp->count <> 2 then return Tko.TYPE_NONE
        return c.types->Builtin( Tko.TY_INTEGER )
    case "len", "sizeof"
        return c.types->Builtin( Tko.TY_INTEGER )
    case "lbound", "ubound"
        if isArr = false then return Tko.TYPE_NONE
        return c.types->Builtin( Tko.TY_INTEGER )
    case "instr", "instrrev"
        if isStr = false then return Tko.TYPE_NONE
        return c.types->Builtin( Tko.TY_INTEGER )
    '' ASC IS ULONG, and it matches fb_ASC's own uint32 return. An earlier note here
    '' claimed UINTEGER; '#print typeof( asc( v_string ) )' says ULONG on win64, and
    '' so does the intrin truth table it is checked against. Typed a width too wide,
    '' every 'asc' fed a LONGINT where fbc has a LONG.
    case "asc"
        if isStr = false then return Tko.TYPE_NONE
        return c.types->Builtin( Tko.TY_ULONG )
    '' THE VAL FAMILY, which was not in this table at all -- so 'print val( s )' had
    '' nothing to print and declined, while 'dim as double d = val( s )' lowered
    '' because the DECLARATION supplies the type. Measured with '#print typeof', and
    '' the two middle rows are the surprise: 'valint' is LONG and 'valuint' is ULONG,
    '' NOT integer and uinteger, whatever their names say.
    case "val"     : if isStr = false then return Tko.TYPE_NONE
                     return c.types->Builtin( Tko.TY_DOUBLE )
    case "vallng"  : if isStr = false then return Tko.TYPE_NONE
                     return c.types->Builtin( Tko.TY_LONGINT )
    case "valulng" : if isStr = false then return Tko.TYPE_NONE
                     return c.types->Builtin( Tko.TY_ULONGINT )
    case "valint"  : if isStr = false then return Tko.TYPE_NONE
                     return c.types->Builtin( Tko.TY_LONG )
    case "valuint" : if isStr = false then return Tko.TYPE_NONE
                     return c.types->Builtin( Tko.TY_ULONG )
    case "peek"
        if (isNum orelse isPtr) = false then return Tko.TYPE_NONE
        return c.types->Builtin( Tko.TY_UBYTE )
    '' SGN TAKES NO POINTER. fbc rejects 'sgn( p )' outright, and the general isNum
    '' above says yes to one because most of this table's arithmetic does accept a
    '' pointer. Answering LONG for it made a rejected program lower.
    case "sgn"
        if isPtr then return Tko.TYPE_NONE
        if isNum = false then return Tko.TYPE_NONE
        return c.types->Builtin( Tko.TY_LONG )
    '' BIT / BITSET / BITRESET are LONGINT whatever they are given. Measured, over a
    '' LONG and over a UBYTE alike, fbc widens the operand and keeps the result wide:
    ''
    ''   bit( l, j )       (int64)-(((int64)L$0 & (1ll << (J$0 & 63ll))) != 0ll)
    ''   bitset( l, j )    (int64)L$0 | (1ll << (J$0 & 63ll))
    ''
    '' -- the narrowing back to LONG in 'l = bitset( l, j )' comes from the ASSIGNMENT,
    '' not from the intrinsic. Untyped, every one of them declined.
    '' DIR IS A STRING in every one of its spellings -- 'dir( )', 'dir( pattern )',
    '' 'dir( pattern, attrib )', 'dir( pattern, attrib, outAttrib )' and the bare
    '' continuation 'dir( outAttrib )'. It was not in this table at all, so every
    '' assignment from one had nothing to store: file/dir-overloads.bas is fifteen
    '' lines of nothing else.
    case "dir"
        return c.types->Builtin( Tko.TY_STRING )
    case "bit", "bitset", "bitreset"
        if isPtr then return Tko.TYPE_NONE
        if isNum = false then return Tko.TYPE_NONE
        return c.types->Builtin( Tko.TY_LONGINT )
    '' WCHR is WIDE, and its length is the ARGUMENT COUNT PLUS ONE: measured with
    '' '#print typeof', 'wchr( 65 )' is 'WSTRING * 2' and 'wchr( 65, 66 )' is
    '' 'WSTRING * 3' -- the terminator counts. Untyped, every term built out of one
    '' read as NEUTRAL, so 'u &= wchr( QUOTE )' over a ustring could not tell which
    '' flavour it was appending and declined.
    case "wchr"
        if isNum = false then return Tko.TYPE_NONE
        '' 'WSTRING * 1', whatever the argument count. The 'WSTRING * 2' and
        '' 'WSTRING * 3' an earlier note here recorded are what fbc gives a CONSTANT
        '' argument, which it FOLDS into a literal of that width; the runtime call is
        '' 'WSTRING * 1' for one argument and for two alike -- measured on both.
        '' tiko-lang does not fold, so the runtime answer is the honest one, and the
        '' folded row is a divergence check-intrin reports rather than one this hides.
        return c.types->ArrayOf( c.types->Builtin( Tko.TY_WSTRING ), 1, 1 )
    case "chr", "mki", "mkl", "mks", "mkd", "mkshort", "mklongint"
        if isNum = false then return Tko.TYPE_NONE
        return c.types->Builtin( Tko.TY_STRING )
    '' THE CVx FAMILY TAKES A NUMBER TOO. 'cvi( 1.58e40 )' reinterprets a DOUBLE'S
    '' BITS rather than a string's bytes -- fbc has a separate entry point for each
    '' pairing -- and requiring a string here typed every one of them as nothing, so
    '' the declaration they initialise had no value to store.
    case "cvi", "cvl", "cvs", "cvd", "cvshort", "cvlongint"
        if (isStr orelse isNum) = false then return Tko.TYPE_NONE
        select case nm
        case "cvi"       : return c.types->Builtin( Tko.TY_INTEGER )
        case "cvl"       : return c.types->Builtin( Tko.TY_LONG )
        case "cvs"       : return c.types->Builtin( Tko.TY_SINGLE )
        case "cvd"       : return c.types->Builtin( Tko.TY_DOUBLE )
        case "cvshort"   : return c.types->Builtin( Tko.TY_SHORT )
        end select
        return c.types->Builtin( Tko.TY_LONGINT )
    case "strptr", "sadd"
        '' A UDT THAT CASTS TO A STRING IS A STRING OPERAND HERE TOO, by the same rule
        '' STR follows: measured, '#print typeof( strptr( u ) )' over a type with
        '' 'operator cast( ) byref as zstring' is ZSTRING PTR, and fbc emits the cast
        '' and nothing else. udt-zstring/strptr.bas writes it nine times.
        '' ASKED FIRST, for the reason STR is: with the cast folded into 'ab' the
        '' isStr test below is now TRUE for one of these, and the wide/narrow rules
        '' after it would answer for the CAST'S FLAVOUR rather than for the cast.
        dim as Tko.TypeId spct = UdtStringCastType_( c, a0 )
        if spct <> Tko.TYPE_NONE then return c.types->Pointer_( spct )
        '' A WIDE operand gives a WIDE pointer: '#print typeof( strptr( w ) )' over a
        '' 'wstring * 4' is 'WSTRING * 4 PTR', not a zstring ptr. Typing it narrow made
        '' 'dim pw as wstring ptr = strptr( w )' an incompatible initialiser and
        '' declined every use of pw after it.
        if isStr = false then return Tko.TYPE_NONE
        if ab = Tko.TY_WSTRING then
            return c.types->Pointer_( c.types->Builtin( Tko.TY_WSTRING ) )
        end if
        return c.types->Pointer_( c.types->Builtin( Tko.TY_ZSTRING ) )
    case "varptr"
        if a0 = Tko.TYPE_NONE then return Tko.TYPE_NONE
        return c.types->Pointer_( a0 )

    '' SINGLE in, SINGLE out; everything else DOUBLE.
    '' NONE OF THE MATH FAMILY TAKES A POINTER. fbc rejects every one of them over an
    '' 'any ptr' -- measured, all nine -- and the general isNum above says yes to one
    '' because most of this table's arithmetic does accept a pointer. Answering DOUBLE
    '' for them made a rejected program lower.
    case "sin", "cos", "tan", "atn", "asin", "acos", "exp", "log", "sqr"
        if isPtr then return Tko.TYPE_NONE
        if isNum = false then return Tko.TYPE_NONE
        if ab = Tko.TY_SINGLE then return c.types->Builtin( Tko.TY_SINGLE )
        return c.types->Builtin( Tko.TY_DOUBLE )

    '' The argument's PROMOTED type: any integer gives INTEGER, a float gives itself.
    case "abs", "int", "fix"
        if ab = Tko.TY_NONE then return Tko.TYPE_NONE
        if IsFloat_( ab ) then return c.types->Builtin( ab )
        if IsInt_( ab ) then return c.types->Builtin( Tko.TY_INTEGER )
        return Tko.TYPE_NONE

    '' A string function keeps the string KIND it was given.
    '' STR is always a var-length STRING, even for a WSTRING argument -- unlike TRIM and
    '' the rest, which keep the kind they were handed.
    '' STR OF A UDT THAT CASTS TO A STRING IS THE CAST, and its type is the CAST'S own:
    '' measured, '#print typeof( str( u ) )' over a type with 'operator cast( ) byref as
    '' zstring' is ZSTRING, not STRING. fbc emits no conversion at all for the shape.
    ''
    '' Untyped, it was not merely this call that declined. A concatenation is typed from
    '' its LEFT TERM, so 'str( u ) & ", "' had nothing to classify and PRINT gave up on
    '' the whole item -- while '", " & str( u )', the same terms the other way round,
    '' lowered. That asymmetry is what the corpus's QT( ) macro walks into.
    case "str"
        '' ASKED BEFORE the general rules, because with the cast folded into 'ab'
        '' above STR would otherwise answer STRING for a WIDE cast -- and measured,
        '' '#print typeof( str( u ) )' over 'operator cast( ) byref as const wstring'
        '' is CONST WSTRING. STR keeps the CAST'S own kind, not the STRING every other
        '' argument gives it.
        dim as Tko.TypeId ct = UdtStringCastType_( c, a0 )
        if ct <> Tko.TYPE_NONE then return ct
        if (isNum orelse isStr) = false then return Tko.TYPE_NONE
        return c.types->Builtin( Tko.TY_STRING )
    '' WSTR IS A FIXED WSTRING, not a var-length one, and the LENGTH is measured:
    '' 'WSTRING * 1' for every argument fbc accepts except a fixed wstring, which keeps
    '' its own. Typing it as nothing at all left every concatenation of one untyped --
    '' 'wstr( i ) + w' as a SELECT CASE subject is 19 corpus declines by itself.
    case "wstr"
        '' ...and the wide half takes one too: 'wstr( u )' over the same type is
        '' 'WSTRING * 1', the length every accepted argument gets.
        if (isNum orelse isStr) = false then
            if UdtStringCastType_( c, a0 ) = Tko.TYPE_NONE then return Tko.TYPE_NONE
        end if
        dim as long wn = 1
        if ab = Tko.TY_WSTRING then
            if c.types->Kind( a0 ) = Tko.TK_ARRAY then wn = c.types->ElemCount( a0 )
        end if
        if wn < 1 then wn = 1
        return c.types->ArrayOf( c.types->Builtin( Tko.TY_WSTRING ), 1, wn )
    '' STRING( n, ch ), WSTRING( n, ch ) AND SPACE( n ). Measured with '#print typeof':
    '' STRING and STRING, and 'WSTRING * 1' for the wide one -- the same shape wstr( )
    '' has. Untyped, 'len( string( 3, "a" ) )' had nothing to measure and declined,
    '' while 'dim as string a = string( 3, "a" )' beside it lowered.
    case "space"
        if isNum = false then return Tko.TYPE_NONE
        return c.types->Builtin( Tko.TY_STRING )
    case "string"
        return c.types->Builtin( Tko.TY_STRING )
    case "wstring"
        return c.types->ArrayOf( c.types->Builtin( Tko.TY_WSTRING ), 1, 1 )

    '' THE RADIX FAMILY. Measured with '#print typeof(...)': hex, oct and bin are
    '' STRING and their wide halves are 'WSTRING * 1' -- the same shape wstr( ) has,
    '' and not a bare WSTRING. Untyped, every one of them made its CONSUMER decline:
    '' 'takeZstringPtr( hex( n ) )' reached overload resolution with an argument of no
    '' type and resolved to nothing.
    case "hex", "oct", "bin"
        if isNum = false then return Tko.TYPE_NONE
        return c.types->Builtin( Tko.TY_STRING )
    case "whex", "woct", "wbin"
        if isNum = false then return Tko.TYPE_NONE
        return c.types->ArrayOf( c.types->Builtin( Tko.TY_WSTRING ), 1, 1 )
    case "trim", "ltrim", "rtrim", "ucase", "lcase", "mid", "left", "right"
        if isStr = false then return Tko.TYPE_NONE
        '' A WIDE ARGUMENT GIVES 'WSTRING * 1', not a bare WSTRING. The two are
        '' different types to fbc -- '*p' over a 'wstring ptr' prints WSTRING and
        '' 'trim( w )' prints WSTRING * 1 -- and the bare one is what a byref
        '' parameter declares, so typing the result that way made every one of these
        '' look like a reference to somebody else's storage.
        if ab = Tko.TY_WSTRING then
            return c.types->ArrayOf( c.types->Builtin( Tko.TY_WSTRING ), 1, 1 )
        end if
        return c.types->Builtin( Tko.TY_STRING )

    '' The two GRAPHICS expressions. Their result types are measured from what fbc
    '' declares -- 'void* fb_GfxImageCreate( ... )' and 'uint32 fb_GfxPoint( ... )' --
    '' and neither was typed at all, so 'dim as any ptr a = imagecreate( 16, 16 )'
    '' declined with no idea what it was declining.
    case "imagecreate"
        return c.types->Pointer_( c.types->Builtin( Tko.TY_ANY ) )
    '' RGB and RGBA are PREDECLARED NAMES, not procedures -- 'dim as long rgb' is
    '' fbc's error 4, duplicated definition -- and they fold to shifts rather than to
    '' a call, so they cannot go in the prelude with the rest of the graphics surface.
    case "rgb", "rgba"
        return c.types->Builtin( Tko.TY_ULONG )
    case "point"
        return c.types->Builtin( Tko.TY_ULONG )
    end select
    return Tko.TYPE_NONE
end function

'' The name at an untyped leaf: the identifier itself, or a call's or member's callee.
'' Nothing is recorded for a leaf that has no name to record.
private sub NoteUntypedName_( byref c as Ctx, byval id as Tko.NodeId )
    if c.st->argUntypedNames.Count >= 200000 then return
    dim as Tko.NodeId n = id
    if c.ast->Kind( n ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr cp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        n = cp->target
    end if
    if n = Tko.NODE_NONE then return
    if c.ast->Kind( n ) = Tko.N_MEMBER then
        dim as Tko.BinaryPayload ptr mb = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, n )].data )]
        n = mb->rhs
    end if
    if n = Tko.NODE_NONE then return
    if c.ast->Kind( n ) <> Tko.N_IDENT then return
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, n )].data )]
    c.st->argUntypedNames.Push( cast( ulong, ip->name ) )
end sub

'' The deepest node that is still untyped, following the single path a wrapper takes.
''
'' An argument's own kind is usually N_PAREN or N_BINARY, which says only "something
'' inside is missing". Descending to the leaf turns the count into the list of expression
'' forms actually not implemented -- which is the difference between "1,995 parentheses"
'' and a name to go and write.
private function UntypedLeaf_ _
    ( byref c as Ctx, byval id as Tko.NodeId ) as Tko.NodeId

    dim as Tko.NodeId cur = id
    for guard as long = 0 to 63
        select case c.ast->Kind( cur )
        case Tko.N_PAREN
            dim as Tko.ListPayload ptr lp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, cur )].data )]
            if lp->count <> 1 then return cur
            cur = cast( Tko.NodeId, c.ast->children[lp->first] )
        case Tko.N_UNARY
            dim as Tko.UnaryPayload ptr up = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, cur )].data )]
            cur = up->operand
        case Tko.N_BINARY
            '' Whichever side is the untyped one; if both are, the left is reported and
            '' the right will be counted on its own the next time round.
            dim as Tko.BinaryPayload ptr bp = _
                @c.ast->binaries[cast( long, c.ast->nodes[cast( long, cur )].data )]
            if TypeOf_( c, bp->lhs ) = Tko.TYPE_NONE then
                cur = bp->lhs
            elseif TypeOf_( c, bp->rhs ) = Tko.TYPE_NONE then
                cur = bp->rhs
            else
                return cur
            end if
        case else
            return cur
        end select
    next
    return cur
end function

'' The TYPE of a procedure symbol -- 'sub cdecl ( byval x as long )' -- as opposed to its
'' return type, which is what Symbol.type_ holds. A procedure type is already a pointer in
'' FreeBASIC, so this wraps one: 'sub( ) ptr' is PPFvvE, two Ps for that reason.
'' The head of a UDT's constructor or destructor overload chain, by the internal name
'' the mangler uses. Check's own lookup, so it does not reach into lowering's.
private function StructorHead_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref which as string ) as Tko.SymbolId
    return UdtMemberSym_( c, t, which )
end function

declare function ProcPtrPickOverload_ _
    ( byref c as Ctx, byval head as Tko.SymbolId, _
      byval lp as Tko.ListPayload ptr ) as Tko.SymbolId

private function MemberProcPtr_ _
    ( byref c as Ctx, byval fnE as Tko.NodeId, byval lp as Tko.ListPayload ptr ) as Tko.SymbolId

    '' A BARE OVERLOADED NAME TAKES THE SAME SIGNATURE MATCH. 'procptr( s, sub( ) )'
    '' over two subs called 's' is measured as '&_Z1Sv' and
    '' 'procptr( s, sub( byval as byte ) )' as '&_Z1Sa' -- the same rule the member
    '' form already had, over a chain that hangs off the name instead of off a type.
    '' Without it only the first overload was ever bound, so the signature was read
    '' and then ignored.
    if c.ast->Kind( fnE ) = Tko.N_IDENT then
        if lp->count < 2 then return Tko.SYMBOL_NONE
        dim as Tko.SymbolId bh = c.info->RefOf( fnE )
        dim as Tko.Symbol ptr bhs = c.syms->SymbolAt( bh )
        if bhs = 0 then return Tko.SYMBOL_NONE
        if bhs->kind <> cast( ubyte, Tko.SYM_PROC ) then return Tko.SYMBOL_NONE
        return ProcPtrPickOverload_( c, bh, lp )
    end if

    if c.ast->Kind( fnE ) <> Tko.N_MEMBER then return Tko.SYMBOL_NONE
    dim as Tko.BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, fnE )].data )]
    if c.ast->Kind( mp->rhs ) <> Tko.N_IDENT then return Tko.SYMBOL_NONE
    dim as Tko.IdentPayload ptr rip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, mp->rhs )].data )]
    dim as string mname = Tko.Text.LowerAscii( c.names->Spelling( rip->name ) )

    '' The TYPE the member belongs to: the left side names it.
    dim as Tko.Symbol ptr ls = c.syms->SymbolAt( c.info->RefOf( mp->lhs ) )
    if ls = 0 then return Tko.SYMBOL_NONE
    if ls->kind <> cast( ubyte, Tko.SYM_UDT ) then return Tko.SYMBOL_NONE
    dim as Tko.TypeId ut = c.types->Unqualify( ls->type_ )
    if ut = Tko.TYPE_NONE then return Tko.SYMBOL_NONE

    dim as Tko.SymbolId head = Tko.SYMBOL_NONE
    select case mname
    case "constructor" : head = StructorHead_( c, ut, "__ctor" )
    case "destructor"  : head = StructorHead_( c, ut, "__dtor" )
    case else
        '' AN ORDINARY MEMBER TOO, because the SIGNATURE FORM has to reach it: without
        '' this 'procptr( T.M, sub( byval as long ) )' fell back to whatever Resolve
        '' bound, which is the FIRST overload -- a silently wrong function address.
        head = UdtMemberSym_( c, ut, mname )
    end select
    if head = Tko.SYMBOL_NONE then return Tko.SYMBOL_NONE
    dim as Tko.Symbol ptr hs = c.syms->SymbolAt( head )
    if hs = 0 then return Tko.SYMBOL_NONE
    if hs->kind <> cast( ubyte, Tko.SYM_PROC ) then return Tko.SYMBOL_NONE

    '' NO SIGNATURE WRITTEN: the first overload, which is what fbc takes.
    if lp->count < 2 then return head
    return ProcPtrPickOverload_( c, head, lp )
end function


'' The overload in 'head''s chain whose PARAMETER TYPES match the written signature,
'' position for position. Shared by the member and the bare-name forms.
function ProcPtrPickOverload_ _
    ( byref c as Ctx, byval head as Tko.SymbolId, _
      byval lp as Tko.ListPayload ptr ) as Tko.SymbolId

    '' A SIGNATURE WRITTEN AND NOT MATCHED IS A DECLINE, never a fallback to the first.
    '' The whole point of writing one is that the first is not the one wanted, so
    '' answering with it would be a wrong address that lowers and verifies.
    dim as Tko.SymbolId noMatch = Tko.SYMBOL_NONE

    '' A SIGNATURE: the one whose PARAMETER TYPES match it, position for position. A
    '' destructor takes none, so this only ever discriminates constructors.
    dim as Tko.NodeId sigN = cast( Tko.NodeId, c.ast->children[lp->first + 1] )
    if c.ast->Kind( sigN ) <> Tko.N_TYPEREF then return noMatch
    dim as Tko.TypeId sigT = c.info->TypeOf_( sigN )
    if sigT = Tko.TYPE_NONE then return noMatch
    '' A procedure TYPE is already a pointer in FreeBASIC; the callable is inside it.
    if c.types->Kind( sigT ) = Tko.TK_POINTER then sigT = c.types->Inner( sigT )
    if c.types->Kind( sigT ) <> Tko.TK_PROC then return noMatch

    '' A procedure type's parameters live in the type pool: 'count' of them from
    '' 'first', the same way the mangler and the type printer read one.
    dim as long want = c.types->types[cast( long, sigT )].count
    dim as Tko.SymbolId cur = head
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
            '' THE RECEIVER IS NOT IN THE WRITTEN SIGNATURE. 'sub( byval as integer )'
            '' describes a one-argument constructor, whose N_PROC also carries 'this'
            '' nowhere -- the parameters counted here are the declared ones only.
            dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
            dim as long have = 0
            for i as long = 0 to pp->count - 1
                dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                if c.ast->Kind( prm ) = Tko.N_PARAM then have += 1
            next
            if have = want then
                dim as boolean same = true
                dim as long seen = 0
                for i as long = 0 to pp->count - 1
                    dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                    if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
                    dim as Tko.TypeId pt = c.info->TypeOf_( StmtOf( c, prm )->a )
                    dim as Tko.TypeId wt = Tko.TYPE_NONE
                    if seen < want then
                        wt = cast( Tko.TypeId, _
                            c.types->pool[c.types->types[cast( long, sigT )].first + seen] )
                    end if
                    if (pt <> Tko.TYPE_NONE) andalso (wt <> Tko.TYPE_NONE) then
                        dim as Tko.TypeId pu = c.types->Unqualify( pt )
                        dim as Tko.TypeId wu = c.types->Unqualify( wt )
                        if c.types->Kind( wu ) = Tko.TK_REFERENCE then
                            wu = c.types->Unqualify( c.types->Inner( wu ) )
                        end if
                        if c.types->Kind( pu ) = Tko.TK_REFERENCE then
                            pu = c.types->Unqualify( c.types->Inner( pu ) )
                        end if
                        if pu <> wu then same = false
                    end if
                    seen += 1
                next
                if same then return cur
            end if
        end if
        cur = s->nextOverload
    wend
    return noMatch
end function

private function ProcTypeOfSymbol_ _
    ( byref c as Ctx, byval sid as Tko.SymbolId ) as Tko.TypeId

    if sid = Tko.SYMBOL_NONE then return Tko.TYPE_NONE
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return Tko.TYPE_NONE
    if s->kind <> cast( ubyte, Tko.SYM_PROC ) then return Tko.TYPE_NONE
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( pn ) <> Tko.N_PROC then return Tko.TYPE_NONE

    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    dim as Tko.TypeId ret = s->type_
    if ret = Tko.TYPE_NONE then ret = c.types->Builtin( Tko.TY_VOID )
    dim as Tko.TypeIdVec2 ps

    '' AN INSTANCE MEMBER'S SIGNATURE STARTS WITH ITS RECEIVER. Measured:
    '' '#print typeof( procptr( T.proc1 ) )' over a member sub with no parameters of its
    '' own is SUB(AS T), and fbc's C declares it 'void _ZN1T5PROC1Ev( struct $1T* )'.
    '' Leaving the receiver out gave 'sub( ) ptr' -- a type of the wrong arity, which
    '' every call through the pointer then disagreed with.
    ''
    '' A STATIC member has no receiver, which is what PF_STATIC says; a free procedure
    '' has no owning TYPE scope to find one in.
    if (pp->extra and Tko.PF_STATIC) = 0 then
        dim as Tko.SymScope ptr osc = c.syms->ScopeAt( s->parent )
        if osc <> 0 then
            if osc->kind = cast( ubyte, Tko.SCOPEK_TYPE ) then
                dim as Tko.Symbol ptr ow = c.syms->SymbolAt( osc->owner )
                if ow <> 0 then
                    if ow->type_ <> Tko.TYPE_NONE then
                        ps.Push( cast( ulong, c.types->Reference( ow->type_ ) ) )
                    end if
                end if
            end if
        end if
    end if

    for i as long = 0 to pp->count - 1
        dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
        dim as Tko.StmtPayload ptr sp2 = StmtOf( c, prm )
        dim as Tko.TypeId pt = c.info->TypeOf_( sp2->a )
        if pt = Tko.TYPE_NONE then return Tko.TYPE_NONE
        if (c.ast->nodes[cast( long, prm )].flags and Tko.NF_BYREF) <> 0 then
            pt = c.types->Reference( pt )
        end if
        ps.Push( cast( ulong, pt ) )
    next
    return c.types->Pointer_( c.types->ProcType( ret, ps ) )
end function

'' IS THIS NODE THE RECEIVER -- the implicit 'this' of a member body? It is declared
'' by Collect and typed by Resolve as a POINTER to the owning type; nothing else in
'' scope can carry that name, because THIS is a keyword everywhere else.
private function IsThisIdent_( byref c as Ctx, byval n as Tko.NodeId ) as boolean
    if n = Tko.NODE_NONE then return false
    if c.ast->Kind( n ) <> Tko.N_IDENT then return false
    dim as Tko.InternId nm = _
        c.ast->idents[cast( long, c.ast->nodes[cast( long, n )].data )].name
    if c.names->Fold( nm ) <> c.names->Fold( c.names->GetString( "this" ) ) then
        return false
    end if
    dim as Tko.Symbol ptr sy = c.syms->SymbolAt( c.info->RefOf( n ) )
    if sy = 0 then return false
    return (sy->kind = cast( ubyte, Tko.SYM_PARAMETER ))
end function

'' The result type of a conversion intrinsic, or TYPE_NONE when this is not one.
''
'' These are KEYWORDS in expression position, so no symbol is ever bound and the callee
'' lookup finds nothing: the whole answer is a table, measured in
'' tests/types/expected/fbc-conv.txt. Their acceptance is WIDER than assignment's --
'' 'cbyte( a_string )' is a BYTE to fbc while 'dim as byte b = a_string' is refused --
'' so ConversionCost is not the viability test here and is not used as one.
'' The TYPE a PEEK or POKE names, written either as a bare builtin keyword -- which
'' the intrinsic argument parser reads as an IDENT -- or as a 'typeof', which is a
'' TYPEREF. Both are the same argument.
private function PeekTypeArg_ _
    ( byref c as Ctx, byval n as Tko.NodeId ) as Tko.TypeId

    if n = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( n ) = Tko.N_TYPEREF then return c.info->TypeOf_( n )
    '' 'peek( typeof( b ), p )' -- in an INTRINSIC argument list every argument is
    '' read as an expression, so a 'typeof' arrives as a CALL rather than as the
    '' TYPEREF the declaration parser would have made. Its operand's type is the
    '' answer either way.
    if c.ast->Kind( n ) = Tko.N_CALL then
        dim as Tko.ListPayload ptr tp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, n )].data )]
        if tp->count <> 1 then return Tko.TYPE_NONE
        if tp->target = Tko.NODE_NONE then return Tko.TYPE_NONE
        if c.ast->Kind( tp->target ) <> Tko.N_IDENT then return Tko.TYPE_NONE
        dim as Tko.IdentPayload ptr tnp = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, tp->target )].data )]
        if Tko.Text.LowerAscii( c.names->Spelling( tnp->name ) ) <> "typeof" then
            return Tko.TYPE_NONE
        end if
        return TypeOf_( c, cast( Tko.NodeId, c.ast->children[tp->first] ) )
    end if
    if c.ast->Kind( n ) <> Tko.N_IDENT then return Tko.TYPE_NONE
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, n )].data )]
    select case Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )
    case "byte"     : return c.types->Builtin( Tko.TY_BYTE )
    case "ubyte"    : return c.types->Builtin( Tko.TY_UBYTE )
    case "short"    : return c.types->Builtin( Tko.TY_SHORT )
    case "ushort"   : return c.types->Builtin( Tko.TY_USHORT )
    case "long"     : return c.types->Builtin( Tko.TY_LONG )
    case "ulong"    : return c.types->Builtin( Tko.TY_ULONG )
    case "integer"  : return c.types->Builtin( Tko.TY_INTEGER )
    case "uinteger" : return c.types->Builtin( Tko.TY_UINTEGER )
    case "longint"  : return c.types->Builtin( Tko.TY_LONGINT )
    case "ulongint" : return c.types->Builtin( Tko.TY_ULONGINT )
    case "single"   : return c.types->Builtin( Tko.TY_SINGLE )
    case "double"   : return c.types->Builtin( Tko.TY_DOUBLE )
    end select

    '' ...OR A NAMED TYPE. 'type array as ubyte' followed by
    '' 'peek( array, array( 0 ) )' is how quirk/peek-poke.bas checks that a TYPEDEF
    '' and an array SUBSCRIPT of the same spelling are told apart -- the first
    '' argument is the type and the second the pointer, and only their position says
    '' which is which.
    '' THE SCOPE COMES FROM WHAT RESOLVE BOUND, not from ScopeOf: Collect never walks
    '' a procedure BODY, so an expression node inside one has no scope of its own.
    '' Resolve bound this name to the VARIABLE -- 'dim as ubyte ptr array( 0 to 1 )'
    '' is declared before 'type array as ubyte' shadows it -- and the type of the
    '' same spelling lives in that variable's own scope.
    dim as Tko.Symbol ptr rsy = c.syms->SymbolAt( c.info->RefOf( n ) )
    dim as Tko.ScopeId look = Tko.SCOPE_NONE
    if rsy <> 0 then
        select case rsy->kind
        case Tko.SYM_UDT, Tko.SYM_TYPEDEF
            return rsy->type_
        end select
        look = rsy->parent
    end if
    if look = Tko.SCOPE_NONE then look = c.info->ScopeOf( n )
    dim as Tko.SymbolId tsid = c.syms->LookupTyped( look, ip->name, true )
    dim as Tko.Symbol ptr tsy = c.syms->SymbolAt( tsid )
    if tsy <> 0 then
        select case tsy->kind
        case Tko.SYM_UDT, Tko.SYM_TYPEDEF
            return tsy->type_
        end select
    end if
    return Tko.TYPE_NONE
end function


private function IntrinsicCallType_ _
    ( byref c as Ctx, byval cp as Tko.ListPayload ptr ) as Tko.TypeId

    if cp->target = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( cp->target ) <> Tko.N_IDENT then return Tko.TYPE_NONE
    dim as Tko.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Tko.Text.LowerAscii( c.names->Spelling( ip->name ) )

    '' THE RUNTIME PROCEDURES SPELLED AS ORDINARY IDENTIFIERS. Nothing binds them,
    '' so the callee lookup finds no symbol and the call came out UNTYPED -- and
    '' 'var oldcolors = color( 1 )' then declared a variable with no type and
    '' stored an i32 into a void slot. The verifier caught it; two corpus files.
    ''
    '' Measured, one '#print typeof' each, and COLOR IS UNSIGNED where the rest
    '' are not:
    ''
    ''   color  ULONG      width run bsave bload chain  LONG
    ''   seek   LONGINT    dylibload dylibsymbol        ANY PTR
    ''
    '' ONLY WHEN THE NAME IS UNBOUND: a program of its own that declares 'run'
    '' or 'seek' must keep its own result type, and the symbol says which this
    '' is. The lowering side of the same table is BuiltinProcRtl's unbound-only
    '' half in lowerintr.bas; a name added to one belongs in both.
    if c.info->RefOf( cp->target ) = Tko.SYMBOL_NONE then
        select case nm
        case "color"
            return c.types->Builtin( Tko.TY_ULONG )
        case "width", "run", "bsave", "bload", "chain"
            return c.types->Builtin( Tko.TY_LONG )
        case "seek"
            return c.types->Builtin( Tko.TY_LONGINT )
        case "dylibload", "dylibsymbol"
            return c.types->Pointer_( c.types->Builtin( Tko.TY_ANY ) )
        end select
    end if

    '' '__FB_QUERY_SYMBOL__( query, symbol )' IS AN INTEGER, whatever it is asked --
    '' measured, '#print typeof' of one says INTEGER even for the text queries. Its
    '' SECOND argument is a symbol rather than a value, so nothing about it can be
    '' inferred from the operands the way the rest of this table works.
    if (nm = "__fb_query_symbol__") andalso (cp->count = 2) then
        return c.types->Builtin( Tko.TY_INTEGER )
    end if

    '' CAST and CPTR name their result outright, as a TYPE argument.
    '' 'cva_arg( list, TYPE )' HAS THE TYPE IT IS TOLD TO HAVE. The second argument is
    '' a type reference, resolved by the time Check runs, and it IS the result type --
    '' there is nothing to infer and nothing to check it against.
    if (nm = "cva_arg") andalso (cp->count = 2) then
        dim as Tko.NodeId vt = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
        if c.ast->Kind( vt ) <> Tko.N_TYPEREF then return Tko.TYPE_NONE
        return c.info->TypeOf_( vt )
    end if

    '' PEEK IS UBYTE UNLESS IT IS TOLD OTHERWISE. Measured: 'peek( p )' prints through
    '' fb_PrintUByte and 'peek( integer, p )' through fb_PrintLongint, so the type
    '' argument -- a bare keyword or a 'typeof' -- IS the result type.
    if (nm = "peek") andalso (cp->count >= 1) andalso (cp->count <= 2) then
        if cp->count = 1 then return c.types->Builtin( Tko.TY_UBYTE )
        dim as Tko.NodeId pt = cast( Tko.NodeId, c.ast->children[cp->first] )
        dim as Tko.TypeId ptt = PeekTypeArg_( c, pt )
        if ptt <> Tko.TYPE_NONE then return ptt
        return Tko.TYPE_NONE
    end if

    if ((nm = "cast") orelse (nm = "cptr")) andalso (cp->count = 2) then
        dim as Tko.NodeId ta = cast( Tko.NodeId, c.ast->children[cp->first] )
        if c.ast->Kind( ta ) <> Tko.N_TYPEREF then return Tko.TYPE_NONE
        dim as Tko.TypeId rt = c.info->TypeOf_( ta )
        if rt = Tko.TYPE_NONE then return Tko.TYPE_NONE
        dim as Tko.NodeId sn = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
        dim as Tko.TypeId st = TypeOf_( c, sn )
        if st = Tko.TYPE_NONE then return rt
        '' 'this' DENOTES THE OBJECT, not the pointer. tiko-lang types it as a
        '' POINTER because that is what the ABI passes -- fbc's own C spells the
        '' receiver 'struct $1T*' -- and every member access reaches through it, so
        '' the modelling is right everywhere except here, where the source's
        '' POINTER-NESS is what the rule turns on.
        ''
        '' 'cast( Base, this ) = v' is the base SLICE, and fbc emits
        '' 'memcpy( THIS, &V, 8 )' for it. Typed off the pointer it was refused, so
        '' the assignment target had no type and the statement declined.
        ''
        '' Measured, and the distinction is real: 'cast( Base, *p )' over a derived
        '' OBJECT is accepted while 'cast( Base, p )' over the POINTER is fbc error
        '' 20. So this unwraps the receiver and nothing else.
        if IsThisIdent_( c, sn ) then
            if c.types->Kind( st ) = Tko.TK_POINTER then st = c.types->Inner( st )
        end if
        '' Measured acceptance. CPTR reaches a pointer only FROM one, or from a
        '' pointer-width integer; CAST follows the destination's class -- a pointer
        '' destination takes the same two, a numeric one takes anything but a pointer,
        '' and a STRING destination takes a var-length string and nothing else, not even
        '' a ZSTRING * n.
        dim as boolean srcPtr = (c.types->Kind( st ) = Tko.TK_POINTER)
        dim as boolean srcPtrInt = false
        if c.types->Kind( st ) = Tko.TK_BUILTIN then
            srcPtrInt = IsPointerSized_( c.types->BuiltinOf( st ), *c.types )
        end if
        if c.types->Kind( rt ) = Tko.TK_POINTER then
            '' A UDT THAT CASTS TO A POINTER IS A POINTER SOURCE. Measured:
            '' 'cast( integer ptr, bar )' emits '_ZN3FOOcvPu7INTEGEREv( &BAR )' and uses
            '' its result. Refusing it left the cast untyped, so the DEREF around it was
            '' untyped too and emitted nothing -- while the same cast assigned to a
            '' pointer variable, one line above, lowered.
            if (srcPtr orelse srcPtrInt) = false then
                if UdtCastResultOf_( c, st, true ) = Tko.TYPE_NONE then
                    return Tko.TYPE_NONE
                end if
            end if
            return rt
        end if
        if nm = "cptr" then return Tko.TYPE_NONE
        if c.types->Kind( rt ) = Tko.TK_BUILTIN then
            if IsStringy_( c.types->BuiltinOf( rt ) ) then
                if st <> rt then return Tko.TYPE_NONE
                return rt
            end if
        end if
        '' A pointer reaches a numeric destination only when that destination is
        '' POINTER-WIDTH: 'cast( long, p )' is refused on win64 and accepted on win32,
        '' where a long is four bytes like the pointer.
        if srcPtr then
            if c.types->Kind( rt ) <> Tko.TK_BUILTIN then return Tko.TYPE_NONE
            if IsPointerSized_( c.types->BuiltinOf( rt ), *c.types ) = false then
                return Tko.TYPE_NONE
            end if
        end if
        return rt
    end if

    '' The EXPRESSION intrinsics -- LEN, ASC, LBOUND, STR and the rest of the 48
    '' IFORM_EXPR keywords. Measured in tests/types/expected/fbc-intrin.txt; several are
    '' not guessable, which is why the whole family is a table rather than a rule.
    dim as Tko.TypeId et = ExprIntrinsicType_( c, nm, cp )
    if et <> Tko.TYPE_NONE then return et

    '' IIF( cond, a, b ) -- the result is the two ARMS' common type, and Check computed
    '' NOTHING for it. That is not just a missing row: it propagates. '(iif( c, a, b
    '' )).i' had an untyped base so the member never resolved, 'print iif( c, 1, 2 )'
    '' could not choose an entry point, and 'var v = iif( ... )' inferred nothing and
    '' got a VOID slot.
    ''
    '' Measured: 'iif( c, u1, u2 )' over a UDT is that UDT, two strings give STRING,
    '' and 1 with 2.5 gives DOUBLE -- the ordinary binary promotion. Identical arms are
    '' answered directly so a UDT, a string and a pointer all work without asking the
    '' numeric table about them.
    if nm = "iif" then
        if cp->count <> 3 then return Tko.TYPE_NONE
        dim as Tko.TypeId ta = _
            TypeOf_( c, cast( Tko.NodeId, c.ast->children[cp->first + 1] ) )
        dim as Tko.TypeId tb = _
            TypeOf_( c, cast( Tko.NodeId, c.ast->children[cp->first + 2] ) )
        if ta = tb then return ta
        if ta = Tko.TYPE_NONE then return tb
        if tb = Tko.TYPE_NONE then return ta
        return BinaryResult( Tko.TK_PLUS, ta, tb, *c.types )
    end if

    '' 'procptr( T.m, virtual )' takes a SECOND argument naming which override to
    '' point at. It does not change the result type, so one or two are both accepted
    '' here and everything else is not one of these intrinsics.
    if cp->count < 1 then return Tko.TYPE_NONE
    if (cp->count > 1) andalso (nm <> "procptr") then return Tko.TYPE_NONE
    if cp->count > 2 then return Tko.TYPE_NONE

    '' PROCPTR( F ) is the procedure's own type, which in FreeBASIC is already a pointer.
    '' Measured: 'typeof( procptr( F ) )' is 'SUB CDECL(AS LONG)'.
    ''
    '' It matters far past printing a type. ResolveCall_ treats an untyped ARGUMENT as
    '' making the whole call undecidable, so one of these left fbcunit's
    '' 'fbcu.add_test( ..., procptr( test_name ), ... )' unbound -- and an unbound callee
    '' is a declined statement. 2,444 of them across the corpus, from this one gap.
    if nm = "procptr" then
        '' 'procptr( T.m, )' -- A TRAILING COMMA WITH NOTHING AFTER IT. It is what an
        '' EMPTY VARIADIC macro argument expands to, and fbc accepts it: the delegate
        '' macro in pointers/procptr-low-level-delegate.bas is written
        '' 'procptr( typeName.procName, signature )' over 'signature...', and every one
        '' of its ten call sites leaves the signature out.
        ''
        '' The empty argument arrives as an N_ERROR from the expression parser, which is
        '' the honest thing for it to produce; treating the call as having TWO arguments
        '' then sent it down the overload-selection path, where nothing matched and the
        '' whole expression came out untyped. There is one argument here.
        dim as long ppCount = cp->count
        if ppCount = 2 then
            dim as Tko.NodeId ppSecond = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
            if ppSecond = Tko.NODE_NONE then
                ppCount = 1
            elseif c.ast->Kind( ppSecond ) = Tko.N_ERROR then
                ppCount = 1
            elseif c.ast->Kind( ppSecond ) = Tko.N_ELIDED then
                ppCount = 1
            end if
        end if

        '' 'procptr( T.m, VIRTUAL )' IS NOT A POINTER AT ALL. Measured: fbc folds it to
        '' the member's VTABLE SLOT INDEX as an int64 -- 'FP$0 = 1ll' for the second
        '' virtual member and 0 for the first -- which is what
        '' pointers/procptr-virtual.bas asserts against its own INDEX constants. The
        '' comment above had it as an override selector that "does not change the result
        '' type", and typing it as a procedure pointer left every one of them declining.
        if ppCount = 2 then
            dim as Tko.NodeId va = cast( Tko.NodeId, c.ast->children[cp->first + 1] )
            if IsVirtualKeyword_( c, va ) then
                return c.types->Builtin( Tko.TY_LONGINT )
            end if
        end if

        '' A MEMBER, not just a bare name: 'procptr( T.proc1 )' is an N_MEMBER, and
        '' rejecting it left the whole expression untyped -- so 'var fp = procptr(
        '' T.proc1 )' gave fp a VOID slot and the store into it was malformed. Both
        '' shapes are bound to their procedure symbol by then, so the type comes from
        '' the same place.
        dim as Tko.NodeId pa = cast( Tko.NodeId, c.ast->children[cp->first] )
        dim as Tko.NodeKind pk = c.ast->Kind( pa )
        if (pk <> Tko.N_IDENT) andalso (pk <> Tko.N_MEMBER) then return Tko.TYPE_NONE

        '' A STRUCTOR HAS NO ORDINARY NAME TO BIND -- the parser leaves the keyword as
        '' the member -- and an OVERLOAD written with a signature binds to the wrong
        '' one. Both are decided HERE and the answer is written back onto the member
        '' node, so lowering reads it off RefOf like any other procptr.
        ''
        '' Deciding it in lowering instead was tried and produced a VERIFY FAILURE:
        '' the address lowered while 'var fp = procptr( T.constructor )' still had a
        '' VOID slot, because nothing had typed the expression. Binding is Check's job
        '' and typing follows from it.
        dim as Tko.SymbolId picked = MemberProcPtr_( c, pa, cp )
        if picked <> Tko.SYMBOL_NONE then
            c.info->SetRef( pa, picked )
            return ProcTypeOfSymbol_( c, picked )
        end if
        '' A SECOND ARGUMENT THAT SELECTED NOTHING IS NOT A PROCPTR AT ALL. Falling
        '' back to whatever was bound would answer with the FIRST overload, and the
        '' only reason to write a signature is that the first is not the one wanted.
        '' 'procptr( T.v1, virtual )' lands here too -- it names which OVERRIDE to
        '' point at, which is a different address again.
        if ppCount = 2 then return Tko.TYPE_NONE

        return ProcTypeOfSymbol_( c, c.info->RefOf( pa ) )
    end if

    dim as Tko.BuiltinType b = Tko.TY_NONE
    select case nm
    case "cbyte"    : b = Tko.TY_BYTE
    case "cubyte"   : b = Tko.TY_UBYTE
    case "cshort"   : b = Tko.TY_SHORT
    case "cushort"  : b = Tko.TY_USHORT
    case "clng"     : b = Tko.TY_LONG
    case "culng"    : b = Tko.TY_ULONG
    case "cint"     : b = Tko.TY_INTEGER
    case "cuint"    : b = Tko.TY_UINTEGER
    case "clngint"  : b = Tko.TY_LONGINT
    case "culngint" : b = Tko.TY_ULONGINT
    case "csng"     : b = Tko.TY_SINGLE
    case "cdbl"     : b = Tko.TY_DOUBLE
    case "cbool"    : b = Tko.TY_BOOLEAN
    case "csign", "cunsg"
        return SignedFlip_( TypeOf_( c, cast( Tko.NodeId, c.ast->children[cp->first] ) ), _
                            (nm = "cunsg"), *c.types )
    end select
    if b = Tko.TY_NONE then return Tko.TYPE_NONE

    '' A POINTER argument reaches only the pointer-width conversions. For every other
    '' one -- cbyte, csng, cbool -- fbc refuses a pointer outright.
    dim as Tko.TypeId at = TypeOf_( c, cast( Tko.NodeId, c.ast->children[cp->first] ) )
    if at <> Tko.TYPE_NONE then
        if c.types->Kind( at ) = Tko.TK_POINTER then
            if IsPointerSized_( b, *c.types ) = false then return Tko.TYPE_NONE
        end if
    end if
    return c.types->Builtin( b )
end function